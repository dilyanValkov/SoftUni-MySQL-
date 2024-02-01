#01. Employees with Salary Above 35000
DELIMITER %%
CREATE PROCEDURE usp_get_employees_salary_above_35000 ()
BEGIN
SELECT `first_name`, `last_name`FROM `employees`
WHERE `salary` > 35000
ORDER BY `first_name`, `last_name`, `employee_id`;
END%%

#02. Employees with Salary Above Number
DELIMITER %%
CREATE PROCEDURE usp_get_employees_salary_above (salary_to_find DECIMAL (19,4))
BEGIN
SELECT `first_name`, `last_name`FROM `employees`
WHERE `salary` >= salary_to_find
ORDER BY `first_name`, `last_name`, `employee_id`;
END%%

#03. Town Names Starting With
DELIMITER %%
CREATE PROCEDURE usp_get_towns_starting_with (town_to_find VARCHAR (40))
BEGIN
SELECT `name` AS 'town_name' FROM `towns`
WHERE `name` LIKE CONCAT(town_to_find, '%')
ORDER BY town_name;
END%%

#04. Employees from Town
DELIMITER %%
CREATE PROCEDURE usp_get_employees_from_town (town VARCHAR (40))
BEGIN
SELECT `first_name`, `last_name`FROM `employees` AS e
JOIN `addresses` USING (`address_id`)
JOIN `towns` AS t USING (`town_id`)
WHERE t.`name` = town
ORDER BY `first_name`, `last_name`;
END%%

#05. Salary Level Function
DELIMITER %%
CREATE FUNCTION ufn_get_salary_level (salary_to_find DECIMAL (19,4)) 
RETURNS VARCHAR (20) 
DETERMINISTIC
BEGIN
DECLARE result VARCHAR(20);
IF salary_to_find < 30000 THEN SET result := 'Low';
ELSEIF salary_to_find <= 50000 THEN  SET result := 'Average';
ELSEIF salary_to_find > 50000 THEN SET result :='High';
END IF;
RETURN result;
END%%

#06. Employees by Salary Level
DELIMITER %%
CREATE PROCEDURE usp_get_employees_by_salary_level (salary_level VARCHAR (40))
BEGIN
SELECT `first_name`, `last_name`FROM `employees` 
WHERE ufn_get_salary_level(`salary`) = salary_level
ORDER BY `first_name` DESC, `last_name` DESC;
END%%

#07. Define Function
DELIMITER %%
CREATE FUNCTION ufn_is_word_comprised(set_of_letters varchar(50), word varchar(50))
RETURNS INT
DETERMINISTIC
BEGIN
RETURN word REGEXP CONCAT(set_of_letters, ']+$');
END%%

#08. Find Full Name
DELIMITER %%
CREATE PROCEDURE usp_get_holders_full_name ()
BEGIN
SELECT CONCAT_WS(' ', `first_name`, `last_name`) AS 'full_name' FROM `account_holders`
ORDER BY full_name, id;
END%%

#9. People with Balance Higher Than
DELIMITER %%
CREATE PROCEDURE usp_get_holders_with_balance_higher_than(number_to_find INT)
BEGIN
SELECT `first_name`, `last_name`  FROM `account_holders` AS ah
JOIN `accounts` AS a ON ah.id = a.account_holder_id
GROUP BY ah.`id`
HAVING SUM(a.`balance`) > number_to_find
ORDER BY a.account_holder_id;
END%%

#10. Future Value Function
DELIMITER %%
CREATE FUNCTION ufn_calculate_future_value (sum DECIMAL (19,4), yearly_interest_rate DOUBLE, number_of_years INT)
RETURNS DECIMAL (19,4)
DETERMINISTIC
BEGIN
RETURN sum * POW((1 + yearly_interest_rate), number_of_years);
END%%

#11. Calculating Interest
DELIMITER %%
CREATE PROCEDURE usp_calculate_future_value_for_account(id INT, interest_rate DECIMAL (19,4))
BEGIN
DECLARE result DECIMAL (19,4);
SELECT 
    a.`id` AS 'account_id',
    ah.`first_name`,
    ah.`last_name`,
    a.`balance` AS 'current_balance',
    UFN_CALCULATE_FUTURE_VALUE(a.`balance`, interest_rate, 5) AS 'balance_in_5_years'
FROM
    `account_holders` AS ah
        JOIN
    `accounts` AS a ON ah.id = a.account_holder_id
WHERE
    a.`id` = id;
END%%

#12. Deposit Money
DELIMITER %%
CREATE PROCEDURE usp_deposit_money(account_id INT, money_amount DECIMAL (19,4))
BEGIN
     START TRANSACTION;
	 IF (money_amount <= 0) THEN ROLLBACK;
     ELSE
	 UPDATE `accounts` AS a
	 SET a.`balance` = a.`balance` + money_amount
     WHERE a.`id` = account_id;
END IF;
END%%

#13. Withdraw Money
DELIMITER %%
CREATE PROCEDURE usp_withdraw_money(account_id INT, money_amount DECIMAL (19,4))
BEGIN
     START TRANSACTION;
  	  IF (money_amount <= 0 OR 
		  money_amount > (SELECT a.`balance` FROM `accounts` AS a WHERE a.`id` = account_id) ) THEN ROLLBACK;
     ELSE
	 UPDATE `accounts` AS a
	 SET a.`balance` = a.`balance` - money_amount
     WHERE a.`id` = account_id;
END IF;
END%%

#14. Money Transfer
DELIMITER %%
CREATE PROCEDURE usp_transfer_money(from_account_id INT, to_account_id INT, money_amount DECIMAL (19,4))
BEGIN
     START TRANSACTION;
	 IF ((SELECT COUNT(id) FROM `accounts` WHERE `id`= from_account_id) <> 1
     OR (SELECT COUNT(id) FROM `accounts` WHERE `id`= to_account_id) <> 1
     OR from_account_id = to_account_id
     OR money_amount <= 0
     OR (SELECT `balance` FROM `accounts` WHERE `id` = from_account_id) < money_amount)
     THEN ROLLBACK;
     ELSE
	UPDATE `accounts` 
SET 
    `balance` = `balance` - money_amount
WHERE
    `id` = from_account_id;
	UPDATE `accounts` 
SET 
    `balance` = `balance` + money_amount
WHERE
    `id` = to_account_id;
     END IF;
END%%

#15. Log Accounts Trigger 
CREATE TABLE `logs` (
    `log_id` INT AUTO_INCREMENT PRIMARY KEY,
    `account_id` INT NOT NULL,
    `old_sum` DECIMAL(19 , 4 ),
    `new_sum` DECIMAL(19 , 4 )
);
DELIMITER %%
CREATE 
    TRIGGER  acc_changes
 BEFORE UPDATE ON `accounts` FOR EACH ROW 
 BEGIN
    INSERT INTO `logs` (`account_id` , `old_sum` , `new_sum`) VALUES (OLD.`id` , OLD.`balance` , NEW.`balance`);
 END%%
 
#16. Emails Trigger
CREATE TABLE `notification_emails` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `recipient` INT NOT NULL,
    `subject` TEXT,
    `body` TEXT
);
DELIMITER %%
CREATE 
    TRIGGER  email_notifications
 AFTER INSERT ON `logs` FOR EACH ROW 
 BEGIN
    INSERT INTO `notification_emails` (`recipient` , `subject` , `body`) VALUES (NEW.`account_id` , CONCAT('Balance change for account: ',
            NEW.`account_id`) , CONCAT('On ',
            NOW(),
            ' your balance was changed from ',
            NEW.`old_sum`,
            ' to ',
            NEW.`new_sum`,
            '.'));
END%%





