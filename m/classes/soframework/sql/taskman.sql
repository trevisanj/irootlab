-- MySQL dump 10.13  Distrib 5.5.25, for ubuntu10.04 (x86_64)
--
-- Host: localhost    Database: taskman
-- ------------------------------------------------------
-- Server version	5.5.25-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `task_scene`
--

DROP TABLE IF EXISTS `task_scene`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_scene` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) DEFAULT NULL,
  `when_created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `randomseed_subdatasetprovider` int(11) NOT NULL DEFAULT '0',
  `randomseed_cubeprovider` int(11) NOT NULL DEFAULT '0',
  `randomseed_under` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `task_tasklist`
--

DROP TABLE IF EXISTS `task_tasklist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_tasklist` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idscene` int(11) NOT NULL,
  `idx` int(11) NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT '0',
  `who` varchar(64) NOT NULL DEFAULT '' COMMENT 'In case ongoing, who is executing the task',
  `when_started` datetime DEFAULT NULL,
  `when_finished` datetime DEFAULT NULL,
  `classname` varchar(255) NOT NULL,
  `fns_input` text,
  `fn_output` varchar(255) DEFAULT NULL,
  `ovrindex` int(11) NOT NULL,
  `cvsplitindex` int(11) NOT NULL,
  `stabilization` int(11) NOT NULL DEFAULT '0',
  `dependencies` tinytext NOT NULL,
  `tries` int(11) NOT NULL DEFAULT '0',
  `failedreports` text NOT NULL,
  `hash` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `iddataset` (`idscene`,`idx`),
  KEY `task_tasklist_hash` (`hash`)
) ENGINE=InnoDB AUTO_INCREMENT=95965 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-06-12 19:38:41
