WITH user_transaction_stats AS (
    SELECT
        owner_id,
        COUNT(*) AS total_transactions,
        TIMESTAMPDIFF(MONTH, MIN(transaction_date), MAX(transaction_date)) + 1 AS months_active
    FROM
        savings_savingsaccount
    GROUP BY
        owner_id
),
user_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        months_active,
        (total_transactions / months_active) AS avg_transactions_per_month,
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
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM
    user_frequency
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency')