--part1 and part2
select down,rght,sum(
case when (id-down-1)%down = 0 then cast (SUBSTRING(replace(REPLACE(tree_row,'#','1'),'.','0'), 1+(rght*((id-1)/down))%len(tree_row),1) as int) else 0 end
) as sum_all
from forest
cross apply(
select 1 as down, 1 as rght
union select 1 as down, 3 as rght
union select 1 as down, 5 as rght
union select 1 as down, 7 as rght
union select 2 as down, 1 as rght
)q
where id > down
group by down,rght