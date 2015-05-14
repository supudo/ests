-- phpMyAdmin SQL Dump
-- version 4.3.12
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: May 14, 2015 at 04:23 PM
-- Server version: 5.6.23
-- PHP Version: 5.5.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `ror_ests`
--

-- --------------------------------------------------------

--
-- Table structure for table `casestudies`
--

CREATE TABLE IF NOT EXISTS `casestudies` (
  `id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `header_image` varchar(255) DEFAULT NULL,
  `description` text,
  `text_color` varchar(10) DEFAULT NULL,
  `created_user_id` int(10) unsigned NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `casestudy_challenges`
--

CREATE TABLE IF NOT EXISTS `casestudy_challenges` (
  `id` int(11) unsigned NOT NULL,
  `case_study_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL,
  `position` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `casestudy_links`
--

CREATE TABLE IF NOT EXISTS `casestudy_links` (
  `id` int(11) unsigned NOT NULL,
  `case_study_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL,
  `position` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `casestudy_overviews`
--

CREATE TABLE IF NOT EXISTS `casestudy_overviews` (
  `id` int(11) unsigned NOT NULL,
  `case_study_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL,
  `position` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `casestudy_solutions`
--

CREATE TABLE IF NOT EXISTS `casestudy_solutions` (
  `id` int(11) unsigned NOT NULL,
  `case_study_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL,
  `position` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `casestudy_technologies`
--

CREATE TABLE IF NOT EXISTS `casestudy_technologies` (
  `id` int(11) unsigned NOT NULL,
  `case_study_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL,
  `position` int(11) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `url` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `created_user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `currencies`
--

CREATE TABLE IF NOT EXISTS `currencies` (
  `id` smallint(5) unsigned NOT NULL,
  `code` varchar(5) NOT NULL,
  `title` varchar(255) NOT NULL,
  `symbol` varchar(10) NOT NULL,
  `is_infront` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `currencies_exchanges`
--

CREATE TABLE IF NOT EXISTS `currencies_exchanges` (
  `id` int(11) unsigned NOT NULL,
  `from_currency_id` int(11) unsigned NOT NULL,
  `to_currency_id` int(11) unsigned NOT NULL,
  `rate` decimal(13,4) unsigned NOT NULL,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `engagement_models`
--

CREATE TABLE IF NOT EXISTS `engagement_models` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `has_minmax` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `estimates`
--

CREATE TABLE IF NOT EXISTS `estimates` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `is_signed` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `rate_id` int(11) unsigned NOT NULL,
  `engagement_model_id` int(11) unsigned NOT NULL,
  `client_id` int(11) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `owner_user_id` int(11) unsigned NOT NULL,
  `created_user_id` int(11) unsigned NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `estimates_assumptions`
--

CREATE TABLE IF NOT EXISTS `estimates_assumptions` (
  `id` int(11) unsigned NOT NULL,
  `estimate_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=317 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `estimates_lines`
--

CREATE TABLE IF NOT EXISTS `estimates_lines` (
  `id` int(11) unsigned NOT NULL,
  `estimate_id` int(11) unsigned NOT NULL,
  `estimates_sections_id` int(11) unsigned NOT NULL,
  `technology_id` int(11) unsigned DEFAULT '0',
  `position_id` int(11) unsigned NOT NULL,
  `line_number` int(11) NOT NULL DEFAULT '1',
  `line` text NOT NULL,
  `hours_min` float unsigned DEFAULT '0',
  `hours_max` float unsigned DEFAULT '0',
  `created_user_id` int(11) unsigned NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=1186 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `estimates_sections`
--

CREATE TABLE IF NOT EXISTS `estimates_sections` (
  `id` int(11) unsigned NOT NULL,
  `estimate_id` int(11) unsigned NOT NULL,
  `estimates_sheet_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=195 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `estimates_sheets`
--

CREATE TABLE IF NOT EXISTS `estimates_sheets` (
  `id` int(11) unsigned NOT NULL,
  `estimate_id` int(11) unsigned NOT NULL,
  `title` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE IF NOT EXISTS `permissions` (
  `id` int(11) unsigned NOT NULL,
  `subject_class` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `positions`
--

CREATE TABLE IF NOT EXISTS `positions` (
  `id` int(11) unsigned NOT NULL,
  `technology_id` int(11) unsigned NOT NULL,
  `complexity` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL,
  `is_am` tinyint(4) NOT NULL DEFAULT '0',
  `is_pdm` tinyint(4) NOT NULL DEFAULT '0',
  `is_rated` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=91 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `client_id` int(11) unsigned NOT NULL,
  `project_status_id` int(11) unsigned NOT NULL,
  `account_manager_user_id` int(11) unsigned NOT NULL DEFAULT '0',
  `production_manager_user_id` int(11) unsigned DEFAULT '0',
  `project_owner_user_id` int(11) unsigned DEFAULT '0',
  `start_date_scheduled` timestamp NULL DEFAULT NULL,
  `start_date_actual` timestamp NULL DEFAULT NULL,
  `end_date_scheduled` timestamp NULL DEFAULT NULL,
  `end_date_actual` timestamp NULL DEFAULT NULL,
  `internal_yn` tinyint(1) NOT NULL DEFAULT '0',
  `rejection_reasons` text,
  `created_user_id` int(11) unsigned NOT NULL,
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `projects_comments`
--

CREATE TABLE IF NOT EXISTS `projects_comments` (
  `id` int(11) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `comment` text,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `projects_requests`
--

CREATE TABLE IF NOT EXISTS `projects_requests` (
  `id` int(11) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `request` text,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `projects_technologies`
--

CREATE TABLE IF NOT EXISTS `projects_technologies` (
  `id` int(11) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `technology_id` int(11) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=78 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `project_statuses`
--

CREATE TABLE IF NOT EXISTS `project_statuses` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(50) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rates`
--

CREATE TABLE IF NOT EXISTS `rates` (
  `id` int(11) unsigned NOT NULL,
  `currency_id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `modified_user_id` int(11) NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `rates_prices`
--

CREATE TABLE IF NOT EXISTS `rates_prices` (
  `id` int(11) unsigned NOT NULL,
  `rate_id` int(11) unsigned NOT NULL,
  `engagement_model_id` int(11) unsigned NOT NULL,
  `technology_id` int(11) unsigned NOT NULL,
  `position_id` int(11) unsigned NOT NULL,
  `daily_rate` decimal(13,4) NOT NULL,
  `hourly_rate` decimal(13,4) NOT NULL,
  `modified_user_id` int(11) unsigned NOT NULL,
  `modified_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=508 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `schema_migrations`
--

CREATE TABLE IF NOT EXISTS `schema_migrations` (
  `version` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `technologies`
--

CREATE TABLE IF NOT EXISTS `technologies` (
  `id` int(11) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `style` varchar(25) DEFAULT NULL,
  `is_rated` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(10) unsigned NOT NULL,
  `username` varchar(150) NOT NULL,
  `password_digest` varchar(255) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `remember_token` varchar(255) NOT NULL,
  `technology_id` int(11) unsigned NOT NULL,
  `position_id` int(11) unsigned NOT NULL,
  `client_id` int(11) unsigned NOT NULL,
  `is_pdm` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_am` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `created_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_modified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB AUTO_INCREMENT=208 DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `users_permissions`
--

CREATE TABLE IF NOT EXISTS `users_permissions` (
  `id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `permission_id` int(11) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `casestudies`
--
ALTER TABLE `casestudies`
  ADD PRIMARY KEY (`id`), ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `casestudy_challenges`
--
ALTER TABLE `casestudy_challenges`
  ADD PRIMARY KEY (`id`), ADD KEY `case_study_id` (`case_study_id`);

--
-- Indexes for table `casestudy_links`
--
ALTER TABLE `casestudy_links`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `casestudy_overviews`
--
ALTER TABLE `casestudy_overviews`
  ADD PRIMARY KEY (`id`), ADD KEY `case_study_id` (`case_study_id`);

--
-- Indexes for table `casestudy_solutions`
--
ALTER TABLE `casestudy_solutions`
  ADD PRIMARY KEY (`id`), ADD KEY `case_study_id` (`case_study_id`);

--
-- Indexes for table `casestudy_technologies`
--
ALTER TABLE `casestudy_technologies`
  ADD PRIMARY KEY (`id`), ADD KEY `case_study_id` (`case_study_id`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `currencies`
--
ALTER TABLE `currencies`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `currencies_exchanges`
--
ALTER TABLE `currencies_exchanges`
  ADD PRIMARY KEY (`id`), ADD KEY `from_currency_id` (`from_currency_id`), ADD KEY `to_currency_id` (`to_currency_id`);

--
-- Indexes for table `engagement_models`
--
ALTER TABLE `engagement_models`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `estimates`
--
ALTER TABLE `estimates`
  ADD PRIMARY KEY (`id`), ADD KEY `project_id` (`project_id`), ADD KEY `client_id` (`client_id`), ADD KEY `owner_user_id` (`owner_user_id`), ADD KEY `rate_id` (`rate_id`), ADD KEY `engagement_model_id` (`engagement_model_id`);

--
-- Indexes for table `estimates_assumptions`
--
ALTER TABLE `estimates_assumptions`
  ADD PRIMARY KEY (`id`), ADD KEY `estimate_id` (`estimate_id`);

--
-- Indexes for table `estimates_lines`
--
ALTER TABLE `estimates_lines`
  ADD PRIMARY KEY (`id`), ADD KEY `estimate_id` (`estimate_id`), ADD KEY `technology_id` (`technology_id`), ADD KEY `estimates_sections_id` (`estimates_sections_id`), ADD KEY `position_id` (`position_id`);

--
-- Indexes for table `estimates_sections`
--
ALTER TABLE `estimates_sections`
  ADD PRIMARY KEY (`id`), ADD KEY `estimate_id` (`estimate_id`), ADD KEY `estimates_sheet_id` (`estimates_sheet_id`);

--
-- Indexes for table `estimates_sheets`
--
ALTER TABLE `estimates_sheets`
  ADD PRIMARY KEY (`id`), ADD KEY `estimate_id` (`estimate_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `positions`
--
ALTER TABLE `positions`
  ADD PRIMARY KEY (`id`), ADD KEY `technology_id` (`technology_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`id`), ADD KEY `client_id` (`client_id`), ADD KEY `account_manager_user_id` (`account_manager_user_id`), ADD KEY `production_manager_user_id` (`production_manager_user_id`), ADD KEY `project_owner_user_id` (`project_owner_user_id`), ADD KEY `project_status_id` (`project_status_id`);

--
-- Indexes for table `projects_comments`
--
ALTER TABLE `projects_comments`
  ADD PRIMARY KEY (`id`), ADD KEY `project_id` (`project_id`), ADD KEY `modified_user_id` (`modified_user_id`);

--
-- Indexes for table `projects_requests`
--
ALTER TABLE `projects_requests`
  ADD PRIMARY KEY (`id`), ADD KEY `project_id` (`project_id`), ADD KEY `modified_user_id` (`modified_user_id`);

--
-- Indexes for table `projects_technologies`
--
ALTER TABLE `projects_technologies`
  ADD PRIMARY KEY (`id`), ADD KEY `project_id` (`project_id`), ADD KEY `technology_id` (`technology_id`);

--
-- Indexes for table `project_statuses`
--
ALTER TABLE `project_statuses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rates`
--
ALTER TABLE `rates`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rates_prices`
--
ALTER TABLE `rates_prices`
  ADD PRIMARY KEY (`id`), ADD KEY `technology_id` (`technology_id`), ADD KEY `modified_user_id` (`modified_user_id`), ADD KEY `position_id` (`position_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `schema_migrations`
--
ALTER TABLE `schema_migrations`
  ADD UNIQUE KEY `unique_schema_migrations` (`version`);

--
-- Indexes for table `technologies`
--
ALTER TABLE `technologies`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `title` (`title`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `username` (`username`), ADD KEY `technology_id` (`technology_id`), ADD KEY `position_id` (`position_id`), ADD KEY `client_id` (`client_id`);

--
-- Indexes for table `users_permissions`
--
ALTER TABLE `users_permissions`
  ADD PRIMARY KEY (`id`), ADD KEY `user_id` (`user_id`), ADD KEY `permission_id` (`permission_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `casestudies`
--
ALTER TABLE `casestudies`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `casestudy_challenges`
--
ALTER TABLE `casestudy_challenges`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `casestudy_links`
--
ALTER TABLE `casestudy_links`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `casestudy_overviews`
--
ALTER TABLE `casestudy_overviews`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=46;
--
-- AUTO_INCREMENT for table `casestudy_solutions`
--
ALTER TABLE `casestudy_solutions`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `casestudy_technologies`
--
ALTER TABLE `casestudy_technologies`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `clients`
--
ALTER TABLE `clients`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=182;
--
-- AUTO_INCREMENT for table `currencies`
--
ALTER TABLE `currencies`
  MODIFY `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `currencies_exchanges`
--
ALTER TABLE `currencies_exchanges`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=49;
--
-- AUTO_INCREMENT for table `engagement_models`
--
ALTER TABLE `engagement_models`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `estimates`
--
ALTER TABLE `estimates`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=26;
--
-- AUTO_INCREMENT for table `estimates_assumptions`
--
ALTER TABLE `estimates_assumptions`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=317;
--
-- AUTO_INCREMENT for table `estimates_lines`
--
ALTER TABLE `estimates_lines`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1186;
--
-- AUTO_INCREMENT for table `estimates_sections`
--
ALTER TABLE `estimates_sections`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=195;
--
-- AUTO_INCREMENT for table `estimates_sheets`
--
ALTER TABLE `estimates_sheets`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `positions`
--
ALTER TABLE `positions`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=91;
--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=24;
--
-- AUTO_INCREMENT for table `projects_comments`
--
ALTER TABLE `projects_comments`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `projects_requests`
--
ALTER TABLE `projects_requests`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `projects_technologies`
--
ALTER TABLE `projects_technologies`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=78;
--
-- AUTO_INCREMENT for table `project_statuses`
--
ALTER TABLE `project_statuses`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `rates`
--
ALTER TABLE `rates`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `rates_prices`
--
ALTER TABLE `rates_prices`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=508;
--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `technologies`
--
ALTER TABLE `technologies`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=48;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=208;
--
-- AUTO_INCREMENT for table `users_permissions`
--
ALTER TABLE `users_permissions`
  MODIFY `id` int(11) unsigned NOT NULL AUTO_INCREMENT;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_accountmanager` FOREIGN KEY (`account_manager_user_id`) REFERENCES `users` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_projects_clients` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_projects_projects_statuses` FOREIGN KEY (`project_status_id`) REFERENCES `project_statuses` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
