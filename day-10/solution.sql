--part1
select 
sum(case when jolts - prevJolts = 1 then 1 else 0 end ) * (sum(case when jolts - prevJolts = 3 then 1 else 0 end ) + 1) as ans 
from (
select jolts,isnull(lag(jolts) over(order by jolts),0) as prevJolts  from adapters
)q

--part2
declare @t table (jolt int, sum bigint)
declare @jolt int, @sum bigint

insert into @t select 0,1

declare c cursor for 
select jolts from adapters order by jolts 
open c 
fetch next from c into @jolt
while @@FETCH_STATUS = 0
begin
select @sum = isnull((select sum from @t where jolt = @jolt - 1),0)
+isnull((select sum from @t where jolt = @jolt - 2),0)
+isnull((select sum from @t where jolt = @jolt - 3),0)
insert into @t select @jolt, @sum
fetch next from c into @jolt
end
close c
deallocate c

select max(sum) as ans from @t 