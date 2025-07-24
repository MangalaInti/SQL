VIEW AND TEMPORARY TABLES AREN'T THE SAME!

Some of the differences between views and temporary tables in SQL are:
1. Views exist in the database until they are dropped. But, temporary tables exist until the session/transaction has ended.
2. Views can help to simplify complex queries and hide the complexity from the end-user. They can also be used to restrict access to specific rows or columns of a table. But, temporary tables have no such inherent security features.

--SQL
What’s the difference between COUNT(column) and COUNT(DISTINCT
column)?
COUNT(column) will return the number of NULL values in that column. COUNT(DISTINCT
column) will return the number of unique non-NULL values in that column.

What’s the difference between COUNT(column) and COUNT(DISTINCT
column)?
COUNT(column) will return the number of non-NULL values in that column. COUNT(DISTINCT
column) will return the number of unique non-NULL values in that column.

What is a correlated subquery?
A correlated subquery is a subquery that refers to a field in the outer query.
Subqueries can be standalone queries (non-correlated), or they can use fields in the outer query. These
fields are often used in join conditions or in WHERE clauses.


What is cardinality?
Cardinality refers to the uniqueness of values in a column. High cardinality means that there is a large
percentage of unique values. Low cardinality means there is a low percentage of unique values.

How can you create an empty table from an existing table?

create table emp1 as select * from emp where 1=0

What’s the difference between % and _ for pattern matching (e.g. in the LIKE
operator)?
The difference is the % sign will match one or more characters, but the _ sign will match only one
character.

What’s the difference between ANY and ALL?
The ANY keyword checks that a value meets at least one of the conditions in the following set of
values. The ALL keyword checks that a value meets all of the conditions in the following set of values

 Difference between Group BY and Partition BY
Group BY is used to aggregate functions like SUM, MIN, MAX etc
it results 1 row per group
e.g - Find the average marks for each subject

select subject, avg(marks) from students
group by subject

Partition BY is a window function, used to perform calculations 
Does NOT collapse rows; instead, it calculates values within each partition while still keeping all rows.
In partition by we use functions like - Rank(), Row_number() etc

e.g  Student who scored highest marks in each subject
     select student, subject, marks from (
     select student, subject, marks, 
     rank() over(partition by subject order by marks desc) rn
     from students) where rn =1 
