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
                                   `vehicle_type` enum('MOTORBIKE','CAR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `vehicle_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `license_plate` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                                   `id_card_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `id_card_front_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `id_card_back_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `license_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `license_image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `vehicle_color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `vehicle_registration_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                                   `verification_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
                                   PRIMARY KEY (`id`),
                                   KEY `user_id` (`user_id`),
                                   CONSTRAINT `driver_vehicles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
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
                             `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                             `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                             `otp_code` varchar(6) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                             `expires_at` timestamp NOT NULL,
                             `is_used` tinyint(1) DEFAULT '0',
                             `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             KEY `idx_phone_number` (`phone_number`)
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_codes`
--

LOCK TABLES `otp_codes` WRITE;
/*!40000 ALTER TABLE `otp_codes` DISABLE KEYS */;
INSERT INTO `otp_codes` VALUES (83,'0977612236','kyvk.sil@gmail.com','365450','2026-06-15 03:01:34',1,'2026-06-15 02:56:33'),(87,'0977612231','fptubusinessclub1@gmail.com','862559','2026-06-17 10:35:45',1,'2026-06-17 10:30:44'),(88,'0929343789','kimkkyvu2004hd@gmail.com','027775','2026-06-17 10:37:36',1,'2026-06-17 10:32:36'),(89,'0929343783','kyvkhe182094@fpt.edu.vn','829756','2026-06-22 03:11:12',1,'2026-06-22 03:06:11'),(90,'0976176203','contact.holabus@gmail.com','504453','2026-06-22 06:56:27',1,'2026-06-22 06:51:26');
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
                                   `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                                   `is_active` tinyint(1) DEFAULT '1',
                                   PRIMARY KEY (`id`),
                                   KEY `trip_id` (`trip_id`),
                                   CONSTRAINT `trip_blog_posts_ibfk_1` FOREIGN KEY (`trip_id`) REFERENCES `trips` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trip_blog_posts`
--

LOCK TABLES `trip_blog_posts` WRITE;
/*!40000 ALTER TABLE `trip_blog_posts` DISABLE KEYS */;
INSERT INTO `trip_blog_posts` VALUES (54,136,'Tìm bạn đường từ Trường Tiểu Học Victoria 65 Cẩm Hội,Phường Đống Mác,Quận Hai Bà Trưng,Thành Phố Hà Nội đến Công Viên Yên Sở Phường Yên Sở,Quận Hoàng Mai,Thành Phố Hà Nội','Mình có chuyến đi từ Trường Tiểu Học Victoria 65 Cẩm Hội,Phường Đống Mác,Quận Hai Bà Trưng,Thành Phố Hà Nội đến Công Viên Yên Sở Phường Yên Sở,Quận Hoàng Mai,Thành Phố Hà Nội vào lúc 2026-07-01 08:59:00.0. Ai có nhu cầu đi chung thì liên hệ nhé!',1),(55,137,'Tìm bạn đường từ Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội đến Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội','Mình có chuyến đi từ Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội đến Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội vào lúc 2026-07-02 08:01:00.0. Ai có nhu cầu đi chung thì liên hệ nhé!',1),(56,140,'Tìm bạn đường từ Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội đến 31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội','Mình có chuyến đi từ Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội đến 31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội vào lúc 2026-07-01 21:31:00.0. Ai có nhu cầu đi chung thì liên hệ nhé!',1);
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
                         `passenger_id` int DEFAULT NULL,
                         `driver_id` int DEFAULT NULL,
                         `driver_vehicle_id` int DEFAULT NULL,
                         `pickup_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `pickup_lat` double DEFAULT NULL,
                         `pickup_lng` double DEFAULT NULL,
                         `dropoff_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `dropoff_lat` double DEFAULT NULL,
                         `dropoff_lng` double DEFAULT NULL,
                         `trip_type` enum('ON_DEMAND','PRE_BOOK') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `scheduled_time` datetime DEFAULT NULL,
                         `match_status` enum('PENDING','MATCHED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
                         `completion_status` enum('NOT_STARTED','IN_PROGRESS','COMPLETED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'NOT_STARTED',
                         `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                         `note_for_driver` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `price` decimal(10,2) DEFAULT NULL,
                         `distance` decimal(10,2) DEFAULT NULL,
                         `vehicle_type` enum('MOTORBIKE','CAR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'CAR',
                         `cancel_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `created_by_role` enum('passenger','driver') COLLATE utf8mb4_unicode_ci DEFAULT 'passenger',
                         `completed_at` timestamp NULL DEFAULT NULL,
                         PRIMARY KEY (`id`),
                         KEY `passenger_id` (`passenger_id`),
                         KEY `driver_id` (`driver_id`),
                         KEY `fk_trips_driver_vehicle` (`driver_vehicle_id`),
                         KEY `idx_trips_match_status` (`match_status`),
                         KEY `idx_trips_trip_type` (`trip_type`),
                         CONSTRAINT `fk_trips_driver_vehicle` FOREIGN KEY (`driver_vehicle_id`) REFERENCES `driver_vehicles` (`id`) ON DELETE SET NULL,
                         CONSTRAINT `trips_ibfk_1` FOREIGN KEY (`passenger_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
                         CONSTRAINT `trips_ibfk_2` FOREIGN KEY (`driver_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=147 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trips`
--

LOCK TABLES `trips` WRITE;
/*!40000 ALTER TABLE `trips` DISABLE KEYS */;
INSERT INTO `trips` VALUES (134,62,NULL,NULL,'83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957271,105.843021,'Trường Tiểu Học Victoria 65 Cẩm Hội,Phường Đống Mác,Quận Hai Bà Trưng,Thành Phố Hà Nội',21.010974,105.860573,'ON_DEMAND',NULL,'CANCELLED','NOT_STARTED','2026-06-22 08:25:04','',30200.00,7.20,'MOTORBIKE',NULL,'passenger',NULL),(135,62,58,NULL,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'Cảng Hàng Không Quốc Tế Nội Bài Xã Phú Cường,Huyện Sóc Sơn,Thành Phố Hà Nội',21.217325,105.792194,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-06-23 07:25:07','',177200.00,49.20,'MOTORBIKE',NULL,'passenger','2026-06-23 07:25:07'),(136,62,58,NULL,'Trường Tiểu Học Victoria 65 Cẩm Hội,Phường Đống Mác,Quận Hai Bà Trưng,Thành Phố Hà Nội',21.010974,105.860573,'Công Viên Yên Sở Phường Yên Sở,Quận Hoàng Mai,Thành Phố Hà Nội',20.964654,105.855129,'PRE_BOOK','2026-07-01 08:59:00','MATCHED','COMPLETED','2026-06-23 08:56:01','',28100.00,6.60,'MOTORBIKE',NULL,'passenger','2026-06-23 08:56:32'),(137,62,58,NULL,'Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957613,105.844366,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'PRE_BOOK','2026-07-02 08:01:00','MATCHED','COMPLETED','2026-06-23 09:04:51','',139400.00,38.40,'MOTORBIKE',NULL,'passenger','2026-06-23 09:05:43'),(138,62,NULL,NULL,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'ON_DEMAND',NULL,'CANCELLED','NOT_STARTED','2026-06-23 10:26:07','',122250.00,33.50,'MOTORBIKE',NULL,'passenger',NULL),(139,62,NULL,NULL,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'ON_DEMAND',NULL,'CANCELLED','NOT_STARTED','2026-06-23 10:27:01','',122250.00,33.50,'MOTORBIKE',NULL,'passenger',NULL),(140,62,58,NULL,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'PRE_BOOK','2026-07-01 21:31:00','MATCHED','COMPLETED','2026-06-23 10:27:38','',122250.00,33.50,'MOTORBIKE',NULL,'passenger','2026-06-24 03:33:24'),(141,62,58,NULL,'Đại Học FPT Xã Thạch Hòa,Huyện Thạch Thất,Thành Phố Hà Nội',21.012845,105.527637,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-06-23 10:27:59','',122250.00,33.50,'MOTORBIKE',NULL,'passenger','2026-06-23 10:28:37'),(142,62,58,NULL,'Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957613,105.844366,'Cảng Hàng Không Quốc Tế Nội Bài Xã Phú Cường,Huyện Sóc Sơn,Thành Phố Hà Nội',21.217325,105.792194,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-06-24 03:19:28','',126800.00,34.80,'MOTORBIKE',NULL,'passenger','2026-06-24 03:19:43'),(143,62,58,NULL,'Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957613,105.844366,'Bệnh Viện Bạch Mai 78 Giải Phóng,Phường Phương Mai,Quận Đống Đa,Thành Phố Hà Nội',21.002184,105.840893,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-06-29 08:42:24','',23550.00,5.30,'MOTORBIKE',NULL,'passenger','2026-06-29 08:43:28'),(144,62,58,NULL,'Ngõ 83 Ngọc Hồi Phường Hoàng Liệt,Quận Hoàng Mai,Thành Phố Hà Nội',20.957613,105.844366,'Trường Đại Học Thành Đông 3 Vũ Công Đán,Phường Tứ Minh,Thành Phố Hải Dương,Tỉnh Hải Dương',20.92362,106.282527,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-07-02 08:05:08','',186300.00,51.80,'MOTORBIKE',NULL,'passenger','2026-07-02 08:05:39'),(145,62,58,NULL,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.967158,105.795656,'33 Cầu Cốn Phường Trần Hưng Đạo,Thành Phố Hải Dương,Tỉnh Hải Dương',20.934261,106.342151,'PRE_BOOK','2026-07-05 16:16:00','MATCHED','COMPLETED','2026-07-04 09:16:48','',20000.00,78.20,'MOTORBIKE','Tài xế hủy chuyến hẹn trước','driver','2026-07-04 09:34:27'),(146,62,58,NULL,'31 Yên Xá Xã Tân Triều,Huyện Thanh Trì,Thành Phố Hà Nội',20.972992,105.796114,'Trường Tiểu Học Victoria 65 Cẩm Hội,Phường Đống Mác,Quận Hai Bà Trưng,Thành Phố Hà Nội',21.010974,105.860573,'ON_DEMAND',NULL,'MATCHED','COMPLETED','2026-07-04 10:04:19','',41050.00,10.30,'MOTORBIKE',NULL,'passenger','2026-07-04 10:05:55');
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
                         `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `phone_number` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
                         `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVE',
                         `gender` enum('male','female','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'other',
                         `role` enum('passenger','driver','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'passenger',
                         `hobbies` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                         `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                         `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `phone_number` (`phone_number`),
                         UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (51,'admin','0929343780','kimkyvu2004hd@gmail.com','$2a$12$VhnesNy/cuIM.2qc9iTlyOi1rR0j0pyTHtXwVdBwlnxv3K2I9.Cbi','ACTIVE','male','admin','Music, Food & Drink, Sports, Business','2026-06-09 15:30:06','2026-06-09 15:31:26'),(58,'Tài xế 1','0977612236','kyvk.sil@gmail.com','$2a$12$XtGmfsSGcKgwlYRmEluUNekRiuDSQebEXIj4vK4yHt2vnTraGrPES','ACTIVE','male','driver','Music, Travel, Sports, Tech','2026-06-15 02:57:52','2026-06-15 04:26:55'),(60,'Hành khách 3','0977612231','fptubusinessclub1@gmail.com','$2a$12$cXclNQv79q3Tum1JQbE9.e6Y411aGY/opQafc.yqIb00K38JTep0.','ACTIVE','male','passenger','Gaming, Food & Drink, Fitness & Gym, Finance & Investing','2026-06-17 10:31:24','2026-06-17 10:31:24'),(61,'Hành khách 4','0929343789','kimkkyvu2004hd@gmail.com','$2a$12$qKjipWlUSPGoiv0uMq7MEewS3hEe2r9zV6tDD.dNMAEFcJNS4696u','ACTIVE','male','passenger','Fashion, Gaming, Fitness & Gym, Finance & Investing','2026-06-17 10:33:08','2026-06-17 10:33:08'),(62,'Hành khách test','0929343783','kyvkhe182094@fpt.edu.vn','$2a$12$7/QcgJtJX1ZGYNc1Nwg5TekDwZwGWkTY8iJa1CuQwMALD1ouETKP.','ACTIVE','male','passenger','Gaming, Food & Drink, Fitness & Gym, Business','2026-06-22 03:07:08','2026-06-22 03:07:08'),(63,'Hành khách 2','0976176203','contact.holabus@gmail.com','$2a$12$H7aNSFA8N5d.Tlk38Sn80u7u8VZWdBlIVFQBuX1.4omYAJL7oZ0de','ACTIVE','male','passenger','Music, Travel, Fitness & Gym, Finance & Investing','2026-06-22 06:52:07','2026-06-22 06:52:07');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'transcake_db'
--

--
-- Dumping routines for database 'transcake_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-04 17:22:47
