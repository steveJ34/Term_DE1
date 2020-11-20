# Term_DE1  

## Project Description 


### OPERATIONAL LAYER: 

The data includes National Basketball Association (NBA) statistics for players, teams and coaches for 2017-2018 season. The relational database can be seen below. 



![Figure 1 - Relational Database NBA](Images/RelationSchema.png)



CSV files were used to store the raw data. Then a schema and tables were created with the same attributes as the CSV files. Finally, the data was inserted into MySQL using the following command 

* LOAD DATA 
* LOCAL INFILE 'path_to_csv_file'
* INTO TABLE 'corresponding_table'
* FIELDS TERMINATED BY ','
* LINES TERMINATED BY '\r\n'
* IGNORE 1 LINES 

### ANALYTICAL LAYER: 
After the tables were loaded to MySQL, the analytical data layer was established. Due to the fact that not all of the tables in the operationla layer can be related to each other, the decision to create two analytical tables was made. The tables are created using events which re-create them every minute for an hour and record the times of creation to a table called “messages”. Below is amore deatailed description for each of the created tables.  


1. Team_Coach_Analytic: includes information about teams such as the Franchise name, name abbreviation, city/state and the coach. In addition, it includes both defensive and offensive statistics. This can provide insight to team performance for he season, using both the already available data and trnformed data (e.g. assist on field goal percentage).
1. Players_Analytic: includes the players’ attributes such as name, age, position and franchise as well as individual performance metrics like games played. Data from this layer provides the opportunity to create more detailed analytic insight to see what player were major contributors to team performance. 

By creating views from the above data marts, we can potentially answer the following question. 

### POTENTIAL ANALYTICS:  

#### Team Level (Team_Coach_Analytic)

* Question 1: Who are the top 10 defensive coaches including. The view is ordered by steals, assuming steals are the ultimate goal of a tema on defence. 
* Question 2: Who are the top 10 coaches that rely on three point shots the most 
* Question 3: What are the top ten teams with the highest field goal attempts (FGA), in order from highest to lowest? 
* Question 4: What are the top ten teams with the highest effective field goal percentages (EFG%) and how it compares to simple Field Goal %?  
* Question 5: Which teams assists on field goals percentage is more than 50%?



#### Player Level (Players_Analytic) 

* Question 1: Which players averaged over 25 points per game? 
* Question 2: Who was the most time (48 minutes) efficient scorer in the league? 
* Question 3: What players played less than or equal to half the season but scored over 15 points a game? 

### DATA MART: 

The following queries result in views that provide answers to the questions listed above.

#### Team Level 

* Question 1: SELECT * FROM CoachesByDefence;

![Figure 2 - Top 10 Defensive Coaches](Images/CoachesByDefence.png)

* Question 2: SELECT * FROM CoachesBy3PShooting;

![Figure 3 - Top 10 Coaches Relying on 3pt](Images/CoachesBy3PAttempt.png)

* Question 3: SELECT * FROM CoachesByAssist;

![Figure 4 - Top 10 Teams with Highest FGA](Images/Top10FGA.png)



#### Individual Level 

* Question 1: SELECT * FROM TopPPG;


![Figure 8 - Top Scorers per Game](Images/TopPPG.png)


* Question 2: SELECT * FROM TopTimeEfficient;


![Figure 9 - Top 10 Most Time Efficient Players](Images/TopTimeEfficient.png)

* Question 3: SELECT * FROM HalfSeason15Points;


![Figure 10 - PLayers that played Half Season or Less but Avearged at least 15 PPG ](Images/HalfSeason15Points.png)
