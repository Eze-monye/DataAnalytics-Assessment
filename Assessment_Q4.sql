SELECT
    u.id AS customer_id,
    concat (u.first_name, ' ', u.last_name) as name ,
    
    -- Calculates how many full months a customer has been active
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,

    -- Total number of transactions (0 for users with no transactions)
    COUNT(sa.id) AS total_transactions,

    -- Calculates estimated CLV: average monthly transactions * 12 * 0.1% of avg confirmed amount
    CASE
        WHEN TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) = 0 THEN NULL
        ELSE (
            (COUNT(sa.id) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12
        ) * AVG(sa.confirmed_amount * 0.001)
    END AS estimated_clv

FROM
    users_customuser u

-- Left join to include users with zero transactions
LEFT JOIN
    savings_savingsaccount sa ON sa.owner_id = u.id AND sa.confirmed_amount > 0

GROUP BY
    u.id, concat (u.first_name, ' ', u.last_name), u.date_joined

ORDER BY
    estimated_clv DESC;
