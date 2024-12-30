SELECT * FROM sales.sales_data;

ALTER TABLE sales_data MODIFY COLUMN date DATETIME;

UPDATE sales_data
SET date = STR_TO_DATE(date, '%m/%d/%y');

select date 
from sales_data;

SELECT DATE_FORMAT(date, '%d/%m/%Y') AS dates
FROM sales_data;

--------- MAIN
select * from sales_data
order by date;

-- price of each product category
SELECT category, price
FROM sales_data
GROUP BY category, price;

-- Total sales
select sum(revenue) as total_sales
from sales_data;

-- SALES FOR EACH PRODUCT CATEGORY

select category, sum(Revenue) as total_sale
from sales_data
group by Category
order by total_sale DESC;

-- Orders for each category

select category, sum(Sales_Volume) as total_orders
from sales_data
group by category
order by total_orders desc;

-- total_sales, orders across each category

select category, sum(Sales_Volume) as total_orders, sum(Revenue) as total_sales
from sales_data
group by category
order by total_sales desc;

-- Sales during each season

select season, sum(revenue) as total_sales
from sales_data
group by season
order by total_sales;

-- top-selling product category in each season

select season, 
	category, 
	sum(revenue) as max_sales,
	DENSE_RANK() OVER (partition by season order by sum(revenue) DESC) as cat_rank
from sales_data
group by season, category;

---  method 2

select season, category, total_sales
from(
	select season,
		   category,
		   sum(revenue) as total_sales,
		   DENSE_RANK() OVER (PARTITION BY season ORDER BY SUM(revenue) DESC) AS cat_rank
	from sales_data
    group by season, category
	)subquery
where cat_rank = 1;

-- low-selling product category in each season
SELECT season, category, total_sales
FROM (
    SELECT season, 
           category, 
           SUM(revenue) AS total_sales,
           DENSE_RANK() OVER (PARTITION BY season ORDER BY SUM(revenue) ASC) AS cat_rank
    FROM sales_data
    GROUP BY season, category
) subquery
WHERE cat_rank = 1;

-- min and max price of each product category.
select category, 
		min(price) as sale_price, 
		max(price) as org_price,
        ((max(price) - min(price)) / max(price)) * 100 as discount_percentage
from sales_data 
group by category;	

-- total sales for each season

select season, sum(revenue) as sales
from sales_data
group by season
order by sales desc;

-- buying patterns

select season, 
	(sum(sales_volume) / sum(revenue)) as order_to_sale_ratio
from sales_data	
group by season
order by order_to_sale_ratio desc;

-- Sales across different countries

select location, sum(revenue) as sales
from sales_data
group by location
order by sales desc;

select category, sum(revenue), sum(sales_volume)
from sales_data
where date = '2023-11-24'
group by category;

-- Black Friday (November Sales)
select sum(revenue) as total_sales
from sales_data
where extract(month from date) = 11;

-- November Sales across Products
select product_name, sum(revenue) as total_sales
from sales_data
where extract(month from date) = 11
group by product_name;

-- Monthly Sales analysis

select month(date) as Month,
sum(revenue) as total_revenue
from sales_data
group by month(date)
order by month;

-- Inventory Analysis
select category, sum(stock_level) as total_stock, sum(revenue) as total_sales, sum(sales_volume) as quantity_sold
from sales_data
group by category
order by total_stock desc;

-- outwear analysis during winter
select category, season, sum(revenue) as total_revenue
from sales_data
where category = 'Outerwear'
group by season;

