--Delete duplicate records
Delete from table where id Not in(select min(id) from table
group by column_to_check)

How do we split columns sql

select split_part(full_name,' ',1) as first_name,
       split_part(full_name,' ',2) as last_name
from employees

--How to round- numeric data in sql
Select ROUND(col_name,decimal_places) as rounded_value
from table_name

--How to get unique records from table

select distinct col_name from table

--How to find the most frequently occuring value in a column

select MODE() WITHIN GROUP(ORDER BY column_name) as most_frequent
from table

--How to remove leading zeros from data in sql column
Use the LTRIM() function to trim zeros

Select LTRIM(col_nm,'0') as trimmed_column from table

--How to create a backup of a sql table
To create a backup use SELECT INTO stmt to copy the entire table

select * INTO backup_table from orginal_table

--How to Reverse a string in sql

Select Reverse(col_nm) as reversed from table

