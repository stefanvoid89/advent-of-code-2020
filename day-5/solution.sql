--part1
with z as (
select q.number * 8 + p.number t ,q.number * 8 + p.number as seat_num from (
select row,id, sum(substring(row,len(row)-position.number,1) * power(2,position.number) ) as number  from 
(select left(replace(replace(replace(replace(seat,'B','1'),'F','0'),'R','1'),'L','0'),7) as row,id from seats)q
cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(row)-1
group by row,id)q inner join (
select seat, id ,sum(substring(seat,len(seat)-position.number,1) * power(2,position.number) ) as number  from 
(select right(replace(replace(replace(replace(seat,'B','1'),'F','0'),'R','1'),'L','0'),3) as seat,id from seats)q
cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(seat)-1
group by seat,id)p on q.id = p.id
) select max(seat_num) from z; 

--part2
with z as (
select q.number * 8 + p.number t ,q.number * 8 + p.number as seat_num
,q.number * 8 + p.number  -  lag(q.number * 8 + p.number ) over (order by q.number * 8 + p.number ) as diff 
from (
select row,id, sum(substring(row,len(row)-position.number,1) * power(2,position.number) ) as number  from 
(select left(replace(replace(replace(replace(seat,'B','1'),'F','0'),'R','1'),'L','0'),7) as row,id from seats)q
cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(row)-1
group by row,id)q inner join (
select seat, id ,sum(substring(seat,len(seat)-position.number,1) * power(2,position.number) ) as number  from 
(select right(replace(replace(replace(replace(seat,'B','1'),'F','0'),'R','1'),'L','0'),3) as seat,id from seats)q
cross join master.dbo.spt_values as position
WHERE   position."type" =   'P'   
and position.number <=  len(seat)-1
group by seat,id)p on q.id = p.id
) select seat_num -1  from z where diff = 2; 
