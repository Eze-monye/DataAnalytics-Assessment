SELECT
    p.id AS plan_id,
    p.owner_id,
    -- u.name AS owner_name,--Uncomment this to get the name of the user
    -- u.email AS owner_email, --Uncomment to get the email of the user for marketing and engagement purposes
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
LEFT JOIN --Left join returns all plans and matching record from savings table which
    savings_savingsaccount sa ON sa.plan_id = p.id AND sa.confirmed_amount > 0
-- LEFT JOIN
--    users_customuser u ON u.id = p.owner_id --this join helps return the email and name of user when uncommented
WHERE
	--filters for both savings and Investment plans
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
	--filters for plans that has not been deleted
    AND p.is_deleted = 0
GROUP BY
    p.id, p.owner_id,
	CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END
HAVING --Identifies inactive users for more than 365 days
    inactivity_days IS NULL OR inactivity_days > 365
ORDER BY
    inactivity_days DESC