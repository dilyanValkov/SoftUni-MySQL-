#1. Managers
SELECT e.`employee_id`, 
CONCAT_WS(' ',`first_name`,`last_name`) AS 'full_name',
d.`department_id`,
d.`name` 
FROM `employees` AS e
JOIN `departments` AS d ON e.`employee_id` = d.`manager_id`
ORDER BY `employee_id`
LIMIT 5;

#2. Towns and Addresses
SELECT a.`town_id`, 
t.`name`,
a.`address_text` 
FROM `addresses` AS a
JOIN `towns` AS t ON a.`town_id` = t.`town_id`
WHERE t.`name` IN ('San Francisco' ,'Sofia' , 'Carnation')
ORDER BY `town_id`, `address_id`;

#3. Employees Without Managers
SELECT e.`employee_id`, 
e.`first_name`, e.`last_name`,
e.`department_id`,
e.`salary` 
FROM `employees` AS e
WHERE `manager_id` IS NULL;

#4. High Salary
SELECT COUNT(`employee_id`) FROM employees
WHERE `salary` > (
SELECT AVG (`salary`) from `employees`);