--Practice Questions
1. SELECT
    o.order_id,
    SUM(oi.qty) AS total_qty,
    SUM(oi.amt) AS total_amt
FROM
    orders o
JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    o.order_id;

2. SELECT
    title,
    COUNT(emp_id) AS number_of_employees,
    AVG(age) AS average_age
FROM
    Employees
GROUP BY
    title;

3. SELECT
    c.category_name,
    COUNT(p.prod_id) AS total_products
FROM
    products p
JOIN
    categories c ON p.category_id = c.category_id
GROUP BY
    c.category_name;

4. SELECT
    p.prod_name,
    COUNT(r.rating) AS number_of_reviews,
    AVG(r.rating) AS average_rating
FROM
    products p
LEFT JOIN
    reviews r ON p.prod_id = r.prod_id
GROUP BY
    p.prod_id, p.prod_name;

5. WITH CustomerOrderTotals AS (
    SELECT
        c.cust_id,
        c.cust_name,
        SUM(o.order_amt) AS total_order_amount
    FROM
        customers c
    JOIN
        orders o ON c.cust_id = o.cust_id
    GROUP BY
        c.cust_id, c.cust_name
)
SELECT
    cust_id,
    cust_name,
    total_order_amount
FROM
    CustomerOrderTotals
WHERE
    total_order_amount = (SELECT MAX(total_order_amount) FROM CustomerOrderTotals)
    OR total_order_amount = (SELECT MIN(total_order_amount) FROM CustomerOrderTotals);
	
6. SELECT
    dept,
    MAX(age) AS max_age,
    MIN(age) AS min_age
FROM
    Employees
GROUP BY
    dept;

7. SELECT
    TO_CHAR(order_dt, 'YYYY-MM') AS order_month,
    COUNT(order_id) AS number_of_orders,
    SUM(order_amt) AS total_sales_amount
FROM
    orders
GROUP BY
    TO_CHAR(order_dt, 'YYYY-MM')
ORDER BY
    order_month;
	
8.SELECT
    s.supplier_name,
    COUNT(p.prod_id) AS number_of_products,
    AVG(p.price) AS average_price
FROM
    suppliers s
JOIN
    product p ON s.supplier_id = p.supplier_id
GROUP BY
    s.supplier_name
ORDER BY
    s.supplier_name;

9. SELECT
    c.category_name,
    MAX(p.price) AS max_price,
    MIN(p.price) AS min_price
FROM
    products p
JOIN
    categories c ON p.category_id = c.category_id
GROUP BY
    c.category_name
ORDER BY
    c.category_name;

10. SELECT
    c.category_name,
    AVG(r.rating) AS average_rating,
    COUNT(r.rating) AS number_of_reviews
FROM
    products p
JOIN
    Reviews r ON p.prod_id = r.prod_id
JOIN
    categories c ON p.cat_id = c.category_id
GROUP BY
    c.category_name
ORDER BY
    c.category_name;
 	
	
