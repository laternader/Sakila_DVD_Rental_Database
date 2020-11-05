# Sakila DVD Rental Database

In this project, you will query the Sakila DVD Rental database. The Sakila Database holds information about a company that rents movie DVDs. For this project, you will be querying the database to gain an understanding of the customer base, such as what the patterns in movie watching are across different customer groups, how they compare on payment earnings, and how the stores compare in their performance. To assist you in the queries ahead, the schema for the DVD Rental database is provided below.
https://www.postgresqltutorial.com/postgresql-sample-database/

## Question 1:
We want to retain and reward our customers that have kept on renting DVDs. We reward them every 6 months with a coupon as a way of encouraging them to always come back. The reward they get is based on their lifetime purchase count; how often they made purchases in quintiles.

Write a query that returns customer id, the full name, their full address, and the reward they get.

## Question 2:
What are the rental totals per month for Store 1 vs. Store 2?

We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for.

Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.

## Question 3:
On average, how many movies are rented out for a specific genre? Which are the top 3 genres rented out?

We want to know which genres are the most popular based on how often a movie is rented out for that genre. Find the average amount of movies being rented out for a specific genre and tell us what are the 3 most popular genres based on the information from the query.

Write a query that returns film category and the average amount of movies rented out for that category

## Question 4:
Which are the top 10 countries in total revenue and what is their earned revenue per month in 2007?

We would like to know who were our top 10 paying countries, how much revenue made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the country name, month and year of payment, and total payment amount for each month by these top 10 countries?

Write a query that returns the top 10 countries' names, the month name, the total amount earned for that month (use PARTITIONS), and just to be safe the date_trunc.

*data was provided by Udacity*
