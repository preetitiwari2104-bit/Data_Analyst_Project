-- ================================
-- Database Creation
-- ================================

create database intern;
use intern;

-- ================================
-- To Change The Table Name
-- ================================

rename table transaction to transactions;

-- ================================
-- To Change The Datatype Of Columns
-- ================================

ALTER TABLE user
ADD PRIMARY KEY (client_id);

ALTER TABLE cards
ADD PRIMARY KEY (card_id);

alter table transactions 
drop foreign key fk_transaction_cards;

alter table transaction
add primary key (transaction_id);

ALTER TABLE cards
ADD CONSTRAINT fk_cards_user
FOREIGN KEY (client_id)
REFERENCES user(client_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (client_id)
REFERENCES user(client_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transaction_card
FOREIGN KEY (card_id)
REFERENCES cards(card_id);

desc cards;
desc user;
desc transactions;

ALTER TABLE cards
MODIFY COLUMN card_brand VARCHAR(50);

ALTER TABLE cards
MODIFY COLUMN card_type VARCHAR(50);

ALTER TABLE cards
MODIFY COLUMN expires VARCHAR(20);

ALTER TABLE cards
MODIFY COLUMN has_chip VARCHAR(10);

ALTER TABLE cards
MODIFY COLUMN credit_limit DOUBLE;

ALTER TABLE cards
MODIFY COLUMN acct_open_date DATE;

ALTER TABLE cards
MODIFY COLUMN card_on_dark_web VARCHAR(10);


ALTER TABLE user
MODIFY COLUMN retirement_age INT;

ALTER TABLE user
MODIFY COLUMN gender VARCHAR(20);

ALTER TABLE user
MODIFY COLUMN credit_score INT;

set sql_safe_updates=0;

UPDATE transactions
SET amount = REPLACE(amount, '$', '');

ALTER TABLE transactions
MODIFY COLUMN amount DOUBLE;

ALTER TABLE transactions
MODIFY COLUMN date DATETIME;

ALTER TABLE transactions
MODIFY COLUMN use_chip VARCHAR(20);

ALTER TABLE transactions
MODIFY COLUMN merchant_city VARCHAR(100);

ALTER TABLE transactions
MODIFY COLUMN merchant_state VARCHAR(100);

ALTER TABLE transactions
MODIFY COLUMN zip VARCHAR(20);

ALTER TABLE transactions
MODIFY COLUMN zip VARCHAR(20);


-- ================================
-- SHOW TABLES
-- ================================

SELECT * FROM user;
SELECT * FROM cards;
SELECT * FROM transactions;

-- ================================
-- WHERE CLAUSE
-- ================================

SELECT *
FROM user
WHERE credit_score > 700;

-- ================================
-- ORDER BY
-- ================================

SELECT *
FROM user
ORDER BY yearly_income DESC;

-- ================================
-- DISTINCT
-- ================================

SELECT DISTINCT merchant_state
FROM transactions;

-- ================================
-- LIMIT
-- ================================

SELECT *
FROM transactions
LIMIT 10;

-- ================================
-- AGGREGATE FUNCTIONS
-- ================================

SELECT COUNT(*) AS total_users
FROM user;

SELECT AVG(yearly_income) AS average_income
FROM user;

SELECT MAX(amount) AS highest_transaction
FROM transactions;

SELECT MIN(amount) AS lowest_transaction
FROM transactions;

SELECT SUM(amount) AS total_transaction_amount
FROM transactions;

-- ================================
-- GROUP BY
-- ================================

SELECT 
merchant_state,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY merchant_state;

-- ================================
-- HAVING
-- ================================

SELECT 
merchant_state,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY merchant_state
HAVING COUNT(*) > 50;

-- ================================
-- INNER JOIN
-- ================================

SELECT 
u.client_id,
u.gender,
t.amount,
t.merchant_city
FROM user u
INNER JOIN transactions t
ON u.client_id = t.client_id;

-- ================================
-- LEFT JOIN
-- ================================

SELECT 
u.client_id,
u.gender,
t.amount
FROM user u
LEFT JOIN transactions t
ON u.client_id = t.client_id;

-- ================================
-- RIGHT JOIN
-- ================================

SELECT 
u.client_id,
t.amount
FROM user u
RIGHT JOIN transactions t
ON u.client_id = t.client_id;

-- ================================
-- TOP 10 HIGHEST TRANSACTIONS
-- ================================

SELECT *
FROM transactions
ORDER BY amount DESC
LIMIT 10;

-- ================================
-- TOP SPENDING USERS
-- ================================

SELECT 
client_id,
SUM(amount) AS total_spent
FROM transactions
GROUP BY client_id
ORDER BY total_spent DESC
LIMIT 10;

-- ================================
-- STATE WISE SALES
-- ================================

SELECT 
merchant_state,
SUM(amount) AS total_sales
FROM transactions
GROUP BY merchant_state
ORDER BY total_sales DESC;

-- ================================
-- MONTHLY TRANSACTIONS
-- ================================

SELECT 
MONTH(date) AS month_no,
SUM(amount) AS monthly_sales
FROM transactions
GROUP BY MONTH(date)
ORDER BY month_no;

-- ================================
-- CREDIT SCORE ANALYSIS
-- ================================

SELECT 
credit_score,
COUNT(*) AS total_people
FROM user
GROUP BY credit_score
ORDER BY credit_score DESC;

-- ================================
-- HIGH DEBT USERS
-- ================================

SELECT *
FROM user
WHERE total_debt > yearly_income;

-- ================================
-- ERROR TRANSACTIONS
-- ================================

SELECT *
FROM transactions
WHERE errors IS NOT NULL;

-- ================================
-- CHIP USAGE ANALYSIS
-- ================================

SELECT 
use_chip,
COUNT(*) AS total_transactions
FROM transactions
GROUP BY use_chip;

-- ================================
-- SUBQUERY
-- ================================

SELECT *
FROM users
WHERE yearly_income >
(
    SELECT AVG(yearly_income)
    FROM users
);

-- ================================
-- WINDOW FUNCTION
-- ================================

SELECT 
client_id,
amount,
RANK() OVER(ORDER BY amount DESC) AS ranking
FROM transactions;

-- ================================
-- CASE WHEN
-- ================================

SELECT 
client_id,
yearly_income,

CASE
    WHEN yearly_income > 100000 THEN 'High Income'
    WHEN yearly_income > 50000 THEN 'Medium Income'
    ELSE 'Low Income'
END AS income_category

FROM users;

-- ================================
-- LIKE OPERATOR
-- ================================

SELECT *
FROM transactions
WHERE merchant_city LIKE '%New%';

-- ================================
-- BETWEEN
-- ================================

SELECT *
FROM transactions
WHERE amount BETWEEN 100 AND 1000;

-- ================================
-- IN OPERATOR
-- ================================

SELECT *
FROM transactions
WHERE merchant_state IN ('California', 'Texas');

-- ================================
-- VIEW
-- ================================

CREATE VIEW top_users AS
SELECT 
client_id,
SUM(amount) AS total_spent
FROM transactions
GROUP BY client_id;

SELECT * FROM top_users;

-- ================================
-- STORED PROCEDURE
-- ================================

DELIMITER //

CREATE PROCEDURE high_income_users()
BEGIN
    SELECT *
    FROM users
    WHERE yearly_income > 100000;
END //

DELIMITER ;

CALL high_income_users();

-- ================================
-- TRIGGER
-- ================================

CREATE TABLE transaction_backup (
    transaction_id INT,
    amount DOUBLE
);

DELIMITER //

CREATE TRIGGER backup_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    INSERT INTO transaction_backup(transaction_id, amount)
    VALUES (NEW.transaction_id, NEW.amount);
END //

DELIMITER ;

-- ================================
-- UPDATE QUERY
-- ================================

UPDATE users
SET credit_score = 800
WHERE client_id = 1;

-- ================================
-- SAFE UPDATE MODE
-- ================================

SET SQL_SAFE_UPDATES = 0;

DELETE FROM transactions
WHERE amount = 0;

SET SQL_SAFE_UPDATES = 1;

-- ================================
-- END
-- ================================

