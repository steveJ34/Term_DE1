-- Creating a datamart for teams, coaches, team statistics

use nba_17_18;
 
 DROP PROCEDURE IF EXISTS CreateTeamCoachAnalytic;

DELIMITER //

CREATE PROCEDURE CreateTeamCoachAnalytic()

BEGIN
Drop table if exists Team_Coach_Analytic;

	CREATE TABLE Team_Coach_Analytic AS
	SELECT 
       Teams.TeamID,
       Coaches.name AS Coach, 
	   Teams.TeamName As Franchise, 
	   Teams.TeamAbbr As Short_Franchise,
       Teams.Location As City,
	   Team_Stats.G As Games,
	   Team_Stats.FG As FieldGoals,
	   Team_Stats.FGA As FieldGoalsAttempt,   
       Team_Stats.FGP As FieldGoalsPercent,
	   Team_Stats.ThreeP As Team_3P,
       Team_Stats.ThreePA As Team_3PA,
       Team_Stats.ThreePP As Team_3PP, 
       Team_Stats.AST As Assist,
       Team_Stats.STL As Steal,
       Team_Stats.BLK As BlockShot,
       Team_Stats.TOV As Turnover,
       Team_Stats.PF As Fouls,
       Team_Stats.PTS As Points
	FROM
		Teams
        JOIN Team_Stats ON Teams.teamid = team_stats.teamid
        JOIN Coaches ON Teams.teamid = coaches.teamid
	ORDER BY 
		TeamID ; 

END //
DELIMITER ;

-- Creating messages table to caprture event

DROP TABLE IF EXISTS MESSAGES; 
 
CREATE TABLE messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    message VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL
);

-- Creating an event for Team Stat Coach Data Analytic

DROP EVENT IF EXISTS CreateTeamCoachAnalyticEvent; 

CREATE EVENT CreateTeamCoachAnalyticEvent
ON SCHEDULE EVERY 1 MINUTE
STARTS CURRENT_TIMESTAMP
ENDS CURRENT_TIMESTAMP + INTERVAL 1 HOUR
DO
   CALL CreateTeamCoachAnalytic();
   INSERT INTO messages(message,created_at)
   VALUES('Team Stats Coach Mart Created',NOW());

-- Checking the messages table

SELECT * FROM messages;

-- Potential Analytics that can be done with Team and Coach level data using views 

-- Top 10 Coaches by steals 

DROP VIEW IF EXISTS CoachesByDefence;

CREATE VIEW `CoachesByDefence` AS

SELECT Coach, Franchise, Steal, BlockShot, Fouls FROM Team_Coach_Analytic
ORDER BY Steal DESC
LIMIT 10;

SELECT * FROM CoachesByDefence; 

-- Top 10 Coaches who rely on three point shots  

DROP VIEW IF EXISTS CoachesBy3PAttempt;

CREATE VIEW `CoachesBy3PAttempt` AS

SELECT Coach, Franchise, Team_3PA, Team_3P, ROUND (Team_3PP, 2) FROM Team_Coach_Analytic
ORDER BY Team_3PA DESC
LIMIT 10;

SELECT * FROM CoachesBy3PAttempt;


-- Top 10 teams which have the highest FG attempts 

DROP VIEW IF EXISTS Top10FGA;

CREATE VIEW `Top10FGA` AS

SELECT Franchise, FieldGoalsAttempt FROM Team_Coach_Analytic
ORDER BY FieldGoalsAttempt DESC
LIMIT 10;

SELECT * FROM Top10FGA;  	

-- Comparing effective Field Goal % to Field Goal % for top 10 teams with highest effective Field Goal % 

DROP VIEW IF EXISTS eFGtoFG;

CREATE VIEW `eFGtoFG` AS

SELECT Franchise, ROUND(FieldGoalsPercent, 2), ROUND((FieldGoals + (0.5 * team_3P))/FieldGoalsAttempt, 2)as eFieldGoal 
FROM Team_Coach_Analytic
ORDER BY eFieldGoal DESC
LIMIT 10;

SELECT * FROM eFGtoFG;

-- Teams which assists on field goals percentage is more than 50\% (more passing oriented)

DROP VIEW IF EXISTS AssistOnFGRatio;  

CREATE VIEW `AssistOnFGRatio` AS

SELECT Franchise, ROUND(CAST(Assist as FLOAT)/CAST(FieldGoals as FLOAT), 2) as AssistOnFieldGoalRatio
FROM Team_Coach_Analytic
WHERE CAST(assist as FLOAT)/CAST(fieldgoals as FLOAT) > .5;

SELECT * FROM AssistOnFGRatio;  

-- How often teams foul their opponents

DROP VIEW IF EXISTS FoulPerGame; 

CREATE view `FoulPerGame` as 	
SELECT franchise, ROUND(fouls/games, 2) as foulsPerGm
FROM Team_Coach_Analytic;

SELECT * FROM FoulPerGame;

