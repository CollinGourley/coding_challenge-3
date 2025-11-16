-- Task 1 Identify the top 5 spending customers in the store database.

SELECT
    c.id AS customer_id,
    c.first_name || ' ' || c.last_name AS customer_full_name,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS total_spend
FROM customers c
JOIN orders o
  ON o.customer_id = c.id
JOIN order_items oi
  ON oi.order_id = o.id
GROUP BY c.id, customer_full_name
ORDER BY total_spend DESC
LIMIT 5;


-- Task 2 Total revenue by product category.

SELECT
    p.category AS category,
    ROUND(SUM(oi.quantity * oi.unit_price), 2) AS revenue
FROM products p
JOIN order_items oi
  ON oi.product_id = p.id
JOIN orders o
  ON o.id = oi.order_id
-- Include all orders here; see delivered-only variant afterwards
GROUP BY p.category
ORDER BY revenue DESC;


--Task 3 employees earning above department average

SELECT
    e.first_name,
    e.last_name,
    d.name AS department_name,
    e.salary AS employee_salary,
    ROUND(dept_avg.avg_salary, 2) AS department_avg_salary
FROM employees e
JOIN departments d
  ON e.department_id = d.id
JOIN (
    -- department average salaries
    SELECT
        department_id,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
) AS dept_avg
  ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.avg_salary
ORDER BY d.name ASC, e.salary DESC;

--Task 4 Cities with the most loyalty customers
SELECT
    city,
    COUNT(*) AS gold_customer_count
FROM customers
WHERE upper(loyalty_level) = 'GOLD'
GROUP BY city
ORDER BY gold_customer_count DESC, city ASC;
  