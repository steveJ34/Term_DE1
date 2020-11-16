DROP SCHEMA IF EXISTS nba_17_18;

-- creating schema

CREATE SCHEMA nba_17_18;
USE nba_17_18;

-- Creating Tables

-- Coach Stats

CREATE TABLE Coach_Stats (
Name     VARCHAR(100) NOT NULL,
Team     VARCHAR(10),
SeasG    INT,
SeasW    INT,
SeasL    INT,
FranG    INT,
FranW    INT,
FranL    INT,
CareW    INT,
CareL    INT,
CareWP   FLOAT,
POSeasG  INT,
POSeasW  INT,
POSeasL  INT,
POFranG  INT,
POFranW  INT,
POFranL  INT,
POCareG  INT,
POCareW  INT,
POCareL  INT,
PRIMARY KEY(Name));

-- Coahes

CREATE TABLE Coaches (
Name      VARCHAR(100),
TeamID   INT REFERENCES Teams(TeamID),
PRIMARY KEY(Name, TeamID));

-- Player Stats 

CREATE TABLE Player_Stats ( 
Player    VARCHAR(100) NOT NULL,
Tm       VARCHAR(10) NOT NULL,
Gms      INT,
Gstart   INT,
MP       INT,
FG       INT,
FGA      INT,
FGP      FLOAT,
ThreeP   INT,
ThreePA  INT,
ThreePP  FLOAT,
TwoP     INT,
TwoPA    FLOAT,
TwoPP    FLOAT,
eFGP     FLOAT,
FT       INT,
FTA      FLOAT,
FTP      FLOAT,
ORB      INT,
DRB      INT,
TRB      INT,
AST      INT,
STL      INT,
BLK      INT,
TOV      INT,
PF       INT,
PTS      INT,
PRIMARY KEY(Player, Tm));

-- Players

CREATE TABLE Players (
Name VARCHAR(100),
Pos VARCHAR(10),
Age INT,
PRIMARY KEY(Name));


-- Team Stats 

CREATE TABLE Team_Stats (
TeamId   INT,
G        INT,
MP       INT,
FG       INT,
FGA      INT,
FGP      FLOAT,
ThreeP   INT,
ThreePA  INT,
ThreePP  FLOAT,
TwoP     INT,
TwoPA    INT,
TwoPP    FLOAT,
FT       INT,
FTA      INT,
FTP      FLOAT,
ORB      INT,
DRB      INT,
TRB      INT,
AST      INT,
STL      INT,
BLK      INT,
TOV      INT,
PF       INT,
PTS      INT,
PRIMARY KEY(TeamId));

-- Teams 

CREATE TABLE Teams (
TeamID INT NOT NULL,
TeamName VARCHAR(100) NOT NULL,
TeamAbbr VARCHAR(10),
Location VARCHAR(100),
PRIMARY KEY(TeamID));

-- Top Scorers 

CREATE TABLE Top_Scorers (
Points INT NOT NULL,
Name VARCHAR(100) NOT NULL,
Year INT,
TeamName VARCHAR(100),
OppTeamName VARCHAR(100),
TeamScore INT,
OppTeamScore INT,
MinsPlayed INT);


-- local_infile to be ON

SHOW VARIABLES LIKE "local_infile";
SET GLOBAL local_infile = 'ON';


-- Loading Data 

-- Load Coach Stats 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Coach_Stats_v2.csv'
INTO TABLE Coach_Stats
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Name, Team, SeasG, SeasW, SeasL, FranG, FranW, FranL, CareW, CareL, CareWP, POSeasG, POSeasW, POSeasL, POFranG, POFranW, POFranL, POCareG, POCareW, POCareL);

-- Load Coaches 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Coaches.csv'
INTO TABLE Coaches
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Name, TeamID);

-- Load Player Stats 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Player_Stats.csv'
INTO TABLE Player_Stats 
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Player, Tm, Gms, Gstart, MP, FG, FGA, FGP, ThreeP, ThreePA, ThreePP, TwoP, TwoPA, TwoPP, eFGP, FT, FTA, FTP, ORB, DRB, TRB, AST, STL, BLK, TOV, PF, PTS);

-- Load Players 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Players.csv'
INTO TABLE Players
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Name, Pos, Age);

-- Load Team Stats 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Team_Stats.csv'
INTO TABLE Team_Stats
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(TeamID, G, MP, FG, FGA, FGP, ThreeP, ThreePA, ThreePP, TwoP, TwoPA, TwoPP, FT, FTA, FTP, ORB, DRB, TRB, AST, STL, BLK, TOV, PF, PTS);

-- Load Teams

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /Data Engineering /DE1SQL/HW/HW1/NBA_data_2017_2018/Teams.csv'
INTO TABLE Teams
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(TeamID, TeamName, TeamAbbr, Location);

-- Load Top Scorers 

LOAD DATA LOCAL INFILE '/Users/steve_j/Documents/CEU /data_engineering/DE1SQL/HW/HW1/NBA_data_2017_2018/Teams.csv'
INTO TABLE Top_Scorers
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(Points, Name, Year, TeamName, OppTeamName, TeamScore, OppTeamScore, MinsPlayed);


select * from top_scorers;

