-- First CTE: Aggregate user transaction stats
WITH user_transaction_stats AS (
    SELECT
        sa.owner_id, 
        COUNT(*) AS total_transactions,
        -- Ensure at least 1 month is counted even if min and max transaction are in the same month
        TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), MAX(sa.transaction_date)) + 1 AS months_active
    FROM
        savings_savingsaccount sa
    GROUP BY
        sa.owner_id
),

-- Second CTE: Categorize users by frequency
user_frequency AS (
    SELECT
        owner_id,
        total_transactions,
        months_active,
        -- Calculate average transactions per month (cast to decimal to ensure proper division)
        (total_transactions / months_active) AS avg_transactions_per_month,
        CASE
            WHEN (total_transactions / months_active) >= 10 THEN 'High Frequency'
            WHEN (total_transactions / months_active) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM
        user_transaction_stats
)

-- Final query: Summarize frequency categories
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month
FROM
    user_frequency
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
