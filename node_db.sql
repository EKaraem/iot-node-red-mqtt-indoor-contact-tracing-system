-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2021 at 06:49 PM
-- Server version: 10.1.38-MariaDB
-- PHP Version: 7.3.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `node_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `getData` (IN `room_num` VARCHAR(50) CHARSET utf8, IN `day` DATE)  NO SQL
BEGIN
SELECT
   count(DISTINCT history.user_name)as count_all,
   COUNT(DISTINCT CASE WHEN user_type =0 THEN history.user_name END) count_student,  
   COUNT(DISTINCT CASE WHEN user_type =1 THEN history.user_name END) count_teacher,
   DATE_FORMAT(date, ' %h') as per_day
FROM history LEFT OUTER JOIN USER ON history.user_name = USER.user_name 
where state=1 and room=room_num and date(history.date)=day
Group by  DATE_FORMAT(date, '%Y-%m-%d-%h');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getHistory` (IN `room_num` VARCHAR(50) CHARSET utf8)  NO SQL
BEGIN
SELECT
   count(distinct history.user_name)as count_all,
   COUNT(DISTINCT CASE WHEN user_type =0 THEN history.user_name END) count_student,  
   COUNT(DISTINCT CASE WHEN user_type =1 THEN history.user_name END) count_teacher,
   DATE_FORMAT(date, '%Y-%m-%d') as per_day
FROM history LEFT OUTER JOIN USER ON history.user_name = USER.user_name 
where state=1 and room=room_num
Group by  DATE_FORMAT(date, '%Y-%m-%d');


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getTotal` (IN `room_num` VARCHAR(50) CHARSET utf8, IN `date` DATE)  NO SQL
BEGIN
SELECT count(*)as count,(select room.capacity from room where room=room_num) as cap FROM history INNER JOIN (SELECT MAX(id) as id FROM history GROUP BY user_name) last_updates ON last_updates.id = history.id and state=1 and room=room_num and  date(history.date)=date;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUser` (IN `room_num` VARCHAR(50) CHARSET utf8, IN `username` VARCHAR(50) CHARSET utf8, IN `stat` BOOLEAN, OUT `val` BOOLEAN)  NO SQL
BEGIN
/* INSERT INTO user (user_name,user_type) SELECT * FROM (SELECT username, 0) AS tmp WHERE NOT EXISTS ( SELECT user_name FROM user WHERE user_name = username ) LIMIT 1; */

IF EXISTS(SELECT * FROM user where user.user_name=username ) THEN
SET val=(SELECT state FROM history WHERE id IN(SELECT MAX(id) FROM history where user_name=username and room=room_num));

IF val!=stat OR ISNULL(val) THEN
INSERT INTO `history`( `room`, `user_name`,`state`) VALUES (room_num,username,stat);
END IF;

END IF;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `history`
--

CREATE TABLE `history` (
  `id` int(11) NOT NULL,
  `room` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `state` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `history`
--

INSERT INTO `history` (`id`, `room`, `user_name`, `date`, `state`) VALUES
(64, 'room1', 'ibeacon1', '2021-03-25 01:32:05', 1),
(65, 'room3', 'ibeacon1', '2021-03-25 01:32:05', 1),
(66, 'room3', 'ibeacon2', '2021-03-25 01:37:26', 1),
(67, 'room3', 'ibeacon3', '2021-03-25 02:37:35', 1),
(68, 'room3', 'ibeacon1', '2021-03-25 05:37:49', 0),
(69, 'room3', 'ibeacon4', '2021-03-25 01:37:53', 1),
(70, 'room3', 'ibeacon1', '2021-03-25 07:37:56', 1),
(71, 'room3', 'ibeacon4', '2021-03-25 01:38:12', 0),
(72, 'room3', 'ibeacon3', '2021-03-25 01:38:15', 0),
(73, 'room3', 'ibeacon2', '2021-03-25 01:38:35', 1),
(74, 'room3', 'ibeacon2', '2021-03-25 01:41:26', 1),
(75, 'room3', 'ibeacon1', '2021-03-25 01:45:54', 1),
(76, 'room2', 'ibeacon3', '2021-03-26 01:42:11', 1),
(77, 'room3', 'ibeacon2', '2021-03-26 01:43:38', 1),
(78, 'room3', 'ibeacon4', '2021-03-26 16:06:46', 1),
(79, 'room3', 'ibeacon2', '2021-03-26 17:11:51', 0),
(80, 'room2', 'ibeacon1', '2021-03-28 15:13:34', 1),
(81, 'room2', 'ibeacon1', '2021-03-28 15:13:34', 0),
(82, 'room2', 'ibeacon2', '2021-03-28 15:13:56', 1),
(83, 'room2', 'ibeacon1', '2021-03-28 15:13:56', 0),
(84, 'room3', 'ibeacon1', '2021-03-28 12:19:40', 1),
(85, 'room3', 'ibeacon1', '2021-03-28 15:19:40', 1),
(86, 'room3', 'ibeacon2', '2021-03-29 15:25:14', 1),
(87, 'room1', 'ibeacon3', '2021-03-29 16:25:14', 1),
(90, 'room1', 'ibeacon1', '2021-03-29 15:25:18', 1),
(91, 'room2', 'ibeacon1', '2021-03-28 15:29:01', 1),
(92, 'room2', 'ibeacon1', '2021-03-28 15:29:01', 0),
(93, 'room2', 'ibeacon1', '2021-03-28 15:29:19', 1),
(94, 'room2', 'ibeacon1', '2021-03-28 15:29:19', 0),
(95, 'room2', 'ibeacon1', '2021-03-28 15:29:25', 1),
(96, 'room2', 'ibeacon1', '2021-03-28 15:29:25', 0),
(97, 'room2', 'ibeacon1', '2021-03-28 15:30:37', 1),
(98, 'room2', 'ibeacon1', '2021-03-28 15:30:37', 0),
(99, 'room2', 'ibeacon1', '2021-03-28 15:30:57', 1),
(100, 'room2', 'ibeacon1', '2021-03-28 15:30:57', 0),
(101, 'room2', 'ibeacon1', '2021-03-28 16:02:06', 1),
(102, 'room2', 'ibeacon1', '2021-03-28 16:02:06', 0),
(103, 'room2', 'ibeacon1', '2021-03-28 16:31:36', 1),
(104, 'room2', 'ibeacon1', '2021-03-28 16:31:36', 0),
(105, 'room2', 'ibeacon1', '2021-03-28 16:58:11', 1),
(106, 'room2', 'ibeacon1', '2021-03-28 16:58:11', 0),
(107, 'room2', 'ibeacon1', '2021-03-28 17:20:49', 1),
(108, 'room2', 'ibeacon1', '2021-03-28 17:20:49', 0),
(109, 'room2', 'ibeacon1', '2021-03-28 17:21:22', 1),
(110, 'room2', 'ibeacon1', '2021-03-28 17:21:22', 0),
(111, 'room2', 'ibeacon1', '2021-03-28 17:38:29', 1),
(112, 'room2', 'ibeacon1', '2021-03-28 17:38:29', 0),
(113, 'room2', 'ibeacon1', '2021-03-28 17:40:05', 1),
(114, 'room2', 'ibeacon1', '2021-03-28 17:40:05', 0),
(115, 'room2', 'ibeacon1', '2021-03-28 17:44:30', 1),
(116, 'room2', 'ibeacon1', '2021-03-28 17:44:30', 0),
(117, 'room2', 'ibeacon1', '2021-03-28 17:45:11', 1),
(118, 'room2', 'ibeacon1', '2021-03-28 17:45:11', 0),
(119, 'room2', 'ibeacon1', '2021-03-28 17:46:22', 1),
(120, 'room2', 'ibeacon1', '2021-03-28 17:46:22', 0),
(121, 'room2', 'ibeacon1', '2021-03-28 17:47:32', 1),
(122, 'room2', 'ibeacon1', '2021-03-28 17:47:32', 0),
(123, 'room2', 'ibeacon1', '2021-03-28 17:48:50', 1),
(124, 'room2', 'ibeacon1', '2021-03-28 17:48:50', 0),
(125, 'room2', 'ibeacon1', '2021-03-28 17:50:49', 1),
(126, 'room2', 'ibeacon1', '2021-03-28 17:50:49', 0),
(127, 'room2', 'ibeacon1', '2021-03-28 17:56:23', 1),
(128, 'room2', 'ibeacon1', '2021-03-28 17:56:23', 0),
(129, 'room2', 'ibeacon1', '2021-03-28 17:57:47', 1),
(130, 'room2', 'ibeacon1', '2021-03-28 17:57:47', 0),
(131, 'room2', 'ibeacon1', '2021-03-28 18:01:03', 1),
(132, 'room2', 'ibeacon1', '2021-03-28 18:01:03', 0),
(133, 'room2', 'ibeacon1', '2021-03-28 18:02:31', 1),
(134, 'room2', 'ibeacon1', '2021-03-28 18:02:31', 0),
(135, 'room2', 'ibeacon1', '2021-03-28 18:03:28', 1),
(136, 'room2', 'ibeacon1', '2021-03-28 18:03:28', 0),
(137, 'room2', 'ibeacon1', '2021-03-28 18:04:18', 1),
(138, 'room2', 'ibeacon1', '2021-03-28 18:04:18', 0),
(139, 'room2', 'ibeacon1', '2021-03-28 18:07:04', 1),
(140, 'room2', 'ibeacon1', '2021-03-28 18:07:04', 0),
(141, 'room2', 'ibeacon1', '2021-03-28 18:10:39', 1),
(142, 'room2', 'ibeacon1', '2021-03-28 18:10:39', 0),
(143, 'room2', 'ibeacon1', '2021-03-28 18:11:23', 1),
(144, 'room2', 'ibeacon1', '2021-03-28 18:11:23', 0),
(145, 'room2', 'ibeacon1', '2021-03-28 18:11:58', 1),
(146, 'room2', 'ibeacon1', '2021-03-28 18:11:58', 0),
(147, 'room2', 'ibeacon1', '2021-03-28 18:12:17', 1),
(148, 'room2', 'ibeacon1', '2021-03-28 18:12:17', 0),
(149, 'room2', 'ibeacon1', '2021-03-28 18:13:21', 1),
(150, 'room2', 'ibeacon1', '2021-03-28 18:13:21', 0),
(151, 'room2', 'ibeacon1', '2021-03-28 18:14:32', 1),
(152, 'room2', 'ibeacon1', '2021-03-28 18:14:32', 0),
(153, 'room2', 'ibeacon1', '2021-03-28 18:15:01', 1),
(154, 'room2', 'ibeacon1', '2021-03-28 18:15:01', 0),
(155, 'room2', 'ibeacon1', '2021-03-28 18:16:21', 1),
(156, 'room2', 'ibeacon1', '2021-03-28 18:16:21', 0),
(157, 'room2', 'ibeacon1', '2021-03-28 18:17:31', 1),
(158, 'room2', 'ibeacon1', '2021-03-28 18:17:31', 0),
(159, 'room2', 'ibeacon1', '2021-03-28 18:18:28', 1),
(160, 'room2', 'ibeacon1', '2021-03-28 18:18:28', 0),
(161, 'room2', 'ibeacon1', '2021-03-28 18:19:06', 1),
(162, 'room2', 'ibeacon1', '2021-03-28 18:19:06', 0),
(163, 'room2', 'ibeacon1', '2021-03-28 18:20:38', 1),
(164, 'room2', 'ibeacon1', '2021-03-28 18:20:38', 0),
(165, 'room2', 'ibeacon1', '2021-03-28 21:47:32', 1),
(166, 'room2', 'ibeacon1', '2021-03-28 21:47:32', 0),
(167, 'room2', 'ibeacon1', '2021-03-29 00:36:29', 1),
(168, 'room2', 'ibeacon1', '2021-03-29 00:36:29', 0),
(169, 'room3', 'ibeacon1', '2021-03-29 01:00:42', 0),
(170, 'room2', 'ibeacon1', '2021-03-29 01:00:42', 1),
(171, 'room2', 'ibeacon1', '2021-03-29 01:00:42', 0),
(172, 'room2', 'ibeacon1', '2021-03-29 01:01:55', 1),
(173, 'room2', 'ibeacon1', '2021-03-29 01:01:55', 0),
(174, 'room2', 'ibeacon1', '2021-03-29 01:03:39', 1),
(175, 'room2', 'ibeacon1', '2021-03-29 01:03:39', 0),
(176, 'room2', 'ibeacon1', '2021-03-29 01:04:10', 1),
(177, 'room2', 'ibeacon1', '2021-03-29 01:04:10', 0),
(178, 'room2', 'ibeacon1', '2021-03-29 01:08:21', 1),
(179, 'room2', 'ibeacon1', '2021-03-29 01:08:21', 0),
(180, 'room2', 'ibeacon1', '2021-03-29 01:09:02', 1),
(181, 'room2', 'ibeacon1', '2021-03-29 01:09:02', 0),
(182, 'room2', 'ibeacon1', '2021-03-29 01:09:36', 1),
(183, 'room2', 'ibeacon1', '2021-03-29 01:09:36', 0),
(184, 'room2', 'ibeacon1', '2021-03-29 01:11:38', 1),
(185, 'room2', 'ibeacon1', '2021-03-29 01:11:38', 0),
(186, 'room2', 'ibeacon1', '2021-03-29 01:12:25', 1),
(187, 'room2', 'ibeacon1', '2021-03-29 01:12:25', 0),
(188, 'room2', 'ibeacon1', '2021-03-29 01:15:01', 1),
(189, 'room2', 'ibeacon1', '2021-03-29 01:15:01', 0),
(190, 'room2', 'ibeacon1', '2021-03-29 01:16:29', 1),
(191, 'room2', 'ibeacon1', '2021-03-29 01:16:29', 0),
(192, 'room2', 'ibeacon1', '2021-03-29 01:17:15', 1),
(193, 'room2', 'ibeacon1', '2021-03-29 01:17:15', 0),
(194, 'room2', 'ibeacon1', '2021-03-29 01:19:30', 1),
(195, 'room2', 'ibeacon1', '2021-03-29 01:19:30', 0),
(196, 'room2', 'ibeacon1', '2021-03-29 01:20:14', 1),
(197, 'room2', 'ibeacon1', '2021-03-29 01:20:14', 0),
(198, 'room2', 'ibeacon1', '2021-03-29 01:20:43', 1),
(199, 'room2', 'ibeacon1', '2021-03-29 01:20:43', 0),
(200, 'room2', 'ibeacon1', '2021-03-29 01:21:13', 1),
(201, 'room2', 'ibeacon1', '2021-03-29 01:21:13', 0),
(202, 'room2', 'ibeacon1', '2021-03-29 01:21:21', 1),
(203, 'room2', 'ibeacon1', '2021-03-29 01:21:22', 0),
(204, 'room2', 'ibeacon1', '2021-03-29 01:22:03', 1),
(205, 'room2', 'ibeacon1', '2021-03-29 01:22:03', 0),
(206, 'room2', 'ibeacon1', '2021-03-29 01:25:01', 1),
(207, 'room2', 'ibeacon1', '2021-03-29 01:25:01', 0),
(208, 'room2', 'ibeacon1', '2021-03-29 01:25:57', 1),
(209, 'room2', 'ibeacon1', '2021-03-29 01:25:57', 0),
(210, 'room2', 'ibeacon1', '2021-03-29 01:26:37', 1),
(211, 'room2', 'ibeacon1', '2021-03-29 01:26:37', 0),
(212, 'room2', 'ibeacon1', '2021-03-29 01:28:28', 1),
(213, 'room2', 'ibeacon1', '2021-03-29 01:28:28', 0),
(214, 'room2', 'ibeacon1', '2021-03-29 01:29:07', 1),
(215, 'room2', 'ibeacon1', '2021-03-29 01:29:07', 0),
(216, 'room2', 'ibeacon1', '2021-03-29 01:29:34', 1),
(217, 'room2', 'ibeacon1', '2021-03-29 01:29:34', 0),
(218, 'room2', 'ibeacon1', '2021-03-29 01:30:51', 1),
(219, 'room2', 'ibeacon1', '2021-03-29 01:30:51', 0),
(220, 'room2', 'ibeacon1', '2021-03-29 01:36:54', 1),
(221, 'room2', 'ibeacon1', '2021-03-29 01:36:54', 0),
(222, 'room2', 'ibeacon1', '2021-03-29 01:38:22', 1),
(223, 'room2', 'ibeacon1', '2021-03-29 01:38:22', 0),
(224, 'room2', 'ibeacon1', '2021-03-29 01:40:49', 1),
(225, 'room2', 'ibeacon1', '2021-03-29 01:40:49', 0),
(226, 'room2', 'ibeacon1', '2021-03-29 01:41:36', 1),
(227, 'room2', 'ibeacon1', '2021-03-29 01:41:36', 0),
(228, 'room2', 'ibeacon1', '2021-03-30 20:47:39', 1),
(229, 'room2', 'ibeacon2', '2021-03-30 20:47:39', 0),
(230, 'room3', 'ibeacon2', '2021-03-31 01:24:55', 0),
(231, 'room3', 'ibeacon2', '2021-03-31 01:29:23', 1),
(232, 'room3', 'ibeacon3', '2021-03-31 01:29:36', 1),
(233, 'room3', 'ibeacon2', '2021-03-31 01:30:09', 0),
(234, 'room3', 'ibeacon2', '2021-03-31 01:31:17', 1),
(235, 'room3', 'ibeacon1', '2021-03-31 01:31:18', 1),
(236, 'room3', 'ibeacon3', '2021-03-31 01:31:47', 0),
(237, 'room3', 'ibeacon2', '2021-03-31 01:31:48', 0),
(238, 'room3', 'ibeacon3', '2021-03-31 01:32:01', 1),
(239, 'room3', 'ibeacon2', '2021-03-31 01:32:01', 1),
(240, 'room3', 'ibeacon3', '2021-03-31 01:32:31', 0),
(241, 'room3', 'ibeacon2', '2021-03-31 01:32:31', 0),
(242, 'room3', 'ibeacon1', '2021-03-31 01:34:07', 0),
(243, 'room1', 'ibeacon2 ', '2021-03-31 01:37:23', 1),
(244, 'room1', 'ibeacon3', '2021-03-31 01:38:44', 0),
(245, 'room1', 'ibeacon2 ', '2021-03-31 01:38:45', 0),
(246, 'room3', 'ibeacon2 ', '2021-03-31 01:40:09', 1),
(247, 'room3', 'ibeacon3', '2021-03-31 01:40:10', 1),
(248, 'room3', 'ibeacon4', '2021-03-31 01:41:03', 0),
(249, 'room3', 'ibeacon3', '2021-03-31 01:41:05', 0),
(250, 'room3', 'ibeacon3', '2021-03-31 01:41:53', 1),
(251, 'room3', 'ibeacon1', '2021-03-31 01:41:54', 1),
(252, 'room3', 'ibeacon2 ', '2021-03-31 01:42:23', 0),
(253, 'room3', 'ibeacon3', '2021-03-31 01:42:24', 0),
(254, 'room3', 'ibeacon2 ', '2021-03-31 01:43:25', 1),
(255, 'room3', 'ibeacon3', '2021-03-31 01:43:25', 1),
(256, 'room3', 'ibeacon1', '2021-03-31 01:44:06', 0),
(257, 'room3', 'ibeacon2 ', '2021-03-31 01:44:10', 0),
(258, 'room3', 'ibeacon3', '2021-03-31 01:44:12', 0),
(259, 'room3', 'ibeacon2 ', '2021-03-31 01:44:46', 1),
(260, 'room3', 'ibeacon1 ', '2021-03-31 01:44:57', 1),
(261, 'room3', 'ibeacon3', '2021-03-31 01:45:14', 1),
(262, 'room3', 'ibeacon1 ', '2021-03-31 01:45:35', 0),
(263, 'room3', 'ibeacon2 ', '2021-03-31 01:45:37', 0),
(264, 'room3', 'ibeacon3', '2021-03-31 01:49:07', 0),
(265, 'room3', 'ibeacon1 ', '2021-03-31 01:49:31', 1),
(266, 'room3', 'ibeacon2 ', '2021-03-31 01:49:41', 1),
(267, 'room3', 'ibeacon1 ', '2021-03-31 01:50:28', 0),
(268, 'room3', 'ibeacon3', '2021-03-31 01:51:37', 1),
(269, 'room3', 'ibeacon3', '2021-03-31 01:52:28', 0),
(270, 'room3', 'ibeacon1 ', '2021-03-31 01:53:35', 1),
(271, 'room3', 'ibeacon2 ', '2021-03-31 01:54:05', 0),
(272, 'room3', 'ibeacon1 ', '2021-03-31 02:04:07', 0),
(273, 'room3', 'ibeacon1', '2021-03-31 14:50:58', 1),
(274, 'room3', 'ibeacon2', '2021-03-31 14:51:11', 1),
(275, 'room3', 'ibeacon1', '2021-03-31 14:51:35', 0),
(276, 'room3', 'ibeacon2', '2021-03-31 15:00:28', 0),
(277, 'room3', 'ibeacon1 ', '2021-03-31 17:04:48', 1),
(278, 'room3', 'ibeacon2 ', '2021-03-31 17:05:12', 1),
(279, 'room3', 'ibeacon1 ', '2021-03-31 17:05:29', 0),
(280, 'room3', 'ibeacon3', '2021-03-31 17:05:33', 1),
(281, 'room3', 'ibeacon1 ', '2021-03-31 17:05:35', 1),
(282, 'room3', 'ibeacon2 ', '2021-03-31 17:05:53', 0),
(283, 'room3', 'ibeacon3', '2021-03-31 17:06:05', 0),
(284, 'room3', 'ibeacon1 ', '2021-03-31 17:14:59', 0),
(285, 'room3', 'ibeacon1', '2021-03-31 17:33:44', 1),
(286, 'room3', 'ibeacon2', '2021-03-31 17:34:02', 1),
(287, 'room3', 'ibeacon1', '2021-03-31 17:34:26', 0),
(288, 'room3', 'ibeacon3', '2021-03-31 17:34:46', 1),
(289, 'room3', 'ibeacon4', '2021-03-31 17:35:02', 1),
(290, 'room3', 'ibeacon2', '2021-03-31 17:35:10', 0),
(291, 'room3', 'ibeacon3', '2021-03-31 17:35:28', 0),
(292, 'room3', 'ibeacon4', '2021-03-31 17:35:53', 0);

-- --------------------------------------------------------

--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `room` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`room`, `capacity`) VALUES
('room1', 10),
('room2', 5),
('room3', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `user_name` varchar(50) NOT NULL,
  `user_type` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`user_name`, `user_type`) VALUES
('IBEACON1', 1),
('IBEACON2', 0),
('IBEACON3', 0),
('IBEACON4', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `history`
--
ALTER TABLE `history`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `room`
--
ALTER TABLE `room`
  ADD PRIMARY KEY (`room`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`user_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `history`
--
ALTER TABLE `history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=293;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
