# dataIntelligence_exercise
A fun, exploratory exercise

# Introduction

## Part I: SQL
Given a set of table schemas and assuming these tables live in a Presto SQL tablespace, answer the following questions:
-    Top 5 most popular pieces of content consumed this week. 
-    Number of weekly active users for the latest full week (Monday – Sunday). WAU is calculated by counting registered users with > 60 seconds dwell time between Monday-Sunday.
-    Top 5 pieces of content from each content type consumed this week by only active users (using the above definition). 

## Part II: Machine Learning and Insights
The goal of this exercise is to understand what aspects of user behavior indicate that a user is likely to use our new podcast App. 

### Input Data:
The input user data contains several fields of interest, in addition to whether the user engaged with the podcast app.

*High Level Summary of the Data*
- 1M records with 999500 unique records for 999500 unique users.
- Most fields have full coverage, but the user age and user state are missing values (~2% and ~1% respectively)
- 3 Unique Values for States: California, Georgia, and Washington, DC
- Assuming the "U" and "S" values for the Marital Status field both indicate unmarried status

Most of the available data is categorical and, if not already encoded as a binary field, will need to be one-hot encoded to use for modeling purposes.

### Feature Selection and Model
*Correlation Summary*
- The number of news subscriptions demonstrates the strongest correlation with the target
- Gender and several of the income "buckets" also demonstrate some correlation with the target
- State and Age seem to have very little or no correlation with the target

I will explore a logistic regression approach, using recurvise feature elimination to select the features for the model.

Model Evaluation Metrics will include:

- Accuracy: Count of incorrect predictions/Count of Correct Predictions
- Precision: tp / (tp + fp)
- Recall: tp / (tp + fn)
- F-Score: A weighted mean of the precision and recall

### Output Data:
The output data, data/Scores.csv, include the predictions for the test set (after splitting the input data into training and test sets) and the probability of a given user using the podcast app:
Scores.csv
- anon_user_id: INT; unique user indentifier
- target: BOOLEAN; 0 for user who did not use the app, 1 for user who did use the app
- prediction: BOOLEAN; prediction from the logistic regression model; 0 for user who did not use the app, 1 for user who did use the app
- probability: FLOAT; predictied probability of user using the podcast app 

