--DAY6
1. CREATE VIEW product_sales AS
SELECT 
    p.prod_id,
    p.prod_name,
    SUM(oi.qty * oi.amt) AS total_sales_amt
FROM 
    products p
JOIN 
    order_items oi
ON 
    p.prod_id = oi.prod_id
GROUP BY 
    p.prod_id, p.prod_name;
	
2. 

--create Indexes
Create indexes on cust_id and order_dt columns in the orders table to improve the performance of filtering and sorting operations.
CREATE INDEX idx_orders_cust_id ON orders (cust_id);
CREATE INDEX idx_orders_order_dt ON orders (order_dt DESC);

--Optimized query
SELECT 
    o.order_id,
    o.cust_id,
    o.order_dt,
    o.order_amt
FROM 
    orders o
WHERE 
    o.cust_id = 12345
ORDER BY 
    o.order_dt DESC;
	

3. 
--Create Index 
CREATE INDEX idx_employees_last_name ON employees (last_name);

--Measure the performance before indexing

EXPLAIN ANALYZE
SELECT 
    emp_id, emp_name, first_name, last_name, sal
FROM 
    employees
WHERE 
    last_name = 'Smith';
	
--Measure the performance after indexing 

Run the same 'EXPLAIN ANALYZE'	

4. CREATE VIEW product_reviews AS
SELECT 
    p.prod_id,
    p.prod_name,
    AVG(r.rating) AS avg_rating,
    COUNT(r.rating) AS number_of_reviews
FROM 
    products p
LEFT JOIN 
    reviews r
ON 
    p.prod_id = r.prod_id
GROUP BY 
    p.prod_id, p.prod_name;
	
5. 

--Create Index on cust_id
Creating an index on the cust_id column in the orders table will improve the performance of the query
CREATE INDEX idx_orders_cust_id ON orders (cust_id);

--Optimized query

SELECT 
    c.cust_id,
    c.cust_name,
    SUM(o.order_amt) AS total_order_amount
FROM 
    customers c
JOIN 
    orders o
ON 
    c.cust_id = o.cust_id
GROUP BY 
    c.cust_id, c.cust_name
ORDER BY 
    total_order_amount DESC
LIMIT 10;

6. 
--create index
CREATE INDEX idx_orders_order_dt ON orders (order_dt);

--Measure the performance before index
EXPLAIN ANALYZE
SELECT 
    order_id, 
    order_dt, 
    order_amt
FROM 
    orders
WHERE 
    order_dt BETWEEN '2023-01-01' AND '2023-12-31';

--Measure the performance after index
Run the same query

7. CREATE VIEW dept_avg_salary AS
SELECT 
    dept,
    AVG(sal) AS avg_salary
FROM 
    employees
GROUP BY 
    dept;

8. 
--Create index
Creating indexes on the cat_id columns in both the products and categories tables will improve the performance of the join and the filter operations.

CREATE INDEX idx_products_cat_id ON products (cat_id);
CREATE INDEX idx_categories_cat_id ON categories (cat_id);

--Write the Optimized Query
SELECT 
    p.prod_id,
    p.prod_name,
    c.cat_name
FROM 
    products p
JOIN 
    categories c
ON 
    p.cat_id = c.cat_id
WHERE 
    c.cat_name = 'specific_category_name';

9. 
--create index
CREATE INDEX idx_products_prod_name ON products (prod_name);

--Query
EXPLAIN ANALYZE
SELECT 
    prod_id, 
    prod_name, 
    cat_id
FROM 
    products
WHERE 
    prod_name ILIKE '%specific_search_term%';

10. 
CREATE VIEW customer_total_order_amount AS
SELECT 
    c.cust_id,
    c.cust_name,
    SUM(o.order_amt) AS total_order_amount
FROM 
    customer c
LEFT JOIN 
    orders o
ON 
    c.cust_id = o.cust_id
GROUP BY 
    c.cust_id, c.cust_name;
