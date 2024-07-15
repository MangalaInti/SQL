--DAY9
1. SELECT 
    c.cust_id,
    c.cust_name,
    SUM(o.order_amt) AS total_order_amount
FROM 
    customers c
JOIN 
    orders o ON c.cust_id = o.cust_id
WHERE 
    o.order_dt BETWEEN 'start_date' AND 'end_date'
GROUP BY 
    c.cust_id,
    c.cust_name
ORDER BY 
    total_order_amount DESC;

2.  SELECT 
    p.prod_id,
    p.prod_name,
    c.cat_name
FROM 
    products p
JOIN 
    categories c ON p.cat_id = c.cat_id;

3.  SELECT 
    o.order_id,
    o.order_dt,
    (SELECT c.cust_name FROM customers c WHERE c.cust_id = o.cust_id) AS cust_name
FROM 
    orders o;
4. Create indexes
  CREATE INDEX idx_products_prod_id ON products(prod_id);
  CREATE INDEX idx_ratings_prod_id ON ratings(prod_id);

SELECT 
    p.prod_id,
    p.prod_name,
    AVG(r.rating) AS avg_rating
FROM 
    products p
JOIN 
    ratings r ON p.prod_id = r.prod_id
GROUP BY 
    p.prod_id,
    p.prod_name
ORDER BY 
    p.prod_id;

5. SELECT 
    e.emp_id,
    e.emp_name,
    d.dept_name
FROM 
    employees e
JOIN 
    departments d ON e.dept_id = d.dept_id;

6. 
  ***
SELECT 
    cust_name
FROM 
    customers
WHERE 
    cust_id IN (
        SELECT 
            cust_id
        FROM 
            orders
        GROUP BY 
            cust_id
        HAVING 
            COUNT(order_id) >= 2
    );

7. Create index
   CREATE INDEX idx_orders_order_dt ON orders(order_dt);
SELECT 
    DATE_TRUNC('month', order_dt) AS month,
    SUM(order_amt) AS total_sales
FROM 
    orders
GROUP BY 
    DATE_TRUNC('month', order_dt)
ORDER BY 
    month;

8. SELECT 
    p.prod_id,
    p.prod_name,
    s.supplier_name
FROM 
    products p
JOIN 
    suppliers s ON p.supplier_id = s.supplier_id;
9.  SELECT 
    c.cust_name
FROM 
    customers c
JOIN 
    orders o ON c.cust_id = o.cust_id
WHERE 
    o.order_dt >= NOW() - INTERVAL '30 days'
GROUP BY
    c.cust_name;

10. CREATE INDEX idx_products_prod_id ON products(prod_id);
   CREATE INDEX idx_order_items_prod_id ON order_items(prod_id);

SELECT 
    p.prod_id,
    p.prod_name,
    SUM(oi.amt) AS total_sales
FROM 
    products p
JOIN 
    order_items oi ON p.prod_id = oi.prod_id
GROUP BY 
    p.prod_id, p.prod_name
ORDER BY 
    total_sales DESC
LIMIT 
    5;



  
