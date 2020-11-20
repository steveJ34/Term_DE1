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

-- Potential Analytics that can be done with Team and Coach data using views 

-- Top 10 Coaches by defence. Showstop 10 defensive coaches including aggreagated and per game stats for steals, rebounds and Blocked shots. Ordered by steals, assuming steals are the ultimate goal of a tema on defence 

DROP VIEW IF EXISTS CoachesByDefence;

CREATE VIEW `CoachesByDefence` AS

SELECT Coach, Franchise, Steal, ROUND(Steal/games, 2) AS StealperGm , BlockShot, ROUND(BlockShot/games, 2) AS BlockShotPerGm, Fouls, ROUND(fouls/games, 2) AS FoulsPerGm FROM Team_Coach_Analytic
ORDER BY Steal DESC
LIMIT 10;

SELECT * FROM CoachesByDefence; 

-- Shooting patterns of different teams depending on coach in terms of 3 point shootin and its effects the Filed Goal and Effective Field Goal percentages

DROP VIEW IF EXISTS CoachesBy3PShooting;

CREATE VIEW `CoachesBy3PShooting` AS

SELECT Coach, Franchise, Team_3PA, Team_3P, ROUND (Team_3PP, 2) AS Team_3PP, ROUND(FieldGoalsPercent, 2) AS FieldGoal, ROUND((FieldGoals + (0.5 * team_3P))/FieldGoalsAttempt, 2)as eFieldGoal FROM Team_Coach_Analytic
ORDER BY Team_3P DESC;

SELECT * FROM CoachesBy3PShooting;

-- Coaches who move the ball the most (assist on field goal ratio is over 0.5) and how it affects the turnovers

DROP VIEW IF EXISTS CoachesByPassing;  

CREATE VIEW `CoachesByPassing` AS

SELECT Franchise, Assist, ROUND(CAST(Assist as FLOAT)/CAST(FieldGoals as FLOAT), 2) as AssistOnFieldGoalRatio, Turnover
FROM Team_Coach_Analytic
WHERE CAST(assist as FLOAT)/CAST(fieldgoals as FLOAT) > .5;

SELECT * FROM CoachesByPassing;  

