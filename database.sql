CREATE DATABASE  IF NOT EXISTS `transcake_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `transcake_db`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: transcake_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `driver_vehicles`
--

DROP TABLE IF EXISTS `driver_vehicles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `driver_vehicles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `vehicle_type` enum('MOTORBIKE','CAR') COLLATE utf8mb4_unicode_ci NOT NULL,
  `vehicle_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `license_plate` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `id_card_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_card_front_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `id_card_back_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `avatar_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `license_image_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_color` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `vehicle_registration_url` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `verification_status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `driver_vehicles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `driver_vehicles`
--

LOCK TABLES `driver_vehicles` WRITE;
/*!40000 ALTER TABLE `driver_vehicles` DISABLE KEYS */;
INSERT INTO `driver_vehicles` VALUES (24,58,'MOTORBIKE','Honda wave S','29G1-24031','2026-06-15 02:57:52','030204002816','https://res.cloudinary.com/dfqjxzs2s/image/upload/v1781492270/uf28qwavb84hjbrvqbgy.png','https://res.cloudinary.com/dfqjxzs2s/image/upload/v1781492270/xcv7hj5cfz8ccxulntdz.png','https://res.cloudinary.com/dfqjxzs2s/image/upload/v1781492270/gh8dmnpamt9kebruqcii.png','030204002816','https://res.cloudinary.com/dfqjxzs2s/image/upload/v1781492270/dtnqisfzvuccsdi2udeq.png','Đỏ','https://res.cloudinary.com/dfqjxzs2s/image/upload/v1781492270/knmrobhyuc8kyjereyae.png','APPROVED');
/*!40000 ALTER TABLE `driver_vehicles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_codes`
--

DROP TABLE IF EXISTS `otp_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_codes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `otp_code` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` timestamp NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_codes`
--

LOCK TABLES `otp_codes` WRITE;
/*!40000 ALTER TABLE `otp_codes` DISABLE KEYS */;
INSERT INTO `otp_codes` VALUES (82,'0986176203','kyvkhe182094@fpt.edu.vn','828141','2026-06-15 02:55:49',1,'2026-06-15 02:50:49'),(83,'0977612236','kyvk.sil@gmail.com','365450','2026-06-15 03:01:34',1,'2026-06-15 02:56:33'),(85,'0929343781','contact.holabus@gmail.com','963777','2026-06-15 15:52:33',0,'2026-06-15 15:47:32');
/*!40000 ALTER TABLE `otp_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trip_blog_posts`
--

DROP TABLE IF EXISTS `trip_blog_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trip_blog_posts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `trip_id` int NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `trip_id` (`trip_id`),
  CONSTRAINT `trip_blog_posts_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_blog_posts`
--

LOCK TABLES `trip_blog_posts` WRITE;
/*!40000 ALTER TABLE `trip_blog_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `trip_blog_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trips`
--

DROP TABLE IF EXISTS `trips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trips` (
  `id` int NOT NULL AUTO_INCREMENT,
  `passenger_id` int NOT NULL,
  `driver_id` int DEFAULT NULL,
  `driver_vehicle_id` int DEFAULT NULL,
  `pickup_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pickup_lat` double DEFAULT NULL,
  `pickup_lng` double DEFAULT NULL,
  `dropoff_location` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dropoff_lat` double DEFAULT NULL,
  `dropoff_lng` double DEFAULT NULL,
  `trip_type` enum('ON_DEMAND','PRE_BOOK') COLLATE utf8mb4_unicode_ci NOT NULL,
  `scheduled_time` datetime DEFAULT NULL,
  `match_status` enum('PENDING','MATCHED','CANCELLED') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `completion_status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED','FAILED') COLLATE utf8mb4_unicode_ci DEFAULT 'NOT_STARTED',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `note_for_driver` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `distance` decimal(10,2) DEFAULT NULL,
  `vehicle_type` enum('MOTORBIKE','CAR') COLLATE utf8mb4_unicode_ci DEFAULT 'CAR',
  `cancel_reason` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `passenger_id` (`passenger_id`),
  KEY `driver_id` (`driver_id`),
  KEY `fk_trips_driver_vehicle` (`driver_vehicle_id`),
  KEY `idx_trips_match_status` (`match_status`),
  KEY `idx_trips_trip_type` (`trip_type`),
  CONSTRAINT `fk_trips_driver_vehicle` FOREIGN KEY (`driver_vehicle_id`) REFERENCES `driver_vehicles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `users` (`id`),
  CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trips`
--

LOCK TABLES `trips` WRITE;
/*!40000 ALTER TABLE `trips` DISABLE KEYS */;
INSERT INTO `trips` VALUES (78,57,58,NULL,'83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957271,105.843021,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-06-15 02:59:48','đón tôi trước cổng công ty',40000.00,7.00,'MOTORBIKE',NULL),(79,57,58,NULL,'83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957271,105.843021,'Cảng Hàng Không Quốc Tế Nội Bài Xã Phú Cường,Huyện Sóc Sơn,Thành Phố Hà Nội',21.217325,105.792194,'ON_DEMAND',NULL,'CANCELLED','FAILED','2026-06-15 09:44:11','đón tôi trước cổng công ty',178000.00,34.60,'MOTORBIKE','Kẹt xe, không thể di chuyển');
/*!40000 ALTER TABLE `trips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone_number` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
  `gender` enum('male','female','other') COLLATE utf8mb4_unicode_ci DEFAULT 'other',
  `role` enum('passenger','driver','admin') COLLATE utf8mb4_unicode_ci DEFAULT 'passenger',
  `hobbies` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (51,'admin','0929343780','kimkyvu2004hd@gmail.com','$2a$12$VhnesNy/cuIM.2qc9iTlyOi1rR0j0pyTHtXwVdBwlnxv3K2I9.Cbi','ACTIVE','male','admin','Music, Food & Drink, Sports, Business','2026-06-09 15:30:06','2026-06-09 15:31:26'),(57,'Vũ Kim Kỳ','0986176203','kyvkhe182094@fpt.edu.vn','$2a$12$bNTVs2gwWfwu2lEiTnR/ZemxW9Q/9M4qTlGu8oq6o5.fpsDtDB4Y.','ACTIVE','male','passenger','Music, Travel, Sports, Tech','2026-06-15 02:51:34','2026-06-15 02:51:34'),(58,'Tài xế 1','0977612236','kyvk.sil@gmail.com','$2a$12$XtGmfsSGcKgwlYRmEluUNekRiuDSQebEXIj4vK4yHt2vnTraGrPES','ACTIVE','male','driver','Music, Travel, Sports, Tech','2026-06-15 02:57:52','2026-06-15 04:26:55');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

-- Dump completed
