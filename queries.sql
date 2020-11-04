/*Query 1 - query used for first insight/first slide*/
/*What do lifetime customers receive?*/

/*We want to retain and reward our customers that have kept on renting DVDs. We reward them every 6 months with a coupon as a way of encouraging them to always come back. The reward they get is based on their lifetime purchase count; how often they made purchases in quintiles. 

Write a query that returns customer id, the full name, their full address, and the reward they get.*/

 WITH twenty AS (
	 SELECT COUNT(customer_id) count, 
			customer_id cust_id,
			NTILE(5) OVER (ORDER BY COUNT(customer_id)) AS quintile
	 FROM payment
	 GROUP BY 2
	 ORDER BY 3 DESC),
	 
	 rewards AS (
	 SELECT cust_id,
			quintile,
			count,
			CASE WHEN quintile = 5 THEN 'Free movie rental'
				 WHEN quintile = 4 THEN '75% off for 2 movies'
				 WHEN quintile = 3 THEN '50% off for 2 movies'
				 WHEN quintile = 2 THEN '50% off for 1 movie'
				 ELSE '40% off for 1 movie' END AS rewards
	 FROM twenty)
	 
 SELECT r.cust_id,
		c.first_name || ' ' || c.last_name AS full_name,
		CONCAT(a.address,', ' , city.city,' ',a.postal_code,', ', country.country) AS full_address,
		r.rewards
 FROM rewards r
 JOIN customer c
 ON	  r.cust_id = c.customer_id
 JOIN address a
 ON	  a.address_id = c.address_id
 JOIN city
 ON city.city_id = a.city_id
 JOIN country
 ON city.country_id = country.country_id


 
/*Query 2 - query used for second insight/second slide*/
/*What are the rental totals per month for Store 1 vs. Store 2?*/

/*We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. 

Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.*/

 SELECT store_id,
	    DATE_PART('month',date) AS month,
	    DATE_PART('year', date) AS year,
	    count		
 FROM
	(
	SELECT store_id,
			DATE_TRUNC('month',r.rental_date) date,
			COUNT(*) count
	FROM rental r
	JOIN payment p
	ON 	 r.rental_id = p.rental_id
	JOIN staff s
	ON	 s.staff_id = p.staff_id

	GROUP BY store_id, date
	ORDER BY date, store_id
	) sub1
	


/*Query 3 - query used for third insight/third slide*/	
/*On average, how many movies are rented out for a specific genre? Which are the top 3 genres rented out?*/

/*We want to know which genres are the most popular based on how often a movie is rented out for that genre. Find the average amount of movies being rented out for a specific genre and tell us what are the 3 most popular genres based on the information from the query.

Write a query that returns film category and the average amount of movies rented out for that category*/

 SELECT category_name,
	    sum/count AS avg_rented
 FROM
	(
	SELECT category_name,
			COUNT(film_title) AS count,
			SUM(rental_count) AS sum
	FROM
		(
		SELECT  f.title AS film_title,
				c.name AS category_name,
				COUNT(r.rental_id) AS rental_count
		FROM category AS c
		JOIN film_category AS fc
		ON c.category_id=fc.category_id
		JOIN film AS f
		ON f.film_id=fc.film_id
		JOIN inventory AS i
		ON f.film_id=i.film_id
		JOIN rental AS r
		ON i.inventory_id=r.inventory_id
		
		GROUP BY 1,2
		ORDER BY 2,1
		) t1
	GROUP BY 1
	) t2
 GROUP BY 1,2
 
 

/*Query 4 - query used for fourth insight/fourth slide*/
/*Which are the top 10 countries in total revenue and what is their earned revenue per month in 2007?*/

/*We would like to know who were our top 10 paying countries, how much revenue made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the country name, month and year of payment, and total payment amount for each month by these top 10 countries?

Write a query that returns the top 10 countries' names, the month name, the total amount earned for that month (use PARTITIONS), and just to be safe the date_trunc.*/

WITH top10_countries AS
		(
		SELECT country, SUM(tot_spent)
		FROM (
			SELECT co.country country, c.customer_id cust_id
			FROM customer c
			JOIN address a
			ON c.address_id = a.address_id
			JOIN city ci
			ON ci.city_id = a.city_id
			JOIN country co
			ON co.country_id = ci.country_id
			GROUP BY 1,2
			ORDER BY cust_id DESC ) t1
			JOIN (
				SELECT c.customer_id cust_id, SUM(p.amount) tot_spent
				FROM customer c
				JOIN payment p
				ON c.customer_id = p.customer_id
				GROUP BY 1 ) t2
			ON t1.cust_id = t2.cust_id
			GROUP BY 1
			ORDER BY 2 DESC
			LIMIT 10 
		) ,
		/*gives top 10 earning countries*/
		
	 payments AS 
		(
		SELECT 	country,
				t1.cust_id cust_id,
				paid_date,
				tot_spent
		FROM (
			SELECT co.country country, c.customer_id cust_id
			FROM customer c
			JOIN address a
			ON c.address_id = a.address_id
			JOIN city ci
			ON ci.city_id = a.city_id
			JOIN country co
			ON co.country_id = ci.country_id
			ORDER BY cust_id DESC ) t1

		JOIN (
			SELECT c.customer_id cust_id, 
				DATE_TRUNC('month',p.payment_date) paid_date, 
				SUM(p.amount) tot_spent
			FROM customer c
			JOIN payment p
			ON c.customer_id = p.customer_id
			GROUP BY 1,2
			ORDER BY cust_id DESC ) t2
		ON t1.cust_id = t2.cust_id
		WHERE country IN (SELECT country FROM top10_countries) 
		)
	/*combines id, payment amounts, country, and date*/

/*returns country total revenue per month*/
SELECT DISTINCT
	country, 
	to_char(paid_date, 'Month') AS Month,
	sum(tot_spent) total_spent, 
    paid_date
FROM payments
GROUP BY country, paid_date
ORDER BY country, paid_date