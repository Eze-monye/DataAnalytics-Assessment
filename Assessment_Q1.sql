SELECT
    uc.id AS owner_id,
    concat (uc.first_name, ' ', uc.last_name) as name,
    
    -- Customers with at least one funded savings plan
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN pp.id END) AS savings_count,
    
    -- Customers with at least one funded investment plan
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN pp.id END) AS investment_count,
    
    -- Converts the confirmed amount from Kobo to Naira (dividing by 100 instead of multiplying)
    SUM(sa.confirmed_amount) / 100 AS total_deposits

FROM
    users_customuser uc

JOIN
    savings_savingsaccount sa ON sa.owner_id = uc.id

JOIN
    plans_plan pp ON pp.id = sa.plan_id

WHERE
    -- Filters for funded plans and plan type
    sa.confirmed_amount > 0
    AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)

GROUP BY
    uc.id, uc.name

HAVING
    -- Only customers with at least one savings and one investment plan
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN pp.id END) > 0
    AND COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN pp.id END) > 0

ORDER BY
    total_deposits DESC;
