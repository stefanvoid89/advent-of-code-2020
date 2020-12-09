--part1
select  num from xmas x outer apply(
select 1 as one from xmas a inner join xmas b on a.id <> b.id and a.num + b.num = x.num
where 1=1 
and a.id between (x.id - 25) and  x.id 
and b.id between (x.id - 25) and  x.id 
)q
where x.id > 25
and q.one is null

--part2
select min(num)+max(num) as ans from xmas x inner join (
select id,id2  from (
select id,id2,sum(num) over(partition by id order by id, id2) as rt  from (
SELECT x.id,q.num , q.id as id2  from xmas x
cross apply(select id,num from xmas a where a.id >= x.id and a.num < 10884537 )q
where x.num < 10884537
)g
)t where rt = 10884537)l on x.id >= l.id and x.id <= l.id2