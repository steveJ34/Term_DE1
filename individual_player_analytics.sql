use nba_17_18;

-- Creating analytical layer for player statistics

 DROP PROCEDURE IF EXISTS CreatePlayersAnalytic;

DELIMITER //

CREATE PROCEDURE CreatePlayersAnalytic()

BEGIN
DROP TABLE IF EXISTS Players_Analytic;

	CREATE TABLE Players_Analytic AS
	SELECT 
       Players.Name,
	   Players.Pos As Position, 
	   Players.Age As Age,
       Player_Stats.TM As Franchise,
	   Player_Stats.Gms As Games,
	   Player_Stats.MP As MinutesPlayed,   
	   Player_Stats.FG As FieldGoals,
	   Player_Stats.FGA As FieldGoalsAttempt,   
	   Player_Stats.FGP As FieldGoalsPercent,
       Player_Stats.PTS As Points
       
	FROM Players
    
JOIN Player_Stats ON name = Player
	ORDER BY 
		Name; 

END //
DELIMITER ; 

drop event if exists CreatePlayersAnalyticEvent; 

-- Creating an event for Players analytics tables to see when table is updated 
 
CREATE EVENT CreatePlayersAnalyticEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
   CALL CreatePlayersAnalytic();
   INSERT INTO messages(message,created_at)
   VALUES('Player Mart Created',NOW());

SELECT * FROM messages; 

-- Creating data marts as views to answer the analytic questions
 
-- Players that averaged 25 or more points per game

DROP VIEW IF EXISTS TopPPG;

CREATE VIEW `TopPPG` AS

SELECT Name, Position, Age, Games, ROUND(Points/Games, 2) AS ppg
FROM Players_Analytic
WHERE Points/Games >= 25;

SELECT * FROM TopPPG; 


-- Top 10 most time efficient scorers in the league

DROP VIEW IF EXISTS TopTimeEfficient;

CREATE VIEW `TopTimeEfficient` AS

SELECT Name, Position, Points, MinutesPlayed, ROUND (pointsPer48, 2) AS PointsPer48
FROM (
	SELECT Name, Position, Points, MinutesPlayed, CAST(Points as FLOAT)*48/CAST(MinutesPlayed as FLOAT) as PointsPer48
	FROM Players_Analytic
	WHERE Points > 0 AND MinutesPlayed > 0) as ps
ORDER BY PointsPer48 DESC
LIMIT 10;

SELECT * FROM TopTimeEfficient;

-- PLayers who played half the season or less but still averaged 15 points 

DROP VIEW IF EXISTS HalfSeason15Points;

CREATE VIEW `HalfSeason15Points` AS

SELECT Name, Position, Games, Points, ROUND (CAST(Points as FLOAT)/CAST(Games as FLOAT),2) as PPG
FROM Players_Analytic
WHERE Games <= 41 
AND CAST(Points as FLOAT)/CAST(Games as FLOAT) > 15 
AND Points > 0
ORDER BY CAST(Points as FLOAT)/CAST(Games as FLOAT) DESC;

SELECT * FROM HalfSeason15Points; 
