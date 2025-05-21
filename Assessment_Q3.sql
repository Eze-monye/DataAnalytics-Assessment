SELECT
    p.id AS plan_id,
    p.owner_id,
    -- u.name AS owner_name,  -- Uncomment to retrieve user's name
    -- u.email AS owner_email, -- Uncomment to retrieve user's email for engagement purposes

    -- Classify the plan type
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,

    -- Most recent transaction date
    MAX(sa.transaction_date) AS last_transaction_date,

    -- Calculate inactivity in days
    CASE 
        WHEN MAX(sa.transaction_date) IS NULL THEN NULL
        ELSE DATEDIFF(CURDATE(), MAX(sa.transaction_date))
    END AS inactivity_days

FROM
    plans_plan p

-- Join savings accounts, filtering for confirmed (funded) transactions
LEFT JOIN 
    savings_savingsaccount sa ON sa.plan_id = p.id AND sa.confirmed_amount > 0

-- Optionally join user table if user details are needed
-- LEFT JOIN users_customuser u ON u.id = p.owner_id

WHERE
    -- Include only savings or investment plans
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.is_deleted = 0  -- Exclude deleted plans

GROUP BY
    p.id, p.owner_id,
    -- Required to repeat the same CASE in GROUP BY for MySQL compliance
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END

HAVING
    -- Select plans with no activity in over 1 year or never used
    inactivity_days IS NULL OR inactivity_days > 365

ORDER BY
    inactivity_days DESC;
