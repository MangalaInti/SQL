--DAY&
1.
WITH top_customers AS (
    SELECT
        o.cust_id,
        c.cust_name,
        SUM(o.order_amt) AS total_order_amt,
        RANK() OVER (ORDER BY SUM(o.order_amt) DESC) AS rank
    FROM
        orders o
    JOIN
        customer c ON o.cust_id = c.cust_id
    GROUP BY
        o.cust_id, c.cust_name
)
SELECT
    tc.cust_id,
    tc.cust_name,
    tc.total_order_amt,
    ROUND((tc.total_order_amt / (SELECT SUM(order_amt) FROM orders)) * 100, 2) AS percentage_of_total
FROM
    top_customers tc
WHERE
    tc.rank <= 3
ORDER BY
    tc.total_order_amt DESC;

2. CREATE OR REPLACE FUNCTION update_employee_salary(
    p_emp_id INT,
    p_new_sal NUMERIC
) RETURNS VOID AS $$
DECLARE
    v_old_sal NUMERIC;
BEGIN
    -- Get the current salary of the employee
    SELECT sal INTO v_old_sal
    FROM employees
    WHERE emp_id = p_emp_id;

    -- Update the salary of the employee
    UPDATE employees
    SET sal = p_new_sal
    WHERE emp_id = p_emp_id;

    -- Log the change in the salary_log table
    INSERT INTO salary_log (emp_id, old_sal, new_sal, modified_dt)
    VALUES (p_emp_id, v_old_sal, p_new_sal, NOW());
END;
$$ LANGUAGE plpgsql;

To call this stored procedure and update an employee's salary, use the following SQL statement:
    SELECT update_employee_salary(1, 75000);

3. SELECT
    p.prod_id,
    p.prod_name,
    AVG(r.rating) AS avg_rating,
    RANK() OVER (ORDER BY AVG(r.rating) DESC) AS rank
FROM
    products p
JOIN
    ratings r ON p.prod_id = r.prod_id
GROUP BY
    p.prod_id, p.prod_name
ORDER BY
    avg_rating DESC;
4. CREATE OR REPLACE FUNCTION insert_order_with_items(
    p_order_dt TIMESTAMP,
    p_order_items JSONB
) RETURNS VOID AS $$
DECLARE
    v_order_id INT;
BEGIN
    -- Insert into orders table
    INSERT INTO orders (order_dt)
    VALUES (p_order_dt)
    RETURNING order_id INTO v_order_id;

    -- Loop through each item in the JSON array and insert into order_items table
    FOR item IN SELECT * FROM jsonb_array_elements(p_order_items)
    LOOP
        INSERT INTO order_items (order_id, prod_id, qty_amt)
        VALUES (v_order_id, item->>'prod_id', (item->>'qty_amt')::NUMERIC);
    END LOOP;
END;
$$ LANGUAGE plpgsql;


5. SELECT
    p.prod_id,
    p.prod_name,
    SUM(oi.qty * oi.amt) AS total_sales,
    RANK() OVER (ORDER BY SUM(oi.qty * oi.amt) DESC) AS sales_rank
FROM
    products p
JOIN
    order_items oi ON p.prod_id = oi.prod_id
GROUP BY
    p.prod_id, p.prod_name
HAVING
    RANK() OVER (ORDER BY SUM(oi.qty * oi.amt) DESC) <= 5
ORDER BY
    total_sales DESC;

6. CREATE OR REPLACE FUNCTION get_total_order_amount(
    p_cust_id INT
) RETURNS NUMERIC AS $$
DECLARE
    v_total_amount NUMERIC;
BEGIN
    -- Calculate the total order amount for the specified customer
    SELECT COALESCE(SUM(o.order_amt), 0) INTO v_total_amount
    FROM orders o
    WHERE o.cust_id = p_cust_id;

    -- Return the total order amount
    RETURN v_total_amount;
END;
$$ LANGUAGE plpgsql;

7. SELECT
    c.cat_name,
    p.prod_name,
    AVG(r.rating) AS avg_rating,
    RANK() OVER (PARTITION BY c.cat_name ORDER BY AVG(r.rating) DESC) AS rn
FROM
    products p
LEFT JOIN
    ratings r ON p.prod_id = r.prod_id
LEFT JOIN
    categories c ON c.cat_id = p.cat_id
GROUP BY
    c.cat_name, p.prod_name
ORDER BY
    c.cat_name, rn;

8.  The stored procedure will delete records from the Order_items and Orders tables and then delete the record from the 
    customers table.

  CREATE OR REPLACE PROCEDURE delete_customer_and_associations(
    p_cust_id INT
) LANGUAGE plpgsql
AS $$
BEGIN
    -- Delete all order items associated with the orders of the specified customer
    DELETE FROM order_items
    WHERE order_id IN (
        SELECT order_id FROM orders WHERE cust_id = p_cust_id
    );

    -- Delete all orders associated with the specified customer
    DELETE FROM orders
    WHERE cust_id = p_cust_id;

    -- Delete the customer
    DELETE FROM customers
    WHERE cust_id = p_cust_id;

    -- Optionally, you can add a message to confirm the deletion
    RAISE NOTICE 'Customer and associated records have been deleted for customer ID: %', p_cust_id;
END;
$$;

9. SELECT
    e.emp_name,
    SUM(o.order_amt) AS total_sales,
    RANK() OVER (ORDER BY SUM(o.order_amt) DESC) AS rn
FROM
    employees e
JOIN
    orders o ON e.emp_id = o.emp_id
GROUP BY
    e.emp_id, e.emp_name
HAVING
    RANK() OVER (ORDER BY SUM(o.order_amt) DESC) <= 3
ORDER BY
    rn;

10. This stored procedure will perform two main tasks:

Update the Quantity_in_stock for the specified product.
Insert a record into the Stock_log table with the details of the change.

   CREATE OR REPLACE PROCEDURE update_stock_quantity(
    p_prod_id INT,
    p_new_quantity INT
) LANGUAGE plpgsql
AS $$
DECLARE
    v_old_quantity INT;
BEGIN
    -- Get the current quantity in stock for the specified product
    SELECT Quantity_in_stock INTO v_old_quantity
    FROM products
    WHERE prod_id = p_prod_id;

    -- Update the quantity in stock for the specified product
    UPDATE products
    SET Quantity_in_stock = p_new_quantity
    WHERE prod_id = p_prod_id;

    -- Log the change in the Stock_log table
    INSERT INTO Stock_log (prod_id, old_quantity, new_quantity, modified_dt)
    VALUES (p_prod_id, v_old_quantity, p_new_quantity, CURRENT_TIMESTAMP);

    -- Optionally, you can add a message to confirm the update
    RAISE NOTICE 'Updated quantity for product ID %: from % to %', p_prod_id, v_old_quantity, p_new_quantity;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Handle the case where no product is found with the given prod_id
        RAISE EXCEPTION 'Product with ID % does not exist.', p_prod_id;
    WHEN OTHERS THEN
        -- Handle unexpected errors
        RAISE EXCEPTION 'An error occurred while updating stock for product ID %.', p_prod_id;
END;
$$;


 

