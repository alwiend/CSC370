/*
 *	ALwien Dippenaar
 *	V00849850
 *	CSC 370 Assignment 3 
 */

/******************************* Exercise 1 *******************************/

/* Question 1 */
-- Create simple SQL statements to create the above relations 
-- (no constraints for initial creations).
CREATE TABLE Classes(shpclass VARCHAR(30),
					 shptype VARCHAR(3),
					 country VARCHAR(30),
					 numGuns INT,
					 bore INT,
					 displacement INT) ;
			
CREATE TABLE Ships(shpname VARCHAR(20),
				   shpclass VARCHAR(30),
				   launched INT) ;
				   
CREATE TABLE Battles(btlname VARCHAR(20),
					 btldate_fought DATE) ;
					 
CREATE TABLE Outcomes(shpname VARCHAR(30),
					  btlname VARCHAR(30),
					  btlresult VARCHAR(20)) ;

/* Question 2 */
-- Insert the following data. 
INSERT INTO Classes VALUES('Bismarck','bb','Germany',8,15,42000) ;
INSERT INTO Classes VALUES('Kongo','bc','Japan',8,14,32000) ;
INSERT INTO Classes VALUES('North Carolina','bb','USA',9,16,37000) ;
INSERT INTO Classes VALUES('Renown','bc','Gt. Britain',6,15,32000) ;
INSERT INTO Classes VALUES('Revenge','bb','Gt. Britain',8,15,29000) ;
INSERT INTO Classes VALUES('Tennessee','bb','USA',12,14,32000) ;
INSERT INTO Classes VALUES('Yamato','bb','Japan',9,18,65000) ;

INSERT INTO Ships VALUES('California','Tennessee',1921) ;
INSERT INTO Ships VALUES('Haruna','Kongo',1915) ;
INSERT INTO Ships VALUES('Hiei','Kongo',1914) ;
INSERT INTO Ships VALUES('Iowa','Iowa',1943) ;
INSERT INTO Ships VALUES('Kirishima','Kongo',1914) ;
INSERT INTO Ships VALUES('Kongo','Kongo',1913) ;
INSERT INTO Ships VALUES('Missouri','Iowa',1944) ;
INSERT INTO Ships VALUES('Musashi','Yamato',1942) ;
INSERT INTO Ships VALUES('New Jersey','Iowa',1943) ;
INSERT INTO Ships VALUES('North Carolina','North Carolina',1941) ;
INSERT INTO Ships VALUES('Ramilles','Revenge',1917) ;
INSERT INTO Ships VALUES('Renown','Renown',1916) ;
INSERT INTO Ships VALUES('Repulse','Renown',1916) ;
INSERT INTO Ships VALUES('Resolution','Revenge',1916) ;
INSERT INTO Ships VALUES('Revenge','Revenge',1916) ;
INSERT INTO Ships VALUES('Royal Oak','Revenge',1916) ;
INSERT INTO Ships VALUES('Royal Sovereign','Revenge',1916) ;
INSERT INTO Ships VALUES('Tennessee','Tennessee',1920) ;
INSERT INTO Ships VALUES('Washington','North Carolina',1941) ;
INSERT INTO Ships VALUES('Wisconsin','Iowa',1944) ;
INSERT INTO Ships VALUES('Yamato','Yamato',1941) ;

INSERT INTO Battles VALUES('North Atlantic','27-May-1941') ;
INSERT INTO Battles VALUES('Guadalcanal','15-Nov-1942') ;
INSERT INTO Battles VALUES('North Cape','26-Dec-1943') ;
INSERT INTO Battles VALUES('Surigao Strait','25-Oct-1944') ;

INSERT INTO Outcomes VALUES('Bismarck','North Atlantic', 'sunk') ;
INSERT INTO Outcomes VALUES('California','Surigao Strait', 'ok') ;
INSERT INTO Outcomes VALUES('Duke of York','North Cape', 'ok') ;
INSERT INTO Outcomes VALUES('Fuso','Surigao Strait', 'sunk') ;
INSERT INTO Outcomes VALUES('Hood','North Atlantic', 'sunk') ;
INSERT INTO Outcomes VALUES('King George V','North Atlantic', 'ok') ;
INSERT INTO Outcomes VALUES('Kirishima','Guadalcanal', 'sunk') ;
INSERT INTO Outcomes VALUES('Prince of Wales','North Atlantic', 'damaged') ;
INSERT INTO Outcomes VALUES('Rodney','North Atlantic', 'ok') ;
INSERT INTO Outcomes VALUES('Scharnhorst','North Cape', 'sunk') ;
INSERT INTO Outcomes VALUES('South Dakota','Guadalcanal', 'ok') ;
INSERT INTO Outcomes VALUES('West Virginia','Surigao Strait', 'ok') ;
INSERT INTO Outcomes VALUES('Yamashiro','Surigao Strait', 'sunk') ;

/**************************************************************************/

/******************************* Exercise 2 *******************************/
					 
/* Question 1 */
-- The treaty of Washington in 1921 prohibited capital ships heavier than 35,000 tons. 
-- List the ships that violated the treaty of Washington.
SELECT shpname AS Name
FROM Classes JOIN Ships 
USING(shpclass)
WHERE launched >= 1921 AND displacement >= 35000 ;

/* Question 2 */
-- List the name, displacement, and number of guns of the ships engaged in the battle of Guadalcanal.
SELECT o.shpname, X.displacement, X.numguns
FROM (SELECT shpname, displacement, numguns
	  FROM Classes JOIN Ships
	  USING(shpclass)) X
FULL OUTER JOIN outcomes o
ON o.shpname = X.shpname
WHERE btlname = 'Guadalcanal' ;

/* Question 3 */
-- List all the capital ships mentioned in the database. 
-- (Remember that not all ships appear in the Ships relation.)
SELECT CONCAT(s.shpname, o.shpname)
FROM Ships s FULL OUTER JOIN Outcomes o
ON o.shpname = s.shpname ;

/* Question 4 */
-- Find those countries that had both battleships and battlecruisers.
SELECT X.Country
FROM (SELECT Country
	  FROM Classes 
	  WHERE shptype = 'bb') X
INNER JOIN
	 (SELECT Country
	  FROM Classes
	  WHERE shptype = 'bc') Y
ON X.Country = Y.Country ;

/* Question 5 */
-- Find those ships that "lived to fight another day"; they were damaged in one battle, but later fought in another.
SELECT X.shpname
FROM (SELECT shpname
	  FROM Outcomes 
	  WHERE btlresult = 'damaged') X
INNER JOIN
	 (SELECT shpname
	  FROM Outcomes
	  WHERE btlresult = 'sunk' OR btlresult = 'ok') Y
ON X.shpname = Y.shpname ;

/* Question 6 */
-- Find the countries whose ships had the largest number of guns. 
SELECT Country
FROM Classes
WHERE numguns = (SELECT MAX(numguns)
			  	 FROM Classes) ;

/* Question 7 */
-- Find the names of the ships whose number of guns was the largest for those ships of the same bore
CREATE VIEW X AS
SELECT bore, numguns, shpname
FROM Classes JOIN Ships
USING(shpclass) ;

SELECT DISTINCT bore, X1.shpname
FROM X X1 JOIN X X2
USING(bore)
WHERE X1.shpname <> X2.shpname AND X1.numguns >= X2.numguns 
FETCH FIRST 4 ROWS ONLY;

/* Question 8 */
-- Find for each class with at least three ships the number of ships of that class sunk in battle. 
SELECT shpclass, COUNT(btlresult) AS btlresult
FROM (SELECT *
	  FROM Classes FULL JOIN Ships
	  USING(shpclass))
FULL JOIN Outcomes
USING(shpname)
GROUP BY shpclass
HAVING COUNT(shpname) >= 3 AND shpclass IS NOT NULL;

/**************************************************************************/

/******************************* Exercise 3 *******************************/

/* Question 1 */
-- Two of the three battleships of the Italian Vittorio Veneto class – Vittorio Veneto and Italia – were launched in 1940; 
-- the third ship of that class, Roma, was launched in 1942. Each had 15-inch guns and a displacement of 41,000 tons.
-- Insert these facts into the database.
INSERT INTO Classes VALUES('Vittorio Veneto', 'bb', 'Italy', NULL, 15, 41000) ;
INSERT INTO Ships VALUES('Vittorio Veneto', 'Vittorio Veneto', 1940) ;
INSERT INTO Ships VALUES('Italia', 'Vittorio Veneto', 1940) ;
INSERT INTO Ships VALUES('Roma', 'Vittorio Veneto', 1942) ;

/* Question 2 */
-- Delete all classes with fewer than three ships.
DELETE FROM Classes
WHERE C.shpclass IN (SELECT shpclass
						   FROM Classes FULL JOIN Ships 
				  		   USING(shpclass) 
				  		   GROUP BY shpclass 
				 		   HAVING COUNT(shpclass) < 3) ;
 		  
DELETE FROM Ships
WHERE Ships.shpclass IN (SELECT shpclass
						   FROM Classes FULL JOIN Ships 
				  		   USING(shpclass) 
				  		   GROUP BY shpclass 
				 		   HAVING COUNT(shpclass) < 3) ;

/* Question 3 */
-- Modify the Classes relation so that gun bores are measured in centimeters (one inch = 2.5 cm) 
-- and displacements are measured in metric tons (one metric ton = 1.1 ton).
UPDATE Classes 
SET bore = bore * 2.5, displacement = displacement * 1.1 ;

/**************************************************************************/

/******************************* Exercise 4 *******************************/
/* Question 1 */
-- Every class mentioned in Ships must be mentioned in Classes.
ALTER TABLE Classes
ADD CONSTRAINT PK_Classes PRIMARY KEY (shpclass) ; 

CREATE TABLE Exceptions(row_id ROWID,
						owner VARCHAR2(30),
						table_name VARCHAR2(30),
						constraint VARCHAR2(30)
);

-- This one will fail 
ALTER TABLE Ships
ADD CONSTRAINT FK_Ships FOREIGN KEY (shpclass) REFERENCES Classes(shpclass) 
EXCEPTIONS INTO Exceptions ;

DELETE FROM Ships
WHERE shpclass IN (SELECT shpclass
				FROM Ships, Exceptions
				WHERE Ships.rowid = Exceptions.row_id) ;

ALTER TABLE Ships
ADD CONSTRAINT FK_Ships FOREIGN KEY (shpclass) REFERENCES Classes(shpclass) ;

/* Question 2 */
-- Every battle mentioned in Outcomes must be mentioned in Battles.
ALTER TABLE Battles
ADD CONSTRAINT PK_Battles PRIMARY KEY (btlname) ;

ALTER TABLE Outcomes
ADD CONSTRAINT FK_Outcomes FOREIGN KEY (btlname) REFERENCES Battles(btlname) ;

/* Question 3 */
-- Every ship mentioned in Outcomes must be mentioned in Ships.
DELETE FROM Exceptions ;

ALTER TABLE Ships
ADD CONSTRAINT PK_Ships PRIMARY KEY (shpname) ;

-- Will fail
ALTER TABLE Outcomes
ADD CONSTRAINT FK2_Outcomes FOREIGN KEY (shpname) REFERENCES Ships(shpname) 
EXCEPTIONS INTO Exceptions ;

DELETE FROM Outcomes
WHERE shpname IN (SELECT shpname
				  FROM Outcomes, Exceptions
				  WHERE Outcomes.rowid = Exceptions.row_id) ;

ALTER TABLE Outcomes
ADD CONSTRAINT FK2_Outcomes FOREIGN KEY (shpname) REFERENCES Ships(shpname) ;

/* Question 4 */
-- No class of ships may have guns with larger than 16-inch bore.
DELETE FROM Outcomes
WHERE shpname IN (SELECT shpname
			   	  FROM Classes JOIN Ships 
			      USING(shpclass)
			      WHERE Classes.bore > 16) ;

DELETE FROM Ships
WHERE shpname IN (SELECT shpname
			      FROM Classes
			      WHERE bore > 16) ;
			  
DELETE FROM Classes
WHERE bore > 16 ;

ALTER TABLE Classes
ADD CONSTRAINT bore_size 
CHECK (bore <= 16) ;

/* Question 5 */
-- If a class of ships has more than 9 guns, then their bore must be no larger than 14 inches.
ALTER TABLE Classes
ADD CONSTRAINT numguns_bore CHECK (numguns > 9 AND bore <= 14) ;

/* Question 6 */
-- No ship can be in battle before it is launched.
CREATE VIEW launcheddate AS
SELECT launched, btlname
FROM Ships s JOIN Outcomes O
USING(shpname) ; 

ALTER TABLE Battles
ADD CONSTRAINT bdate_slaunched CHECK(launcheddate.btlname = btlname AND launcheddate.launched >= YEAR(btldate_fought)) ;

/* Question 7 */
-- No ship can be launched before the ship that bears the name of the first ship’s class.
CREATE VIEW launchname AS
SELECT shpclass, shpname, launched
FROM Ships FULL JOIN Classes
USING(shpclass)
WHERE shpclass = shpname ;

ALTER TABLE Ships
ADD CONSTRAINT name_launched Check(launchname.shpclass = shpclass AND launchname.shpname <> shpname AND launchname.launched <= launched) ;

/* Question 8 */
-- No ship fought in a battle that was at a later date than another battle in which that ship was sunk. 
CREATE VIEW shipsunk AS 
SELECT *
FROM Outcomes JOIN Battles
USING(btlname)
WHERE btlresult = 'sunk' ;

ALTER TABLE Outcomes
ADD CONSTRAINT battleresult CHECK(shipsunk.shpname <> shpname AND shipsunk.btlname <> btlname) ;

/**************************************************************************/
