# DataAnalytics-Assessment for SQL Proficiency Assessment
 
# Assessment_Q1  (High-Value Customers with Multiple Products)

The SQL query retrieves user information and calculates their savings activity. Specifically, it:
-Fetches the user's ID and name.
-Counts the number of unique savings and investment plans for each user that have confirmed deposits greater than zero.
-Calculates the total confirmed deposits for each user and converts this amount to Naira.
-Joins the users and savings tables using their respective joining keys.
-Filters the results to include only confirmed deposits and excludes plans that are neither savings nor investment plans.
-Ensures that the count of both savings and investment plans is greater than zero for a user to be included in the results.
-Arranges the final result set in descending order based on the total deposits.


# Assessment_Q2 (Transaction Frequency Analysis)

This SQL script analyzes user transaction data to categorize users based on their transaction frequency. It uses Common Table Expressions (CTEs) to break down the analysis into logical steps.
The script performs the following actions:
--Aggregates User Transaction Statistics (`user_transaction_stats` CTE):
    * Counts the total number of transactions performed by each user.
    * Calculates the number of months a user has been active, considering the time difference between their first and last          transaction. A user whose first transaction occurred in the current month is counted a active for at least one month.
--Determines User Transaction Frequency (`user_frequency` CTE):
    * Calculates the average number of transactions per month for each user by dividing their total transactions by their           active months.
    * Categorizes users into "High Frequency", "Medium Frequency", and "Low Frequency" based on their average monthly               transaction count:
    * "High Frequency": Average of 10 or more transactions per month.
    * "Medium Frequency": Average between 3 and 9 transactions per monthly (inclusive).
    * "Low Frequency": Average less than 3 transactions per month.
--Final Result:
    * Groups users by their frequency category.
    * Counts the number of customers in each frequency category.
    * Calculates the average monthly transaction count for each frequency category.
    * Orders the results with "High Frequency" appearing first, followed by "Medium Frequency", and then "Low Frequency".

# Assessment_Q3 (Identifying Dormant Savings and Investment Accounts)

This process identifies customer Savings and Investment plans exhibiting prolonged inactivity forn the opeartion team.
--Categorize Plans: Classifies plans as 'Savings', 'Investment', or 'Other'.
--Determine Last Activity: Identifies the most recent transaction date for each plan.
--Calculate Inactivity duration: Computes the duration (in days) since the last transaction by subtracting the last 
  transaction day from the current date.
--Filter Inactive Accounts: Selects plans with no transaction as null OR 
  last activity exceeding 365 days.
--Filters for only active plans (plans that is not deleted) and either     
  savings or investment plans.
--Prioritize by Inactivity: Orders results by inactivity duration in   
  descending order.

# Assessment_Q4 (Customer Lifetime Value (CLV) Estimation)

This estimates each customer’s Lifetime Value (CLV) based on account tenure and transaction history, using a simplified formula for marketing analysis.
Output Fields
- `customer_id`: Customer's ID  
- `name`: Customer's name  
- `tenure_months`: Months since sign-up  
- `total_transactions`: Number of transactions  
- `estimated_clv`: Estimated lifetime value (based on 0.1% profit per transaction)
 Notes
- Only confirmed transactions are used.
- Users with no tenure or transactions return `NULL` CLV.
- Output is sorted by highest estimated CLV.


