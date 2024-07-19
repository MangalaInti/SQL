--DAY5
1. UPDATE employees SET sal = sal * 1.10;
2. ***
-- Step 1: Delete associated order items
DELETE FROM order_items oi join  orders o
 oi.order_id = o.order_id
AND o.order_dt < NOW() - INTERVAL '1 year';

-- Step 2: Delete the orders themselves
DELETE FROM orders
WHERE order_dt < NOW() - INTERVAL '1 year';

3. ***

BEGIN;

-- Step 1: Insert the new category
INSERT INTO categories (cat_name) VALUES ('New Category Name')
RETURNING cat_id INTO new_cat_id;

-- Step 2: Update all products of a specific category to the new category
UPDATE products
SET cat_id = new_cat_id
WHERE cat_id = (SELECT cat_id FROM categories WHERE cat_name = 'Old Category Name');

COMMIT;

4. UPDATE products
SET discount_percentage = new_discount_percentage
WHERE price BETWEEN 50 AND 100;

5. DELETE FROM reviews WHERE rating < 3;


6. ***
DO $$
DECLARE
    new_cust_id INTEGER;
    new_order_id INTEGER;
BEGIN
    -- Step 1: Insert the new customer
    INSERT INTO customers (cust_name) VALUES ('New Customer Name')
    RETURNING cust_id INTO new_cust_id;

    -- Step 2: Insert the new order for the new customer
    INSERT INTO orders (cust_id, order_dt) VALUES (new_cust_id, CURRENT_DATE)
    RETURNING order_id INTO new_order_id;

    -- Step 3: Insert the order items for the new order
    INSERT INTO order_items (order_id, prod_id, qty) VALUES 
    (new_order_id, 1, 2),  -- Replace with actual product IDs and quantities
    (new_order_id, 2, 3),  -- Replace with actual product IDs and quantities
    (new_order_id, 3, 1);  -- Replace with actual product IDs and quantities

    -- Commit the transaction
    COMMIT;
END $$;

7. UPDATE employees SET sal = sal * 1.15 WHERE dept = 'Sales';

8. *** 
 DELETE FROM products
WHERE prod_id NOT IN (
    SELECT DISTINCT prod_id 
    FROM order_items
);
 --OR 
 DELETE FROM products p
USING products p
LEFT JOIN order_items oi ON p.prod_id = oi.prod_id
WHERE oi.prod_id IS NULL;

9. ***
DO $$
DECLARE
    new_supplier_id INTEGER;
BEGIN
    -- Start the transaction
    BEGIN;

    -- Step 1: Insert the new supplier
    INSERT INTO suppliers (supplier_name) VALUES ('New Supplier Name')
    RETURNING supplier_id INTO new_supplier_id;

    -- Step 2: Insert associated products for the new supplier
    INSERT INTO products (prod_name, supplier_id) VALUES
    ('Product 1', new_supplier_id),
    ('Product 2', new_supplier_id),
    ('Product 3', new_supplier_id);
    -- Add more products as needed

    -- Commit the transaction
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Rollback the transaction in case of an error
        ROLLBACK;
        RAISE NOTICE 'An error occurred, and the transaction has been rolled back.';
END $$;

10. ***

UPDATE orders
SET order_dt = CASE
    WHEN EXTRACT(DOW FROM order_dt) = 0 THEN order_dt + 1  -- Sunday
    WHEN EXTRACT(DOW FROM order_dt) = 6 THEN order_dt + 2  -- Saturday
    ELSE order_dt
END
WHERE EXTRACT(DOW FROM order_dt) IN (0, 6);


--Test Query

SELECT order_id, order_dt,
    CASE 
        WHEN EXTRACT(DOW FROM order_dt) = 0 THEN order_dt + 1  -- Sunday to Monday
        WHEN EXTRACT(DOW FROM order_dt) = 6 THEN order_dt + 2  -- Saturday to Monday
        ELSE order_dt
    END AS new_order_dt
FROM orders
WHERE EXTRACT(DOW FROM order_dt) IN (0, 6);
