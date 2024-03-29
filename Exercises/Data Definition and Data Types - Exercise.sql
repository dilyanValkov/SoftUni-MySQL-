#1.Create Tables
CREATE TABLE `minions`(
`id` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
`age` INT NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `towns` (
  `town_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`town_id`));

#2.Alter Minions Table
ALTER TABLE `minions`
ADD COLUMN `town_id` INT NOT NULL,
ADD CONSTRAINT fk_minions_towns
FOREIGN KEY (`town_id`)
REFERENCES `towns` (`id`);

#3.Insert Records in Both Tables
INSERT INTO `towns`(`id`, `name`)
VALUES (1, 'Sofia'), (2, "Plovdiv"), (3, "Varna");
  
INSERT INTO `minions` (`id`, `name`, `age`, `town_id`)
VALUES (1, "Kevin", 22, 1),
        (2, "Bob", 15, 3),
        (3, "Steward", NULL, 2);

#4.Truncate Table Minions
TRUNCATE `minions`;

#5.Drop All Tables
DROP TABLE `minions`;  
DROP TABLE `towns`;

#6.Create Table People
CREATE TABLE `people`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (200) NOT NULL,
`picture` BLOB,
`height` DOUBLE (10,2),
`weight` DOUBLE (10,2),
`gender` CHAR (1) NOT NULL,
`birthdate` DATE NOT NULL,
`biography` TEXT);

INSERT INTO `people` (`name`,`gender`,`birthdate`)
VALUES 	("Ivan", "m", DATE (NOW())),
		("Ivan", "m", DATE (NOW())),
		("Ivan", "m", DATE (NOW())),
		("Ivan", "m", DATE (NOW())),
		("Ivan", "m", DATE (NOW()));

#7.Create Table Users
CREATE TABLE `users`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`username` VARCHAR (30) NOT NULL,
`password` VARCHAR (26) NOT NULL,
`profile_picture` BLOB,
`last_login_time` TIME,
`is_deleted` BOOLEAN);

INSERT INTO `users` (`username`,`password`)
VALUES 	("Ivan", "m"),
		("Ivan", "m"),
		("Ivan", "m"),
		("Ivan", "m"),
		("Ivan", "m");

#8.Change Primary Key
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD PRIMARY KEY `pk_users` (`id`, `username`);

#9.Set Default Value of a Field
ALTER TABLE `users`
MODIFY COLUMN `last_login_time` DATETIME DEFAULT NOW();

#10.Set Unique Field
ALTER TABLE `users`
DROP PRIMARY KEY,
ADD CONSTRAINT pk_users
PRIMARY KEY (`id`),
MODIFY COLUMN `username` VARCHAR (30) UNIQUE;

#11.Movies Database
CREATE TABLE `directors`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`director_name` VARCHAR (30) NOT NULL,
`notes` TEXT);

CREATE TABLE `genres`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`genre_name` VARCHAR (30) NOT NULL,
`notes` TEXT);

CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category_name` VARCHAR (30) NOT NULL,
`notes` TEXT);

CREATE TABLE `movies` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `title` VARCHAR(40) NOT NULL, 
    `director_id` INT,
    `copyright_year` INT,
    `length` INT,
    `genre_id` INT,
    `category_id` INT,
    `rating` DOUBLE, 
    `notes` TEXT
);

INSERT INTO `directors`(`director_name`,`notes`)
VALUES ('ivan', 'sdafsafsa'),
       ('ivfaan', 'sdafsafsa'),
       ('ivdan', 'sdafsafsa'),
       ('d', 'sdafsafsa'),
       ('igavan', 'sdafsafsa');
       
INSERT INTO `genres`(`genre_name`,`notes`)
VALUES ('ivan', 'sdafsafsa'),
       ('ivfaan', 'sdafsafsa'),
       ('ivdan', 'sdafsafsa'),
       ('d', 'sdafsafsa'),
       ('igavan', 'sdafsafsa');
       
INSERT INTO `categories`(`category_name`,`notes`)
VALUES ('ivan', 'sdafsafsa'),
       ('ivfaan', 'sdafsafsa'),
       ('ivdan', 'sdafsafsa'),
       ('d', 'sdafsafsa'),
       ('igavan', 'sdafsafsa');
       
INSERT INTO `movies`(`title`,`director_id`)
VALUES ('ivan', '1'),
       ('ivfaan', '2'),
       ('ivdan', '3'),
       ('d', '4'),
       ('igavan', '5');

#12. Car Rental Database
CREATE TABLE `categories`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`category` VARCHAR (30) NOT NULL,
`daily_rate` INT,
`weekly_rate` INT,
`monthly_rate` INT,
`weekend_rate` INT);

INSERT INTO `categories` (`category`)
VALUES ('lada'),
       ('porche'),
       ('bus');
       
CREATE TABLE `cars`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`plate_number` VARCHAR (30) NOT NULL,
`make` VARCHAR (30),
`model` VARCHAR (30) NOT NULL,
`car_year` INT,
`category_id` INT,       
`doors` INT,
`picture` BLOB,
`car_condition` TEXT,      
`available`BOOLEAN); 
  
INSERT INTO `cars` (`plate_number`,`model`)
VALUES ('2414', 'lada'),
       ('5252', 'samara'),
       ('2626', 'skoda');

CREATE TABLE `employees`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`first_name` VARCHAR (30) NOT NULL,
`last_name` VARCHAR (30),
`title` VARCHAR (30),
`notes` TEXT);

INSERT INTO `employees` (`first_name`)
VALUES ('Ivan'),
       ('Petko'),
       ('Dragan');
       
CREATE TABLE `customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `driver_license` VARCHAR(20),
    `full_name` VARCHAR(50),
    `address` VARCHAR(50),
    `city` VARCHAR(10),
    `zip_code` VARCHAR(10),
    `notes` TEXT
);
 
INSERT INTO `customers` (`driver_license`, `full_name`)
VALUES 
('TestName1', 'TestName1'),
('TestName2', 'TestName2'),
('TestName3', 'TestName3');
       
CREATE TABLE `rental_orders`(
	`id` INT PRIMARY KEY AUTO_INCREMENT,
    `employee_id` INT,
    `customer_id` INT,
    `car_id` INT,
    `car_condition` VARCHAR(50),
    `tank_level` VARCHAR(20),
    `kilometrage_start` INT,
    `kilometrage_end` INT,
    `total_kilometrage` INT,
    `start_date` DATE, 
    `end_date` DATE, 
    `total_days` INT,
    `rate_applied` DOUBLE,
    `tax_rate` DOUBLE,
    `order_status` VARCHAR(20),
    `notes` TEXT);

INSERT INTO `rental_orders` (`employee_id`)
VALUES (1),
       (2),
       (333); 

#13. Basic Insert
INSERT INTO `towns` (`name`)
VALUES ("Sofia"), ("Plovdiv"), ("Varna"), ("Burgas");
 
INSERT INTO `departments` (`name`)
VALUES ("Engineering"), ("Sales"), ("Marketing"), ("Software Development"), ("Quality Assurance");
 
 
INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`)
VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1, '2004-03-02', 4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28', 525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO', 2, '2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28', 599.88);

#14. Basic Select All Fields
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#15. Basic Select All Fields and Order Them
SELECT * FROM `towns`
ORDER BY `name`;
SELECT * FROM `departments`
ORDER BY `name`;
SELECT * FROM `employees`
ORDER BY `salary` DESC;

#16. Basic Select Some Fields
SELECT `name` FROM `towns`
ORDER BY `name`;
SELECT `name` FROM `departments`
ORDER BY `name`;
SELECT  `first_name`, `last_name`,`job_title`,`salary` FROM `employees`
ORDER BY `salary` DESC;

#17. Increase Employees Salary
UPDATE `employees`
SET `salary` = `salary` * 1.10;
SELECT `salary` FROM `employees`;
