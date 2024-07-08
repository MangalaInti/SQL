1. SELECT * FROM customers WHERE name LIKE 'A%n';

2. SELECT * FROM products WHERE prod_name ~ '[0-9]';

3. SELECT * FROM employees ORDER BY salary ASC NULLS LAST;

4. SELECT * FROM customers WHERE LENGTH(cust_name) = 5;
                        OR
   SELECT * FROM customers WHERE cust_name LIKE '_____';
   
5. SELECT * FROM products WHERE prod_name LIKE 's%e';

6. SELECT * FROM employees ORDER BY lastname ASC, firstname ASC;

7. SELECT o.order_id, o.order_dt, o.cust_id, c.cust_name
FROM orders o
JOIN customers c ON o.cust_id = c.cust_id
WHERE o.order_dt = '2024-07-05'  -- Replace with the specific date
ORDER BY c.cust_name ASC;

8. SELECT *
FROM products
WHERE LENGTH(prod_name) = 3 AND prod_name ~ '^[A-Za-z]+$';

9. SELECT *
FROM employees
ORDER BY salary DESC NULLS FIRST;

10. SELECT *
FROM employees
ORDER BY CASE WHEN salary IS NULL THEN 0 ELSE 1 END DESC, salary DESC;

10. SELECT *
FROM customers
WHERE cust_name LIKE '% %';
