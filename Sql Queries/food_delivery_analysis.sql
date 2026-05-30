use food_delivery;
CREATE TABLE customers(
customer_id INT PRIMARY KEY,
customer_name VARCHAR(100),
city VARCHAR(50)
);

CREATE TABLE restaurants(
restaurant_id INT PRIMARY KEY,
restaurant_name VARCHAR(100),
cuisine VARCHAR(50)
);

CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT,
restaurant_id INT,
order_date DATE,
order_amount DECIMAL(10,2),
status VARCHAR(20),
delivery_time INT,
FOREIGN KEY(customer_id)
REFERENCES customers(customer_id),
FOREIGN KEY(restaurant_id)
REFERENCES restaurants(restaurant_id)
);

SHOW TABLES;

SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM restaurants;
SELECT COUNT(*) FROM orders;

-- KPI 1:Total Revenue
SELECT ROUND(SUM(order_amount),2) AS total_revenue
FROM orders
WHERE status='Delivered'; 

-- KPI 2:Total Orders 
SELECT COUNT(*) AS total_orders
FROM orders;

-- KPI 3: Cancellation Rate 
SELECT
COUNT(*) AS total_orders,
SUM(CASE WHEN status='Delivered' THEN 1 ELSE 0 END) AS delivered_orders,
COUNT(*) - SUM(CASE WHEN status='Delivered' THEN 1 ELSE 0 END) AS cancelled_orders
FROM orders;


-- KPI 4:Average Order Value 
SELECT ROUND(AVG(order_amount),2) AS avg_order_value
FROM orders;

-- KPI 5:Average Delivery Time 
SELECT ROUND(AVG(delivery_time),2) AS avg_delivery_time
FROM orders
WHERE status='Delivered';

-- KPI 6 :MIN,MAX,AVG Orders 
SELECT
MIN(order_amount) AS minimum_order,
MAX(order_amount) AS maximum_order,
ROUND(AVG(order_amount),2) AS average_order
FROM orders;

-- Bussiness Analysis 
-- Top 5 Customers 
SELECT c.customer_name,
       SUM(o.order_amount) AS spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_name
ORDER BY spending DESC
LIMIT 5;

-- Top Restaurants 
SELECT r.restaurant_name,
       SUM(o.order_amount) AS revenue
FROM restaurants r
JOIN orders o
ON r.restaurant_id = o.restaurant_id
GROUP BY r.restaurant_name
ORDER BY revenue DESC;

-- Revenue By City 
SELECT c.city,
       SUM(o.order_amount) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY revenue DESC;

-- Restaurant Ranking 
SELECT
restaurant_name,
revenue,
RANK() OVER(ORDER BY revenue DESC) AS ranking
FROM
(
SELECT
r.restaurant_name,
SUM(o.order_amount) AS revenue
FROM restaurants r
JOIN orders o
ON r.restaurant_id=o.restaurant_id
GROUP BY r.restaurant_name
) t;