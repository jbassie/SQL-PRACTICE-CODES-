-- 1. Find the total amount of poster_qty paper ordered in the orders table --

	SELECT SUM(poster_qty)
	FROM orders

-- 2.Find the total amount of standard_qty paper ordered in the orders table --

	SELECT SUM(standard_qty)
	FROM orders


-- 3.Find the total dollar amount of sales using the total_amt_usd in the orders table --

	SELECT SUM(total_amt_usd)
	FROM orders

/*4. Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. 
This should give a dollar amount for each order in the table */

	Select SUM(standard_amt_usd) as total_standard, SUM(gloss_amt_usd) as total_gloss
	FROM orders

/* 5. Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an 
aggregation and a mathematical operator.*/

	SELECT SUM(standard_amt_usd)/SUM(standard_qty) as standard_price_per_unit
	FROM ORDERS

--6. When was the earliest order ever placed? You only need to return the date --

	SELECT min(occurred_at :: date) AS date
	FROM orders


-- 7. Try performing the same query as in question 1 without using an aggregation function.--

	SELECT occurred_at :: date
	FROM orders
	ORDER BY 1 asc
	LIMIT 1

-- 8. When did the most recent (latest) web_event occur? --
 	SELECT Max(occurred_at)
	FROM orders

--9. Try to perform the result of the previous query without using an aggregation function. --
	SELECT occurred_at
	FROM orders
	ORDER BY 1 desc
	LIMIT 1


 /* 10. Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of 
each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the
average number of sales, as well as the average amount */

	SELECT AVG(standard_qty) as Avg_standard, AVG(standard_amt_usd) as avg_standard_amt,
			AVG(poster_qty) as Avg_poster, AVG(poster_amt_usd) as avg_poster_amt,
			AVG(gloss_qty) as Avg_gloss, AVG(gloss_amt_usd) as avg_gloss_amt
	FROM orders

-- 11. what is the MEDIAN total_usd spent on all orders --

	SELECT COUNT(total_amt_usd)/2
	FROM orders
	-- This gives us the median count, the find the median value
	SELECT *
	FROM (SELECT total_amt_usd
		 FROM orders
		 ORDER BY 1 
		 LIMIT 3457) as table_1
	ORDER BY total_amt_usd desc
	LIMIT 2

/* 12. For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns - one for the account name and one for the average quantity purchased 
for each of the paper types for each account */
	SELECT  a.name as Account_name, AVG(standard_qty) as Avg_standard_amt,
			AVG(poster_qty) as Avg_poster_qty, AVG(gloss_qty) as avg_gloss_amt
	FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
	GROUP BY 1
	
/* 13. For each account, determine the average amount of each type of paper they purchased across their orders.
Your result should have four columns - one for the account name and one for the average quantity purchased for 
each of the paper types for each account */
	SELECT  a.name as Account_name, AVG(standard_amt_usd) as Avg_standard_amt,
			AVG(poster_amt_usd) as Avg_poster_qty, AVG(gloss_amt_usd) as avg_gloss_amt
	FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
	GROUP BY 1

/* 14. Which account(by name) placed the earliest order? Your solution should have the account name and the 
date of the order */

	SELECT a.name, o.occurred_at
	FROM accounts a
		JOIN orders o
		ON a.id = o.account_id
	ORDER BY 2
	LIMIT 1
/* 15. Find the total sales in usd for each account. You should include two columns- the total_sales
	for each company's order in usd and the company name */
	
	SELECT a.name, SUM(o.total_amt_usd) as total_amount
	FROM accounts a
		JOIN orders o
		ON a.id = o.account_id
	GROUP BY 1

/* 16. Via what channel did the most recent(latest) web_event occur, which account was associated with this 
		event? Your query should return only three values- the date, channel, and account name*/
		
	SELECT a.name, w.channel, w.occurred_at
	FROM web_events w
		JOIN accounts a
		ON w.account_id = a.id
	ORDER BY 2 desc
	LIMIT 1

/* 17. Find the total number of times each type of channnel from web_events was used . Your final table should have 
two columns - the channel and the number of times the channel was used */
	SELECT channel, count(channel)
	FROM web_events
	GROUP BY 1

--18. Have any sales reps worked on more than one account --?

	SELECT (s.name), count(a.name)
	FROM accounts a
		JOIN sales_reps s
		ON a.sales_rep_id = s.id
	GROUP BY 1
	HAVING COUNT (a.name) > 1
	ORDER BY 2 desc;

/* 19. Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. 
Do you notice any trends in the yearly sales totals? */
	SELECT DATE_PART('year', occurred_at), SUM(total_amt_usd)
	FROM orders
	GROUP BY 1
	ORDER BY 2 DESC

/* 20. Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly 
represented by the dataset? */
 -- The answer to the first part of the question --
	SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd)
	FROM orders
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1

 _-- For the second part --
	 SELECT DATE_PART('month', occurred_at), SUM(total_amt_usd)
	FROM orders
	GROUP BY 1
	ORDER BY 2 DESC

/* 21 Which year did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all years evenly represented by the dataset? */
	
	SELECT DATE_PART('year', occurred_at), SUM(total)
	FROM orders
	GROUP  BY 1
	ORDER BY 2 DESC

/* 22. Which month did Parch & Posey have the greatest sales in terms of total number of orders? 
Are all months evenly represented by the dataset? */
	
	SELECT DATE_PART('month', occurred_at), SUM(total)
	FROM orders
	GROUP  BY 1
	ORDER BY 2 DESC

-- 23.In which month of which year did Walmart spend the most on gloss paper in terms of dollars? --
	SELECT DATE_PART('month', o.occurred_at), SUM(o.gloss_qty)
	FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
	WHERE a.name = 'Walmart'
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1

/* 24. Write a query to display for each order, the account ID, total amount of the order, and the level of the order- 
‘Large’ or ’Small’ -depending on if the order is $3000 or more, or less than $3000. */

	SELECT id, account_id, total_amt_usd,
		CASE WHEN total_amt_usd < 3000 THEN 'Small'
		ELSE 'Large' END AS level_of_order
	FROM orders
	GROUP BY 1,2

/* 25 Write a query to display the number of orders in each of three categories, based on the total number of
items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'. */

	SELECT id,
		CASE WHEN total < 1000 THEN 'Less than 1000'
			WHEN total >= 1000 AND total <= 2000 THEN 'Between 1000 and 2000'
			ELSE 'Atleast 2000' END AS Level
	FROM orders

/* 26 We would like to understand 3 different branches of customers based on the amount associated with their
purchases. The top branch includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
The second branch is between 200,000 and 100,000 usd. The lowest branch is anyone under 100,000 usd. 
Provide a table that includes the level associated with each account. You should provide the account name, 
the total sales of all orders for the customer, and the level. Order with the top spending customers listed first. */

	SELECT a.name, sum(o.total_amt_usd),
		CASE WHEN SUM(o.total_amt_usd) < 100000 THEN 'Low Spenders'
		WHEN SUM(o.total_amt_usd) >= 100000 and SUM(o.total_amt_usd) <=200000 THEN ' Mid Spenders'
		ELSE 'Top Spenders' END AS Lifetime_value
	FROM orders o
	join accounts a
	on o.account_id = a.id
	GROUP BY 1
	ORDER  BY 2 DESC

/* 27 We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent 
by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending 
customers listed first. */

SELECT a.name, sum(o.total_amt_usd),
		CASE WHEN SUM(o.total_amt_usd) < 100000 THEN 'Low Spenders'
		WHEN SUM(o.total_amt_usd) >= 100000 and SUM(o.total_amt_usd) <=200000 THEN ' Mid Spenders'
		ELSE 'Top Spenders' END AS Lifetime_value
	FROM orders o
		JOIN accounts a
		ON o.account_id = a.id
	WHERE o.occurred_at between '01-01-2016' and '12-31-2017'
	GROUP BY 1
	ORDER  BY 2 DESC

/* 28 We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders.
Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if
they have more than 200 orders. Place the top sales people first in your final table. */

		SELECT s.name,count(*),
				CASE WHEN count(*) > 200 THEN 'TOP'
				ELSE 'BOTTOM' END AS LEVEL
		FROM sales_reps s
			JOIN accounts a 
			ON s.id = a.sales_rep_id
			JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 2 DESC

/* 29 The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides 
they want to see these characteristics represented as well. We would like to identify top performing sales reps,
which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has
any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of 
orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the 
top sales people based on dollar amount of sales first in your final table. */

	SELECT s.name,count(*) as num_orders, sum(o.total_amt_usd) as total_amt,
				CASE WHEN count(*) > 200 or sum(o.total_amt_usd) > 750000 THEN 'TOP'
					WHEN count(*) > 150 or sum(o.total_amt_usd) > 500000 THEN 'MIDDLE'	
					ELSE 'LOW' END AS LEVEL
		FROM sales_reps s
			JOIN accounts a 
			ON s.id = a.sales_rep_id
			JOIN orders o
			ON a.id = o.account_id
		GROUP BY 1
		ORDER BY 3 DESC




	
	
	
	
	
	
	





	
	
