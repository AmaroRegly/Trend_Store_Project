#DATA CLEANING --------------

#Convert column type from object to datetime
ALTER TABLE orders
MODIFY COLUMN order_date datetime;

ALTER TABLE orders
MODIFY COLUMN delivery_date datetime;

#Normalization of column name from product_ID to product_id
ALTER TABLE products
CHANGE product_ID product_id int;

#DATA FUSION ----------------

SELECT *
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id;

#EXPLORAÇÃO DE DADOS ---------------

#What is the overall sales performance throughout 2021?

SELECT 
	SUM(s.total_price)
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id;
    
#What is the average ticket in 2021?

SELECT 
	avg(s.total_price)
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id;

#What is the overall sales performance throughout 2021?

SELECT 
	EXTRACT(month FROM order_date) as month,
    sum(total_price) as total
FROM sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY month
order by total desc;

#Which product categories have the highest revenues?

SELECT 
	p.product_type,
    sum(s.total_price) as total
FROM sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY p.product_type
order by total desc;

#What are the products that SELL THE MOST and are our "champions"? And what are the products that SELL LESS so that we can boost

SELECT
    p.product_name,
    p.product_type,
    SUM(s.total_price) AS total_price
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY 
	p.product_name,
    p.product_type
ORDER BY
	total_price desc;
    
#How many products were sold in 2021?

SELECT
    p.product_name,
    p.product_type,
    SUM(s.quantity) AS qtd
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY 
	p.product_name,
    p.product_type
ORDER BY
	qtd desc;
    
#Who are the top 5 customers in terms of purchases? 

SELECT
	c.customer_name,
    COUNT(o.order_id) AS orders_qtd,
    SUM(s.quantity) AS qtd,
    SUM(s.total_price) AS total_price
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY 
	c.customer_name
ORDER BY
	total_price desc
LIMIT 10;

#Revenue by State
    
SELECT
	c.state,
    SUM(total_price) as total
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY
	c.state
ORDER BY
	total desc;    

#Recipe by genre

SELECT
	c.gender,
    SUM(total_price) as total
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY
	c.gender
ORDER BY
	total desc; 
    
#In the year, how many products on average did customers buy?

WITH media AS (
	SELECT
		AVG(s.quantity) as total
	FROM 
		sales s
	JOIN 
		products p ON s.product_id = p.product_id
	JOIN
		orders o ON s.order_id = o.order_id
	JOIN
		customers c ON o.customer_id = c.customer_id
	)
    SELECT
		AVG(total) as products_avg
	FROM
		media; 
               
#What is the average age of our customers?

SELECT
	AVG(age) as age_avg
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id;
    
  
#Average delivery time
    
SELECT
    AVG(datediff(o.delivery_date, o.order_date)) as diff
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id;
    
#Sales by size

SELECT
    p.size,
    SUM(s.quantity) as quantity
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY
	p.size
ORDER BY
	quantity desc;

#Sales by color

SELECT
    p.colour,
    SUM(s.total_price) as total_price
FROM 
	sales s
JOIN 
	products p ON s.product_id = p.product_id
JOIN
	orders o ON s.order_id = o.order_id
JOIN
	customers c ON o.customer_id = c.customer_id
GROUP BY
	p.colour
ORDER BY
	total_price desc;