--The first Common Table Expression (CTE) that aggregates users transaction 
WITH user_transaction_stats AS (
    SELECT
        sa.owner_id, 
		--Counts how many transactions the user has performed
        COUNT(*) AS total_transactions,
		--Calculates how many full months a user has been active while ensuring users that their first time transacting is the current month is counted as active
		TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) + 1 AS months_active
    FROM
    users_customuser uc
	--Joins the user table and savings table using owner_id as foreign key and ID primary key
	JOIN
		savings_savingsaccount sa ON sa.owner_id = uc.id --plan_id is a foreign key to the ID primary key in the plans table
		
		--Grouping the output to ensure one role per user
    GROUP BY
        owner_id
),
--Second Common Table Expression (CTE) that checks for frequency 
user_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        months_active,
		--Calculate average transactions per month by dividing 
        (total_transactions / months_active) AS avg_transactions_per_month,
		--Categorizes the frequency in different buckets
        CASE
            WHEN (total_transactions / months_active) >= 10 THEN 'High Frequency'
            WHEN (total_transactions / months_active) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        user_transaction_stats
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
	--Calculates the avaerage monthly transaction by using the in built average function and rounding the result up to 2 decimal place
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM
--References the table in the CTE above
    user_frequency
GROUP BY
    frequency_category
ORDER BY
	--Specifies the order inwhich the data should be arranged, based on the Frequency category column
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency')
	

