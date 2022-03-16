SELECT *

FROM Health_Data_Project..Health_Data;



--Select data we will be using
SELECT Indicator_Category, Indicator, Year, Gender, Race_Ethnicity, Value, Place
FROM Health_Data_Project..Health_Data
ORDER BY 3,7;

--Years are messy for 14 columns including multiple years, only for life expectancy however...

--Checking on indicator category if this is odd data
SELECT Indicator_Category, Indicator, Year, Gender, Race_Ethnicity, Value, Place
FROM Health_Data_Project..Health_Data
ORDER BY 3;

--Checking unique values in year

SELECT DISTINCT Year
FROM Health_Data_Project..Health_Data;

--Subsetting data to only include the years between 2010-2015 in future




--Moving onto looking at the values by indicator
SELECT Indicator, Value, Year, Gender, Race_Ethnicity

FROM Health_Data_Project..Health_Data


SELECT Indicator, Value, Year, Gender, Race_Ethnicity

FROM Health_Data_Project..Health_Data

WHERE Indicator = N'Percent of Adults Who Are Obese'

ORDER BY YEAR, Value;

--Not sure why N has to be before the string in the where statement (NVARCHAR data type maybe?)
--Also seems there are  rows with data that contain odd year data 2011-2012.. 

--Checking location of odd year

SELECT Year, Indicator, Place
FROM Health_Data_Project..Health_Data
WHERE Indicator = N'Percent of Adults Who Are Obese'

--Odd year is in U.S. Total, can either use this alone or remove to avoid double count

--Possibly check other areas of interest for this project to avoid double count on KPI

SELECT COUNT(DISTINCT Place) AS Num_Places

FROM Health_Data_Project..Health_Data

SELECT DISTINCT Place
FROM Health_Data_Project..Health_Data

SELECT Place, Year, Indicator, Gender, Race_Ethnicity, Value
FROM Health_Data_Project..Health_Data
ORDER BY Place

SELECT Place, Year, Indicator, Value, Gender, Race_Ethnicity
FROM Health_Data_Project..Health_Data
WHERE Place = N'Cleveland, OH'

SELECT DISTINCT YEAR, Place
FROM Health_Data_Project..Health_Data

WHERE Place = N'Cleveland, OH'

--Cleveland only has data for years 2010-2014... This will work for now


--Making Cleveland Dataset

SELECT Place, Year, Indicator, Cast(Value as float) as Value, Gender, Race_Ethnicity
FROM Health_Data_Project..Health_Data
WHERE Place = N'Cleveland, OH'


-- Making Dataset where Year is 2010-2014

SELECT Place, Year, Indicator, Cast(Value as float) as Value, Gender, Race_Ethnicity
FROM Health_Data_Project..Health_Data
WHERE Year LIKE '201%';
--On right track...


SELECT COUNT(DISTINCT Year)
FROM Health_Data_Project..Health_Data
WHERE Year LIKE '201%';

--Too many unique year values...
--Have to hard code data set...

SELECT Place, Year, Indicator, Cast(Value as float) as Value, Gender, Race_Ethnicity
FROM Health_Data_Project..Health_Data
WHERE Year = '2010' OR Year = '2011' OR Year = '2012' OR Year = '2013' OR Year = '2014'
--Quick Check for nulls...



--SELECT COUNT(*) AS n
--FROM Health_Data_Project..Health_Data
--WHERE Race_Ethnicity IS NULL;
--Value had 13 Nulls...

CREATE VIEW Health_Data_2010_2014 as 
SELECT Place, Year, Indicator, Cast(Value as float) as Value, Gender, Race_Ethnicity
FROM Health_Data_Project..Health_Data
WHERE Year = '2010' OR Year = '2011' OR Year = '2012' OR Year = '2013' OR Year = '2014';