#1. Mountains and Peaks
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (45));

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (45),
`mountain_id` INT);

ALTER TABLE `peaks`
ADD CONSTRAINT `fk`
FOREIGN KEY (mountain_id)
REFERENCES mountains(id);

#2. Trip Organization
SELECT `driver_id`, `vehicle_type`, 
CONCAT_WS(' ',`first_name`,`last_name`) AS 'driver_name' 
FROM `vehicles` AS v
JOIN campers AS c
on v.driver_id = c.id;

#3. SoftUni Hiking
SELECT `starting_point` AS 'route_starting_point', 
`end_point` AS 'route_ending_point', 
`leader_id`,
CONCAT_WS(' ',`first_name`,`last_name`) AS 'leader_name' 
FROM `routes` AS r
JOIN campers AS c
on r.leader_id = c.id;

#4. Delete Mountains
CREATE TABLE `mountains`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (45));

CREATE TABLE `peaks`(
`id` INT PRIMARY KEY AUTO_INCREMENT,
`name` VARCHAR (45),
`mountain_id` INT);

ALTER TABLE `peaks`
ADD CONSTRAINT `fk`
FOREIGN KEY (mountain_id)
REFERENCES mountains(id) ON  DELETE CASCADE;
