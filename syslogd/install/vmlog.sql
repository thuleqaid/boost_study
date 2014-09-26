-- phpMyAdmin SQL Dump
-- version 4.1.6
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Sep 26, 2014 at 02:47 AM
-- Server version: 5.6.16
-- PHP Version: 5.5.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `vmlog`
--

-- --------------------------------------------------------

--
-- Stand-in structure for view `daily`
--
CREATE TABLE IF NOT EXISTS `daily` (
`date` date
,`pc` tinytext
,`count` bigint(21)
);
-- --------------------------------------------------------

--
-- Table structure for table `vmlog`
--

CREATE TABLE IF NOT EXISTS `vmlog` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pc` tinytext COLLATE utf8_bin NOT NULL,
  `user` tinytext COLLATE utf8_bin NOT NULL,
  `action` tinytext COLLATE utf8_bin NOT NULL,
  `detail` text COLLATE utf8_bin NOT NULL,
  `stamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=19 ;

-- --------------------------------------------------------

--
-- Structure for view `daily`
--
DROP TABLE IF EXISTS `daily`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `daily` AS select cast(`stamp` as date) AS `date`,`pc` AS `pc`,count(`pc`) AS `count` from `vmlog` group by cast(`stamp` as date),`pc`;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
