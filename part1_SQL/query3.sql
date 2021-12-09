-- The following query returns the top 5 pieces of content from each
-- content type category for this selected by only weekly active users

SELECT Content_type
		, content_id
		, wau_impressions row_number() OVER ( --partitioning over content_type to get top 5 content pieces within each content group
				PARTITION BY Content_type
				ORDER BY wau_impressions DESC) AS rn
FROM(
	SELECT  Content_type
			, content_id
			, COUNT(DISTINCT(Ads_user_id) as wau_impressions
	FROM Page_Impression p 
	INNER JOIN 
	(-- subquery to get the set of WAUs
		SELECT DISTINCT(Ads_User_Id) as Ads_User_Id
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
	) w
	ON p.Ads_user_id=w.Ads_User_Id
	WHERE p.Timestamp BETWEEN date_trunc('week',current_date) -interval '7' day -- preceding monday
									   AND date_trunc('week', current_date) - interval '1' day   -- preceding sunday
	GROUP BY content_id, content_type
	ORDER BY COUNT(DISTINCT(Ads_user_id) DESC
)
WHERE rn<=5