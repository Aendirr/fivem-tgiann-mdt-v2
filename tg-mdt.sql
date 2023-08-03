-- MySQL dump 10.13  Distrib 8.0.26, for Win64 (x86_64)
--
-- Host: localhost    Database: macro1.0
-- ------------------------------------------------------
-- Server version	8.0.26

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
-- Table structure for table `tgiann_mdt_arananlar`
--

DROP TABLE IF EXISTS `tgiann_mdt_arananlar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgiann_mdt_arananlar` (
  `citizenid` varchar(50) DEFAULT NULL,
  `sebep` longtext,
  `baslangic` varchar(255) DEFAULT NULL,
  `bitis` varchar(255) DEFAULT NULL,
  `isim` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tgiann_mdt_arananlar`
--

LOCK TABLES `tgiann_mdt_arananlar` WRITE;
/*!40000 ALTER TABLE `tgiann_mdt_arananlar` DISABLE KEYS */;
/*!40000 ALTER TABLE `tgiann_mdt_arananlar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tgiann_mdt_cezalar`
--

DROP TABLE IF EXISTS `tgiann_mdt_cezalar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgiann_mdt_cezalar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `aciklama` longtext,
  `ceza` varchar(255) DEFAULT NULL,
  `polis` mediumtext,
  `zanli` mediumtext,
  `cezalar` longtext,
  `olayid` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tgiann_mdt_cezalar`
--

LOCK TABLES `tgiann_mdt_cezalar` WRITE;
/*!40000 ALTER TABLE `tgiann_mdt_cezalar` DISABLE KEYS */;
/*!40000 ALTER TABLE `tgiann_mdt_cezalar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tgiann_mdt_olaylar`
--

DROP TABLE IF EXISTS `tgiann_mdt_olaylar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgiann_mdt_olaylar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `aciklama` longtext,
  `polis` longtext,
  `zanli` longtext,
  `zaman` datetime DEFAULT CURRENT_TIMESTAMP,
  `esyalar` longtext,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tgiann_mdt_olaylar`
--

LOCK TABLES `tgiann_mdt_olaylar` WRITE;
/*!40000 ALTER TABLE `tgiann_mdt_olaylar` DISABLE KEYS */;
/*!40000 ALTER TABLE `tgiann_mdt_olaylar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tgiann_notlar`
--

DROP TABLE IF EXISTS `tgiann_notlar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tgiann_notlar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(255) NOT NULL,
  `yazi` longtext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tgiann_notlar`
--

LOCK TABLES `tgiann_notlar` WRITE;
/*!40000 ALTER TABLE `tgiann_notlar` DISABLE KEYS */;
/*!40000 ALTER TABLE `tgiann_notlar` ENABLE KEYS */;
UNLOCK TABLES;


ALTER TABLE `players`
ADD COLUMN `aranma` longtext, AFTER `daily`;

ALTER TABLE `players`
ADD COLUMN `photo` varchar(500) DEFAULT 'resimsiz', AFTER `aranma`;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-01-10 20:14:16
