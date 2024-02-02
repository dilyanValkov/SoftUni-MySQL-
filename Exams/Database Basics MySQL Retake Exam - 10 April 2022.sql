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

