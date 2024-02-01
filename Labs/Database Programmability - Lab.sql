#1. Count Employees by Town
CREATE FUNCTION ufn_count_employees_by_town(town_name VARCHAR (50))
RETURNS INT
DETERMINISTIC
BEGIN
DECLARE count INT;
SET count := (SELECT COUNT(*) FROM `employees` AS e
	JOIN `addresses`AS a USING (`address_id`)
	JOIN `towns` AS t USING (`town_id`)
	WHERE t.`name` = town_name);
    RETURN count;
END;

#2. Employees Promotion
CREATE PROCEDURE usp_raise_salaries(department_name VARCHAR(50))
BEGIN
UPDATE `employees` as E
JOIN `departments` AS d USING (`department_id`)
SET `salary` = `salary` * 1.05
WHERE department_name = d.`name`;
END;

#3. Employees Promotion By ID
CREATE PROCEDURE usp_raise_salary_by_id(empoyee_id INT)
BEGIN
START TRANSACTION;
IF ((SELECT COUNT(*) FROM `employees`
	WHERE `employee_id` = empoyee_id) <> 1)
        THEN ROLLBACK;
ELSE
UPDATE `employees` 
SET `salary` = `salary` * 1.05
WHERE `employee_id` = empoyee_id;
END IF;
END;

#4. Triggered
CREATE TABLE `deleted_employees`(
`employee_id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR (50),
`last_name` VARCHAR (50),
`middle_name` VARCHAR (50),
`job_title` VARCHAR (50),
`department_id` INT,
`salary` DECIMAL (19,4));

CREATE TRIGGER insert_into_deleted_empl
BEFORE DELETE ON `employees`
FOR EACH ROW
BEGIN
INSERT INTO
`deleted_employees` (`first_name`, `last_name`,`middle_name`,`job_title`,`department_id`,`salary`)
VALUES (OLD.`first_name`,OLD.`last_name`, OLD.`middle_name`, OLD.`job_title`,OLD.`department_id`, OLD.`salary`);
END;

