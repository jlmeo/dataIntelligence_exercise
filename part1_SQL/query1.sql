-- The following query identifies the top 5 most popular pieces of content 
-- consumed by users in a given week

-- Defining a week to be the preceding 7 day period
-- Assuming the total number of unique users is the metric to rank content on
-- EXPECTED OUTPUT:  content_id | count of unique users |

SELECT Content_id
		, COUNT(DISTINCT(Ads_user_id) -- taking the count of unique users who interacted with a piece of content to be the metric determine the most popular content pieces
FROM Page_Impression p
WHERE Timestamp  BETWEEN GETDATE() AND = DATEADD(DAY,-7,GETDATE())
GROUP BY p.Content_id
ORDER BY COUNT(DISTINCT Ads_user_id) DESC
LIMIT 5