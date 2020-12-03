--part1
select count(*) from (
select  trim(left(l1, charindex('-', l1) - 1)) as minimal
,trim(right(l1, len(l1) - charindex('-', l1) )) as maximal, l2 as l,
r as pass
from (
select trim(left(l,len(l) -1))l1, right(l,1)l2, r from  (
select trim(left(pass, charindex(':', pass) - 1)) l,
    trim(right(pass, len(pass) - charindex(':', pass) )) r  from passwords
)q
)p
)r
where (len(pass) - len(replace(pass,l,''))) >= minimal 
and (len(pass) - len(replace(pass,l,'')))  <= maximal

--part2
select count(*) from (
select  substring(pass,minimal,1) as one,substring(pass,maximal,1) as two,l from (
select  cast(trim(left(l1, charindex('-', l1) - 1)) as int) as minimal
,cast(trim(right(l1, len(l1) - charindex('-', l1) )) as int) as maximal, l2 as l,
r as pass
from (
select trim(left(l,len(l) -1))l1, right(l,1)l2, r from  (
select trim(left(pass, charindex(':', pass) - 1)) l,
    trim(right(pass, len(pass) - charindex(':', pass) )) r  from passwords
)q
)p
)r
)g
where 1=1
and ((one = l and two <> l) or (one <> l and two = l))
