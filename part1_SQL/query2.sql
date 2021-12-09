-- The following query identifies the total number of unique weekly
-- active users for the latest full week

-- WAU is calculated by counting registered users with > 60 seconds dwell time between Monday-Sunday.

-- EXPECTED OUTPUT:  count_of_WAU (INT)


SELECT COUNT(DISTINCT(Ads_User_Id)) count_wau
FROM Ad_service_interaction_data c
INNER JOIN
(
	--  Joining to OAuth_ID_Service to get user_id mapping
	SELECT DISTINCT(b.Ads_User_Id) as Ads_User_Id
	FROM OAuth_ID_Service b
	INNER JOIN
	( -- Finding the registered users with a login time occurring in the last full week
		SELECT DISTINCT(a.OAuth_Id) as OAuth_Id --OAuth_id is the unique id with the OAuth_ID_Service table
		FROM Registered_Users a -- this table contains the registered users
		WHERE a.Last_access_time BETWEEN date_trunc('week',current_date) -interval '7' day -- preceding monday
							   AND date_trunc('week', current_date) - interval '1' day   -- preceding sunday
	) r
	ON b.OAuth_Id=r.OAuth_Id
	) s
ON c.Ads_User_Id=s.Ads_User_Id
WHERE c.Dwell_time>=60 -- Assuming Dwell Time is in seconds

