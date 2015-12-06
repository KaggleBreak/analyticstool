# 1. How does the chdir parameter of source() compare to in_dir()? Why might you prefer one approach to the other?
source <- function(file, local = FALSE, echo, print.eval, verbose, prompt.echo, max.deparse.length, chdir = FALSE, encoding, continue.echo, skip.echo = 0, keep.source)
{
  envir <- if (isTRUE(local)) {
      parent.frame()
  }
  else if (identical(local, FALSE)) {
      .GlobalEnv
  }
  else if (is.environment(local)) {
      local
  }
  else stop("'local' must be TRUE, FALSE or an environment")
  have_encoding <- !missing(encoding) && encoding != "unknown"
  if (!missing(echo)) {
      if (!is.logical(echo))
          stop("'echo' must be logical")
      if (!echo && verbose) {
          warning("'verbose' is TRUE, 'echo' not; ... coercing 'echo <- TRUE'")
          echo <- TRUE
      }
  }
  if (verbose) {
      cat("'envir' chosen:")
      print(envir)
  }
  ofile <- file
  from_file <- FALSE
  srcfile <- NULL
  if (is.character(file)) {
      if (identical(encoding, "unknown")) {
          enc <- utils::localeToCharset()
          encoding <- enc[length(enc)]
      }
      else enc <- encoding
      if (length(enc) > 1L) {
          encoding <- NA
          owarn <- options(warn = 2)
          for (e in enc) {
              if (is.na(e))
                next
              zz <- file(file, encoding = e)
              res <- tryCatch(readLines(zz, warn = FALSE),
                error = identity)
              close(zz)
              if (!inherits(res, "error")) {
                encoding <- e
                break
              }
          }
          options(owarn)
      }
      if (is.na(encoding))
          stop("unable to find a plausible encoding")
      if (verbose)
          cat(gettextf("encoding = \"%s\" chosen", encoding),
              "\n", sep = "")
      if (file == "") {
          file <- stdin()
          srcfile <- "<stdin>"
      }
      else {
          filename <- file
          file <- file(filename, "r", encoding = encoding)
          on.exit(close(file))
          if (isTRUE(keep.source)) {
              lines <- readLines(file, warn = FALSE)
              on.exit()
              close(file)
              srcfile <- srcfilecopy(filename, lines, file.mtime(filename)[1],
                isFile = TRUE)
          }
          else {
              from_file <- TRUE
              srcfile <- filename
          }
          loc <- utils::localeToCharset()[1L]
          encoding <- if (have_encoding)
              switch(loc, `UTF-8` = "UTF-8", `ISO8859-1` = "latin1",
                "unknown")
          else "unknown"
      }
  }
  else {
      lines <- readLines(file, warn = FALSE)
      if (isTRUE(keep.source))
          srcfile <- srcfilecopy(deparse(substitute(file)),
              lines)
      else srcfile <- deparse(substitute(file))
  }
  exprs <- if (!from_file) {
      if (length(lines))
          .Internal(parse(stdin(), n = -1, lines, "?", srcfile,
              encoding))
      else expression()
  }
  else .Internal(parse(file, n = -1, NULL, "?", srcfile, encoding))
  on.exit()
  if (from_file)
      close(file)
  Ne <- length(exprs)
  if (verbose)
      cat("--> parsed", Ne, "expressions; now eval(.)ing them:\n")
  if (chdir) {
      if (is.character(ofile)) {
          isURL <- length(grep("^(ftp|http|file)://", ofile)) >
              0L
          if (isURL)
              warning("'chdir = TRUE' makes no sense for a URL")
          if (!isURL && (path <- dirname(ofile)) != ".") {
              owd <- getwd()
              if (is.null(owd))
                stop("cannot 'chdir' as current directory is unknown")
              on.exit(setwd(owd), add = TRUE)
              setwd(path)
          }
      }
      else {
          warning("'chdir = TRUE' makes no sense for a connection")
      }
  }
  if (echo) {
      sd <- "\""
      nos <- "[^\"]*"
      oddsd <- paste0("^", nos, sd, "(", nos, sd, nos, sd,
          ")*", nos, "$")
      trySrcLines <- function(srcfile, showfrom, showto) {
          lines <- tryCatch(suppressWarnings(getSrcLines(srcfile,
              showfrom, showto)), error = function(e) e)
          if (inherits(lines, "error"))
              character()
          else lines
      }
  }
  yy <- NULL
  lastshown <- 0
  srcrefs <- attr(exprs, "srcref")
  for (i in seq_len(Ne + echo)) {
      tail <- i > Ne
      if (!tail) {
          if (verbose)
              cat("\n>>>> eval(expression_nr.", i, ")\n\t\t =================\n")
          ei <- exprs[i]
      }
      if (echo) {
          nd <- 0
          srcref <- if (tail)
              attr(exprs, "wholeSrcref")
          else if (i <= length(srcrefs))
              srcrefs[[i]]
          if (!is.null(srcref)) {
              if (i == 1)
                lastshown <- min(skip.echo, srcref[3L] - 1)
              if (lastshown < srcref[3L]) {
                srcfile <- attr(srcref, "srcfile")
                dep <- trySrcLines(srcfile, lastshown + 1,
                  srcref[3L])
                if (length(dep)) {
                  leading <- if (tail)
                    length(dep)
                  else srcref[1L] - lastshown
                  lastshown <- srcref[3L]
                  while (length(dep) && length(grep("^[[:blank:]]*$",
                    dep[1L]))) {
                    dep <- dep[-1L]
                    leading <- leading - 1L
                  }
                  dep <- paste0(rep.int(c(prompt.echo, continue.echo),
                    c(leading, length(dep) - leading)), dep,
                    collapse = "\n")
                  nd <- nchar(dep, "c")
                }
                else srcref <- NULL
              }
          }
          if (is.null(srcref)) {
              if (!tail) {
                dep <- substr(paste(deparse(ei, control = "showAttributes"),
                  collapse = "\n"), 12L, 1000000L)
                dep <- paste0(prompt.echo, gsub("\n", paste0("\n",
                  continue.echo), dep))
                nd <- nchar(dep, "c") - 1L
              }
          }
          if (nd) {
              do.trunc <- nd > max.deparse.length
              dep <- substr(dep, 1L, if (do.trunc)
                max.deparse.length
              else nd)
              cat("\n", dep, if (do.trunc)
                paste(if (length(grep(sd, dep)) && length(grep(oddsd,
                  dep)))
                  " ...\" ..."
                else " ....", "[TRUNCATED] "), "\n", sep = "")
          }
      }
      if (!tail) {
          yy <- withVisible(eval(ei, envir))
          i.symbol <- mode(ei[[1L]]) == "name"
          if (!i.symbol) {
              curr.fun <- ei[[1L]][[1L]]
              if (verbose) {
                cat("curr.fun:")
                utils::str(curr.fun)
              }
          }
          if (verbose >= 2) {
              cat(".... mode(ei[[1L]])=", mode(ei[[1L]]), "; paste(curr.fun)=")
              utils::str(paste(curr.fun))
          }
          if (print.eval && yy$visible) {
              if (isS4(yy$value))
                methods::show(yy$value)
              else print(yy$value)
          }
          if (verbose)
              cat(" .. after ", sQuote(deparse(ei, control = c("showAttributes",
                "useSource"))), "\n", sep = "")
      }
  }
  invisible(yy)
}



# 2. What function undoes the action of library()? How do you save and restore the values of options() and par()?
search()
detach('package:stringr')

current_options <- options() # set on.exit()
current_par <- par() # set on.exit()



# 3. Write a function that opens a graphics device, runs the supplied code, and closes the graphics device (always, regardless of whether or not the plotting code worked).



# 4. We can use on.exit() to implement a simple version of capture.output().
capture.output2 <- function(code) {
  temp <- tempfile()
  on.exit(file.remove(temp), add = TRUE)

  sink(temp)
  on.exit(sink(), add = TRUE)

  force(code)
  readLines(temp)
}
capture.output2(cat("a", "b", "c", sep = "\n"))
#> [1] "a" "b" "c"

# Compare capture.output() to capture.output2(). How do the functions differ? What features have I removed to make the key ideas easier to see? How have I rewritten the key ideas to be easier to understand?