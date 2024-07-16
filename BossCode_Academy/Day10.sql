--DAY10
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

2. 
