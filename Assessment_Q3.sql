SELECT
    p.id AS plan_id,
    p.owner_id,
    -- u.name AS owner_name,
    -- u.email AS owner_email,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(sa.transaction_date) AS last_transaction_date,
    CASE 
        WHEN MAX(sa.transaction_date) IS NULL THEN NULL
        ELSE DATEDIFF(CURDATE(), MAX(sa.transaction_date))
    END AS inactivity_days
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount sa ON sa.plan_id = p.id AND sa.confirmed_amount > 0
-- LEFT JOIN
--    users_customuser u ON u.id = p.owner_id
WHERE
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
    AND p.is_deleted = 0
GROUP BY
    p.id, p.owner_id, type
HAVING
    inactivity_days IS NULL OR inactivity_days > 365
ORDER BY
    inactivity_days DESC