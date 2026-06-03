drop table if exists zepto

create table zepto(
Category varchar (120),
name VARCHAR (150) NOT NULL,
mrp NUMERIC (8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

SELECT * FROM zepto
ALTER TABLE zepto
ADD sku_id SERIAL PRIMARY KEY ;

--count of rows
SELECT COUNT(*) FROM zepto;

--sample data
SELECT * FROM zepto
limit 10;

--null values
SELECT * FROM zepto
WHERE name IS NULL
OR
 category IS NULL
OR
 mrp IS NULL
OR
 discountpercent IS NULL
OR
 discountedsellingprice IS NULL
OR
 weightingms IS NULL
OR
 outofstock IS NULL
OR
 quantity IS NULL;

--different product categories
SELECT DISTINCT category 
FROM zepto
ORDER BY category;

--products in stock Vs out of stock
SELECT outOFStock,COUNT (sku_id)
FROM zepto
GROUP BY outOfStock;

--PRODUCT names present multiple times
SELECT name, COUNT(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name
HAVING COUNT(sku_id)>5
ORDER BY COUNT(sku_id) DESC;

-- data cleaning

--products with price =0
SELECT * FROM zepto
WHERE mrp = 0  OR discountedSellingPrice = 0;

DELETE FROM zepto
WHERE mrp = 0;

SELECT * FROM zepto

--CONVERT paise to RUPEES
UPDATE zepto
SET mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

--Q1.Find the top 10 best _value products based on the dicount percentage
SELECT DISTINCT name,mrp, discountpercent AS Best_value_products 
from zepto
ORDER BY discountpercent DESC
LIMIT 10;

--Q2. What are the Products with High MRP But Out of stock
SELECT DISTINCT name, mrp
FROM zepto
WHERE outofstock= TRUE AND mrp>= 300
ORDER BY mrp DESC;

--Q3. Calculate Estimated Revenue For each category
SELECT category ,
  SUM(discountedsellingprice * availablequantity) AS total_revenue
FROM zepto
GROUP BY category
ORDER BY total_revenue;

--Q4. FIND all proucts where mrp is greater than 500 and discount is less than 10%

SELECT * FROM zepto

SELECT DISTINCT name, mrp, discountpercent from zepto
WHERE mrp > 500 AND discountpercent <10
ORDER BY mrp DESC, discountpercent DESC;

--Q5. identify the top 5  categories OFFERING the highest AVERAGE discount percentage?
SELECT DISTINCT category, 
ROUND (avg(discountpercent),2) AS avg_discount
from zepto
GROUP BY category
ORDER BY  avg_discount DESC
limit 5;

--Q6. FIND the price per gram for products above 100g and sort by best value
SELECT DISTINCT weightingms,discountedsellingprice, 
ROUND (discountedsellingprice/weightingms,2) AS price_per_gram
FROM zepto
WHERE weightingms > 100
ORDER BY price_per_gram DESC;

--Q7. Group the products into categories like  low, Medium, Bulk

SELECT DISTINCT name, weightingms,
CASE WHEN weightingms < 1000 THEN 'Low'
     WHEN weightingms < 5000 THEN 'Medium'
ELSE 'Bulk'
   END as Weight_category 
 FROM zepto;

--Q8. What is the total Inventory Weight Per catgory

SELECT category ,
SUM(availablequantity * weightingms) AS total_weight
FROM zepto
group by category
ORDER BY total_weight DESC;