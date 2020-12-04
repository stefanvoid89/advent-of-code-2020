--part1
select count(*)
from (
select 
STRING_AGG(cast(q.row as varchar(max)),' ')  WITHIN GROUP ( ORDER BY isnull(p.id,100000) ASC) as d, isnull(p.id,100000) id
from  passports q
outer apply(select top 1 id from passports nn 
where case when len(row) = 0 then 0 else 1 end = 0 and nn.id >q.id )p
where len(q.row) > 0
group by p.id
)g 
where 1=1
and charindex('byr:',d) > 0
and charindex('iyr:',d) > 0
and charindex('eyr:',d) > 0
and charindex('hgt:',d) > 0
and charindex('hcl:',d) > 0
and charindex('ecl:',d) > 0
and charindex('pid:',d) > 0



--part2
select count(*) from (
select id,sum(flag) as c from (
select *,
case 
when field = 'byr' then case when value between 1920 and 2002 then 1 else 0 end
when field = 'iyr' then case when value between 2010 and 2020 then 1 else 0 end
when field = 'eyr' then case when value between 2020 and 2030 then 1 else 0 end
when field = 'hgt' then case when CHARINDEX('cm',value) > 0 then case when cast(replace(value,'cm','') as int) between 150 and 193 then 1 else 0 end 
when CHARINDEX('in',value) > 0 then case when cast(replace(value,'in','') as int) between 59 and 76 then 1 else 0 end 
else 0 end
when field = 'hcl' then case when value like  '#%[a-z0-9]%' and len(value)=7 then 1 else 0 end
when field = 'ecl' then case when value in (
select 'amb' 
union select 'blu' 
union select 'brn' 
union select 'gry' 
union select 'grn' 
union select 'hzl' 
union select 'oth'
) then 1  else 0 end
when field = 'pid' then case when len(value) = 9 then 1 else 0 end
else 0 end as flag
from 
(
select  id,left(value,charindex(':',value) - 1) as field,right(value,len(value)- CHARINDEX(':',value)) as value  
from (
select 
STRING_AGG(cast(q.row as varchar(max)),' ')  WITHIN GROUP ( ORDER BY isnull(p.id,100000) ASC) as d, isnull(p.id,100000) id
from  passports q
outer apply(select top 1 id from passports nn 
where case when len(row) = 0 then 0 else 1 end = 0 and nn.id >q.id )p
where len(q.row) > 0
group by p.id
)g 
cross apply STRING_SPLIT(d,' ')q
where 1=1
and charindex('byr:',d) > 0
and charindex('iyr:',d) > 0
and charindex('eyr:',d) > 0
and charindex('hgt:',d) > 0
and charindex('hcl:',d) > 0
and charindex('ecl:',d) > 0
and charindex('pid:',d) > 0
)f
)h
group by id
having sum(flag) = 7
)m

