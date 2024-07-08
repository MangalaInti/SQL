--DAY2
--Practice Questions
1. SELECT
    c.cust_name,
    o.order_id,
    o.order_dt,
    p.prod_name,
    oi.qty
FROM
    customers c
JOIN
    orders o ON c.cust_id = o.cust_id
JOIN
    order_items oi ON o.order_id = oi.order_id
JOIN
    products p ON oi.prod_id = p.prod_id;
	
2. 	SELECT
    p.prod_name,
    s.supplier_name
FROM
    products p
JOIN
    supplier s ON p.supplier_id = s.supplier_id;
	
3. SELECT
    c.cust_id,
    c.cust_name
FROM
    customers c
LEFT JOIN
    orders o ON c.cust_id = o.cust_id
WHERE
    o.order_id IS NULL
	
4. SELECT
    c.cust_name,
    SUM(oi.qty) AS total_qty
FROM
    customers c
JOIN
    orders o ON c.cust_id = o.cust_id
JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY
    c.cust_name;
	
5. SELECT DISTINCT
    p.prod_id,
    p.prod_name
FROM
    products p
JOIN
    order_items oi ON p.prod_id = oi.prod_id
JOIN
    orders o ON oi.order_id = o.order_id
JOIN
    customers c ON o.cust_id = c.cust_id
WHERE
    c.ctry = 'specific_country';
	
6.SELECT c.cust_id, c.cust_name, COALESCE(SUM(o.order_amt), 0) AS total_order_amt
FROM Customer c
LEFT JOIN Orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name;

7. SELECT c.cust_id, c.cust_name, c.occupation, o.order_id, o.order_dt, oi.prod_id, oi.qty
FROM Customer c
JOIN Orders o ON c.cust_id = o.cust_id
JOIN order_items oi ON o.order_id = oi.order_id
WHERE c.occupation = 'specific_occupation';

8. SELECT DISTINCT c.cust_id, c.cust_name, c.occupation
FROM Customer c
JOIN Orders o ON c.cust_id = o.cust_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.prod_id = p.prod_id
WHERE p.price > (SELECT AVG(price) FROM products);

9.SELECT c.cust_name, COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_name;

10. SELECT p.prod_name, SUM(oi.qty) AS total_qty_ordered
FROM products p
JOIN order_items oi ON p.prod_id = oi.prod_id
GROUP BY p.prod_id, p.prod_name;
