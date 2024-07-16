--DAY10
--Example Question
1. WITH RECURSIVE subordinates AS (
    -- Base case: Select the top-level managers (those who have no manager)
    SELECT
        id,
        name,
        manager_id,
        name AS top_manager_name
    FROM employees
    WHERE manager_id IS NULL

    UNION ALL

    -- Recursive case: Select the subordinates and their top manager
    SELECT
        e.id,
        e.name,
        e.manager_id,
        s.top_manager_name
    FROM employees e
    INNER JOIN subordinates s ON e.manager_id = s.id
)


SELECT
    id,
    name,
    manager_id,
    top_manager_name
FROM subordinates;


1. WITH RECURSIVE subcategories AS (
    -- Anchor member: Select the top-level categories (those without a parent)
    SELECT 
        cat_id, 
        cat_name, 
        cat_name AS top_category, 
        parent_cat_id 
    FROM categories
    WHERE parent_cat_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Join the categories table with the subcategories CTE to find child categories
    SELECT 
        c.cat_id, 
        c.cat_name, 
        s.top_category, 
        c.parent_cat_id 
    FROM categories c
    JOIN subcategories s ON c.parent_cat_id = s.cat_id
)

-- Final select to retrieve the results
SELECT 
    cat_id, 
    cat_name, 
    top_category, 
    parent_cat_id 
FROM subcategories;

2.  select c.cust_name, order_amount,sum(o.order_amt) over(partition by cust_name
order by order_id) run_total
from customers c join orders o
on c.cust_id = o.cust_id

3. SELECT 
    p.prod_id,
    p.prod_name,
    r.rating,
    AVG(r.rating) OVER (PARTITION BY p.prod_id) AS avg_rating,
    MAX(r.rating) OVER (PARTITION BY p.prod_id) AS max_rating
FROM 
    Products p
JOIN 
    Ratings r
ON 
    p.prod_id = r.prod_id;
4.  WITH RECURSIVE subordinates AS (
    -- Anchor member: Select employees with no manager (top-level employees)
    SELECT emp_id, emp_name, 
           emp_name AS mgr_name, 
           manager_id
    FROM employees
    WHERE manager_id IS NULL
    
    UNION ALL
    
    -- Recursive member: Join employees with their managers to get direct reports
    SELECT e.emp_id, e.emp_name, 
           s.mgr_name, 
           e.manager_id
    FROM employees e
    JOIN subordinates s
    ON e.manager_id = s.emp_id
)

-- Select results from the recursive CTE
SELECT emp_id, emp_name, mgr_name, manager_id
FROM subordinates
ORDER BY mgr_name, emp_id;

5. WITH CumulativeQuantities AS (
    SELECT 
        p.prod_name,
        o.order_id,
        o.qty,
        SUM(o.qty) OVER (PARTITION BY o.prod_id ORDER BY o.order_id) AS cum_total
    FROM 
        Products p
    JOIN 
        Orders o
    ON 
        p.prod_id = o.prod_id
)

SELECT 
    prod_name,
    order_id,
    qty,
    cum_total
FROM 
    CumulativeQuantities
ORDER BY 
    prod_name, order_id;

6. SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    MIN(order_amount) OVER (PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS min_order_amount,
    MAX(order_amount) OVER (PARTITION BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS max_order_amount
FROM 
    orders
ORDER BY 
    EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date), order_date;

7. WITH RECURSIVE Ancestors AS (
    -- Anchor member: Start with the specific employee
    SELECT emp_id, emp_name, manager_id, emp_name AS ancestor_name
    FROM employees
    WHERE emp_id = ?  -- Replace ? with the specific employee ID for whom you want to find ancestors
    
    UNION ALL
    
    -- Recursive member: Join to find each ancestor's manager
    SELECT e.emp_id, e.emp_name, e.manager_id, a.ancestor_name
    FROM employees e
    JOIN Ancestors a
    ON e.emp_id = a.manager_id
)

-- Select results from the CTE
SELECT emp_id, emp_name, ancestor_name
FROM Ancestors
ORDER BY ancestor_name;
8. WITH CTE AS (
    SELECT 
        p.prod_id,
        p.prod_name,
        AVG(r.rating) AS avg_rating,
        COUNT(r.rating) AS no_reviews
    FROM 
        Products p
    LEFT JOIN 
        Reviews r
    ON 
        p.prod_id = r.prod_id
    GROUP BY 
        p.prod_id, p.prod_name
)

SELECT 
    prod_id,
    prod_name,
    avg_rating,
    no_reviews
FROM 
    CTE
ORDER BY 
    prod_id;
9. WITH ProductSales AS (
    SELECT 
        p.prod_id,
        p.prod_name,
        SUM(oi.amount) AS total_amount
    FROM 
        Products p
    JOIN 
        order_items oi
    ON 
        p.prod_id = oi.prod_id
    GROUP BY 
        p.prod_id, p.prod_name
)

SELECT 
    prod_name,
    total_amount,
    RANK() OVER (ORDER BY total_amount DESC) AS rn,
    DENSE_RANK() OVER (ORDER BY total_amount DESC) AS drn
FROM 
    ProductSales
ORDER BY 
    total_amount DESC;

10. WITH RECURSIVE DependentEmployees AS (
    -- Anchor member: Start with the specific manager
    SELECT 
        emp_id, 
        emp_name, 
        manager_id
    FROM 
        Employees
    WHERE 
        emp_id = ?  -- Replace ? with the specific manager ID
    
    UNION ALL
    
    -- Recursive member: Join to find each employee reporting to the current employee
    SELECT 
        e.emp_id, 
        e.emp_name, 
        e.manager_id
    FROM 
        Employees e
    JOIN 
        DependentEmployees de
    ON 
        e.manager_id = de.emp_id
)

-- Select results from the CTE
SELECT 
    emp_id, 
    emp_name, 
    manager_id
FROM 
    DependentEmployees;

