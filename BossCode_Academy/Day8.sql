--DAY8
1. Employees(Emp_id, emp_name,dept)
   Departments(Dept, city, country)

2. WITH RECURSIVE Ancestors AS (
    -- Base case: Select the specific employee
    SELECT
        emp_id,
        emp_name,
        manager_id
    FROM Employees
    WHERE emp_id = <specific_emp_id> -- Replace <specific_emp_id> with the ID of the employee

    UNION ALL

    -- Recursive case: Select the manager of the current employee
    SELECT
        e.emp_id,
        e.emp_name,
        e.manager_id
    FROM Employees e
    INNER JOIN Ancestors a ON e.emp_id = a.manager_id
)
-- Select all ancestors
SELECT * FROM Ancestors;

3.  CREATE TABLE Sales (
    prod_id INT,
    month VARCHAR(50),
    amount NUMERIC
);

INSERT INTO Sales (prod_id, month, amount) VALUES
(1, 'January', 100),
(1, 'February', 150),
(1, 'March', 200),
(2, 'January', 120),
(2, 'February', 180),
(2, 'March', 240);

SELECT
    prod_id,
    SUM(CASE WHEN month = 'January' THEN amount ELSE 0 END) AS January,
    SUM(CASE WHEN month = 'February' THEN amount ELSE 0 END) AS February,
    SUM(CASE WHEN month = 'March' THEN amount ELSE 0 END) AS March
FROM
    Sales
GROUP BY
    prod_id
ORDER BY
    prod_id;


4. Students
student_id (Primary Key)
student_name
Courses
course_id (Primary Key)
course_name
Enrollments
enroll_id (Primary Key)
student_id (Foreign Key)


+------------+       +-------------+       +---------------+
|  Students  |       |  Enrollments|       |   Courses     |
+------------+       +-------------+       +---------------+
| student_id |1----M>| enroll_id   |M----1>| course_id     |
| student_name|       | student_id  |       | course_name   |
+------------+       | course_id   |       +---------------+
                     +-------------+

5. 

  WITH RECURSIVE Subordinates AS (
    SELECT
        emp_id,
        emp_name,
        mgr_id
    FROM Employees
    WHERE emp_id = 1

    UNION ALL

    SELECT
        e.emp_id,
        e.emp_name,
        e.mgr_id
    FROM Employees e
    INNER JOIN Subordinates s ON e.mgr_id = s.emp_id
)
SELECT * FROM Subordinates;

6. 
  
  INSERT INTO Sales (prod_id, month1_amt, month2_amt, month3_amt) VALUES
(1, 100, 150, 200),
(2, 120, 180, 240);
  
  SELECT
    prod_id,
    'month1' AS month,
    month1_amt AS amount
FROM
    Sales

UNION ALL

SELECT
    prod_id,
    'month2' AS month,
    month2_amt AS amount
FROM
    Sales

UNION ALL

SELECT
    prod_id,
    'month3' AS month,
    month3_amt AS amount
FROM
    Sales;

7. Relationships
Customers place Orders.
Orders include Products.

  +-------------+       +---------+       +---------+
|  Customers  |       | Orders  |       | Products|
+-------------+       +---------+       +---------+
| cust_id     |1----M>| order_id|M----1>| prod_id |
| cust_name   |       | cust_id  |       | prod_name|
+-------------+       | prod_id  |       +---------+
                      +---------+

8. WITH RECURSIVE CategoryHierarchy AS (
    -- Base case: Select the top-level categories (categories with no parent)
    SELECT
        cat_id,
        cat_name,
        parent_cat_id,
        cat_name AS full_path,
        0 AS level
    FROM categories
    WHERE parent_cat_id IS NULL
    
    UNION ALL
    
    -- Recursive case: Select subcategories of the current category
    SELECT
        c.cat_id,
        c.cat_name,
        c.parent_cat_id,
        CONCAT(ch.full_path, ' -> ', c.cat_name) AS full_path,
        ch.level + 1 AS level
    FROM categories c
    INNER JOIN CategoryHierarchy ch ON c.parent_cat_id = ch.cat_id
)
-- Select all categories and their paths
SELECT
    cat_id,
    cat_name,
    parent_cat_id,
    full_path,
    level
FROM
    CategoryHierarchy
ORDER BY
    full_path;
9. SELECT
    a.col1,
    b.col2
FROM
    tableA a
CROSS JOIN
    tableB b;


10. +-----------------+     +-------------------+     +-----------------+
|     Users       |     |       Songs        |     |    Playlists     |
+-----------------+     +-------------------+     +-----------------+
| user_id (PK)    |     | song_id (PK)       |     | play_id (PK)     |
| user_name       |     | song_name          |     | user_id (FK)     |
+-----------------+     +-------------------+     | song_id (FK)     |
                                                 +-----------------+

              +----------------------+
              |   Playlist_Songs     |
              +----------------------+
              | play_id (FK)         |
              | song_id (FK)         |
              +----------------------+

