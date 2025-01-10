# Wherever you are given a range, keep MIN() and MAX() in mind
# When you want to find first_login use min function
# Convert rows to columns use case statement
# Convert column to rows use union e.g - Rearrange  Products Table
#Any consecutive problem i.e comparing 1 row with another row. First approach is self join
#Consecutive problem - Find all numbers that appear at least three times consecutively.
 Logs table:
+----+-----+
| id | num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |

 SELECT 
	DISTINCT Num AS ConsecutiveNums
FROM (
    SELECT 
        Num,
        LEAD(Num, 1) OVER (ORDER BY id) AS NextNum1,
        LEAD(Num, 2) OVER (ORDER BY id) AS NextNum2
    FROM Logs
) subquery
WHERE Num = NextNum1 AND Num = NextNum2;

---Slight modification
with cte as (
select *,
lead(num,0) over(order by id) next1,
lead(num,1) over(order by id) next2,
lead(num,2) over(order by id) next3         
from public.logs)
select num from cte where next1 = next2 and next1 = next3
 
 # Cummulative problem - sum() over(order by column)
 --Method -I
   select person_name,weight,turn, sum(weight) over(order by turn ) total_wt from queue
 --Method II
  select person_name,weight,turn,
sum(weight) over(order by turn ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) total_wt from queue
 
# Solve a cummulative problem in a sql - TechTFQ	REAL SQL Interview PROBLEM by Capgemini
 (Sum() over(partition order by)
 
#If want to get consecutive records from table then use Row_number i.e id -row_number(order by id)
#if you want to find the highest number of users - 1st find  max(users_count) and select user from table user_count = 

# To find percentages - 
   select sum(case when is_low_fat = 'Y' and is_recyclable = 'Y' then 1 end) 
   /count(*) ::float *100 as percentage
   from facebook_products

 # Increase the salary by 10% 
   select salary * 1.10 from emp 
 if its 50% then 1.50

 # To find median
 select percentile_cont(0.5) within group (order by sat_writing) as median
from sat_scores)

# To find percentages
SELECT SUM(order_amt) FROM orders)) /100*0.1) 

