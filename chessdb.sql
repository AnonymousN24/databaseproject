-- MySQL dump 10.13  Distrib 8.0.39, for Linux (x86_64)
--
-- Host: localhost    Database: chess_tournaments
-- ------------------------------------------------------
-- Server version	8.0.39-0ubuntu0.24.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Candidates_Tournament`
--

DROP TABLE IF EXISTS `Candidates_Tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Candidates_Tournament` (
  `TournamentID` int unsigned NOT NULL,
  `NumParticipants` tinyint unsigned DEFAULT NULL,
  `CityID` int unsigned DEFAULT NULL,
  `Prize` varchar(255) DEFAULT NULL,
  `Commentator` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TournamentID`),
  KEY `CityID` (`CityID`),
  CONSTRAINT `Candidates_Tournament_ibfk_1` FOREIGN KEY (`CityID`) REFERENCES `City` (`ID`),
  CONSTRAINT `Candidates_Tournament_ibfk_2` FOREIGN KEY (`TournamentID`) REFERENCES `Tournament` (`TournamentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Candidates_Tournament`
--

LOCK TABLES `Candidates_Tournament` WRITE;
/*!40000 ALTER TABLE `Candidates_Tournament` DISABLE KEYS */;
INSERT INTO `Candidates_Tournament` VALUES (1,8,1,'€500,000','Viswanathan Anand'),(4,8,10,'€500,000','Fabiano Caruana');
/*!40000 ALTER TABLE `Candidates_Tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `City`
--

DROP TABLE IF EXISTS `City`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `City` (
  `ID` int unsigned NOT NULL,
  `NAME` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `City`
--

LOCK TABLES `City` WRITE;
/*!40000 ALTER TABLE `City` DISABLE KEYS */;
INSERT INTO `City` VALUES (1,'Toronto, Canada'),(2,'Chennai, India'),(3,'Wenzhou, China'),(4,'Berlin, Germany'),(5,'Paris, France'),(6,'London, England'),(7,'Singapore, Singapore'),(8,'Dubai, UAE'),(9,'Tonsberg, Norway'),(10,'Madrid, Spain'),(11,'Bryansk, Russia');
/*!40000 ALTER TABLE `City` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Game_Time`
--

DROP TABLE IF EXISTS `Game_Time`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Game_Time` (
  `ID` int unsigned NOT NULL,
  `Minutes` smallint unsigned DEFAULT NULL,
  `Increment` smallint unsigned DEFAULT NULL,
  `TournamentID` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `TournamentID` (`TournamentID`),
  CONSTRAINT `Game_Time_ibfk_1` FOREIGN KEY (`TournamentID`) REFERENCES `Tournament` (`TournamentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Game_Time`
--

LOCK TABLES `Game_Time` WRITE;
/*!40000 ALTER TABLE `Game_Time` DISABLE KEYS */;
INSERT INTO `Game_Time` VALUES (1,120,30,1),(2,180,30,2);
/*!40000 ALTER TABLE `Game_Time` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Player`
--

DROP TABLE IF EXISTS `Player`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Player` (
  `ID` int unsigned NOT NULL AUTO_INCREMENT,
  `Rating` smallint unsigned DEFAULT NULL,
  `Title` char(2) DEFAULT NULL,
  `Name` varchar(80) DEFAULT NULL,
  `CityID` int unsigned DEFAULT NULL,
  PRIMARY KEY (`ID`),
  KEY `CityID` (`CityID`),
  CONSTRAINT `Player_ibfk_1` FOREIGN KEY (`CityID`) REFERENCES `City` (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Player`
--

LOCK TABLES `Player` WRITE;
/*!40000 ALTER TABLE `Player` DISABLE KEYS */;
INSERT INTO `Player` VALUES (1,2794,'GM','Gukesh Dommaraju',2),(2,2789,'GM','Ding Liren',3),(3,2856,'GM','Magnus Carlsen',9),(4,2856,'GM','Ian Nepomniatchi',11),(25,2400,'IM','Cool',2);
/*!40000 ALTER TABLE `Player` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PlayerTournament`
--

DROP TABLE IF EXISTS `PlayerTournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PlayerTournament` (
  `PlayerID` int unsigned NOT NULL,
  `TournamentID` int unsigned NOT NULL,
  PRIMARY KEY (`PlayerID`,`TournamentID`),
  KEY `fk_tournament` (`TournamentID`),
  CONSTRAINT `fk_player` FOREIGN KEY (`PlayerID`) REFERENCES `Player` (`ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_tournament` FOREIGN KEY (`TournamentID`) REFERENCES `Tournament` (`TournamentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PlayerTournament`
--

LOCK TABLES `PlayerTournament` WRITE;
/*!40000 ALTER TABLE `PlayerTournament` DISABLE KEYS */;
INSERT INTO `PlayerTournament` VALUES (1,1),(2,1),(1,2),(2,2),(1,3),(3,3),(4,3);
/*!40000 ALTER TABLE `PlayerTournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tournament`
--

DROP TABLE IF EXISTS `Tournament`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tournament` (
  `TournamentID` int unsigned NOT NULL,
  `Type` varchar(60) DEFAULT NULL,
  `NumParticipants` smallint unsigned DEFAULT NULL,
  `CityID` int unsigned DEFAULT NULL,
  `Commentator` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TournamentID`),
  KEY `CityID` (`CityID`),
  CONSTRAINT `Tournament_ibfk_1` FOREIGN KEY (`CityID`) REFERENCES `City` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tournament`
--

LOCK TABLES `Tournament` WRITE;
/*!40000 ALTER TABLE `Tournament` DISABLE KEYS */;
INSERT INTO `Tournament` VALUES (1,'Candidates Tournament 2022',8,1,'Viswanathan Anand'),(2,'World Championship 2023',2,7,NULL),(3,'World Championship 2021',2,8,'Fabiano Caruana'),(4,'Candidates Tournament 2021',8,10,'Fabiano Caruana');
/*!40000 ALTER TABLE `Tournament` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `World_Championship`
--

DROP TABLE IF EXISTS `World_Championship`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `World_Championship` (
  `TournamentID` int unsigned NOT NULL,
  `Prize` varchar(255) DEFAULT NULL,
  `CityID` int unsigned DEFAULT NULL,
  `Commentator` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TournamentID`),
  KEY `CityID` (`CityID`),
  CONSTRAINT `World_Championship_ibfk_1` FOREIGN KEY (`TournamentID`) REFERENCES `Tournament` (`TournamentID`),
  CONSTRAINT `World_Championship_ibfk_2` FOREIGN KEY (`CityID`) REFERENCES `City` (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `World_Championship`
--

LOCK TABLES `World_Championship` WRITE;
/*!40000 ALTER TABLE `World_Championship` DISABLE KEYS */;
INSERT INTO `World_Championship` VALUES (2,NULL,7,NULL),(3,'£2,500,000',8,'Fabiano Caruana');
/*!40000 ALTER TABLE `World_Championship` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-11-20 16:46:35
