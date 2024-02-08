CREATE SCHEMA `real_estate_db`;

CREATE TABLE `cities` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(60) UNIQUE NOT NULL
);

CREATE TABLE `property_types` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `type` VARCHAR(40) UNIQUE NOT NULL,
    `description` TEXT
);

CREATE TABLE `properties` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `address` VARCHAR(80) UNIQUE NOT NULL,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `area` DECIMAL(19 , 2 ),
    `property_type_id` INT,
    `city_id` INT,
    CONSTRAINT fk_properties_property_types FOREIGN KEY (`property_type_id`)
        REFERENCES property_types (`id`),
    CONSTRAINT fk_properties_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `agents` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) UNIQUE NOT NULL,
    `email` VARCHAR(50) UNIQUE NOT NULL,
    `city_id` INT,
    CONSTRAINT fk_agents_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `buyers` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(40) NOT NULL,
    `last_name` VARCHAR(40) NOT NULL,
    `phone` VARCHAR(20) UNIQUE NOT NULL,
    `email` VARCHAR(50) UNIQUE NOT NULL,
    `city_id` INT,
    CONSTRAINT fk_buyers_cities FOREIGN KEY (`city_id`)
        REFERENCES cities (`id`)
);

CREATE TABLE `property_offers` (
    `property_id` INT NOT NULL,
    `agent_id` INT NOT NULL,
    `price` DECIMAL(19 , 2 ) NOT NULL,
    `offer_datetime` DATETIME,
    CONSTRAINT fk_property_offers_properties FOREIGN KEY (`property_id`)
        REFERENCES properties (`id`),
    CONSTRAINT fk_property_offers_agents FOREIGN KEY (`agent_id`)
        REFERENCES agents (`id`)
);

CREATE TABLE `property_transactions` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `property_id` INT NOT NULL,
    `buyer_id` INT NOT NULL,
    `transaction_date` DATE,
    `bank_name` VARCHAR(30),
    `iban` VARCHAR(40) UNIQUE,
    `is_successful` TINYINT(1),
    CONSTRAINT fk_property_transactions_properties FOREIGN KEY (`property_id`)
        REFERENCES properties (`id`),
    CONSTRAINT fk_property_transactions_buyers FOREIGN KEY (`buyer_id`)
        REFERENCES buyers (`id`)
);

#02. Insert
INSERT INTO `property_transactions`(`property_id`,`buyer_id`,
`transaction_date`,`bank_name`,`iban`,`is_successful`)(
SELECT  DAY(`offer_datetime`) + `agent_id`,
	    MONTH(`offer_datetime`)+ `agent_id`,
       DATE(`offer_datetime`),
       CONCAT('Bank',' ',`agent_id`),
       CONCAT('BG',`price`,`agent_id`),
       1 FROM `property_offers`
       WHERE `agent_id` <= 2);
       
UPDATE `properties` 
SET 
    `price` = `price` - 50000
WHERE
    `price` >= 800000;

DELETE FROM `property_transactions` 
WHERE
    `is_successful` = 0;

SELECT 
    *
FROM
    `agents`
ORDER BY `city_id` DESC , `phone` DESC;

SELECT 
    `property_id`, `agent_id`, `price`, `offer_datetime`
FROM
    `property_offers`
WHERE
    YEAR(`offer_datetime`) = 2021
ORDER BY `price`
LIMIT 10;

SELECT 
    SUBSTRING(p.`address`, 1, 6) AS 'agent_name',
    CHAR_LENGTH(p.`address`) * 5430 AS 'price'
FROM
    `properties` AS p
        LEFT JOIN
    `property_offers` AS po ON p.id = po.property_id
WHERE
    po.`property_id` IS NULL
ORDER BY agent_name DESC , price DESC;

SELECT 
    `bank_name`, COUNT(`iban`) AS 'count'
FROM
    `property_transactions`
GROUP BY `bank_name`
HAVING count >= 9
ORDER BY count DESC , bank_name;

SELECT 
    `address`,
    `area`,
    CASE
        WHEN `area` <= 100 THEN 'small'
        WHEN `area` <= 200 THEN 'medium'
        WHEN `area` <= 500 THEN 'large'
        ELSE 'extra large'
    END AS 'size'
FROM
    `properties`
ORDER BY `area` , `address` DESC;

#10. Offers count in a city
DELIMITER $$
CREATE FUNCTION udf_offers_from_city_name (cityName VARCHAR(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(p.`id`) AS `count` FROM `cities` AS c
JOIN `properties` AS p ON c.id = p.city_id
JOIN `property_offers` AS po ON po.property_id = p.id
WHERE c.`name` = cityName
GROUP BY c.`name`);
END$$

#11. Special Offer
DELIMITER $$
CREATE PROCEDURE  udp_special_offer (first_name VARCHAR(50))
BEGIN
UPDATE `property_offers` AS po
JOIN `agents` AS a ON a.id = po.agent_id
SET po.`price` = po.`price` - po.`price` * 0.1
WHERE a.`first_name` = first_name;
END$$
