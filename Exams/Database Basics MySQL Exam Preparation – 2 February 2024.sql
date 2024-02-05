CREATE SCHEMA universities_db;

#01. Table Design
CREATE TABLE `countries`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR (40) UNIQUE NOT NULL);

CREATE TABLE `cities`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR (40) UNIQUE NOT NULL,
`population` INT,
`country_id` INT NOT NULL,
CONSTRAINT fk_cities_countries
FOREIGN KEY (`country_id`)
REFERENCES countries(`id`));

CREATE TABLE `universities`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR (60) UNIQUE NOT NULL,
`address` VARCHAR (80) UNIQUE NOT NULL,	
`tuition_fee` DECIMAL(19,2) NOT NULL,
`number_of_staff` INT,
`city_id` INT,
CONSTRAINT fk_univers_cities
FOREIGN KEY (`city_id`)
REFERENCES cities(`id`));

CREATE TABLE `students`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR (40) NOT NULL,
`last_name` VARCHAR (40) NOT NULL,
`age` INT,
`phone` VARCHAR (20) UNIQUE NOT NULL,	
`email`VARCHAR (255) UNIQUE NOT NULL,	
`is_graduated` BOOLEAN NOT NULL,
`city_id` INT,
CONSTRAINT fk_students_cities
FOREIGN KEY (`city_id`)
REFERENCES cities(`id`));

CREATE TABLE `courses`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR (40) UNIQUE NOT NULL,
`duration_hours` DECIMAL(19,2),
`start_date` DATE,	
`teacher_name`VARCHAR (60) UNIQUE NOT NULL,	
`description` TEXT,
`university_id` INT,
CONSTRAINT fk_courses_universiteties
FOREIGN KEY (`university_id`)
REFERENCES universities(`id`));

CREATE TABLE `students_courses`(
`grade` DECIMAL(19,2) NOT NULL,
`student_id` INT NOT NULL,
`course_id` INT NOT NULL,
CONSTRAINT fk_sc_students
FOREIGN KEY (`student_id`)
REFERENCES students(`id`),
CONSTRAINT fk_sc_courses
FOREIGN KEY (`course_id`)
REFERENCES courses(`id`));

#02. Insert
INSERT INTO `courses` (`name`,`duration_hours`,`start_date`,`teacher_name`,`description`,`university_id`)(
SELECT CONCAT(`teacher_name`, ' ', 'course'),
		CHAR_LENGTH(`name`)/10,
        DATE_ADD(`start_date`, INTERVAL 5 DAY),
        REVERSE(`teacher_name`),
        CONCAT('Course ', `teacher_name`, REVERSE(`description`)),
        DAY(`start_date`)
        FROM `courses`
        WHERE `id` <= 5);
        
 #03. Update
UPDATE `universities` 
SET 
    `tuition_fee` = `tuition_fee` + 300
WHERE
    `id` BETWEEN 5 AND 12;
    
#04. Delete
DELETE u FROM `universities` AS u 
WHERE
    `number_of_staff` IS NULL;
    
#05. Cities
SELECT 
    `id`, `name`, `population`, `country_id`
FROM
    `cities`
ORDER BY `population` DESC;

#06. Students age
SELECT 
    `first_name`, `last_name`, `age`, `phone`, `email`
FROM
    `students`
WHERE
    `age` >= 21
ORDER BY `first_name` DESC , `email` , `id`
LIMIT 10;

#07. New students
SELECT CONCAT_WS(' ' , c.`first_name`, c.`last_name`) AS `full_name`,
substring(c.`email`,2,10),
REVERSE(c.`phone`) AS 'password'
FROM `students` AS c
LEFT JOIN `students_courses` AS sc ON c.`id` = sc.`student_id`
WHERE sc.`course_id` IS NULL
ORDER BY `password` DESC;

#08. Students count
SELECT 
    COUNT(s.`id`) AS 'students_count',
    u.`name` AS 'universotety_name'
FROM
    `students` AS s
         JOIN
    `students_courses` AS sc ON s.`id` = sc.`student_id`
         JOIN
    `courses` AS c ON c.`id` = sc.`course_id`
        RIGHT JOIN
    `universities` AS u ON u.`id` = c.`university_id`
GROUP BY u.`name`
HAVING students_count >= 8
ORDER BY students_count DESC , universotety_name DESC;

#09. Price rankings
SELECT 
    u.`name`,
    c.`name`,
    u.`address`,
    (CASE
        WHEN u.`tuition_fee` < 800 THEN 'cheap'
        WHEN u.`tuition_fee` BETWEEN 800 AND 1200 THEN 'normal'
        WHEN u.`tuition_fee` BETWEEN 1200 AND 2500 THEN 'high'
        ELSE 'expensive'
    END) AS 'price_rank',
    u.`tuition_fee`
FROM
    `universities` AS u
        JOIN
    `cities` AS c ON u.`city_id` = c.`id`
ORDER BY u.`tuition_fee`;

#10. Average grades
DELIMITER %%
CREATE FUNCTION  udf_average_alumni_grade_by_course_name(course_name VARCHAR(60)) 
RETURNS DECIMAL(19,2)
DETERMINISTIC
BEGIN
RETURN (SELECT AVG(sc.`grade`) AS 'average_alumni_grade' FROM `courses` AS c
JOIN `students_courses` AS sc ON c.`id` = sc.`course_id`
JOIN `students` AS s ON s.`id` = sc.`student_id`
WHERE c.`name` = course_name AND s.`is_graduated` = 1);
END%%

#11. Graduate students
DELIMITER %%
CREATE PROCEDURE udp_graduate_all_students_by_year(year_started INT)
BEGIN
UPDATE `students` AS s
JOIN `students_courses` AS sc ON s.`id` = sc.`student_id`
JOIN `courses` AS c ON c.`id` = sc.`course_id`
SET s.`is_graduated` = 1
WHERE YEAR(c.`start_date`) = year_started;
END%%


    
    