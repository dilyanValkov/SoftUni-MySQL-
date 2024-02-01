#01. Find Book Titles
SELECT `title` FROM `books`
WHERE `title` LIKE 'The%'
ORDER BY `id`;

#02. Replace Titles
SELECT REPLACE (`title`, 'The', '***') AS 'title' 
FROM `books`
WHERE SUBSTRING(`title` ,1,3) = 'The'
ORDER BY `id`;

#03. Sum Cost of All Books
SELECT ROUND (SUM(`cost`),2) AS 'Sum' FROM `books`;

#04. Days Lived
SELECT CONCAT_WS(' ', `first_name`,`last_name`) AS 'Full Name',
CONCAT( DATEDIFF(`died`, `born`)) AS 'Days Lived' FROM `authors`;

#05. Harry Potter Books
SELECT `title` FROM `books`
WHERE `title` LIKE 'Harry Potter%'
ORDER BY `id`;
