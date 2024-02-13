#01. Table Design
CREATE TABLE `continents`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(40) UNIQUE NOT NULL
);

CREATE TABLE `countries`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(40) UNIQUE NOT NULL,
`country_code`  VARCHAR(10) UNIQUE NOT NULL,
`continent_id` INT NOT NULL,
CONSTRAINT fk_countries_continents
FOREIGN KEY (`continent_id`)
REFERENCES continents(`id`)
);

CREATE TABLE `preserves`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(255) UNIQUE NOT NULL,
`latitude`  DECIMAL(9,6),
`longitude`  DECIMAL(9,6),
`area` INT,
`type` VARCHAR (20),
`established_on` DATE NOT NULL
);

CREATE TABLE `positions`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(40) UNIQUE NOT NULL,
`description` TEXT,
`is_dangerous` BOOLEAN NOT NULL
);

CREATE TABLE `workers`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(40) NOT NULL,
`last_name` VARCHAR(40) NOT NULL,
`age` INT,
`personal_number` VARCHAR (20) UNIQUE NOT NULL,
`salary` DECIMAL (19,2),
`is_armed` BOOLEAN NOT NULL,
`start_date` DATE,
`preserve_id` INT,
`position_id` INT,
CONSTRAINT fk_workers_preserves
FOREIGN KEY (`preserve_id`)
REFERENCES preserves(`id`),
CONSTRAINT fk_workers_positions
FOREIGN KEY (`position_id`)
REFERENCES positions(`id`)
);

CREATE TABLE `countries_preserves` (
    `country_id` INT,
    `preserve_id` INT,
    CONSTRAINT fk_countries_preserves_countries FOREIGN KEY (`country_id`)
        REFERENCES countries(`id`),
    CONSTRAINT fk_countries_preserves_preserves FOREIGN KEY (`preserve_id`)
        REFERENCES preserves(`id`)
);

#02. Insert
INSERT INTO `preserves` (`name`,`latitude`,`longitude`,`area`,`type`,`established_on`) 
SELECT CONCAT(`name`, ' ', 'is in South Hemisphere'),
		`latitude`,
        `longitude`,
        `area` * `id`,
        LOWER(`type`),
        `established_on` FROM `preserves`
        WHERE `latitude` < 0;
        
#03. Update
UPDATE `workers`
SET `salary` = `salary` + 500
WHERE `position_id` IN (5,8,11,13);

#04. Delete
DELETE FROM `preserves`
WHERE `established_on` IS NULL;

#05. Most experienced workers
SELECT 
    CONCAT(first_name, ' ', last_name) AS 'full_name',
    DATEDIFF('2024-01-01', start_date) AS 'days_of_experience'
FROM
    `workers`
WHERE
    2023 - YEAR(`start_date`) > 5
ORDER BY days_of_experience DESC
LIMIT 10;

#06. Workers salary
SELECT 
    w.`id`,
    w.`first_name`,
    w.`last_name`,
    p.`name`,
    c.`country_code`
FROM
    `workers` AS w
        JOIN
    `preserves` AS p ON w.`preserve_id` = p.`id`
        JOIN
    `countries_preserves` AS cp ON cp.`preserve_id` = p.`id`
        JOIN
    `countries` AS c ON cp.`country_id` = c.`id`
WHERE
    w.`salary` > 5000 AND `age` < 50
ORDER BY c.`country_code`;

#07. Armed workers count
SELECT 
    p.`name`, COUNT(w.`id`) AS 'armed_workers'
FROM
    `workers` AS w
        JOIN
    `preserves` AS p ON w.`preserve_id` = p.`id`
WHERE
    w.`is_armed` IS TRUE
GROUP BY p.`name`
ORDER BY armed_workers DESC , p.`name`;

#08. Oldest preserves
SELECT 
    p.`name`,
    c.`country_code`,
    YEAR(p.`established_on`) AS 'founded_in'
FROM
    `preserves` AS p
        JOIN
    `countries_preserves` AS cp ON cp.`preserve_id` = p.`id`
        JOIN
    `countries` AS c ON cp.`country_id` = c.`id`
WHERE
    MONTH(p.`established_on`) = 05
ORDER BY founded_in
LIMIT 5;

#09. Preserve categories
SELECT 
    `id`,
    `name`,
    (CASE
        WHEN `area` <= 100 THEN 'very small'
        WHEN `area` <= 1000 THEN 'small'
        WHEN `area` <= 10000 THEN 'medium'
        WHEN `area` <= 50000 THEN 'large'
        ELSE 'very large'
    END) AS 'category'
FROM
    `preserves`
ORDER BY `area` DESC;

#10. Extract average salary
DELIMITER ^^
CREATE FUNCTION udf_average_salary_by_position_name (position_name VARCHAR(40))
RETURNS DECIMAL (19,2)
DETERMINISTIC
BEGIN
DECLARE result DECIMAL (19,2);
SET result := (SELECT AVG(w.`salary`) FROM `workers` AS w
JOIN `positions` AS p ON w.`position_id`= p.`id`
WHERE p.`name` = position_name
GROUP BY p.`id`);
RETURN result;
END^^

#11. Improving the standard of living
DELIMITER ^^
CREATE PROCEDURE udp_increase_salaries_by_country (country_name VARCHAR(40))
BEGIN
UPDATE `workers` AS w
JOIN `countries_preserves` AS cp ON cp.`preserve_id` = w.`preserve_id`
JOIN `countries` AS c ON c.`id` = cp.`country_id`
SET w.`salary` = `salary` * 1.05
WHERE c.`name` = country_name;
END^^