
--Q#1 Combine two tables
Write a sql query to report name and address of each person in persons table. If the address of a person is not present in address table, 
report null instead

SELECT p.name, a.city, a.state
FROM persons p
LEFT JOIN address a ON p.id = a.person_id;

--Q#2 Second Highest Salary

select salary from (
SELECT salary, dense_rank() over(order by salary desc) rn from emp ) e where rn = 2

--Q#3 Nth Highest salary

select salary from (
SELECT salary, dense_rank() over(order by salary desc) rn from emp ) e where rn = 4

--Q#4 Rank Scores

select Score, dense_rank() over(order by Score desc) as 'Rank' from Scores

--Q#5 Consecutive Numbers

select distinct a.num as consecutive_num 
from logs a join logs b on  a.num = b.num and a.id = b.id-1
join logs c on  b.num = c.num and b.id = c.id-1 


--Q#6 Employees earning more than their managers

SELECT e.id, e.name, e.salary, e.managerId
FROM Employees e
JOIN Employees m ON e.managerId = m.id
WHERE e.salary > m.salary;

--Q#7 Duplicate Emails

SELECT email_id
FROM employees
GROUP BY email_id
HAVING COUNT(email_id) > 1;


--Q#8 - Customers who never order

SELECT c.name AS customers
FROM Customers c
LEFT JOIN Orders o ON c.id = o.customerId
WHERE o.customerId IS NULL;

--Q#9 - Department with Highest Salary
Write a sql query to find employees  who have highest salary in each of the department

SELECT Department.Name AS Department, Employee.Name AS Employee, Max(Salary) OVER (PARTITION BY Department ORDER BY Salary) AS Salary 
FROM Employee JOIN Department ON Employee.DepartmentId = Department.Id

--Q#10 Department Top Three salaries

SELECT department_id, employee_name, salary
FROM (
    SELECT department_id, employee_name, salary,
        ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS row_num
    FROM employees
) AS t
WHERE row_num <= 3;

--Q#11 Delete Duplicate Emails 
Keeping only unique email with smallest id


DELETE from Person where Id  not in
(select id from (select min(Id) as Id 
                            from Person group by Email ) as p)
							
OR


DELETE p2 FROM Person p1 JOIN Person p2 
ON p2.Email = p1.Email WHERE p2.Id > p1.Id;						


--Q#12 Raising Temperature

WITH cte AS (
  SELECT 
    id,
    recordDate,
    temperature,
    LAG(temperature) OVER (ORDER BY recordDate) AS prev_temp
  FROM 
    TemperatureRecords
)
SELECT 
  id, 
  recordDate, 
  temperature, 
  prev_temp 
FROM 
  cte 
WHERE 
  temperature > prev_temp;

OR


WITH rising_temp AS (
    SELECT
        id,
        temperature,
        LAG(temperature) OVER (ORDER BY recordDate) as prev_temp,
        DATEDIFF(DAY, LAG(recordDate) OVER (ORDER BY recordDate), recordDate) as date_diff
    FROM Weather
)
SELECT id
FROM rising_temp
WHERE
    temperature > prev_temp
    AND
    date_diff = 1


OR


select t.id from weather t, weather y where datediff(t.recorddate, y.recorddate) =1  and t.temperature > y.temperture

--Q#13  ****Trips and Users

Select  request_at, 
round(sum(case when status != 'completed' then 1.00 else 0 end)/count(*),2) as cancellation_rate
from trips t 
where  
client_id not in (
select users_id from users where banned = 'Yes') 
and
driver_id not in(
 select users_id from users where banned = 'Yes'   
)
group by request_at
order by request_at	

--Q#14 Find customer referee

SELECT name FROM Customer WHERE referee_id != 2 OR referee_id IS NULL;	

--Q#15 Customer placing the largest number of orders

select customer_number from orders  group by 1
order by count(distinct order_number) desc limit 1;
 OR
Select customer_number from orders group by customer_number 
order by sum(order_number) desc  limit 1	 
	 

--Q#16 Big Countries

SELECT
    name, population, area
FROM
    world
WHERE
    area > 3000000 OR population > 25000000
	

--Q#17 Classes more than 5 students
select `class` from `courses` group by `class` having count(distinct `student`) >= 5

--Q#18 **** Human Traffic of Stadium
WITH CTE AS (
    SELECT id,
    visit_date,
    people,
    id - ROW_NUMBER() OVER(ORDER BY id) AS consecutive
    FROM Stadium
    WHERE people >= 100
)

SELECT id, visit_date, people
FROM CTE
WHERE consecutive IN (
    SELECT consecutive
    FROM CTE
    GROUP BY consecutive
    HAVING COUNT(id) >= 3
)

	 OR
with filtered_data as (
select id, 
       visit_date, 
       people, 
       LAG(id,1) OVER(order by id) as prevID_1, 
       LAG(id,2) OVER(order by id) as prevID_2,
       LEAD(id,1) OVER(order by id) as nextID_1, 
       LEAD(id,2) OVER(order by id) as nextID_2
from Stadium 
where people>=100
), ordered_filtered_data as (
select *, 
       CASE WHEN id+1=nextID_1 AND id+2 = nextID_2 then 'Y' 
            WHEN id-1=prevID_1 AND id-2 = prevID_2 then 'Y' 
            WHEN id-1 = prevID_1 and id+1=nextID_1 then 'Y'
            ELSE 'N' END as flag
from filtered_data
)
select id, visit_date, people from ordered_filtered_data where flag = 'Y'

--Q#19  Sales Person - 

Report all salesperson who did not have any orders related to company with name 'RED'

Solution#1

SELECT s.name
FROM orders o 
    JOIN company c ON o.com_id = c.com_id AND c.name = 'RED'
    RIGHT JOIN salesperson s ON o.sales_id = s.sales_id
WHERE o.sales_id IS NULL;

Solution#2

SELECT name
FROM salesperson
WHERE sales_id NOT IN (
    SELECT distinct sales_id
    FROM orders
    WHERE com_id = (SELECT com_id FROM company WHERE name = 'RED')
);


--Q#20 Tree Node

--Q#21 Not Boring Movies
select * from cinema
where mod(id,2) <> 0 and description != 'boring'
order by rating desc

--Q#21 *** Exchange Seats

--Using IF Stmt
select 
    if( id%2 <> 0, if( id = ( select max(id) from seat ), id, id+1), id-1 ) as id, 
student 
from seat 
order by id

--Using CASE stmt
select 
    case 
        when id=(select max(id) from seat) and id%2 <> 0 then id
        when id%2 = 0 then id-1
        when id%2 <> 0 then id+1
    end as id, student 
from seat 
order by id

--Another case

SELECT ( CASE
            WHEN id%2 != 0 AND id != counts THEN id+1
            WHEN id%2 != 0 AND id = counts THEN id
            ELSE id-1
        END) AS id, student
FROM seat, (select count(*) as counts from seat) 
AS seat_counts
ORDER BY id ASC

--Q#22 Swap Salary 

update Salary 
    set sex = (case when sex = 'm' 
               then 'f' 
               else 'm'
               end)

--Q#23 ***Cooperated At Least Three Times

SELECT actor_id, director_id
FROM ActorDirector
GROUP BY actor_id, director_id
HAVING COUNT(*) >= 3

--Q#25 ***Sales Analysis III

select s.product_id, p.product_name

from sales s, product p

where s.product_id = p.product_id

group by s.product_id, p.product_name

having min(s.sale_date) >= '2019-01-01' 
    and max(s.sale_date) <= '2019-03-31'
	

OR
SELECT P.product_id, P.product_name
FROM Sales AS S
RIGHT JOIN Product AS P
ON S.product_id = P.product_id
GROUP BY P.product_id, P.product_name
HAVING MAX(sale_date) BETWEEN '2019-01-01' AND '2019-03-31'
      AND MIN(sale_date) BETWEEN '2019-01-01' AND '2019-03-31'
OR
	
select distinct s.product_id, p.product_name
from sales s join product p 
on s.product_id=p.product_id
where s.sale_date between '2019-01-01' and '2019-03-31' 
and s.product_id not in 
  (select product_id from sales where sale_date not between '2019-01-01' and '2019-03-31');	
	
--Q#25 Game Play Analysis I

Using group by
SELECT
player_id, min(event_date) as first_login
FROM
Activity
group by player_id ;

2. Using Windows function

SELECT
player_id,
event_date as first_login
FROM
(

SELECT
player_id,
event_date,
dense_rank() OVER (PARTITION BY player_id order by event_date) as denserank_date
FROM
Activity ) as rank_date
WHERE denserank_date = 1;


--Q#27 User Activity for the past 30 days

daily active user count for a period of 30 days
We will be using datdiff function to address this period of 30 days.

2. ending 2019–07–27

SELECT
     activity_date as day,
    COUNT(DISTINCT user_id) as active_users
    
FROM Activity
where 
    datediff('2019-07-27', activity_date) < 30
        and
    activity_date <= '2019-07-27'
GROUP BY activity_date

	OR
select activity_date as day, count(distinct user_id) as active_users from activity
where activity_date   between '2019-07-27'::date  - interval  '30 days'
and '2019-07-27'::date
group by 1
	OR
-- Write your PostgreSQL query statement below
-- period from 2019-06-27 until 2019-07-27
select activity_date as day,
count(distinct user_id) as active_users
from Activity
where activity_date > '2019-07-27'::timestamp - INTERVAL '30 days'
and activity_date <= '2019-07-27'::timestamp
group by activity_date	


--Q#28 Article Views I

select distinct author_id as id
from Views
where author_id = viewer_id
order by author_id asc

--Q#29 ***Market Analysis I

select user_id as buyer_id, join_date, COUNT(order_id) as orders_in_2019 
from Users LEFT JOIN Orders on user_id = buyer_id 
and  extract(year from order_date) = 2019 
group by user_id, join_date

Q#30 Reformat Department Table

select id,
    avg(case when month = 'Jan' then revenue end) as Jan_Revenue,
    avg(case when month = 'Feb' then revenue end) as Feb_Revenue,
    avg(case when month = 'Mar' then revenue end) as Mar_Revenue,
    avg(case when month = 'Apr' then revenue end) as Apr_Revenue,
    avg(case when month = 'May' then revenue end) as May_Revenue,
    avg(case when month = 'Jun' then revenue end) as Jun_Revenue,
    avg(case when month = 'Jul' then revenue end) as Jul_Revenue,
    avg(case when month = 'Aug' then revenue end) as Aug_Revenue,
    avg(case when month = 'Sep' then revenue end) as Sep_Revenue,
    avg(case when month = 'Oct' then revenue end) as Oct_Revenue,
    avg(case when month = 'Nov' then revenue end) as Nov_Revenue,
    avg(case when month = 'Dec' then revenue end) as Dec_Revenue
from Department
group by id
order by id


Q#31** Capital Gain/Loss

SELECT
    stock_name,
    total_sell - total_buy as capital_gain_loss
FROM (
SELECT
    stock_name,
    SUM(CASE WHEN operation = 'Sell' THEN price ELSE 0 END) as total_sell,
    SUM(CASE WHEN operation = 'Buy' THEN price ELSE 0 END ) as total_buy 
FROM Stocks
GROUP BY 1
) x
ORDER BY 1

	OR
-- Write your PostgreSQL query statement below
select 
       stock_name,  
       sum(case when operation = 'Sell' then price else NULL end )- sum(case when operation = 'Buy' then price else NULL end) as capital_gain_loss
       from Stocks 
       group by stock_name ; 	
	

--Q#32 Top Travellers

SELECT u.name, COALESCE(SUM(r.distance), 0) AS travelled_distance 
FROM Users u 
LEFT JOIN Rides r ON u.id = r.user_id 
GROUP BY u.id, u.name 
ORDER BY travelled_distance DESC, u.name ASC;

--Q33 Group Sold Products By DATE


GROUP_CONCAT() function will sort the product names in lexicographical order before concatenating them

select sell_date, count(distinct product) as num_sold,
group_concat(distinct product order by product asc) as products
from Activities
group by sell_date
order by sell_date

--Q34 Patient with a condition code

SELECT * FROM PATIENTS
WHERE CONDITIONS LIKE 'DIAB1%' OR CONDITIONS LIKE '% DIAB1%'

--Q35 Customer who visited but did not make any transactions

SELECT V.customer_id, COUNT(V.visit_id) AS count_no_trans
FROM Visits V
LEFT JOIN Transactions T ON V.visit_id = T.visit_id
WHERE T.transaction_id IS NULL
GROUP BY V.customer_id;

--Q36 Bank Account Summary II

select name,sum(amount) balance
from Transactions t
join Users u
on t.account = u.account
group by name
having balance>10000

--Q37 Fix Names in a Table

SELECT Users.user_id , CONCAT(UPPER(SUBSTR(Users.name,1,1)),LOWER(SUBSTR(Users.name,2))) AS name 
FROM Users
ORDER BY
Users.user_id ASC

--Q38 Daily Leads and Partners

SELECT date_id,
       make_name,
       COUNT(DISTINCT lead_id) AS unique_leads,
       COUNT(DISTINCT partner_id) AS unique_partners
FROM DailySales
GROUP BY 1, 2
ORDER BY NULL;

--Q39 Find Followers count

SELECT user_id, 
       Count(follower_id) AS followers_count 
FROM   followers 
GROUP  BY user_id 
ORDER  BY user_id; 

--Q40 Find Totoal time spend by each employee

SELECT emp_id, SUM(out_time - in_time) AS total_time
FROM table
GROUP BY emp_id

--Q41 Recycleable and Low Fat Products

SELECT product_id
FROM   Products
WHERE  low_fats = 'Y'
       AND recyclable = 'Y'
ORDER  BY NULL;

--Q42*** Rearrange the Products Table


SELECT product_id, 'store1' AS store, store1 AS price FROM Products WHERE store1 IS NOT NULL
UNION 
SELECT product_id, 'store2' AS store, store2 AS price FROM Products WHERE store2 IS NOT NULL
UNION 
SELECT product_id, 'store3' AS store, store3 AS price FROM Products WHERE store3 IS NOT NULL

ORDER BY 1,2 ASC;

--Q43 Calculcate Special Bonus

SELECT employee_id,
       IF(employee_id % 2 != 0 AND name NOT LIKE 'M%', salary, 0) AS bonus
FROM Employees
ORDER BY employee_id;

--Q44 The Latest Login in 2020

select user_id , max(time_stamp) AS last_stamp
from logins
where time_stamp LIKE '2020%'
group by user_id 
order by user_id;

--Q45 *** Employees with Missing Information

Select e.employee_id from Employees e 
LEFT JOIN Salaries s 
ON e.employee_id = s.employee_id
WHERE s.salary  is NULL

UNION

Select s.employee_id from Salaries s
LEFT JOIN Employees e 
ON e.employee_id = s.employee_id
WHERE e.name is NULL

ORDER BY employee_id;

