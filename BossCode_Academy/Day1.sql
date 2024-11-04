--DAY1

1. SELECT C.CUSTOMER_ID FROM CUSTOMER C LEFT JOIN ORDERS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID

2. SELECT C.CUSTOMER_ID FROM CUSTOMER C LEFT JOIN ORDERS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID  WHERE O.CUSTOMER_ID IS NULL
  
3.  SELECT ORDER_ID FROM ORDERS GROUP BY ORDER_ID HAVING SUM(QTY) >(SELECT AVG(QTY) FROM ORDERS ) 

--Practice Questions

1. SELECT CUSTOMER_NAME FROM (
   SELECT C.CUSTOMER_NAME, O.ORDER_AMT, DENSE_RANK() OVER(PARTITION BY C.CUSTOMER_NAME ORDER BY O.ORDER_AMT DESC) RN
   FROM CUSTOMER C JOIN ORDERS O
   ON C.CUSTOMER_ID = O.CUSTOMER_ID) WHERE RN<=5

 2.* SELECT C.CUSTOMER_NAME FROM CUSTOMERS C JOIN ORDERS O
    ON C.CUST_ID=O.CUST_ID
    WHERE O.ORDER_DATE>= NOW() - INTERVAL '30 days'   

3. select prod_id, prod_name from products p join orders o
   on p.prod_id = o.prod_id
   group by 1,2 having count(order_id) >= 3  

4. select order_id, prod_id, qty from  customer c join orders o
   on c.cust_id = o.cust_id
  join order_details OD
  on o.order_id = od.order_id
  where c.city = 'Bangalore'   
  
5. SELECT DISTINCT c.cust_id, c.cust_name, c.city
FROM customer c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.prod_id = p.prod_id
WHERE p.price > 100;

6. Select c.customer_id, avg(order_amt)
from customer c join order o
on c.cust_id = o.cust_id
group by c.customer_id

7. SELECT p.prod_id, p.prod_name, p.price
FROM products p
LEFT JOIN order_details od ON p.prod_id = od.prod_id
WHERE od.prod_id IS NULL;

8.* SELECT DISTINCT c.cust_name
FROM customer c
JOIN orders o ON c.cust_id = o.cust_id
WHERE EXTRACT(DOW FROM o.order_dt) IN (0, 6);

9. Select EXTRACT(MONTH FROM order_dt) AS month,
       SUM(order_amount) AS total_order_amount
FROM orders
GROUP BY EXTRACT(MONTH FROM order_dt)
ORDER BY month;


10.* SELECT c.cust_id, c.cust_name, c.city
FROM customer c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.cust_id, c.cust_name, c.city
HAVING COUNT(DISTINCT od.prod_id) > 2;
