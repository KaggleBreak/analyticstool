def lazy_range(n):
    i = 0
    while i<n:
        yield i
        i += 1

test_lazy = lazy_range(10)
print test_lazy

print test_lazy.next()
print test_lazy.next()
print test_lazy.next()
print test_lazy.next()
print test_lazy.next()
print test_lazy.next()
print test_lazy.next()
print test_lazy.next()


