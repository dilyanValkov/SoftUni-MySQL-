#1. Departments Info
SELECT `department_id`, COUNT(`id`) AS 'Number of empoyees' FROM `employees`
GROUP BY `department_id`;

#2. Average Salary
SELECT `department_id`, ROUND(AVG(`salary`),2) AS 'Average salary' 
FROM `employees`
GROUP BY `department_id`;

#3. Minimum Salary
SELECT `department_id`, ROUND(MIN(`salary`),2) AS 'Min salary'
FROM `employees`
GROUP BY `department_id`
HAVING `Min salary` > 800;

#4. Appetizers Count
SELECT COUNT(`category_id`) AS 'Appetizers' FROM `products`
WHERE `price` > 8
GROUP BY `category_id`
HAVING `category_id` = 2;

#5. Menu Prices
SELECT`category_id`,
ROUND(AVG(`price`),2) AS 'Average Price',
ROUND(MIN(`price`),2) AS 'Cheapest Price',
ROUND(MAX(`price`),2) AS 'Most Expensive Product'
FROM `products`
GROUP BY `category_id`;