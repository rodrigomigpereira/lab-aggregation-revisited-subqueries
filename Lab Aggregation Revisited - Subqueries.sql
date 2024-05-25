## Lab | Aggregation Revisited - Subqueries

## In this lab, you will be using the Sakila database of movie rentals.

use sakila; ## Use the database sakila

## Instructions

## Select the first name, last name, and email address of all the customers who have rented a movie.

SELECT * FROM customer; ## columns --- customer_id, store_id, first_name, last_name, email, address_id, active, create_date, last_update
SELECT * FROM payment; ## columns --- payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update

SELECT c.first_name, c.last_name, c.email
	FROM customer c
		WHERE customer_id IN (
			SELECT customer_id
			FROM payment p
            WHERE amount != "0"        
        );

		## Another alternative for the exercise above:
	SELECT DISTINCT c.first_name, c.last_name, c.email
	FROM customer c
	JOIN rental r 
    ON c.customer_id = r.customer_id;

## What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT p.customer_id, CONCAT(c.first_name," ", last_name) As customer_name, AVG(p.amount) 
	FROM payment p
		JOIN customer c
        ON p.customer_id = c.customer_id
			GROUP BY c.customer_id;

## Select the name and email address of all the customers who have rented the "Action" movies.
	## Write the query using multiple join statements
	## Write the query using sub queries with multiple WHERE clause and IN condition
	## Verify if the above two queries produce the same results or not

SELECT * FROM customer; ## columns --- customer_id, first_name, last_name, email
SELECT * FROM payment; ## columns --- customer_id, rental_id
SELECT * FROM rental; ## columns --- rental_id, inventory_id
SELECT * FROM inventory; ## columns --- inventory_id, film_id
SELECT * FROM film_category; ## columns --- film_id, category_id
SELECT * FROM category; ## columns --- category_id, name

	## queries using multiple join statements
SELECT DISTINCT CONCAT(c.first_name," ", last_name) As customer_name, c.email
	FROM customer c
 		JOIN payment p
        ON c.customer_id = p.customer_id
			JOIN rental r
            ON p.rental_id = r.rental_id
				JOIN inventory i
                ON r.inventory_id = i.inventory_id
					JOIN film_category fc
                    ON i.film_id = fc.film_id
						JOIN category cat
						ON fc.category_id = cat.category_id
						WHERE cat.name = "Action"
	ORDER BY customer_name ASC; 

	## sub queries with multiple WHERE clause and IN condition
SELECT DISTINCT first_name, last_name, email
FROM customer
WHERE customer_id IN (
    SELECT DISTINCT r.customer_id
    FROM rental r
    WHERE r.inventory_id IN (
        SELECT DISTINCT i.inventory_id
        FROM inventory i
        WHERE i.film_id IN (
            SELECT DISTINCT f.film_id
            FROM film f
            JOIN film_category fc ON f.film_id = fc.film_id
            JOIN category c ON fc.category_id = c.category_id
            WHERE c.name = 'Action'
        )
    )
);

## Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
	## If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
    
SELECT * FROM payment; ## columns --- payment_id, customer_id, staff_id, rental_id, amount, payment_date, last_update

SELECT 
    customer_id,    
    amount,
    CASE
        WHEN amount BETWEEN 0 AND 2 THEN 'low'
        WHEN amount BETWEEN 2 AND 4 THEN 'medium'
        ELSE 'high'
    END AS value_transaction
FROM payment;


