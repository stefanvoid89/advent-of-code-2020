--part1
select sum(d) from (
select count(distinct c) as d, id_group from (
select substring(ans,len(ans)-position.number,1) as c, id_group   from (
select 
q.*,isnull(p.id,1000000) as id_group
from  answers q
outer apply(select top 1 id from answers nn 
where case when len(ans) = 0 then 0 else 1 end = 0 and nn.id >q.id )p
where len(q.ans) > 0
--order by q.id
)f cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(ans)-1
)x group by id_group
)y

--part2
select count(*) from (
select c as chr, count(c) as chr_count, id_group from (
select substring(ans,len(ans)-position.number,1) as c, id_group   from (
select 
q.*,isnull(p.id,1000000) as id_group
from  answers q
outer apply(select top 1 id from answers nn 
where case when len(ans) = 0 then 0 else 1 end = 0 and nn.id >q.id )p
where len(q.ans) > 0
)f cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(ans)-1 
)t
group by c,id_group
)b inner join (
select count(id_group) as chr_count,id_group from (
select q.*,isnull(p.id,1000000) as id_group
from  answers q
outer apply(select top 1 id from answers nn 
where case when len(ans) = 0 then 0 else 1 end = 0 and nn.id >q.id )p
where len(q.ans) > 0
)f
group by id_group
) v on b.id_group = v.id_group and b.chr_count = v.chr_count