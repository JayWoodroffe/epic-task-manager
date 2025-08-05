-- MySQL dump 10.13  Distrib 8.0.35, for Win64 (x86_64)
--
-- Host: localhost    Database: kanban_db
-- ------------------------------------------------------
-- Server version	8.0.35

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
-- Table structure for table `board`
--

DROP TABLE IF EXISTS `board`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `board` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `CreatedById` int NOT NULL,
  `CreatedOn` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `Name` varchar(255) NOT NULL,
  `Description` text,
  PRIMARY KEY (`Id`),
  KEY `CreatedById` (`CreatedById`),
  KEY `UpdatedById` (`UpdatedById`),
  CONSTRAINT `board_ibfk_1` FOREIGN KEY (`CreatedById`) REFERENCES `siteuser` (`Id`),
  CONSTRAINT `board_ibfk_2` FOREIGN KEY (`UpdatedById`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `board`
--

LOCK TABLES `board` WRITE;
/*!40000 ALTER TABLE `board` DISABLE KEYS */;
INSERT INTO `board` VALUES (1,'2e477bc4-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:04:46',1,'2025-08-04 10:28:06',1,'User interface','This is a board description.'),(2,'2e47f797-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:04:46',NULL,NULL,1,'Research','We need to adequately research the topics related to this project.'),(3,'2e47fac7-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:04:46',NULL,NULL,1,'Deployment',''),(7,'421d5fa2-0188-45f1-b1af-961f5283ca7f',1,'2025-08-02 20:56:27',NULL,NULL,0,'new',''),(8,'3976b3e1-e1a6-4098-a0a5-45aa0bc8062c',1,'2025-08-02 21:05:10',NULL,NULL,1,'extra new board','for an extra new project'),(9,'a8e005b6-1bf8-4346-b830-2d3baa7f047f',1,'2025-08-02 21:06:20',NULL,NULL,1,'super new board','new description too!');
/*!40000 ALTER TABLE `board` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `list`
--

DROP TABLE IF EXISTS `list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `list` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `CreatedById` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `name` varchar(255) NOT NULL,
  `BoardId` int NOT NULL,
  `StatusId` int NOT NULL,
  `Position` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `BoardId` (`BoardId`),
  KEY `StatusId` (`StatusId`),
  KEY `CreatedById` (`CreatedById`),
  KEY `UpdatedById` (`UpdatedById`),
  CONSTRAINT `list_ibfk_1` FOREIGN KEY (`BoardId`) REFERENCES `board` (`Id`),
  CONSTRAINT `list_ibfk_2` FOREIGN KEY (`StatusId`) REFERENCES `status` (`Id`),
  CONSTRAINT `list_ibfk_3` FOREIGN KEY (`CreatedById`) REFERENCES `siteuser` (`Id`),
  CONSTRAINT `list_ibfk_4` FOREIGN KEY (`UpdatedById`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `list`
--

LOCK TABLES `list` WRITE;
/*!40000 ALTER TABLE `list` DISABLE KEYS */;
INSERT INTO `list` VALUES (1,'763a1e01-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:06:47',NULL,NULL,1,'Backburner',1,1,0),(2,'763fdbf4-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:06:47',NULL,NULL,1,'To Do',1,2,1),(3,'763fde3d-6b14-11f0-8177-842afdcb8544',1,'2025-07-27 20:06:47',NULL,NULL,0,'Done',1,3,2),(6,'f00f4007-5c9c-4c37-8e6d-6b1f58068fed',1,'2025-08-04 10:08:38',NULL,NULL,0,'New List from Postman',1,1,0),(7,'19b54d73-1f04-4e84-8050-ae97e92188fa',1,'2025-08-04 10:39:13',NULL,NULL,1,'Front-end List',1,1,4),(8,'1c1d3632-26c0-473d-a464-388a8e3a251c',5,'2025-08-04 11:01:24',NULL,NULL,1,'To Do',3,1,0),(9,'6141f6ba-21a8-45de-8699-9de771d96382',1,'2025-08-04 11:18:27',NULL,NULL,1,'Done',1,1,3);
/*!40000 ALTER TABLE `list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `project`
--

DROP TABLE IF EXISTS `project`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `project` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `CreatedById` int NOT NULL,
  `CreatedOn` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `Name` varchar(255) DEFAULT NULL,
  `Description` text,
  PRIMARY KEY (`Id`),
  KEY `CreatedById` (`CreatedById`),
  KEY `UpdatedById` (`UpdatedById`),
  CONSTRAINT `project_ibfk_1` FOREIGN KEY (`CreatedById`) REFERENCES `siteuser` (`Id`),
  CONSTRAINT `project_ibfk_2` FOREIGN KEY (`UpdatedById`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `project`
--

LOCK TABLES `project` WRITE;
/*!40000 ALTER TABLE `project` DISABLE KEYS */;
INSERT INTO `project` VALUES (1,'eccf0ced-6b13-11f0-8177-842afdcb8544',1,'2025-07-27 20:02:56',1,'2025-08-04 10:27:14',1,'Discovery App','Creating a functional, clean Mobile App for Discovery'),(2,'ecd740f7-6b13-11f0-8177-842afdcb8544',1,'2025-07-27 20:02:56',1,'2025-08-04 11:00:56',1,'PhysioHub',''),(7,'f1154298-434d-490a-a75d-e306afd4e920',1,'2025-07-30 22:17:53',NULL,NULL,0,'Updated Project','Updated description for this project.'),(9,'bf7aa49d-5577-4d91-acec-46d3b9940ee7',1,'2025-08-02 13:55:19',NULL,NULL,0,'New Project','Apt description.'),(10,'fd1c44e0-c96c-4d1a-89fb-abbba418bc8f',1,'2025-08-02 14:03:24',NULL,NULL,0,'new',''),(11,'cc806a50-18a3-4a4d-aa33-32deafaa9406',1,'2025-08-02 14:20:03',1,'2025-08-04 19:35:23',1,'Project Frontend','This project was created in the front-end.'),(12,'3794e8e6-a9e2-4f81-92f5-0e449a76ea80',1,'2025-08-02 14:22:30',NULL,NULL,0,'new new',''),(13,'83b06ca4-cb51-4319-bc6f-5cf9076a9bc0',1,'2025-08-02 20:25:27',NULL,NULL,0,'','');
/*!40000 ALTER TABLE `project` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `projectboard`
--

DROP TABLE IF EXISTS `projectboard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `projectboard` (
  `ProjectId` int NOT NULL,
  `BoardId` int NOT NULL,
  PRIMARY KEY (`ProjectId`,`BoardId`),
  KEY `BoardId` (`BoardId`),
  CONSTRAINT `projectboard_ibfk_1` FOREIGN KEY (`ProjectId`) REFERENCES `project` (`Id`),
  CONSTRAINT `projectboard_ibfk_2` FOREIGN KEY (`BoardId`) REFERENCES `board` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `projectboard`
--

LOCK TABLES `projectboard` WRITE;
/*!40000 ALTER TABLE `projectboard` DISABLE KEYS */;
INSERT INTO `projectboard` VALUES (1,1),(1,2),(2,3),(1,7),(12,8),(12,9);
/*!40000 ALTER TABLE `projectboard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `siteuser`
--

DROP TABLE IF EXISTS `siteuser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `siteuser` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PasswordHash` text NOT NULL,
  `FullName` varchar(255) DEFAULT NULL,
  `Role` enum('admin','user') DEFAULT 'user',
  `CreatedById` int DEFAULT NULL,
  `CreatedOn` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`Id`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `siteuser`
--

LOCK TABLES `siteuser` WRITE;
/*!40000 ALTER TABLE `siteuser` DISABLE KEYS */;
INSERT INTO `siteuser` VALUES (1,'a4f4a006-6b13-11f0-8177-842afdcb8544','emaileg@gmail.com','5NUvs11JWzbkkqpFYjhB0A==.+Kui2rD5cXRrcfST3coY3MqhcnXZI4YhKm6F4AAoNN0=','Admin','admin',NULL,'2025-07-27 20:00:56',NULL,NULL,1),(2,'a512a761-6b13-11f0-8177-842afdcb8544','emaileg2@gmail.com','/0NagGdfE01oE2aqiOFINw==.gK5vUK5fKLzXo2B+cyJWJaDuk+xQr/55uFqMLPSux5E=','TestUser2','user',NULL,'2025-07-27 20:00:56',NULL,NULL,1),(3,'0b58a4c1-aad8-4473-9be3-888aab748720','test@test.com','izs0oAmc3Vkg2/i3ISbk3g==.fyCRqI7yT3s0HvJ1An0+m8DW3ID17tmCq7v8RtX8HNU=','Test','user',NULL,'2025-07-30 14:44:26',NULL,NULL,1),(4,'0f6f1735-a3d4-4dd9-9dc4-1fe070566db9','heck@gmail.com','wnmHaNtUD3l3aVgBAB3AyQ==.FyCtFVpsujlxTgdYTnGjxOcSSEDoTg4rswYGbw0GuXw=','Jay Woodroffe','user',NULL,'2025-07-30 19:10:53',NULL,NULL,1),(5,'bf876503-eabd-4e84-9ea8-1730c8012f8e','new@gmail.com','ieP9WsH5xqQpSBu2mnKkWQ==.Fa4pwWEc5LzeEn0MhkbP2DMuZ/qECo7C3he71VuvBkE=','New User Flow','user',NULL,'2025-08-04 12:57:28',NULL,NULL,1);
/*!40000 ALTER TABLE `siteuser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `status` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `CreatedById` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `Name` varchar(255) NOT NULL,
  `Color` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `CreatedById` (`CreatedById`),
  KEY `UpdatedById` (`UpdatedById`),
  CONSTRAINT `status_ibfk_1` FOREIGN KEY (`CreatedById`) REFERENCES `siteuser` (`Id`),
  CONSTRAINT `status_ibfk_2` FOREIGN KEY (`UpdatedById`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (1,'b19546d0-6b13-11f0-8177-842afdcb8544',1,'2025-07-27 20:01:17',NULL,NULL,1,'To Do',NULL),(2,'b1968771-6b13-11f0-8177-842afdcb8544',1,'2025-07-27 20:01:17',NULL,NULL,1,'In Progress',NULL),(3,'b1968b82-6b13-11f0-8177-842afdcb8544',1,'2025-07-27 20:01:17',NULL,NULL,1,'Done',NULL);
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task`
--

DROP TABLE IF EXISTS `task`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Guid` char(36) NOT NULL,
  `CreatedById` int DEFAULT NULL,
  `CreatedOn` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedById` int DEFAULT NULL,
  `UpdatedOn` datetime DEFAULT NULL,
  `IsActive` tinyint NOT NULL DEFAULT '1',
  `Name` varchar(255) NOT NULL,
  `ListId` int NOT NULL,
  `Position` int NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `ListId` (`ListId`),
  KEY `CreatedById` (`CreatedById`),
  KEY `UpdatedById` (`UpdatedById`),
  CONSTRAINT `task_ibfk_3` FOREIGN KEY (`ListId`) REFERENCES `list` (`Id`),
  CONSTRAINT `task_ibfk_4` FOREIGN KEY (`CreatedById`) REFERENCES `siteuser` (`Id`),
  CONSTRAINT `task_ibfk_5` FOREIGN KEY (`UpdatedById`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task`
--

LOCK TABLES `task` WRITE;
/*!40000 ALTER TABLE `task` DISABLE KEYS */;
INSERT INTO `task` VALUES (1,'b8946c25-6b20-11f0-8177-842afdcb8544',1,'2025-07-27 21:34:32',NULL,NULL,1,'first task',2,0),(2,'b8db3e25-6b20-11f0-8177-842afdcb8544',1,'2025-07-27 21:34:32',NULL,NULL,0,'first task',1,1),(3,'b8db50f1-6b20-11f0-8177-842afdcb8544',1,'2025-07-27 21:34:32',NULL,NULL,0,'second task',1,2),(4,'b8db52d1-6b20-11f0-8177-842afdcb8544',1,'2025-07-27 21:34:32',NULL,NULL,1,'third task',2,2),(5,'b8db5414-6b20-11f0-8177-842afdcb8544',1,'2025-07-27 21:34:32',NULL,NULL,0,'fourth task',1,3),(6,'36e9c641-e8ec-4833-90b6-65b151a60f9f',1,'2025-08-03 10:52:36',NULL,NULL,0,'My new task',2,2),(8,'da30ec0b-8740-42a9-88e6-089206d85e47',1,'2025-08-03 17:56:30',NULL,NULL,0,'Extra new task to double check ',1,2),(9,'6f45e034-0a08-46f8-9181-afe6561c670b',1,'2025-08-03 18:04:53',NULL,NULL,0,'dgm',1,2),(10,'3357bd46-0abd-4345-a934-968c1809c42e',1,'2025-08-03 18:05:05',NULL,NULL,0,'2',1,2),(11,'ffb98879-305b-4064-a1ac-c033c4e22269',1,'2025-08-03 18:05:17',NULL,NULL,0,'hfzutxugxutxutx utcuyxutc5c utdutcutc ',1,2),(12,'2064173a-89f2-48f7-bcbd-4dc1562d9fb4',1,'2025-08-03 18:56:02',NULL,NULL,0,'position check',2,3),(13,'d6ce3cc5-0465-4a0b-91df-a8e7cd900408',1,'2025-08-03 19:05:08',NULL,NULL,0,'task to be done',1,1),(14,'eaa0fa68-9b79-42c6-b925-3292b1169526',1,'2025-08-03 20:59:27',NULL,NULL,0,'fourth task in this list',2,4),(15,'737fa6ca-29fb-4f8b-a57f-111ab944e346',1,'2025-08-03 21:11:11',NULL,NULL,0,'Tasks can be moved between lists',2,1),(16,'1d7d01bf-9062-4d41-8afc-5c3781cd3d80',1,'2025-08-03 21:17:43',NULL,NULL,1,'A completed task',9,0),(17,'18542948-7b9a-4ec0-96ee-a34ae8461bd6',1,'2025-08-04 10:44:52',NULL,NULL,1,'Login Screen',7,0),(18,'8b1cdc54-85eb-486f-bd15-401be1a721fe',1,'2025-08-04 10:45:02',NULL,NULL,1,'Sign up Screen',7,1),(19,'16c1ffbe-6df4-465f-99f2-12d30633bfae',1,'2025-08-04 10:47:08',NULL,NULL,1,'Adding a new list to a board',7,2),(20,'cff7a394-3fbf-4419-9f4a-61ca45b3511b',1,'2025-08-04 10:51:30',NULL,NULL,1,'Write Unit Test',7,3),(21,'0de4b9c1-c0b2-4adb-aef7-f9f52279a12c',1,'2025-08-04 10:51:50',NULL,NULL,1,'Logout',7,4),(22,'216c872e-b2bd-4b51-8682-834c684bf40e',1,'2025-08-04 10:53:16',NULL,NULL,0,'Errors with logout',7,3),(23,'88b174f7-837b-4a12-84bb-bb66eaec3bad',5,'2025-08-04 11:01:37',NULL,NULL,1,'Task Created by new user',8,0);
/*!40000 ALTER TABLE `task` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userproject`
--

DROP TABLE IF EXISTS `userproject`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userproject` (
  `ProjectId` int NOT NULL,
  `UserId` int NOT NULL,
  PRIMARY KEY (`ProjectId`,`UserId`),
  KEY `UserId` (`UserId`),
  CONSTRAINT `userproject_ibfk_1` FOREIGN KEY (`ProjectId`) REFERENCES `project` (`Id`),
  CONSTRAINT `userproject_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `siteuser` (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userproject`
--

LOCK TABLES `userproject` WRITE;
/*!40000 ALTER TABLE `userproject` DISABLE KEYS */;
INSERT INTO `userproject` VALUES (1,1),(2,1),(9,1),(10,1),(11,1),(12,1),(13,1),(1,2),(2,2),(7,3),(9,3),(1,4),(7,4),(9,4),(11,4),(2,5);
/*!40000 ALTER TABLE `userproject` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-05 10:21:08
