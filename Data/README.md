## Data

The directory contains the data used for the project in csv format. It includes the following six tables: 

* Coaches
* Player_Stats
* Players 
* Team_Stats 
* Teams

The aforementioned tables servea as a base for the Operational Layer described below. 

### Operational Layer 

The layer data includes of National Basketball Association (NBA) statistics for players, teams and coaches for 2017-2018 season. CSV files were used to to store the raw date. Then a schema and tables was created with the same attributes as the CSV files. Finally, the data was inserted into MySQL using the following command 

LOAD DATA 
LOCAL INFILE 'path_to_csv_file'
INTO TABLE 'corresponding_table'
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES 
