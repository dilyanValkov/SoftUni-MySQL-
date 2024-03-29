CREATE TABLE `countries` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL
);

CREATE TABLE `towns` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `country_id` INT NOT NULL,
    CONSTRAINT fk_t_c FOREIGN KEY (`country_id`)
        REFERENCES countries (`id`)
);

CREATE TABLE `stadiums` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `capacity` INT NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT fk_s_t FOREIGN KEY (`town_id`)
        REFERENCES towns (`id`)
);

CREATE TABLE `teams` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(45) NOT NULL,
    `established` DATE NOT NULL,
    `fan_base` BIGINT DEFAULT 0 NOT NULL,
    `stadium_id` INT NOT NULL,
    CONSTRAINT fk_t_s FOREIGN KEY (`stadium_id`)
        REFERENCES stadiums (`id`)
);

CREATE TABLE `skills_data` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `dribbling` INT DEFAULT 0,
    `pace` INT DEFAULT 0,
    `passing` INT DEFAULT 0,
    `shooting` INT DEFAULT 0,
    `speed` INT DEFAULT 0,
    `strength` INT DEFAULT 0
);

CREATE TABLE `players` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `age` INT DEFAULT 0 NOT NULL,
    `position` CHAR NOT NULL,
    `salary` DECIMAL(10 , 2 ) DEFAULT 0 NOT NULL,
    `hire_date` DATETIME,
    `skills_data_id` INT NOT NULL,
    `team_id` INT,
    CONSTRAINT fk_p_sd FOREIGN KEY (`skills_data_id`)
        REFERENCES skills_data (`id`),
    CONSTRAINT fk_p_t FOREIGN KEY (`team_id`)
        REFERENCES teams (`id`)
);

CREATE TABLE `coaches` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(10) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `salary` DECIMAL(10 , 2 ) DEFAULT 0 NOT NULL,
    `coach_level` INT DEFAULT 0 NOT NULL
);

CREATE TABLE `players_coaches` (
    `player_id` INT,
    `coach_id` INT,
    CONSTRAINT PK PRIMARY KEY (`player_id` , `coach_id`),
    CONSTRAINT fk_pc_p FOREIGN KEY (`player_id`)
        REFERENCES players (`id`),
    CONSTRAINT fk_pc_c FOREIGN KEY (`coach_id`)
        REFERENCES coaches (`id`)
);

#02
INSERT INTO `coaches`(`first_name`,`last_name`,`salary`,`coach_level`)(
SELECT 
    p.`first_name`,
    p.`last_name`,
    2 * p.`salary`,
    CHAR_LENGTH(p.`first_name`) AS 'coach_level'
FROM
    `players` AS p
    WHERE p.`age` >= 45
);

UPDATE `coaches` AS c 
SET 
    c.`coach_level` = c.`coach_level` + 1
WHERE
    c.`id` IN (SELECT 
            `coach_id`
        FROM
            `players_coaches`)
        AND c.`first_name` LIKE 'A%';

#04
DELETE FROM `players` AS p
WHERE p.`age` >= 45;

SELECT 
    `first_name`, `age`, `salary`
FROM
    `players`
ORDER BY `salary` DESC;

SELECT 
    p.`id`,
    CONCAT_WS(' ', `first_name`, `last_name`) AS `full_name`,
    p.`age`,
    p.`position`,
    p.`hire_date`
FROM
    `players` AS p
        JOIN
    `skills_data` AS sd ON p.`skills_data_id` = sd.`id`
WHERE
    (`age` < 23 AND `position` = 'A'
        AND `hire_date` IS NULL
        AND sd.`strength` > 50)
ORDER BY `salary` , `age`;

SELECT 
    t.`name` AS 'team_name',
    t.`established`,
    t.`fan_base`,
    COUNT(`team_id`) AS `players_count`
FROM
    `teams` AS t
        LEFT JOIN
    `players` AS p ON t.id = p.team_id
GROUP BY t.`id`
ORDER BY `players_count` DESC , `fan_base` DESC;

SELECT 
    MAX(sd.`speed`) AS 'max_speed', t.`name` AS 'town_name'
FROM
    `skills_data` AS sd
        RIGHT JOIN
    `players` AS p ON sd.id = p.skills_data_id
        RIGHT JOIN
    `teams` AS te ON te.id = p.team_id
        RIGHT JOIN
    `stadiums` AS st ON st.id = te.stadium_id
        RIGHT JOIN
    `towns` AS t ON t.id = st.town_id
WHERE
    te.`name` <> 'Devify'
GROUP BY t.`name`
ORDER BY max_speed DESC , town_name;

SELECT 
    c.`name`,
    COUNT(p.`id`) AS 'total_count_of_players',
    SUM(p.`salary`) AS 'total_sum_of_salries'
FROM
    `players` AS p
        RIGHT JOIN
    `teams` AS t ON t.`id` = p.`team_id`
        RIGHT JOIN
    `stadiums` AS s ON s.`id` = t.`stadium_id`
        RIGHT JOIN
    `towns` AS tow ON tow.`id` = s.`town_id`
        RIGHT JOIN
    `countries` AS c ON c.`id` = tow.`country_id`
GROUP BY c.`name`
ORDER BY total_count_of_players DESC , c.`name`;

#10
DELIMITER $$
CREATE FUNCTION udf_stadium_players_count (stadium_name VARCHAR(30))
RETURNS INT 
DETERMINISTIC
BEGIN
DECLARE `count` INT;
SET count := (SELECT COUNT(p.`id`) AS 'count' FROM `players` AS p
JOIN `teams` AS t on t.`id` = p.`team_id`
JOIN `stadiums` AS s on s.`id` = t.`stadium_id`
WHERE s.`name` = stadium_name);
RETURN count;
END$$	

#11
DELIMITER $$ 
CREATE PROCEDURE udp_find_playmaker(min_dribble_points INT,team_name VARCHAR(45))
BEGIN
SELECT CONCAT_WS(' ',p.`first_name`,p.`last_name`) AS `full_name`,
p.`age`,
p.`salary`,
sd.`dribbling`,
sd.`speed`,
t.`name`AS 'team_name' FROM `players` AS p
JOIN `skills_data` AS sd ON sd.`id` = p.`skills_data_id`
JOIN `teams` AS t ON t.`id` = p.`team_id`
WHERE sd.`dribbling` > min_dribble_points
AND t.`name` = team_name
ORDER BY sd.`speed` DESC
LIMIT 1;
END$$