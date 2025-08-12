Telco Customer Churn Analysis (SQL)

Project Goal :This project analyzes customer churn in a fictional Telco dataset using SQL. The main goal is to identify customer attributes and behaviors most associated with churn, and to guide future analysis in Python for more advanced statistical testing.


 Business Questions
 1. Which customer demographics are most associated with churn?
 2. Is there a correlation between tenure and churn?
 3. Do certain payment methods have higher churn rates?
 4. Are there specific types of support issues common among churned customers?
 5. Does resolution time of support tickets impact churn?



Dataset Overview 

The analysis is based on two main tables:


 • TelcoCustomerChurn: Based on the Telco Customer Churn dataset publicly available on Kaggle. This dataset contains customer demographics, services, tenure, contract type, and churn status.
 
 • SupportTickets: This is a fictional table created with ChatGPT for the purpose of illustrating multi-table SQL joins and issue-based churn analysis. It contains synthetic data on support issue types and resolution times.



Assumptions:

 • This is a sample dataset used for learning purposes.
 
 • Column Churn is binary (Yes/No).
 
 • Some transformations (like churn rate calculations) are done directly using SQL aggregations.



 Tools Used:
 
 • SQL (SQLlite-like syntax)
 
 • CASE statements for conditional aggregation
 
 • JOINs for combining customer and support data
 
 • Grouped aggregation (GROUP BY) for churn rate comparison



 Sample Insights
 
 • Customers without partners had slightly higher churn rates.
 
 • Senior citizens are more likely to churn.
 
 • Longer tenure is associated with lower churn.
 
 • No clear relationship found between resolution time and churn (requires statistical testing in Python).
 
 • Internet-related support issues are more common among churned customers.
