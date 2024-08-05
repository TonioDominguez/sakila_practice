/*

1a. Display the first and last names of all actors from the table actor.

1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.

2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?

2b. Find all actors whose last name contain the letters GEN:

2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:

2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.

3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs.

3c. Now delete the middle_name column.

4a. List the last names of actors, as well as how many actors have that last name.

4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

4c. Oh, no! The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS, the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.

4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO. Otherwise, change the first name to MUCHO GROUCHO, as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO MUCHO GROUCHO, HOWEVER! (Hint: update the record using a unique identifier.)

5a. You cannot locate the schema of the address table. Which query would you use to re-create it?

Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:

6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.

6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.

6d. How many copies of the film Hunchback Impossible exist in the inventory system?

6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

Total amount paid

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.

7b. Use subqueries to display all actors who appear in the film Alone Trip.

7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as famiy films.

7e. Display the most frequently rented movies in descending order.

7f. Write a query to display how much business, in dollars, each store brought in.

7g. Write a query to display for each store its store ID, city, and country.

7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

8b. How would you display the view that you created in 8a?

8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

*/


-- ANSWER 1A

SELECT first_name, last_name FROM actor;

-- ANSWER 1B

SELECT UPPER(CONCAT(first_name, "  ", last_name)) AS "Actor Name" FROM actor;

-- ANSWER 2A

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "Joe";

-- ANSWER 2B

SELECT * FROM actor
WHERE last_name LIKE "%gen%";

-- ANSWER 2C

SELECT last_name, first_name FROM actor
WHERE last_name LIKE "%li%"
ORDER BY last_name;

-- ANSWER 2D

SELECT country_id, country FROM COUNTRY
WHERE country IN ("Afghanistan","Bangladesh","China");

-- ANSWER 3A

ALTER TABLE actor
ADD middle_name VARCHAR(50) AFTER first_name;

-- ANSWER 3B

ALTER TABLE actor
MODIFY COLUMN middle_name BLOB;

-- ANSWER 3C

ALTER TABLE actor
DROP COLUMN middle_name;

-- ANSWER 4A

SELECT last_name, COUNT(last_name) AS n_of_last_name FROM actor
GROUP BY last_name

-- ANSWER 4B

SELECT last_name, COUNT(last_name) AS n_of_last_name FROM actor
GROUP BY last_name
HAVING n_of_last_name >= 2

-- ANSWER 4C

UPDATE actor SET first_name = "HARPO"
WHERE actor_id = 172

-- ANSWER 4D

UPDATE actor SET first_name = "GROUCHO"
WHERE actor_id = 172

-- ANSWER 5A

CREATE TABLE address (
	address_id int NOT NULL AUTO_INCREMENT,
    address varchar(100) NOT NULL,
    address2 varchar(100),
    district varchar(100) NOT NULL,
    city_id int NOT NULL,
    postal_code int,
    phone int,
    location geometry,
    last_update datetime DEFAULT CURRENT_TIMESTAMP(),
    PRIMARY KEY (address_id)
);

-- ANSWER 6A

SELECT first_name, last_name, address FROM staff
JOIN address
ON staff.address_id = address.address_id

-- ANSWER 6B

SELECT first_name, last_name, SUM(amount) AS amount_rung_up FROM staff
JOIN payment
ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id

-- ANSWER 6C

SELECT title, COUNT(actor_id) AS n_of_actors  FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY film.film_id

-- ANSWER 6D

SELECT title, COUNT(inventory_id) AS n_of_copys FROM inventory
JOIN film ON inventory.film_id = film.film_id
WHERE title = "Hunchback Impossible"
GROUP BY inventory.film_id

-- ANSWER 6E

SELECT first_name, last_name, COUNT(amount) AS total_amount_paid FROM payment
JOIN customer ON payment.customer_id = customer.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name

-- ANSWER 7A

SELECT film.title FROM film
JOIN language ON film.language_id = language.language_id
WHERE (film.title LIKE "K%" OR film.title LIKE "Q%") AND language.name = "English";

-- ANSWER 7B

SELECT actor.first_name, actor.last_name FROM actor
WHERE actor.actor_id IN (
	SELECT film_actor.actor_id FROM film_actor
    WHERE film_actor.film_id = (
		SELECT film.film_id FROM film
        WHERE film.title = "Alone Trip")
);

-- ANSWER 7C

SELECT DISTINCT customer.first_name, customer.last_name, customer.email FROM customer
JOIN address ON customer.address_id = customer.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
WHERE country.country = "CANADA";

-- ANSWER 7D

SELECT film.title FROM film
WHERE film.film_id IN (
	SELECT film_category.film_id  FROM film_category
    WHERE film_category.category_id = (
    SELECT category.category_id FROM category
    WHERE category.name = "Family")
);

-- ANSWER 7E

SELECT film.title, COUNT(rental.rental_id) AS n_of_rentals FROM film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.film_id, film.title
ORDER BY n_of_rentals DESC

-- ANSWER 7F