drop table #2015

select a.*, '2015' as teamyear, ROW_NUMBER() over(PARTITION BY a.["team"] order by a.["season"] desc) as number 
into #2015
from [bi_itemp].[dbo].[compactfinalround] a
where a.["season"] < '2015'

set nocount on;
declare @sql varchar(8000)
, @sdt char(10)
, @edt char(10)
, @lap1 datetime
, @lap2 datetime
, @delta int 
, @lap_time char(20)

set @sdt = 2003 -- ½ÃÀÛÀÏ
set @edt = 2014 -- Á¾·áÀÏ

while @sdt <= @edt 
begin 
set @lap1 = getdate()

set @sql = '
insert into #2015
select a.*, '''+@sdt+''' as year, ROW_NUMBER() over(PARTITION BY a.["team"] order by a.["season"] desc) as number 
from [bi_itemp].[dbo].[compactfinalround] a
where a.["season"] < '''+@sdt+'''
'

	--	print @sql
	 exec (@sql)

	set @lap2 = getdate()
	set @delta = datediff(ss, @lap1, @lap2) 
	set @lap_time = convert(char(20), @lap2, 120)
	raiserror('%s - completed %i (seconds) : %s', 0, 1, @sdt, @delta, @lap_time) with nowait ;

	set @sdt = @sdt+1
end;
set nocount off;


select COUNT(*)
from #2015
where ["season"] = teamyear

select season, wteam, COUNT(*) ½Â¸®È½¼ö
into #½Â¸®ÆÀ
from [bi_itemp].[dbo].[RegularSeasonDetailedResults]
group by season, wteam

select season, lteam, COUNT(*) ÆÐ¹èÈ½¼ö
into #ÆÐ¹èÆÀ
from [bi_itemp].[dbo].[RegularSeasonDetailedResults]
group by season, lteam

select t.*, cast(t.½Â¸®È½¼ö as numeric)/(t.½Â¸®È½¼ö+t.ÆÐ¹èÈ½¼ö) ½Â·ü
into #½Â·ü
from(
select a.season, a.wteam as team, a.½Â¸®È½¼ö, b.ÆÐ¹èÈ½¼ö
from #½Â¸®ÆÀ a
left join #ÆÐ¹èÆÀ b
on a.season = b.season
and a.wteam = b.lteam
)t

drop table #teamall

select a.*, isnull(b.["final"],'"etc"') as wfinal_last1
into #teamall
from [bi_itemp].[dbo].[teamall4] a
left join #2015 b
on a.["season"] = b.teamyear
and a.["Wteam"] = b.["team"]
and b.number = 1

select *
from #teamall2

select a.*, isnull(b.["final"],'"etc"') as lfinal_last1
into #teamall2
from #teamall a
left join #2015 b
on a.["season"] = b.teamyear
and a.["lteam"] = b.["team"]
and b.number = 1

drop table #teamall3

select a.*, b.½Â¸®È½¼ö as W½Â¸®È½¼ö, b.ÆÐ¹èÈ½¼ö as WÆÐ¹èÈ½¼ö, b.½Â·ü as W½Â·ü 
into #teamall3
from #teamall2 a
left join #½Â·ü b
on a.["season"] = b.season
and a.["wteam"] = b.team

drop table #teamall4

select a.*, b.½Â¸®È½¼ö as l½Â¸®È½¼ö, b.ÆÐ¹èÈ½¼ö as lÆÐ¹èÈ½¼ö, b.½Â·ü as l½Â·ü 
into #teamall4
from #teamall3 a
left join #½Â·ü b
on a.["season"] = b.season
and a.["lteam"] = b.team

select *
from #teamall4


