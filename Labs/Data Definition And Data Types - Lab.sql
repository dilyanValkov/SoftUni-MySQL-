#1.
CREATE TABLE `employees`(
`id` INT NOT NULL AUTO_INCREMENT,
`first_name` VARCHAR (45) NOT NULL,
`last_name` VARCHAR (45) NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `categories`(
`id` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
PRIMARY KEY (`id`));

CREATE TABLE `products`(
`id` INT NOT NULL AUTO_INCREMENT,
`name` VARCHAR (45) NOT NULL,
`category_id` INT NOT NULL,
PRIMARY KEY (`id`));

#2.
INSERT INTO `employees`(`first_name`,`last_name`) 
VALUES  ("dsad","dssada"),
	("dssad","dsadda"),
        ("dsad","dsasada");

#3.
ALTER TABLE `employees`
ADD COLUMN `middle_name` VARCHAR (45) NOT NULL AFTER `first_name`;

#4.
ALTER TABLE `products` 
ADD CONSTRAINT `category_id`
FOREIGN KEY (`category_id`)
REFERENCES `categories` (`id`);

#5.
ALTER TABLE `employees`
CHANGE COLUMN `middle_name` `middle_name`  VARCHAR (100) NOT NULL;