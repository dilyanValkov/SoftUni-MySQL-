#01. Table Design
CREATE TABLE `genres`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(50) NOT NULL UNIQUE);

CREATE TABLE `movies_additional_info`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`rating` DECIMAL(10,2) NOT NULL,
`runtime` INT NOT NULL,
`picture_url` VARCHAR(80) NOT NULL,
`budget` DECIMAL(10,2),
`release_date` DATE NOT NULL,
`has_subtitles` BOOLEAN,
`description` TEXT);

CREATE TABLE `countries`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`name` VARCHAR(30) NOT NULL UNIQUE,
`continent` VARCHAR(30) NOT NULL,
`currency` VARCHAR (5) NOT NULL);

CREATE TABLE `actors`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`first_name` VARCHAR(50) NOT NULL,
`last_name` VARCHAR(50) NOT NULL,
`birthdate` DATE NOT NULL,
`height` INT,
`awards` INT,
`country_id` INT NOT NULL,
CONSTRAINT fk_actors_countries
FOREIGN KEY (`country_id`)
REFERENCES countries(`id`));

CREATE TABLE `movies`(
`id` INT AUTO_INCREMENT PRIMARY KEY,
`title` VARCHAR(70) NOT NULL UNIQUE,
`country_id` INT NOT NULL,
`movie_info_id` INT NOT NULL UNIQUE,
CONSTRAINT fk_movie_moviesInfo
FOREIGN KEY (`movie_info_id`)
REFERENCES movies_additional_info(`id`),
CONSTRAINT fk_movie_countries
FOREIGN KEY (`country_id`)
REFERENCES countries(`id`)
);

CREATE TABLE `genres_movies`(
`genre_id` INT,
`movie_id` INT,
CONSTRAINT fk_genres_movies_movie
FOREIGN KEY (`movie_id`)
REFERENCES movies(`id`),
CONSTRAINT fk_genres_movies_genres
FOREIGN KEY (`genre_id`)
REFERENCES genres(`id`)
);

CREATE TABLE `movies_actors`(
`movie_id` INT,
`actor_id` INT,
CONSTRAINT fk_movie_actors_movie
FOREIGN KEY (`movie_id`)
REFERENCES movies(`id`),
CONSTRAINT fk_movie_actors_actors
FOREIGN KEY (`actor_id`)
REFERENCES actors(`id`)
);

#02. Insert
INSERT INTO `actors` (`first_name`, `last_name`,`birthdate`, `height`,`awards`,`country_id`)(
SELECT REVERSE(a.`first_name`),
	   REVERSE(a.`last_name`),
       DATE(a.`birthdate`) - INTERVAL 2 DAY,
       10 + a.`height`,
       `country_id`,
       '3' FROM `actors` AS a
       WHERE a.`id`  <= 10
      );
      
#03. Update
UPDATE `movies_additional_info` AS m 
SET 
    m.`runtime` = m.`runtime` - 10
WHERE
    m.`id` >= 15 AND m.`id` <= 25;
    
#04. Delete
DELETE c FROM `countries` AS c
        LEFT JOIN
    `movies` AS m ON c.`id` = m.`country_id` 
WHERE
    m.`country_id` IS NULL;
    
#05. Countries
SELECT 
    `id`, `name`, `continent`, `currency`
FROM
    `countries`
ORDER BY `currency` DESC , `id`;

#06. Old movies
SELECT 
    m.`id`, m.`title`, ma.`runtime`, ma.`budget`, ma.`release_date`
FROM
    `movies_additional_info` AS ma
        JOIN
    `movies` AS m ON ma.`id` = m.`movie_info_id`
WHERE
    YEAR(ma.`release_date`) BETWEEN 1996 AND 1999
ORDER BY ma.`runtime` , m.`id`
LIMIT 20;

#07. Movie casting
SELECT 
    CONCAT_WS(' ', a.`first_name`, a.`last_name`) AS 'full_name',
    CONCAT(REVERSE(a.`last_name`),
            CHAR_LENGTH(a.`last_name`),
            '@cast.com') AS 'email',
    2022 - YEAR(a.`birthdate`) AS 'age',
    a.`height`
FROM
    `actors` AS a
        LEFT JOIN
    `movies_actors` AS ma ON a.`id` = ma.`actor_id`
        LEFT JOIN
    `movies` AS m ON m.`id` = ma.`movie_id`
WHERE
    m.`id` IS NULL
ORDER BY a.`height`;

#08. International festival
SELECT 
    c.`name`, COUNT(m.`title`) AS 'movies_count'
FROM
    `countries` AS c
        JOIN
    `movies` AS m ON c.`id` = m.`country_id`
GROUP BY c.`name`
HAVING movies_count >= 7
ORDER BY c.`name` DESC;

#09. Rating system
SELECT 
    m.`title`,
    (CASE
        WHEN ma.rating <= 4 THEN 'poor'
        WHEN ma.rating BETWEEN 4 AND 7 THEN 'good'
        WHEN ma.rating > 7 THEN 'excellent'
    END) AS 'rating',
    IF(ma.has_subtitles IS TRUE,
        'english',
        '-') AS 'subtitles',
    ma.`budget`
FROM
    `movies` AS m
        JOIN
    `movies_additional_info` AS ma ON m.`movie_info_id` = ma.`id`
ORDER BY ma.budget DESC;

#10. History movies
DELIMITER $$
CREATE FUNCTION udf_actor_history_movies_count(full_name VARCHAR(50))
RETURNS INT DETERMINISTIC
BEGIN
RETURN (SELECT COUNT(a.`id`) FROM  `movies` AS m
JOIN `movies_actors` AS ma ON m.`id` = ma.`movie_id`
JOIN `actors` AS a ON ma.`actor_id` = a.`id`
JOIN `genres_movies` AS gm ON gm.`movie_id` = m.`id`
JOIN `genres` AS g ON g.`id` = gm.`genre_id`
WHERE g.`id` = 12 AND (CONCAT(a.first_name, ' ',a.last_name) = full_name));
END$$

#11. Movie awards
DELIMITER %%
CREATE PROCEDURE udp_award_movie (movie_title VARCHAR(50))
BEGIN
UPDATE `actors` AS a
JOIN `movies_actors` as ma ON ma.`actor_id` = a.`id`
JOIN `movies` as m ON ma.`movie_id` = m.`id`
SET a.`awards` = a.`awards` + 1
WHERE m.`title` = movie_title;
END%%
