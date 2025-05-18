SELECT
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
	--calculates customers total transactions and substitues zero for customers without transactions
    COALESCE(COUNT(sa.id), 0) AS total_transactions,
	--calculates the clv and converts the 0.1 percent to 0.001
    CASE
        WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) = 0 THEN NULL
        ELSE ((COUNT(sa.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12) * AVG(sa.confirmed_amount * 0.001)
    END AS estimated_clv
FROM
    users_customuser u
LEFT JOIN
    savings_savingsaccount sa ON sa.owner_id = u.id
GROUP BY
    u.id, u.name, u.date_joined
ORDER BY
    estimated_clv DESC
	