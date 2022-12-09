CREATE DATABASE  IF NOT EXISTS `nba_game_scores` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `nba_game_scores`;
-- MySQL dump 10.13  Distrib 8.0.30, for macos12 (x86_64)
--
-- Host: 127.0.0.1    Database: nba_game_scores
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach` (
  `coach_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`coach_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES (1,'Joe Mazzulla','1970-01-01'),(2,'Darvin Ham','1970-01-01'),(3,'Billy Donovan','1970-01-01');
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `game`
--

DROP TABLE IF EXISTS `game`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `game` (
  `date` date NOT NULL,
  `stadium` varchar(64) NOT NULL,
  `home_team_score` int NOT NULL,
  `away_team_score` int NOT NULL,
  PRIMARY KEY (`date`,`stadium`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `game`
--

LOCK TABLES `game` WRITE;
/*!40000 ALTER TABLE `game` DISABLE KEYS */;
INSERT INTO `game` VALUES ('2020-12-25','TD Garden',110,80),('2021-12-25','TD Garden',120,88),('2022-12-25','TD Garden',77,88);
/*!40000 ALTER TABLE `game` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `has`
--

DROP TABLE IF EXISTS `has`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `has` (
  `team_name` varchar(32) NOT NULL,
  `coach_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  PRIMARY KEY (`team_name`,`coach_id`),
  KEY `coach_id` (`coach_id`),
  CONSTRAINT `has_ibfk_1` FOREIGN KEY (`team_name`) REFERENCES `team` (`team_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `has_ibfk_2` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `has`
--

LOCK TABLES `has` WRITE;
/*!40000 ALTER TABLE `has` DISABLE KEYS */;
INSERT INTO `has` VALUES ('Bulls',3,'2020-01-01',NULL),('Celtics',1,'2020-01-01',NULL),('Lakers',2,'2020-01-01',NULL);
/*!40000 ALTER TABLE `has` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player`
--

DROP TABLE IF EXISTS `player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player` (
  `player_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`player_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player`
--

LOCK TABLES `player` WRITE;
/*!40000 ALTER TABLE `player` DISABLE KEYS */;
INSERT INTO `player` VALUES (1,'Jayson Tatum','1990-01-01'),(2,'Jaylen Brown','1990-01-01'),(3,'Blake Griffin','1990-01-01'),(4,'LeBron James','1990-01-01'),(5,'Lonzo Ball','1990-01-01');
/*!40000 ALTER TABLE `player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `player_game_stat`
--

DROP TABLE IF EXISTS `player_game_stat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `player_game_stat` (
  `date` date NOT NULL,
  `stadium` varchar(64) NOT NULL,
  `player_id` int NOT NULL,
  `minutes_played` int NOT NULL,
  `two_total` int DEFAULT NULL,
  `two_goal` int DEFAULT NULL,
  `three_total` int DEFAULT NULL,
  `three_goal` int DEFAULT NULL,
  `free_throw_total` int DEFAULT NULL,
  `free_throw_goal` int DEFAULT NULL,
  `rebounds` int DEFAULT NULL,
  `assists` int DEFAULT NULL,
  `blocks` int DEFAULT NULL,
  `steals` int DEFAULT NULL,
  PRIMARY KEY (`date`,`stadium`,`player_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `player_game_stat_ibfk_1` FOREIGN KEY (`date`, `stadium`) REFERENCES `game` (`date`, `stadium`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `player_game_stat_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `player_game_stat`
--

LOCK TABLES `player_game_stat` WRITE;
/*!40000 ALTER TABLE `player_game_stat` DISABLE KEYS */;
INSERT INTO `player_game_stat` VALUES ('2020-12-25','TD Garden',1,40,15,7,3,1,1,1,5,5,2,0),('2020-12-25','TD Garden',4,40,15,7,3,3,1,1,5,5,2,0);
/*!40000 ALTER TABLE `player_game_stat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plays`
--

DROP TABLE IF EXISTS `plays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plays` (
  `date` date NOT NULL,
  `stadium` varchar(64) NOT NULL,
  `player_id` int NOT NULL,
  PRIMARY KEY (`date`,`stadium`,`player_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `plays_ibfk_1` FOREIGN KEY (`date`, `stadium`) REFERENCES `game` (`date`, `stadium`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `plays_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plays`
--

LOCK TABLES `plays` WRITE;
/*!40000 ALTER TABLE `plays` DISABLE KEYS */;
INSERT INTO `plays` VALUES ('2020-12-25','TD Garden',1),('2021-12-25','TD Garden',1),('2022-12-25','TD Garden',1),('2020-12-25','TD Garden',2),('2021-12-25','TD Garden',2),('2022-12-25','TD Garden',2),('2020-12-25','TD Garden',3),('2021-12-25','TD Garden',3),('2022-12-25','TD Garden',3),('2020-12-25','TD Garden',4),('2021-12-25','TD Garden',4),('2022-12-25','TD Garden',5);
/*!40000 ALTER TABLE `plays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plays_for`
--

DROP TABLE IF EXISTS `plays_for`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plays_for` (
  `team_name` varchar(32) NOT NULL,
  `player_id` int NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `position` varchar(16) NOT NULL,
  PRIMARY KEY (`team_name`,`player_id`),
  KEY `player_id` (`player_id`),
  CONSTRAINT `plays_for_ibfk_1` FOREIGN KEY (`team_name`) REFERENCES `team` (`team_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `plays_for_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `player` (`player_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plays_for`
--

LOCK TABLES `plays_for` WRITE;
/*!40000 ALTER TABLE `plays_for` DISABLE KEYS */;
INSERT INTO `plays_for` VALUES ('Bulls',5,'2020-01-01',NULL,'PG'),('Celtics',1,'2020-01-01',NULL,'PF'),('Celtics',2,'2020-01-01',NULL,'SF'),('Celtics',3,'2020-01-01',NULL,'PF'),('Lakers',4,'2020-01-01',NULL,'PF');
/*!40000 ALTER TABLE `plays_for` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plays_in`
--

DROP TABLE IF EXISTS `plays_in`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plays_in` (
  `date` date NOT NULL,
  `stadium` varchar(64) NOT NULL,
  `team_name` varchar(32) NOT NULL,
  PRIMARY KEY (`date`,`stadium`,`team_name`),
  KEY `team_name` (`team_name`),
  CONSTRAINT `plays_in_ibfk_1` FOREIGN KEY (`date`, `stadium`) REFERENCES `game` (`date`, `stadium`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `plays_in_ibfk_2` FOREIGN KEY (`team_name`) REFERENCES `team` (`team_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plays_in`
--

LOCK TABLES `plays_in` WRITE;
/*!40000 ALTER TABLE `plays_in` DISABLE KEYS */;
INSERT INTO `plays_in` VALUES ('2022-12-25','TD Garden','Bulls'),('2020-12-25','TD Garden','Celtics'),('2021-12-25','TD Garden','Celtics'),('2022-12-25','TD Garden','Celtics'),('2020-12-25','TD Garden','Lakers'),('2021-12-25','TD Garden','Lakers');
/*!40000 ALTER TABLE `plays_in` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `plays_after_plays_in_insert` AFTER INSERT ON `plays_in` FOR EACH ROW BEGIN
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE temp_player_id INT DEFAULT 0;
	DECLARE players_in_game_cursor CURSOR FOR (SELECT player_id FROM plays_for WHERE team_name = NEW.team_name);
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    OPEN players_in_game_cursor;
    
    iterate_players: LOOP
    FETCH players_in_game_cursor INTO temp_player_id;
	IF finished = 1 THEN 
		LEAVE iterate_players;
	END IF;
	INSERT INTO plays(date, stadium, player_id) VALUE (NEW.date, NEW.stadium, temp_player_id);
    END LOOP iterate_players;
    
    CLOSE players_in_game_cursor;
   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `team` (
  `team_name` varchar(32) NOT NULL,
  `home_stadium` varchar(64) NOT NULL,
  `conference` varchar(16) NOT NULL,
  `conference_standing` int NOT NULL,
  PRIMARY KEY (`team_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `team`
--

LOCK TABLES `team` WRITE;
/*!40000 ALTER TABLE `team` DISABLE KEYS */;
INSERT INTO `team` VALUES ('Bulls','United Center','East',2),('Celtics','TD Garden','East',1),('Lakers','Crypto.com Arena','West',1);
/*!40000 ALTER TABLE `team` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `account_name` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`account_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('boston_basket_ball_da_best','12345678'),('eastern_watcher','12345679'),('huskies_champion','12345678'),('team_boston!','12345678'),('watching_east','12345678');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watches`
--

DROP TABLE IF EXISTS `watches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watches` (
  `account_name` varchar(64) NOT NULL,
  `team_name` varchar(32) NOT NULL,
  PRIMARY KEY (`account_name`,`team_name`),
  KEY `team_name` (`team_name`),
  CONSTRAINT `watches_ibfk_1` FOREIGN KEY (`account_name`) REFERENCES `user` (`account_name`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `watches_ibfk_2` FOREIGN KEY (`team_name`) REFERENCES `team` (`team_name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watches`
--

LOCK TABLES `watches` WRITE;
/*!40000 ALTER TABLE `watches` DISABLE KEYS */;
INSERT INTO `watches` VALUES ('boston_basket_ball_da_best','Celtics'),('team_boston!','Celtics'),('team_boston!','Lakers');
/*!40000 ALTER TABLE `watches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'nba_game_scores'
--

--
-- Dumping routines for database 'nba_game_scores'
--
/*!50003 DROP FUNCTION IF EXISTS `current_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `current_team`(input_player_id INT) RETURNS varchar(32) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE current_team VARCHAR(32);
    
    SELECT team_name
    INTO current_team
    FROM plays_for
    WHERE player_id  = input_player_id;

    RETURN current_team;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `games_by_team` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `games_by_team`(input_team_name VARCHAR(32)) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE games_count INT;
    
    SELECT COUNT(*)
    INTO games_count
    FROM plays_in
    WHERE team_name = input_team_name;

    RETURN games_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `team_conf_standing` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `team_conf_standing`(input_team_name VARCHAR(32)) RETURNS varchar(64) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE conf_standing INT;
	DECLARE conf_div VARCHAR(64);

    SELECT conference_standing
    INTO conf_standing
    FROM team
    WHERE team_name = input_team_name;

    SELECT conference
    INTO conf_div
    FROM team
    WHERE team_name = input_team_name;

    RETURN CONCAT(conf_div, ' ', conf_standing);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `team_head_coach` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `team_head_coach`(input_team_name VARCHAR(32)) RETURNS varchar(64) CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
	DECLARE head_coach_name VARCHAR(64);
    
    SELECT coach_id
    INTO head_coach_name
    FROM has AS h
    NATURAL JOIN coach AS c
    WHERE h.team_name = input_team_name
    AND h.end_date IS NULL;

    RETURN head_coach_name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `all_games` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `all_games`(input_team_name VARCHAR(32))
BEGIN
	SELECT *
    FROM game
    WHERE (date, stadium) IN (
		SELECT date, stadium
		FROM plays_in AS pi
		WHERE pi.team_name = input_team_name);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_game`(
    IN date DATE,
    IN home_team_name VARCHAR(32),
    IN away_team_name VARCHAR(32),
    IN home_team_score INT,
    IN away_team_score INT
)
this_proc:BEGIN
	DECLARE game_stadium VARCHAR(64);

	-- Validates required args are present.
	IF date IS NULL OR home_team_name IS NULL OR away_team_name IS NULL OR home_team_score IS NULL OR away_team_score IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;
    
    -- Validates the stadium name used.
    IF NOT EXISTS (SELECT * FROM team WHERE team_name IN (home_team_name, away_team_name))
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 team name does not match any known teams.';
    LEAVE this_proc;
    END IF;
    
    SET game_stadium = (SELECT home_stadium FROM team WHERE team_name = home_team_name);

    INSERT INTO game (date, stadium, home_team_score, away_team_score)
    VALUES (date, game_stadium, home_team_score, away_team_score);
    
    INSERT INTO plays_in (date, stadium, team_name)
    VALUES (date, game_stadium, home_team_name);

    INSERT INTO plays_in (date, stadium, team_name)
    VALUES (date, game_stadium, away_team_name);

    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_player_game_stat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_player_game_stat`(
    date DATE,
    stadium VARCHAR(64),
    player_id INT,
    minutes_played INT,
    two_total INT,
    two_goal INT,
    three_total INT,
    three_goal INT,
    free_throw_total INT,
    free_throw_goal INT,
    rebounds INT,
    assists INT,
    blocks INT,
    steals INT
)
this_proc:BEGIN
	-- Validates required args are present.
	IF date IS NULL OR stadium IS NULL OR player_id IS NULL OR minutes_played IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;

    -- Validates the game PK used.
    IF NOT EXISTS (SELECT * FROM game WHERE stadium = stadium AND date = date)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stadium and date do not match any known game.';
    LEAVE this_proc;
    END IF;

    -- Validates the player PK used.
    IF NOT EXISTS (SELECT * FROM player WHERE player_id = player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Player ID does not match any known players.';
    LEAVE this_proc;
    END IF;

    INSERT INTO player_game_stat (date, stadium, player_id, minutes_played, two_total, two_goal, three_total, three_goal, free_throw_total, free_throw_goal, rebounds, assists, blocks, steals)
    VALUES (date, stadium, player_id, minutes_played, two_total, two_goal, three_total, three_goal, free_throw_total, free_throw_goal, rebounds, assists, blocks, steals);

    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_user`(IN new_account_name VARCHAR(64), IN new_password VARCHAR(64))
this_proc:BEGIN
	-- Validates required args are present.
	IF new_account_name IS NULL OR new_password IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    END IF;

	INSERT INTO user (account_name, password)
    VALUES (new_account_name, new_password);
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_game`(IN existing_date DATE, IN existing_stadium VARCHAR(64))
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates the primary keys are in the database.
	ELSEIF NOT EXISTS (SELECT * FROM game WHERE date = existing_date AND stadium = existing_stadium)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date-stadium value pair non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM game
    WHERE date = existing_date AND stadium = existing_stadium;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_player_game_stat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_player_game_stat`(IN existing_date DATE, IN existing_stadium VARCHAR(64), IN existing_player_id INT)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR existing_player_id IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    
	-- Validates the primary keys are in the database.
	ELSEIF NOT EXISTS (SELECT * FROM player_game_stat WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PK value pair non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM player_game_stat
    WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_user`(IN existing_account_name VARCHAR(64))
this_proc:BEGIN
	IF existing_account_name IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates the account name is in the database.
	ELSEIF NOT EXISTS (SELECT * FROM user WHERE account_name = existing_account_name)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account name non-existent.';
    LEAVE this_proc;
    END IF;

	DELETE FROM user
    WHERE account_name = existing_account_name;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `player_game_avg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `player_game_avg`(input_player_id INT)
BEGIN
	SELECT AVG(minutes_played), AVG(two_total), AVG(two_goal), AVG(three_total)
    , AVG(three_goal), AVG(free_throw_total), AVG(free_throw_goal), AVG(rebounds)
    , AVG(assists), AVG(blocks), AVG(steals)
    FROM player_game_stat
    WHERE player_id = input_player_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_game` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_game`(
	IN existing_date DATE,
    IN existing_stadium VARCHAR(64),
	IN new_date DATE,
    IN new_stadium VARCHAR(64),
    IN new_home_team_score INT,
    IN new_away_team_score INT
)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR new_date IS NULL OR new_stadium IS NULL OR new_home_team_score IS NULL OR new_away_team_score IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates new PK is either unchanged or some unique new value.
	ELSEIF (existing_date != new_date OR existing_stadium != new_stadium) AND EXISTS (SELECT * FROM game WHERE date = new_date AND stadium = new_stadium)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New date and stadium value pair must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE game
    SET date = new_date, stadium = new_stadium, home_team_score = new_home_team_score, away_team_score = new_away_team_score
    WHERE date = existing_date AND stadium = existing_stadium;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_player_game_stat` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_player_game_stat`(
	existing_date DATE,
    existing_stadium VARCHAR(64),
    existing_player_id INT,
    new_date DATE,
    new_stadium VARCHAR(64),
    new_player_id INT,
    new_minutes_played INT,
    new_two_total INT,
    new_two_goal INT,
    new_three_total INT,
    new_three_goal INT,
    new_free_throw_total INT,
    new_free_throw_goal INT,
    new_rebounds INT,
    new_assists INT,
    new_blocks INT,
    new_steals INT
)
this_proc:BEGIN
	IF existing_date IS NULL OR existing_stadium IS NULL OR existing_player_id IS NULL OR new_date IS NULL OR new_stadium IS NULL OR new_player_id IS NULL
    OR new_minutes_played IS NULL OR new_two_total IS NULL OR new_two_goal IS NULL OR new_three_total IS NULL OR new_free_throw_total IS NULL OR new_free_throw_goal IS NULL
    OR new_rebounds IS NULL OR new_assists IS NULL OR new_blocks IS NULL OR new_steals IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
    
	-- Validates new PK is either unchanged or some unique new value.
	ELSEIF (existing_date != new_date OR existing_stadium != new_stadium OR existing_player_id != new_player_id)
    AND EXISTS (SELECT * FROM player_game_stat WHERE date = new_date AND stadium = new_stadium AND player_id = new_player_id)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New PK value pair must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE player_game_stat
    SET date = new_date, stadium = new_stadium, player_id = new_player_id, minutes_played = new_minutes_played, two_total = new_two_total,
	two_goal = new_two_goal, three_total = new_three_total, three_goal = new_three_goal, free_throw_total = new_free_throw_total, free_throw_goal = new_free_throw_goal,
	rebounds = new_rebounds, assists = new_assists, blocks = new_blocks, steals = new_steals
    WHERE date = existing_date AND stadium = existing_stadium AND player_id = existing_player_id;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_user`(IN existing_account_name VARCHAR(64), IN new_account_name VARCHAR(64), IN new_password VARCHAR(64))
this_proc:BEGIN
	IF existing_account_name IS NULL OR new_account_name IS NULL OR new_password IS NULL
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'At least 1 required arg is missing.';
    LEAVE this_proc;
	-- Validates new account name is either unchanged or some unique new value.
	ELSEIF existing_account_name != new_account_name AND EXISTS (SELECT * FROM user WHERE account_name = new_account_name)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New account name must be unique.';
    LEAVE this_proc;
    END IF;

	UPDATE user
    SET account_name = new_account_name, password = new_password
    WHERE account_name = existing_account_name;
    
    SELECT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-12-09 15:32:59
