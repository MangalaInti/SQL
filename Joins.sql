1. Inner Join
Definition: Returns records that have matching values in both tables.
  
  select * from a join b on a.id = b.id

2. Left Join
Definition: Returns all records from the left table, and the matched records from the right table. The result is NULL from the right side if there is no match.

  select * from a left join b on a.id = b.id
  
3. Right Join
Definition: Returns all records from the right table, and the matched records from the left table. The result is NULL from the left side if there is no match.

  select * from a right join b on a.id = b.id

4. Left Join Excluding
Definition: Returns all records from the left table that do not have a match in the right table.

    select * from a left join b on a.id = b.id where b.id is null
  
5. Right Join Excluding
Definition: Returns all records from the right table that do not have a match in the left table.

   select * from right  join b on a.id = b.id where a.id is null

6. Full Outer Join
Definition: Returns all records when there is a match in either left (table1) or right (table2) table records.

  select * from a full outer join b on a.id = b.id
  
7. Full Outer Join Excluding
Definition: Returns all records that do not have a match in either left or right table.

   select * from a full outer join b on a.id = b.id where a.id is null or b.id is null

8. Cross Join
Definition: Returns the Cartesian product of both tables, combining all rows from the first table with all rows from the second table.

select * from a cross join b
