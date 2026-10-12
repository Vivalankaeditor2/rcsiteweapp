CREATE DATABASE  IF NOT EXISTS `vivalanka` /*!40100 DEFAULT CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci */;
USE `vivalanka`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: 10.170.1.6    Database: vivalanka
-- ------------------------------------------------------
-- Server version	5.5.5-10.6.16-MariaDB-log

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
-- Table structure for table `article_category`
--

DROP TABLE IF EXISTS `article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category` (
  `categoryid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parentid` int(11) DEFAULT NULL,
  `category_name` varchar(60) DEFAULT NULL,
  `title` varchar(120) DEFAULT NULL,
  `description` varchar(240) DEFAULT NULL,
  `level` varchar(30) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `active` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`categoryid`),
  KEY `parentid` (`parentid`),
  KEY `active` (`active`)
) ENGINE=MyISAM AUTO_INCREMENT=113 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `article_category_has_articles`
--

DROP TABLE IF EXISTS `article_category_has_articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category_has_articles` (
  `categoryid` int(10) unsigned NOT NULL DEFAULT 0,
  `article_id` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`categoryid`,`article_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `article_category_has_feed_channel`
--

DROP TABLE IF EXISTS `article_category_has_feed_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `article_category_has_feed_channel` (
  `category_id` int(10) unsigned NOT NULL DEFAULT 0,
  `channel_id` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`category_id`,`channel_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articles`
--

DROP TABLE IF EXISTS `articles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `details` text DEFAULT NULL,
  `author_name` varchar(50) DEFAULT NULL,
  `author_intro` tinytext DEFAULT NULL,
  `entry_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `published` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `aproval_status` varchar(20) DEFAULT NULL,
  `editor_name` varchar(50) DEFAULT NULL,
  `editor_email` varchar(50) DEFAULT NULL,
  `categoryid` int(11) DEFAULT NULL,
  `dcode` varchar(50) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `feed_channel_id` int(10) unsigned DEFAULT NULL,
  `process_status` varchar(255) DEFAULT NULL,
  `alias` varchar(240) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`article_id`),
  KEY `categoryid_index` (`categoryid`),
  KEY `aproval_status_index` (`aproval_status`),
  KEY `entry_date` (`entry_date`),
  KEY `process_status` (`process_status`),
  KEY `feed_channel_id` (`feed_channel_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12330553 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articles2`
--

DROP TABLE IF EXISTS `articles2`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles2` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) DEFAULT NULL,
  `aproval_status` varchar(255) DEFAULT NULL,
  `author_intro` varchar(255) DEFAULT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `categoryid` int(11) NOT NULL,
  `dcode` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `editor_email` varchar(255) DEFAULT NULL,
  `editor_name` varchar(255) DEFAULT NULL,
  `entry_date` datetime(6) DEFAULT NULL,
  `feed_channel_id` int(11) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  `process_status` varchar(255) DEFAULT NULL,
  `published` datetime(6) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `title` longtext DEFAULT NULL,
  `updated` datetime(6) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`article_id`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `articles3`
--

DROP TABLE IF EXISTS `articles3`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `articles3` (
  `article_id` int(11) NOT NULL AUTO_INCREMENT,
  `title` longtext DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `details` longtext DEFAULT NULL,
  `author_name` varchar(255) DEFAULT NULL,
  `author_intro` tinytext DEFAULT NULL,
  `entry_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `published` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `aproval_status` varchar(255) DEFAULT NULL,
  `editor_name` varchar(255) DEFAULT NULL,
  `editor_email` varchar(255) DEFAULT NULL,
  `categoryid` int(11) DEFAULT NULL,
  `dcode` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `feed_channel_id` int(10) unsigned DEFAULT NULL,
  `process_status` varchar(255) DEFAULT NULL,
  `alias` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `keywords` varchar(255) DEFAULT NULL,
  `language` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`article_id`),
  KEY `categoryid_index` (`categoryid`),
  KEY `aproval_status_index` (`aproval_status`),
  KEY `entry_date` (`entry_date`),
  KEY `process_status` (`process_status`),
  KEY `feed_channel_id` (`feed_channel_id`)
) ENGINE=MyISAM AUTO_INCREMENT=12107816 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pgrpcount` int(11) DEFAULT NULL,
  `login` varchar(50) NOT NULL DEFAULT '',
  `ship_fname` varchar(50) DEFAULT NULL,
  `ship_lname` varchar(50) DEFAULT NULL,
  `ship_email` varchar(50) DEFAULT NULL,
  `ship_comp` varchar(50) DEFAULT NULL,
  `ship_phone` varchar(50) DEFAULT NULL,
  `ship_fax` varchar(50) DEFAULT NULL,
  `ship_addr` varchar(100) DEFAULT NULL,
  `ship_city` varchar(50) DEFAULT NULL,
  `ship_state` varchar(50) DEFAULT NULL,
  `ship_zip` varchar(50) DEFAULT NULL,
  `ship_cntry` varchar(50) DEFAULT NULL,
  `bill_fname` varchar(50) DEFAULT NULL,
  `bill_lname` varchar(50) DEFAULT NULL,
  `bill_email` varchar(50) DEFAULT NULL,
  `bill_comp` varchar(50) DEFAULT NULL,
  `bill_phone` varchar(50) DEFAULT NULL,
  `bill_fax` varchar(50) DEFAULT NULL,
  `bill_addr` varchar(100) DEFAULT NULL,
  `bill_city` varchar(50) DEFAULT NULL,
  `bill_state` varchar(50) DEFAULT NULL,
  `bill_zip` varchar(50) DEFAULT NULL,
  `bill_cntry` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `directory`
--

DROP TABLE IF EXISTS `directory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `directory` (
  `link_id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `aproval_status` varchar(20) DEFAULT NULL,
  `url` varchar(200) DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` varchar(240) DEFAULT NULL,
  `category1` varchar(50) DEFAULT NULL,
  `category2` varchar(50) DEFAULT NULL,
  `reciprocal_url` varchar(200) DEFAULT NULL,
  `owner_name` varchar(50) DEFAULT NULL,
  `owner_email` varchar(50) DEFAULT NULL,
  `address1` varchar(100) DEFAULT NULL,
  `address2` varchar(100) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `dcode` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`link_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4052061 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email`
--

DROP TABLE IF EXISTS `email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email` (
  `emailid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entered_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `from_name` varchar(50) DEFAULT NULL,
  `from_email` varchar(50) DEFAULT NULL,
  `to_name` varchar(50) DEFAULT NULL,
  `to_email` varchar(50) DEFAULT NULL,
  `subject` varchar(100) DEFAULT NULL,
  `type` varchar(35) DEFAULT NULL,
  `attachment` varchar(100) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `description` varchar(240) DEFAULT NULL,
  `folder` varchar(30) DEFAULT NULL,
  `user` varchar(50) DEFAULT 'preferred',
  PRIMARY KEY (`emailid`)
) ENGINE=MyISAM AUTO_INCREMENT=999747517 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `email_report`
--

DROP TABLE IF EXISTS `email_report`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_report` (
  `reportid` int(11) NOT NULL AUTO_INCREMENT,
  `emailid` int(11) DEFAULT NULL,
  `sent_emails` text DEFAULT NULL,
  `failed_emails` text DEFAULT NULL,
  `error_mesg` varchar(240) DEFAULT NULL,
  PRIMARY KEY (`reportid`),
  KEY `emailid` (`emailid`)
) ENGINE=MyISAM AUTO_INCREMENT=14348 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feed_article`
--

DROP TABLE IF EXISTS `feed_article`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feed_article` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `channel_id` int(10) unsigned DEFAULT NULL,
  `guid` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `received` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `published` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `processed` tinyint(4) DEFAULT NULL,
  `details` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_id_index` (`channel_id`),
  KEY `processed_index` (`processed`)
) ENGINE=MyISAM AUTO_INCREMENT=220852 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feed_channel`
--

DROP TABLE IF EXISTS `feed_channel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feed_channel` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `link` varchar(255) DEFAULT NULL,
  `poll_interval` int(10) unsigned DEFAULT NULL,
  `feed_active` tinyint(1) DEFAULT NULL,
  `feed_type` varchar(30) DEFAULT NULL,
  `poll_interval_min` int(10) unsigned DEFAULT NULL,
  `poll_interval_max` int(10) unsigned DEFAULT NULL,
  `source_site` varchar(50) DEFAULT NULL,
  `next_poll` datetime DEFAULT NULL,
  `last_poll` datetime DEFAULT NULL,
  `default_category_id` int(10) unsigned DEFAULT NULL,
  `comment` varchar(245) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `feed_active` (`feed_active`),
  KEY `next_poll` (`next_poll`)
) ENGINE=MyISAM AUTO_INCREMENT=391 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `feed_channel_log`
--

DROP TABLE IF EXISTS `feed_channel_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feed_channel_log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Primary key for Log records.',
  `channel_id` int(10) unsigned DEFAULT NULL,
  `log_time` timestamp NULL DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `severity` varchar(45) DEFAULT NULL COMMENT 'The severity of the error that occurred.',
  `message` varchar(200) DEFAULT NULL,
  `trace` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `channel_id` (`channel_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9753 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_blocks`
--

DROP TABLE IF EXISTS `geo_blocks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_blocks` (
  `start_ip_num` int(10) unsigned NOT NULL DEFAULT 0,
  `end_ip_num` int(10) unsigned DEFAULT NULL,
  `loc_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`start_ip_num`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `geo_location`
--

DROP TABLE IF EXISTS `geo_location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `geo_location` (
  `id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL,
  `region` varchar(20) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `postal_code` varchar(20) DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `metro_code` int(10) unsigned DEFAULT NULL,
  `area_code` int(10) unsigned DEFAULT NULL,
  KEY `country` (`country`),
  KEY `region` (`region`),
  KEY `location_id` (`location_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `location_article_category`
--

DROP TABLE IF EXISTS `location_article_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location_article_category` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned DEFAULT NULL,
  `category_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `category_id` (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=70 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_charges`
--

DROP TABLE IF EXISTS `order_charges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_charges` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `order_id` int(11) DEFAULT NULL,
  `charge_id` int(11) DEFAULT NULL,
  `module_id` int(11) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `desc_` varchar(100) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `disp_amt` decimal(10,2) DEFAULT NULL,
  `tax_exempt` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_no`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `line_id` int(11) NOT NULL DEFAULT 0,
  `order_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(200) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `taxable` int(11) DEFAULT NULL,
  `upsold` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `attri_id` int(11) DEFAULT NULL,
  `attri_code` varchar(50) DEFAULT NULL,
  `attri_prompt` varchar(200) DEFAULT NULL,
  `opt_id` int(11) DEFAULT NULL,
  `opt_code` varchar(50) DEFAULT NULL,
  `opt_prompt` varchar(200) DEFAULT NULL,
  `opt_price` decimal(10,2) DEFAULT NULL,
  `data` varchar(240) DEFAULT NULL,
  `data_long` varchar(240) DEFAULT NULL,
  `store` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`line_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int(11) NOT NULL DEFAULT 0,
  `batch_id` int(11) DEFAULT NULL,
  `processed` int(11) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `login` varchar(50) DEFAULT NULL,
  `ship_fname` varchar(50) DEFAULT NULL,
  `ship_lname` varchar(50) DEFAULT NULL,
  `ship_email` varchar(50) DEFAULT NULL,
  `ship_comp` varchar(50) DEFAULT NULL,
  `ship_phone` varchar(50) DEFAULT NULL,
  `ship_fax` varchar(50) DEFAULT NULL,
  `ship_addr` varchar(100) DEFAULT NULL,
  `ship_city` varchar(50) DEFAULT NULL,
  `ship_state` varchar(50) DEFAULT NULL,
  `ship_zip` varchar(50) DEFAULT NULL,
  `ship_cntry` varchar(50) DEFAULT NULL,
  `bill_fname` varchar(50) DEFAULT NULL,
  `bill_lname` varchar(50) DEFAULT NULL,
  `bill_email` varchar(50) DEFAULT NULL,
  `bill_comp` varchar(50) DEFAULT NULL,
  `bill_phone` varchar(50) DEFAULT NULL,
  `bill_fax` varchar(50) DEFAULT NULL,
  `bill_addr` varchar(100) DEFAULT NULL,
  `bill_city` varchar(50) DEFAULT NULL,
  `bill_state` varchar(50) DEFAULT NULL,
  `bill_zip` varchar(50) DEFAULT NULL,
  `bill_cntry` varchar(50) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `shipping` decimal(10,2) DEFAULT NULL,
  `ship_id` int(11) DEFAULT NULL,
  `ship_data` varchar(100) DEFAULT NULL,
  `pay_id` int(11) DEFAULT NULL,
  `pay_data` varchar(100) DEFAULT NULL,
  `affil_code` varchar(50) DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `pay_sectyp` varchar(100) DEFAULT NULL,
  `pay_seckey` varchar(240) DEFAULT NULL,
  `pay_secdat` varchar(240) DEFAULT NULL,
  `store` varchar(50) DEFAULT NULL,
  `store2` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `preferences`
--

DROP TABLE IF EXISTS `preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `preferences` (
  `entryid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `pref1` varchar(10) DEFAULT 'YES',
  `pref2` varchar(10) DEFAULT 'YES',
  `pref3` varchar(10) DEFAULT 'YES',
  `pref4` varchar(10) DEFAULT 'YES',
  `phone` varchar(30) DEFAULT NULL,
  `best_time_call` varchar(30) DEFAULT NULL,
  `entered_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`entryid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_attributes`
--

DROP TABLE IF EXISTS `product_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_attributes` (
  `attribute_id` int(11) NOT NULL DEFAULT 0,
  `prod_id` int(11) DEFAULT NULL,
  `default_code` varchar(50) DEFAULT NULL,
  `order_` int(11) DEFAULT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  `type` varchar(20) DEFAULT NULL,
  `attemp_id` int(11) DEFAULT NULL,
  `prompt` varchar(200) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `required` int(11) DEFAULT NULL,
  `image` varchar(240) DEFAULT NULL,
  PRIMARY KEY (`attribute_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_categories`
--

DROP TABLE IF EXISTS `product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_categories` (
  `category_id` int(11) NOT NULL DEFAULT 0,
  `parent_id` int(11) DEFAULT NULL,
  `agrpcount` int(11) DEFAULT NULL,
  `order_` int(11) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `store` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_options`
--

DROP TABLE IF EXISTS `product_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_options` (
  `option_id` int(11) NOT NULL DEFAULT 0,
  `attri_id` varchar(50) DEFAULT NULL,
  `order_` int(11) DEFAULT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  `prompt` varchar(200) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `image` varchar(240) DEFAULT NULL,
  PRIMARY KEY (`option_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `product_id` int(11) NOT NULL DEFAULT 0,
  `catcount` int(11) DEFAULT NULL,
  `agrpcount` int(11) DEFAULT NULL,
  `pgrpcount` int(11) DEFAULT NULL,
  `order_` int(11) DEFAULT NULL,
  `code` varchar(50) NOT NULL DEFAULT '',
  `name` varchar(200) DEFAULT NULL,
  `thumbnail` varchar(240) DEFAULT NULL,
  `image` varchar(240) DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `cost` decimal(10,2) DEFAULT NULL,
  `desc_` text DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `payment_type` varchar(50) DEFAULT 'onetime',
  `taxable` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `store` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product_id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prodxcat`
--

DROP TABLE IF EXISTS `prodxcat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prodxcat` (
  `line_id` int(11) NOT NULL DEFAULT 0,
  `category_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `order_` int(11) DEFAULT NULL,
  PRIMARY KEY (`line_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rc_category`
--

DROP TABLE IF EXISTS `rc_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rc_category` (
  `category_id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `aproval_status` varchar(20) DEFAULT NULL,
  `category_name` varchar(100) DEFAULT NULL,
  `description` varchar(240) DEFAULT NULL,
  `submit_url` varchar(200) DEFAULT NULL,
  `submit_name` varchar(50) DEFAULT NULL,
  `submit_email` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=MyISAM AUTO_INCREMENT=986349 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rc_customer`
--

DROP TABLE IF EXISTS `rc_customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rc_customer` (
  `username` varchar(20) NOT NULL,
  `pword` varchar(20) DEFAULT NULL,
  `customer` varchar(50) NOT NULL,
  `age` decimal(4,1) DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `address` varchar(70) DEFAULT NULL,
  `height_feet` int(11) DEFAULT NULL,
  `height_inches` int(11) DEFAULT NULL,
  `starting_weight` decimal(5,1) DEFAULT NULL,
  `goal_weight` decimal(5,1) DEFAULT NULL,
  `goal_date_value` int(11) DEFAULT NULL,
  `goal_date_name` varchar(15) DEFAULT NULL,
  `start_size` decimal(5,1) DEFAULT NULL,
  `goal_size` decimal(5,1) DEFAULT NULL,
  `high_bp` varchar(10) DEFAULT NULL,
  `heart_conditions` varchar(10) DEFAULT NULL,
  `food_allergies` varchar(10) DEFAULT NULL,
  `other_medical` varchar(50) DEFAULT NULL,
  `nursing` varchar(10) DEFAULT NULL,
  `happy_energy` varchar(10) DEFAULT NULL,
  `appetite_problem` varchar(10) DEFAULT NULL,
  `water_glasses` int(11) DEFAULT NULL,
  `favorite_foods` varchar(10) DEFAULT NULL,
  `drink_coffee` varchar(10) DEFAULT NULL,
  `drink_soda` varchar(10) DEFAULT NULL,
  `drink_alcohol` varchar(10) DEFAULT NULL,
  `smoking` varchar(10) DEFAULT NULL,
  `type` varchar(15) DEFAULT NULL,
  `consultant` varchar(50) DEFAULT 'preferred',
  PRIMARY KEY (`username`),
  UNIQUE KEY `customer` (`customer`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rcsite_config`
--

DROP TABLE IF EXISTS `rcsite_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rcsite_config` (
  `config_key` varchar(100) NOT NULL DEFAULT '',
  `value` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `site_area` varchar(100) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `hot_configurable` int(11) DEFAULT NULL,
  PRIMARY KEY (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `readme`
--

DROP TABLE IF EXISTS `readme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `readme` (
  `id` int(11) NOT NULL,
  `Message` text DEFAULT NULL,
  `Email` text DEFAULT NULL,
  `Bitcoin_Address` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usertype`
--

DROP TABLE IF EXISTS `usertype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usertype` (
  `usertypeid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `usertypename` varchar(32) NOT NULL,
  PRIMARY KEY (`usertypeid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `webui`
--

DROP TABLE IF EXISTS `webui`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `webui` (
  `ui_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `email_header` text DEFAULT NULL,
  `email_footer` text DEFAULT NULL,
  PRIMARY KEY (`ui_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-12 14:07:02
