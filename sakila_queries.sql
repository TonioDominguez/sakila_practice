/*

Write the SQL statements that implement functions of your rental store management system.

Write an SQL script with queries that answer the following questions:

1. Which actors have the first name ‘Scarlett’
2. Which actors have the last name ‘Johansson’
3. How many distinct actors last names are there?
4. Which last names are not repeated?
5. Which last names appear more than once?
6. Which actor has appeared in the most films?
7. Is ‘Academy Dinosaur’ available for rent from Store 1?
8. Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
9. When is ‘Academy Dinosaur’ due?
10. What is that average running time of all the films in the sakila DB?
11. What is the average running time of films by category?
12. Why does this query return the empty set?
    select * from film natural join inventory;
    
*/

-- ANSWER 1

SELECT CONCAT (first_name, "  ", last_name) AS "First name is Scarlett" FROM sakila.actor
WHERE first_name = "Scarlett";

-- ANSWER 2

SELECT CONCAT (first_name, "  ", last_name) AS "Last name is Johansson" FROM sakila.actor
WHERE last_name = "Johansson";

-- ANSWER 3

SELECT COUNT(DISTINCT last_name) AS "Differents Last names" FROM sakila.actor;

-- ANSWER 4

SELECT last_name FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) = 1;

-- ANSWER 5

SELECT last_name FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) > 1;

-- ANSWER 6

SELECT first_name, last_name, COUNT(film_id) AS film_count FROM actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY first_name, last_name
ORDER BY film_count DESC LIMIT 1;

-- ANSWER 7

SELECT title, store_id FROM film
JOIN inventory
ON film.film_id = inventory.film_id
WHERE title = "ACADEMY DINOSAUR" AND store_id = 1

-- ANSWER 8

SELECT * FROM customer
WHERE first_name = "Mary" AND last_name = "Smith";

SELECT * FROM staff
WHERE first_name = "Mike" AND last_name = "Hillyer";

SELECT * FROM film
WHERE title = "Academy Dinosaur";

SELECT * FROM inventory
WHERE film_id = 1 AND store_id = 1;

INSERT INTO rental (inventory_id, customer_id, staff_id) VALUES (1, 1, 1)

-- ANSWER 10

SELECT AVG(length) FROM film;

-- ANSWER 11

SELECT category.name AS category_name, AVG(film.length) AS average_category_length  FROM film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category_name