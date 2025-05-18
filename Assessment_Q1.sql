SELECT
    uc.id AS owner_id,
    uc.name ,
	--Customers with at least one funded savings plan
    COUNT(DISTINCT CASE WHEN pp.is_regular_savings = 1 AND sa.confirmed_amount > 0 THEN pp.id END) AS savings_count,
	--Customers with at least one funded investment plan
    COUNT(DISTINCT CASE WHEN pp.is_a_fund = 1 AND sa.confirmed_amount > 0 THEN pp.id END) AS investment_count,
	--Converts the confirmed amount from Kobo to Naira
    SUM(sa.confirmed_amount) * 100 AS total_deposits
FROM
    users_customuser uc
	--Joins the user table and savings table using owner_id as foreign key and ID primary key
JOIN
    savings_savingsaccount sa ON sa.owner_id = uc.id
	--plan_id is a foreign key to the ID primary key in the plans table
JOIN
    plans_plan pp ON pp.id = sa.plan_id
WHERE
	--Filters for just funded plans
    sa.confirmed_amount > 0
	--Filters for either investment plan or savings plan
    AND (pp.is_regular_savings = 1 OR pp.is_a_fund = 1)
GROUP BY
	--Groups the earlier aggregation to return unique ID and name
    uc.id, uc.name
HAVING
	--Filters again for Customers that has atleast one funded savings plan and one funded investment plan
    savings_count > 0
    AND investment_count > 0
ORDER BY
	--Arranges the total deposits from biggest to smallest
    total_deposits DESC;
 
