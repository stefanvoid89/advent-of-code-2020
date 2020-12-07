--part1
with y  as(
select trim(replace(replace(replace(parent,'bags',''),'bag',''),'.','')) as parent
,cast(nullif(replace(qty,'n',''),'') as int) as qty
,nullif(trim(replace(replace(replace(child,'bags',''),'bag',''),'.','')),'o other') child from (
select bag, left(bag, CHARINDEX('contain',bag) - 1) as parent,RIGHT(bag, CHARINDEX(reverse('contain'), REVERSE(bag)) - 1) as children  
from bags
)q 
cross apply(select left(trim(value),1) as qty, right(trim(value),len(trim(value) )- 1) as child from string_split(children,','))p
)
,
 g as (
select parent, child from y where child = 'shiny gold'
union all
select y.parent, y.child from g inner join y on  y.child = g.parent
)
select distinct parent from g

--part2
with y  as(
select trim(replace(replace(replace(parent,'bags',''),'bag',''),'.','')) as parent
,cast(nullif(replace(qty,'n',''),'') as int) as qty
,nullif(trim(replace(replace(replace(child,'bags',''),'bag',''),'.','')),'o other') child from (
select bag, left(bag, CHARINDEX('contain',bag) - 1) as parent,RIGHT(bag, CHARINDEX(reverse('contain'), REVERSE(bag)) - 1) as children  
from bags
)q 
cross apply(select left(trim(value),1) as qty, right(trim(value),len(trim(value) )- 1) as child from string_split(children,','))p
),
 g as (
select parent, child,qty from y where parent = 'shiny gold'
union all
select y.parent, y.child,isnull(y.qty * g.qty,0) from g inner join y on  y.parent = g.child
)
select sum(qty) from g