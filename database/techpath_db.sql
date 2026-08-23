-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: techpath_db
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `feedback`
--

DROP TABLE IF EXISTS `feedback`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `clarity_rating` tinyint NOT NULL,
  `usefulness_rating` tinyint NOT NULL,
  `changed_decision` tinyint(1) NOT NULL DEFAULT '0',
  `message` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`),
  KEY `fk_feedback_student` (`student_id`),
  CONSTRAINT `fk_feedback_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_clarity_rating` CHECK ((`clarity_rating` between 1 and 5)),
  CONSTRAINT `chk_usefulness_rating` CHECK ((`usefulness_rating` between 1 and 5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `feedback`
--

LOCK TABLES `feedback` WRITE;
/*!40000 ALTER TABLE `feedback` DISABLE KEYS */;
/*!40000 ALTER TABLE `feedback` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mini_tasks`
--

DROP TABLE IF EXISTS `mini_tasks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mini_tasks` (
  `task_id` int NOT NULL AUTO_INCREMENT,
  `track_id` int NOT NULL,
  `task_title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `task_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_a` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_b` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_c` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `option_d` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correct_option` enum('A','B','C','D') COLLATE utf8mb4_unicode_ci NOT NULL,
  `explanation` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`task_id`),
  KEY `fk_tasks_track` (`track_id`),
  CONSTRAINT `fk_tasks_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mini_tasks`
--

LOCK TABLES `mini_tasks` WRITE;
/*!40000 ALTER TABLE `mini_tasks` DISABLE KEYS */;
INSERT INTO `mini_tasks` VALUES (1,1,'Design an AI Customer Email Workflow','A company receives hundreds of customer emails every day. Your task is to choose the best automated workflow that reads each email, classifies it as a complaint, inquiry, or purchase request, saves the result, and notifies the correct team.','Receive the email, notify every team, delete the message, and ask the AI to classify it later.','Receive the email, send its text to an AI model, classify the message, save the result, and notify the correct team.','Save a random category, forward the email to one employee, and wait for manual review.','Reply manually to every email without using automation or artificial intelligence.','B','Option B is correct because an effective AI automation workflow starts with a trigger, sends the email content to an AI model, classifies the message, stores the structured result, and routes the request to the appropriate team.',1),(2,3,'Choose the Best Data Science Approach','A company wants to understand why customers are leaving and predict which customers may leave next. Choose the best approach for solving this problem.','Create a website and ask customers to manually report whether they will leave.','Collect customer data, clean and explore it, select useful features, build a predictive model, evaluate it, and communicate the findings.','Delete incomplete customer records and make a decision based only on personal opinion.','Use a random formula without checking the quality of the data or the model.','B','Option B is correct because a complete data science workflow includes collecting and preparing data, exploring patterns, selecting features, building and evaluating a model, and communicating actionable results.',1),(3,4,'Select the Best Machine Learning Model','A business wants to predict whether a loan applicant is likely to repay a loan. Choose the best machine learning process.','Train a model using unprepared data and deploy it without evaluation.','Choose the model only because it is the most complex algorithm available.','Prepare labeled historical data, split it into training and testing sets, train several models, compare their performance, and select the most suitable one.','Predict the result manually without using historical data.','C','Option C is correct because supervised machine learning requires labeled data, proper preprocessing, training and testing separation, model comparison, and evaluation before deployment.',1),(4,7,'Respond to a Suspicious Login Attempt','A company detects repeated failed login attempts followed by a successful login from an unfamiliar location. Choose the safest response.','Ignore the activity because the login was eventually successful.','Disable all company systems permanently.','Investigate the logs, temporarily secure the account, verify the user, reset credentials if needed, and review related activity for signs of compromise.','Publish the user password so the team can check it.','C','Option C is correct because cybersecurity incident response should contain the threat, verify the event, protect the account, investigate related activity, and document the incident without exposing sensitive information.',1),(5,8,'Design a Reliable Deployment Workflow','A development team wants every approved code change to be tested and deployed consistently. Choose the best Cloud and DevOps workflow.','Upload files manually to the production server without testing.','Push code to version control, run automated tests, build the application, deploy through a controlled pipeline, and monitor the service.','Deploy every unfinished change directly to production.','Keep the code only on one developer computer and avoid backups.','B','Option B is correct because a reliable DevOps workflow uses version control, automated testing, continuous integration, controlled deployment, and monitoring to reduce errors and improve delivery.',1),(6,2,'Analyze a Drop in Monthly Sales','A company notices that monthly sales decreased compared with the previous month. Choose the best data analysis process to understand the reason.','Look at one number only and immediately assume the marketing team caused the decline.','Collect the relevant sales data, clean it, compare periods, segment results by product and region, visualize patterns, and summarize the main findings.','Delete the data and ask employees to guess the cause.','Create a chart without checking whether the data is complete or accurate.','B','Option B is correct because data analysis requires preparing the data, comparing relevant periods, examining useful segments, visualizing patterns, and communicating evidence-based findings.',1),(7,5,'Build a Reliable Registration Form','A website needs a student registration form that saves valid information and gives clear feedback. Choose the best development approach.','Accept every value without validation and store the database password inside the HTML file.','Build the form with HTML and CSS, validate the inputs, send the data to the server, use parameterized SQL, handle errors, and show a success response.','Save the registration information only in the browser console.','Allow the user to submit the form even when all required fields are empty.','B','Option B is correct because a reliable web application validates user input, sends it securely to the backend, uses safe database queries, handles errors, and provides clear feedback.',1),(8,6,'Improve a Confusing Checkout Screen','Users frequently leave an online checkout page before completing payment. Choose the best UI/UX process to improve the experience.','Change the colors randomly without studying the problem.','Add more fields and instructions to make the checkout page longer.','Study user behavior, identify usability problems, simplify the flow, create a prototype, test it with users, and improve the design based on feedback.','Copy another website exactly without considering the users or business requirements.','C','Option C is correct because UI/UX design is based on understanding users, identifying friction, simplifying the journey, prototyping solutions, testing them, and iterating from evidence.',1);
/*!40000 ALTER TABLE `mini_tasks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_dimension_weights`
--

DROP TABLE IF EXISTS `question_dimension_weights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_dimension_weights` (
  `question_id` int NOT NULL,
  `dimension_id` int NOT NULL,
  `weight_value` decimal(4,2) NOT NULL,
  PRIMARY KEY (`question_id`,`dimension_id`),
  KEY `fk_question_dimension` (`dimension_id`),
  CONSTRAINT `fk_dimension_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_question_dimension` FOREIGN KEY (`dimension_id`) REFERENCES `strength_dimensions` (`dimension_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_dimension_weights`
--

LOCK TABLES `question_dimension_weights` WRITE;
/*!40000 ALTER TABLE `question_dimension_weights` DISABLE KEYS */;
INSERT INTO `question_dimension_weights` VALUES (1,1,2.00),(1,3,3.00),(2,1,2.00),(2,2,3.00),(3,4,3.00),(4,5,3.00),(5,1,2.00),(5,5,3.00),(6,3,3.00),(7,2,1.00),(7,5,3.00),(8,4,3.00),(9,1,2.00),(9,3,3.00),(10,2,3.00),(10,4,1.00),(11,2,2.00),(11,3,3.00),(12,1,3.00),(12,5,1.00),(13,1,1.00),(13,3,3.00),(14,4,3.00),(15,1,1.00),(15,5,3.00),(16,2,1.00),(16,5,3.00);
/*!40000 ALTER TABLE `question_dimension_weights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question_weights`
--

DROP TABLE IF EXISTS `question_weights`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `question_weights` (
  `weight_id` int NOT NULL AUTO_INCREMENT,
  `question_id` int NOT NULL,
  `track_id` int NOT NULL,
  `weight_value` decimal(5,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`weight_id`),
  UNIQUE KEY `uq_question_track` (`question_id`,`track_id`),
  KEY `fk_weights_track` (`track_id`),
  CONSTRAINT `fk_weights_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_weights_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_weight_value` CHECK ((`weight_value` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question_weights`
--

LOCK TABLES `question_weights` WRITE;
/*!40000 ALTER TABLE `question_weights` DISABLE KEYS */;
INSERT INTO `question_weights` VALUES (1,1,2,3.00),(2,1,3,2.00),(3,1,4,2.00),(4,2,5,3.00),(5,2,4,2.00),(6,2,8,2.00),(7,3,6,3.00),(8,3,5,1.00),(10,4,1,3.00),(11,4,8,2.00),(13,5,7,3.00),(14,5,8,1.00),(16,6,2,3.00),(17,6,3,2.00),(19,7,8,3.00),(20,7,7,1.00),(22,8,6,3.00),(23,8,5,1.00),(25,9,4,3.00),(26,9,3,3.00),(27,9,2,1.00),(28,10,5,3.00),(29,10,6,1.00),(31,11,4,3.00),(32,11,3,3.00),(33,11,1,1.00),(34,12,8,3.00),(35,12,7,2.00),(36,12,5,1.00),(37,13,2,3.00),(38,13,3,2.00),(40,14,6,3.00),(41,14,5,1.00),(43,15,7,3.00),(44,15,2,1.00),(46,16,1,3.00),(47,16,8,2.00),(48,16,5,1.00);
/*!40000 ALTER TABLE `question_weights` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `questions` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `question_text` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `question_order` int NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`question_id`),
  UNIQUE KEY `question_order` (`question_order`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `questions`
--

LOCK TABLES `questions` WRITE;
/*!40000 ALTER TABLE `questions` DISABLE KEYS */;
INSERT INTO `questions` VALUES (1,'I enjoy examining numbers and finding patterns that help explain a problem.',1,1),(2,'I enjoy writing code and solving technical problems step by step.',2,1),(3,'I care about how digital products look and how easy they are to use.',3,1),(4,'I like finding faster ways to complete repetitive tasks automatically.',4,1),(5,'I am interested in discovering risks and protecting systems from threats.',5,1),(6,'I enjoy turning raw information into clear charts and useful conclusions.',6,1),(7,'I am interested in servers, cloud systems, deployment, and how applications stay online.',7,1),(8,'I enjoy understanding people needs before designing a solution.',8,1),(9,'I am comfortable learning mathematical concepts to solve technical problems.',9,1),(10,'I would enjoy building websites or web applications that people can interact with.',10,1),(11,'I am curious about how systems can learn from data and make predictions.',11,1),(12,'I stay patient when diagnosing a technical problem with several possible causes.',12,1),(13,'I like using evidence and data to support business decisions.',13,1),(14,'I pay attention to colors, typography, spacing, and visual consistency.',14,1),(15,'I enjoy investigating unusual activity and identifying its cause.',15,1),(16,'I enjoy connecting different tools together to create one complete workflow.',16,1);
/*!40000 ALTER TABLE `questions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_answers`
--

DROP TABLE IF EXISTS `quiz_answers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_answers` (
  `answer_id` int NOT NULL AUTO_INCREMENT,
  `attempt_id` int NOT NULL,
  `question_id` int NOT NULL,
  `answer_value` tinyint NOT NULL,
  PRIMARY KEY (`answer_id`),
  UNIQUE KEY `uq_attempt_question` (`attempt_id`,`question_id`),
  KEY `fk_answers_question` (`question_id`),
  CONSTRAINT `fk_answers_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempts` (`attempt_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions` (`question_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_answer_value` CHECK ((`answer_value` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_answers`
--

LOCK TABLES `quiz_answers` WRITE;
/*!40000 ALTER TABLE `quiz_answers` DISABLE KEYS */;
INSERT INTO `quiz_answers` VALUES (1,1,1,1),(2,1,2,3),(3,1,3,1),(4,1,4,1),(5,1,5,4),(6,1,6,3),(7,1,7,2),(8,1,8,5),(9,1,9,4),(10,1,10,3),(11,1,11,5),(12,1,12,4),(13,1,13,4),(14,1,14,3),(15,1,15,3),(16,1,16,4),(17,2,1,4),(18,2,2,4),(19,2,3,3),(20,2,4,4),(21,2,5,3),(22,2,6,2),(23,2,7,5),(24,2,8,1),(25,2,9,3),(26,2,10,4),(27,2,11,2),(28,2,12,5),(29,2,13,2),(30,2,14,2),(31,2,15,4),(32,2,16,3),(33,3,1,4),(34,3,2,3),(35,3,3,3),(36,3,4,4),(37,3,5,5),(38,3,6,4),(39,3,7,1),(40,3,8,4),(41,3,9,4),(42,3,10,3),(43,3,11,4),(44,3,12,4),(45,3,13,5),(46,3,14,3),(47,3,15,4),(48,3,16,4),(49,4,1,2),(50,4,2,4),(51,4,3,4),(52,4,4,4),(53,4,5,4),(54,4,6,3),(55,4,7,2),(56,4,8,4),(57,4,9,4),(58,4,10,3),(59,4,11,5),(60,4,12,4),(61,4,13,4),(62,4,14,3),(63,4,15,4),(64,4,16,4),(65,5,1,2),(66,5,2,4),(67,5,3,3),(68,5,4,2),(69,5,5,3),(70,5,6,4),(71,5,7,2),(72,5,8,4),(73,5,9,3),(74,5,10,3),(75,5,11,4),(76,5,12,4),(77,5,13,3),(78,5,14,5),(79,5,15,1),(80,5,16,4);
/*!40000 ALTER TABLE `quiz_answers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_attempts`
--

DROP TABLE IF EXISTS `quiz_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_attempts` (
  `attempt_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `status` enum('In Progress','Completed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'In Progress',
  `started_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `completed_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`attempt_id`),
  KEY `fk_attempts_student` (`student_id`),
  CONSTRAINT `fk_attempts_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_attempts`
--

LOCK TABLES `quiz_attempts` WRITE;
/*!40000 ALTER TABLE `quiz_attempts` DISABLE KEYS */;
INSERT INTO `quiz_attempts` VALUES (1,4,'Completed','2026-07-31 15:46:51','2026-07-31 15:46:51'),(2,4,'Completed','2026-07-31 16:13:47','2026-07-31 16:13:47'),(3,4,'Completed','2026-07-31 16:15:55','2026-07-31 16:15:55'),(4,4,'Completed','2026-07-31 16:18:05','2026-07-31 16:18:05'),(5,5,'Completed','2026-08-01 00:33:48','2026-08-01 00:33:48');
/*!40000 ALTER TABLE `quiz_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `quiz_scores`
--

DROP TABLE IF EXISTS `quiz_scores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quiz_scores` (
  `score_id` int NOT NULL AUTO_INCREMENT,
  `attempt_id` int NOT NULL,
  `track_id` int NOT NULL,
  `score` decimal(8,2) NOT NULL DEFAULT '0.00',
  `match_percentage` decimal(5,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`score_id`),
  UNIQUE KEY `uq_attempt_track_score` (`attempt_id`,`track_id`),
  KEY `fk_scores_track` (`track_id`),
  CONSTRAINT `fk_scores_attempt` FOREIGN KEY (`attempt_id`) REFERENCES `quiz_attempts` (`attempt_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_scores_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_match_percentage` CHECK ((`match_percentage` between 0 and 100)),
  CONSTRAINT `chk_score` CHECK ((`score` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `quiz_scores`
--

LOCK TABLES `quiz_scores` WRITE;
/*!40000 ALTER TABLE `quiz_scores` DISABLE KEYS */;
INSERT INTO `quiz_scores` VALUES (1,1,3,43.00,71.67),(2,1,8,38.00,58.46),(3,1,4,35.00,70.00),(4,1,5,35.00,63.64),(5,1,2,31.00,56.36),(6,1,7,31.00,68.89),(7,1,6,30.00,60.00),(8,1,1,20.00,57.14),(9,2,8,55.00,84.62),(10,2,5,38.00,69.09),(11,2,7,36.00,80.00),(12,2,2,31.00,56.36),(13,2,3,31.00,51.67),(14,2,4,31.00,62.00),(15,2,1,23.00,65.71),(16,2,6,22.00,44.00),(17,3,3,50.00,83.33),(18,3,2,47.00,85.45),(19,3,8,42.00,64.62),(20,3,4,38.00,76.00),(21,3,5,36.00,65.45),(22,3,7,36.00,80.00),(23,3,6,33.00,66.00),(24,3,1,28.00,80.00),(25,4,8,46.00,70.77),(26,4,3,45.00,75.00),(27,4,5,40.00,72.73),(28,4,4,39.00,78.00),(29,4,6,36.00,72.00),(30,4,2,35.00,63.64),(31,4,7,34.00,75.56),(32,4,1,29.00,82.86),(33,5,5,41.00,74.55),(34,5,8,41.00,63.08),(35,5,3,39.00,65.00),(36,5,6,39.00,78.00),(37,5,4,33.00,66.00),(38,5,2,31.00,56.36),(39,5,1,22.00,62.86),(40,5,7,22.00,48.89);
/*!40000 ALTER TABLE `quiz_scores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `strength_dimensions`
--

DROP TABLE IF EXISTS `strength_dimensions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `strength_dimensions` (
  `dimension_id` int NOT NULL AUTO_INCREMENT,
  `dimension_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `dimension_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`dimension_id`),
  UNIQUE KEY `dimension_name` (`dimension_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `strength_dimensions`
--

LOCK TABLES `strength_dimensions` WRITE;
/*!40000 ALTER TABLE `strength_dimensions` DISABLE KEYS */;
INSERT INTO `strength_dimensions` VALUES (1,'Logic & Problem Solving','Interest in patterns, diagnosis, reasoning, and solving structured problems.'),(2,'Programming Interest','Interest in coding, software development, and building technical applications.'),(3,'Data Orientation','Interest in numbers, evidence, analysis, statistics, and data-driven decisions.'),(4,'Creativity & User Thinking','Interest in visual design, user needs, usability, and creative digital experiences.'),(5,'Automation & Systems Thinking','Interest in workflows, tools, systems, infrastructure, automation, and integration.');
/*!40000 ALTER TABLE `strength_dimensions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `faculty` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `study_year` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `experience_level` enum('Beginner','Intermediate','Advanced') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Beginner',
  `initial_track_id` int DEFAULT NULL,
  `final_track_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `email` (`email`),
  KEY `fk_students_initial_track` (`initial_track_id`),
  KEY `fk_students_final_track` (`final_track_id`),
  CONSTRAINT `fk_students_final_track` FOREIGN KEY (`final_track_id`) REFERENCES `tracks` (`track_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_students_initial_track` FOREIGN KEY (`initial_track_id`) REFERENCES `tracks` (`track_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'c','fg@gmail.com','dc','Second Year','Beginner',5,NULL,'2026-07-31 13:24:14'),(2,'Rewan','rewan@gmail.com','Electronic Engineering','First Year','Intermediate',NULL,NULL,'2026-07-31 13:33:06'),(3,'hossam','hossam@gmail.com','Electronic Engineering','First Year','Intermediate',5,NULL,'2026-07-31 13:49:58'),(4,'Rewan1','rewan1@gmail.com','Electronic Engineering','First Year','Intermediate',NULL,NULL,'2026-07-31 15:45:00'),(5,'final_test1','final_test1@gmail.com','Electronic Engineering','Third Year','Intermediate',NULL,NULL,'2026-08-01 00:33:12');
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `task_attempts`
--

DROP TABLE IF EXISTS `task_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `task_attempts` (
  `task_attempt_id` int NOT NULL AUTO_INCREMENT,
  `student_id` int NOT NULL,
  `task_id` int NOT NULL,
  `selected_option` enum('A','B','C','D') COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `enjoyment_rating` tinyint NOT NULL,
  `wants_to_continue` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`task_attempt_id`),
  KEY `fk_task_attempts_student` (`student_id`),
  KEY `fk_task_attempts_task` (`task_id`),
  CONSTRAINT `fk_task_attempts_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_task_attempts_task` FOREIGN KEY (`task_id`) REFERENCES `mini_tasks` (`task_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_enjoyment_rating` CHECK ((`enjoyment_rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_attempts`
--

LOCK TABLES `task_attempts` WRITE;
/*!40000 ALTER TABLE `task_attempts` DISABLE KEYS */;
INSERT INTO `task_attempts` VALUES (1,4,1,'B',1,4,1,'2026-07-31 18:01:53'),(2,4,1,'B',1,4,1,'2026-07-31 20:03:10'),(3,5,8,'B',0,2,1,'2026-08-01 00:37:09');
/*!40000 ALTER TABLE `task_attempts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_job_roles`
--

DROP TABLE IF EXISTS `track_job_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_job_roles` (
  `job_role_id` int NOT NULL AUTO_INCREMENT,
  `track_id` int NOT NULL,
  `job_role_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`job_role_id`),
  UNIQUE KEY `unique_track_job_role` (`track_id`,`job_role_name`),
  CONSTRAINT `fk_track_job_roles_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_job_roles`
--

LOCK TABLES `track_job_roles` WRITE;
/*!40000 ALTER TABLE `track_job_roles` DISABLE KEYS */;
INSERT INTO `track_job_roles` VALUES (2,1,'AI Agent Developer'),(1,1,'AI Automation Engineer'),(6,1,'AI Integration Engineer'),(3,1,'AI Solutions Engineer'),(5,1,'Intelligent Process Automation Engineer'),(7,1,'Prompt Engineer'),(8,1,'Technical AI Consultant'),(4,1,'Workflow Automation Engineer'),(18,2,'Business Data Analyst'),(17,2,'Business Intelligence Analyst'),(16,2,'Data Analyst'),(21,2,'Financial Data Analyst'),(23,2,'Junior BI Developer'),(20,2,'Marketing Data Analyst'),(22,2,'Operations Analyst'),(19,2,'Reporting Analyst'),(38,3,'Analytics Scientist'),(34,3,'Applied Data Scientist'),(39,3,'Data Science Consultant'),(32,3,'Data Scientist'),(36,3,'Decision Scientist'),(33,3,'Junior Data Scientist'),(35,3,'Product Data Scientist'),(37,3,'Research Data Scientist'),(50,4,'AI Engineer'),(49,4,'Applied Machine Learning Engineer'),(52,4,'Computer Vision Engineer'),(48,4,'Junior Machine Learning Engineer'),(47,4,'Machine Learning Engineer'),(51,4,'MLOps Engineer'),(54,4,'Model Deployment Engineer'),(53,4,'NLP Engineer'),(69,5,'API Developer'),(63,5,'Back-End Developer'),(62,5,'Front-End Developer'),(64,5,'Full-Stack Developer'),(65,5,'JavaScript Developer'),(68,5,'Junior Software Developer'),(66,5,'Node.js Developer'),(67,5,'Web Application Developer'),(84,6,'Design System Designer'),(82,6,'Interaction Designer'),(85,6,'Junior Product Designer'),(80,6,'Product Designer'),(78,6,'UI Designer'),(79,6,'UX Designer'),(81,6,'UX Researcher'),(83,6,'Visual Designer'),(93,7,'Cybersecurity Analyst'),(98,7,'Incident Response Analyst'),(96,7,'Information Security Analyst'),(99,7,'Junior Penetration Tester'),(100,7,'Security Engineer'),(95,7,'Security Operations Analyst'),(94,7,'SOC Analyst'),(97,7,'Vulnerability Assessment Analyst'),(109,8,'Cloud Engineer'),(111,8,'Cloud Operations Engineer'),(108,8,'DevOps Engineer'),(114,8,'Infrastructure Engineer'),(110,8,'Junior DevOps Engineer'),(113,8,'Platform Engineer'),(115,8,'Release Engineer'),(112,8,'Site Reliability Engineer');
/*!40000 ALTER TABLE `track_job_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_roadmap_steps`
--

DROP TABLE IF EXISTS `track_roadmap_steps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_roadmap_steps` (
  `step_id` int NOT NULL AUTO_INCREMENT,
  `track_id` int NOT NULL,
  `step_number` int NOT NULL,
  `step_title` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `step_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`step_id`),
  UNIQUE KEY `uq_track_step_number` (`track_id`,`step_number`),
  CONSTRAINT `fk_roadmap_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_roadmap_steps`
--

LOCK TABLES `track_roadmap_steps` WRITE;
/*!40000 ALTER TABLE `track_roadmap_steps` DISABLE KEYS */;
INSERT INTO `track_roadmap_steps` VALUES (1,1,1,'AI Foundations','Understand artificial intelligence, machine learning concepts, large language models, generative AI, responsible AI, and common business use cases.'),(2,1,2,'Programming Foundations','Learn Python fundamentals, problem solving, JSON, Git, GitHub, and the basic programming skills needed to build automation solutions.'),(3,1,3,'Prompt Engineering','Learn structured prompting, context design, prompt chaining, output formatting, evaluation, safety, and building reliable prompts for business tasks.'),(4,1,4,'APIs and Integrations','Understand REST APIs, HTTP methods, authentication, JSON requests, webhooks, and how different applications exchange data.'),(5,1,5,'Workflow Automation','Build automated workflows using n8n, Make, and Zapier, including triggers, actions, filters, branching, error handling, and data transformation.'),(6,1,6,'AI Agent Foundations','Learn how AI agents observe tasks, reason, plan, use tools, store memory, and complete multi-step objectives with limited human intervention.'),(7,1,7,'Agent Frameworks','Build agentic applications using LangChain, LangGraph, CrewAI, OpenAI SDK, and model APIs such as Gemini and Claude.'),(8,1,8,'RAG and Knowledge Systems','Learn embeddings, vector databases, document processing, retrieval-augmented generation, and connecting agents to private knowledge sources.'),(9,1,9,'Multi-Agent Systems','Design coordinated agent teams with specialized roles, task delegation, shared context, communication, and workflow supervision.'),(10,1,10,'Testing and Production Deployment','Test workflows and agents, handle failures, monitor costs and performance, secure credentials, use Docker, and deploy solutions to cloud platforms.'),(11,1,11,'Portfolio and Business Projects','Build projects such as a customer support agent, research assistant, email automation system, document assistant, CRM workflow, and meeting assistant.'),(16,2,1,'Data Analysis Foundations','Understand the role of data analysis, common business questions, data types, structured and unstructured data, and the complete analysis lifecycle.'),(17,2,2,'Excel and Spreadsheet Analysis','Learn formulas, functions, sorting, filtering, lookup functions, pivot tables, charts, data validation, and spreadsheet-based reporting.'),(18,2,3,'Database and SQL Foundations','Learn relational databases, tables, primary and foreign keys, SELECT statements, filtering, joins, aggregation, grouping, and subqueries.'),(19,2,4,'Statistics for Data Analysis','Understand mean, median, mode, variance, standard deviation, distributions, correlation, percentages, sampling, and interpreting statistical results.'),(20,2,5,'Python for Data Analysis','Learn Python fundamentals and use NumPy and Pandas to load, inspect, filter, transform, group, merge, and summarize datasets.'),(21,2,6,'Data Cleaning and Preparation','Handle missing values, duplicates, incorrect data types, inconsistent categories, outliers, invalid records, and create analysis-ready datasets.'),(22,2,7,'Exploratory Data Analysis','Investigate datasets using summary statistics, filtering, grouping, segmentation, distributions, trends, relationships, and business-focused questions.'),(23,2,8,'Data Visualization','Create clear charts using Excel, Matplotlib, Power BI, or Tableau and select the appropriate visual for comparisons, trends, distributions, and relationships.'),(24,2,9,'Dashboard Development','Build interactive dashboards with KPIs, filters, drill-downs, calculated measures, navigation, and layouts designed for business users.'),(25,2,10,'Data Storytelling and Communication','Turn analytical findings into clear conclusions, explain business impact, create reports, present recommendations, and communicate limitations responsibly.'),(26,2,11,'Portfolio Projects','Build end-to-end projects such as sales analysis, customer behavior analysis, financial dashboards, marketing performance reports, and operational KPI dashboards.'),(32,3,1,'Data Science Foundations','Understand the data science lifecycle, types of data science problems, business objectives, analytical thinking, and how data-driven solutions create value.'),(33,3,2,'Python Programming','Learn Python syntax, variables, conditions, loops, functions, data structures, object-oriented programming, exceptions, modules, and writing reusable code.'),(34,3,3,'Mathematics and Statistics','Study descriptive statistics, probability, distributions, sampling, confidence intervals, hypothesis testing, correlation, linear algebra, and basic calculus concepts.'),(35,3,4,'SQL and Data Access','Learn relational databases, joins, grouping, subqueries, window functions, database extraction, and combining data from multiple sources.'),(36,3,5,'Data Preparation','Use Pandas and NumPy to load, clean, transform, merge, reshape, validate, and prepare structured datasets for analysis and modeling.'),(37,3,6,'Exploratory Data Analysis','Investigate distributions, trends, relationships, segments, outliers, missing values, and potential explanatory variables using statistical and visual methods.'),(38,3,7,'Feature Engineering','Create useful model inputs through encoding, scaling, transformation, aggregation, selection, dimensionality reduction, and domain-informed feature creation.'),(39,3,8,'Machine Learning Foundations','Learn supervised and unsupervised learning, regression, classification, clustering, model assumptions, training workflows, and avoiding data leakage.'),(40,3,9,'Model Evaluation and Experimentation','Evaluate models using suitable metrics, cross-validation, baselines, error analysis, hyperparameter tuning, experiment tracking, and business-focused interpretation.'),(41,3,10,'Communication and Data Products','Present findings through visualizations, reports, notebooks, dashboards, business recommendations, reproducible analysis, and clear explanations for stakeholders.'),(42,3,11,'Deployment and Portfolio Projects','Build complete projects such as customer churn prediction, demand forecasting, recommendation analysis, fraud detection, customer segmentation, and deploy selected models.'),(47,4,1,'Programming and Data Foundations','Learn Python, NumPy, Pandas, data structures, functions, object-oriented programming, data loading, cleaning, transformation, and version control.'),(48,4,2,'Mathematics for Machine Learning','Study linear algebra, probability, statistics, derivatives, gradients, optimization concepts, vectors, matrices, and loss functions.'),(49,4,3,'Data Preprocessing','Handle missing values, duplicates, outliers, categorical variables, scaling, normalization, train-test splitting, and data leakage prevention.'),(50,4,4,'Supervised Learning','Learn regression and classification algorithms including linear regression, logistic regression, decision trees, random forests, support vector machines, and nearest neighbors.'),(51,4,5,'Unsupervised Learning','Learn clustering, dimensionality reduction, anomaly detection, principal component analysis, and methods for discovering hidden structures in data.'),(52,4,6,'Feature Engineering and Selection','Create, transform, encode, scale, select, and reduce features using statistical methods, domain knowledge, and reusable preprocessing pipelines.'),(53,4,7,'Model Evaluation','Use regression and classification metrics, confusion matrices, ROC curves, precision, recall, F1-score, cross-validation, baselines, and error analysis.'),(54,4,8,'Model Optimization','Improve performance through hyperparameter tuning, grid search, randomized search, regularization, ensemble methods, class balancing, and threshold adjustment.'),(55,4,9,'Deep Learning Foundations','Understand neural networks, activation functions, backpropagation, training loops, CNNs, RNNs, transformers, TensorFlow, and PyTorch fundamentals.'),(56,4,10,'Deployment and MLOps','Package models, create prediction APIs, use Docker, track experiments with MLflow, manage model versions, automate pipelines, and monitor production performance.'),(57,4,11,'Portfolio Projects','Build projects such as loan risk prediction, fraud detection, image classification, sentiment analysis, recommendation systems, customer churn prediction, and model deployment APIs.'),(62,5,1,'Web Foundations','Understand how websites work, browsers, servers, HTTP, domain names, hosting, front-end development, back-end development, and full-stack architecture.'),(63,5,2,'HTML','Learn semantic HTML, page structure, headings, links, images, lists, tables, forms, multimedia, accessibility basics, and clean document organization.'),(64,5,3,'CSS and Responsive Design','Learn selectors, box model, colors, typography, positioning, Flexbox, Grid, transitions, media queries, reusable components, and responsive layouts.'),(65,5,4,'JavaScript Fundamentals','Learn variables, data types, conditions, loops, functions, arrays, objects, scope, error handling, modules, and writing reusable JavaScript code.'),(66,5,5,'Browser Programming','Work with the DOM, events, forms, validation, local storage, fetch requests, asynchronous JavaScript, JSON, and dynamic user interfaces.'),(67,5,6,'Front-End Frameworks','Learn component-based development, state, props, routing, reusable interfaces, API integration, and application structure using React or a similar framework.'),(68,5,7,'Backend Development','Build servers with Node.js and Express, create routes, handle requests and responses, use middleware, validate input, and organize backend applications.'),(69,5,8,'Databases and APIs','Learn relational databases, SQL, table relationships, CRUD operations, parameterized queries, REST APIs, data validation, and database integration.'),(70,5,9,'Authentication and Security','Implement registration, login, password hashing, sessions or tokens, role-based access, secure environment variables, input sanitization, and common web security practices.'),(71,5,10,'Testing and Deployment','Debug applications, test routes and interfaces, manage Git branches, configure production settings, deploy applications, connect hosted databases, and monitor errors.'),(72,5,11,'Portfolio Projects','Build projects such as a registration system, task manager, e-commerce application, learning platform, booking system, dashboard, and complete full-stack application.'),(78,6,1,'UI/UX Foundations','Understand the difference between user interface and user experience design, human-centered design, product thinking, usability, accessibility, and the design process.'),(79,6,2,'User Research','Learn research planning, interviews, surveys, observation, competitor analysis, identifying user needs, and organizing qualitative and quantitative findings.'),(80,6,3,'Personas and Journey Mapping','Create evidence-based personas, empathy maps, user scenarios, journey maps, pain points, goals, and opportunity areas.'),(81,6,4,'Information Architecture','Organize content, create navigation structures, develop sitemaps, use card sorting, define labels, and make information easy to find.'),(82,6,5,'User Flows and Wireframes','Design task flows, screen flows, low-fidelity wireframes, page structures, interaction states, and clear paths for completing user goals.'),(83,6,6,'Visual Design Foundations','Learn layout, spacing, alignment, hierarchy, typography, color theory, contrast, grids, icons, visual consistency, and responsive interface principles.'),(84,6,7,'Figma and Interactive Prototyping','Use frames, components, auto layout, variants, constraints, libraries, interactive prototypes, animations, and responsive design features in Figma.'),(85,6,8,'Usability Testing','Plan usability tests, create tasks, observe user behavior, identify friction, analyze findings, prioritize problems, and improve designs through iteration.'),(86,6,9,'Accessibility and Inclusive Design','Design for different abilities, follow accessibility principles, improve keyboard navigation, color contrast, readability, form clarity, and error feedback.'),(87,6,10,'Design Systems and Developer Handoff','Build reusable components, tokens, patterns, documentation, consistent libraries, specifications, and collaborate effectively with developers.'),(88,6,11,'Portfolio Case Studies','Build detailed case studies showing the problem, research, user flows, wireframes, design decisions, prototype, testing results, iterations, and final solution.'),(93,7,1,'Cybersecurity Foundations','Understand confidentiality, integrity, availability, security controls, attack surfaces, threats, vulnerabilities, risks, and common cybersecurity roles.'),(94,7,2,'Networking Fundamentals','Learn IP addressing, TCP and UDP, ports, protocols, DNS, HTTP, routing, firewalls, network segmentation, and how data moves across networks.'),(95,7,3,'Operating Systems and Linux','Learn Windows and Linux fundamentals, file systems, users, permissions, processes, command-line tools, services, logs, and system hardening.'),(96,7,4,'Security Monitoring and Logs','Collect and analyze logs, recognize suspicious patterns, understand SIEM concepts, create alerts, investigate events, and document findings.'),(97,7,5,'Threats and Attack Techniques','Study phishing, malware, password attacks, privilege escalation, lateral movement, social engineering, denial-of-service attacks, and common attacker behavior.'),(98,7,6,'Vulnerability Assessment','Learn asset discovery, port scanning, service identification, vulnerability scanning, severity classification, validation, prioritization, and remediation reporting.'),(99,7,7,'Web Application Security','Understand authentication flaws, access-control problems, injection, cross-site scripting, insecure configuration, session risks, and OWASP security principles.'),(100,7,8,'Identity and Access Management','Learn authentication, authorization, least privilege, multifactor authentication, password policies, account lifecycle management, and role-based access control.'),(101,7,9,'Incident Response','Follow preparation, detection, analysis, containment, eradication, recovery, evidence preservation, communication, and post-incident review processes.'),(102,7,10,'Ethical Hacking and Security Labs','Practice legally in controlled labs using reconnaissance, scanning, vulnerability validation, exploitation fundamentals, reporting, and responsible disclosure principles.'),(103,7,11,'Portfolio and Security Projects','Build projects such as a home security lab, log-analysis dashboard, vulnerability report, incident-response case study, network monitoring exercise, and secure configuration guide.'),(108,8,1,'Cloud and DevOps Foundations','Understand cloud computing, DevOps culture, software delivery, environments, infrastructure, automation, reliability, and collaboration between development and operations.'),(109,8,2,'Linux and Command Line','Learn Linux file systems, users, permissions, processes, services, packages, logs, networking commands, Bash scripting, and system administration fundamentals.'),(110,8,3,'Networking Fundamentals','Learn IP addressing, DNS, HTTP, ports, protocols, routing, load balancing, firewalls, private networks, and communication between distributed services.'),(111,8,4,'Git and Collaborative Development','Use Git repositories, branches, pull requests, merge strategies, release tags, code reviews, and collaborative workflows with GitHub.'),(112,8,5,'Continuous Integration and Delivery','Create automated pipelines that install dependencies, run tests, build applications, validate changes, manage environments, and deploy approved releases.'),(113,8,6,'Docker and Containerization','Build Docker images, write Dockerfiles, manage containers, networks, volumes, environment variables, registries, and multi-container applications.'),(114,8,7,'Kubernetes and Orchestration','Learn pods, deployments, services, configuration, secrets, scaling, health checks, namespaces, rolling updates, and container orchestration concepts.'),(115,8,8,'Cloud Platforms','Work with cloud compute, storage, databases, networking, identity, monitoring, managed services, permissions, and cost awareness on AWS or Azure.'),(116,8,9,'Infrastructure as Code','Use Terraform to define reusable infrastructure, manage state, create modules, review infrastructure changes, and provision consistent environments.'),(117,8,10,'Monitoring, Logging, and Reliability','Collect metrics and logs, create dashboards and alerts, investigate incidents, define service health, monitor performance, and improve reliability with Prometheus and Grafana.'),(118,8,11,'Portfolio and Deployment Projects','Build projects such as a CI/CD pipeline, Dockerized web application, cloud-hosted service, Terraform infrastructure, Kubernetes deployment, and monitoring dashboard.');
/*!40000 ALTER TABLE `track_roadmap_steps` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_skills`
--

DROP TABLE IF EXISTS `track_skills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_skills` (
  `skill_id` int NOT NULL AUTO_INCREMENT,
  `track_id` int NOT NULL,
  `skill_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`skill_id`),
  UNIQUE KEY `unique_track_skill` (`track_id`,`skill_name`),
  CONSTRAINT `fk_track_skills_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_skills`
--

LOCK TABLES `track_skills` WRITE;
/*!40000 ALTER TABLE `track_skills` DISABLE KEYS */;
INSERT INTO `track_skills` VALUES (10,1,'AI agents'),(1,1,'AI fundamentals'),(5,1,'JSON'),(2,1,'LLM basics'),(11,1,'Memory and planning'),(3,1,'Prompt engineering'),(4,1,'Python'),(12,1,'RAG'),(6,1,'REST APIs'),(14,1,'Testing and deployment'),(9,1,'Tool calling'),(13,1,'Vector databases'),(7,1,'Webhooks'),(8,1,'Workflow design'),(27,2,'Business analysis'),(24,2,'Dashboard design'),(16,2,'Data cleaning'),(17,2,'Data preparation'),(29,2,'Data storytelling'),(26,2,'Data validation'),(23,2,'Data visualization'),(25,2,'Descriptive statistics'),(19,2,'Excel analysis'),(18,2,'Exploratory data analysis'),(22,2,'Pandas'),(21,2,'Python fundamentals'),(28,2,'Report writing'),(20,2,'SQL querying'),(45,3,'Business problem solving'),(33,3,'Data cleaning'),(43,3,'Data storytelling'),(41,3,'Data visualization'),(44,3,'Experiment design'),(34,3,'Exploratory data analysis'),(38,3,'Feature engineering'),(37,3,'Hypothesis testing'),(39,3,'Machine learning fundamentals'),(40,3,'Model evaluation'),(36,3,'Probability'),(32,3,'Python programming'),(42,3,'SQL querying'),(35,3,'Statistical analysis'),(53,4,'Classification algorithms'),(54,4,'Clustering'),(56,4,'Cross-validation'),(48,4,'Data preprocessing'),(59,4,'Experiment tracking'),(49,4,'Feature engineering'),(57,4,'Hyperparameter tuning'),(58,4,'Model deployment'),(55,4,'Model evaluation'),(60,4,'Model monitoring'),(47,4,'Python programming'),(52,4,'Regression algorithms'),(50,4,'Supervised learning'),(51,4,'Unsupervised learning'),(71,5,'Authentication and authorization'),(68,5,'Backend development'),(63,5,'CSS styling'),(70,5,'Database integration'),(66,5,'DOM manipulation'),(72,5,'Error handling'),(67,5,'Form validation'),(62,5,'HTML structure'),(65,5,'JavaScript programming'),(64,5,'Responsive design'),(69,5,'REST API development'),(74,5,'Testing and debugging'),(73,5,'Version control'),(75,5,'Web deployment'),(90,6,'Accessibility design'),(88,6,'Color systems'),(91,6,'Design systems'),(82,6,'Information architecture'),(80,6,'Persona development'),(85,6,'Prototyping'),(87,6,'Typography'),(89,6,'Usability testing'),(83,6,'User flow design'),(79,6,'User interviews'),(81,6,'User journey mapping'),(78,6,'User research'),(86,6,'Visual design'),(84,6,'Wireframing'),(106,7,'Ethical hacking fundamentals'),(102,7,'Identity and access management'),(101,7,'Incident response'),(94,7,'Linux fundamentals'),(100,7,'Log analysis'),(104,7,'Network security'),(93,7,'Networking fundamentals'),(97,7,'Risk assessment'),(105,7,'Security documentation'),(99,7,'Security monitoring'),(95,7,'Security principles'),(96,7,'Threat identification'),(98,7,'Vulnerability assessment'),(103,7,'Web security'),(116,8,'Cloud infrastructure'),(118,8,'Configuration management'),(115,8,'Container orchestration'),(114,8,'Containerization'),(113,8,'Continuous delivery'),(112,8,'Continuous integration'),(120,8,'Deployment automation'),(117,8,'Infrastructure as code'),(108,8,'Linux administration'),(119,8,'Monitoring and logging'),(109,8,'Networking fundamentals'),(110,8,'Shell scripting'),(121,8,'System reliability'),(111,8,'Version control');
/*!40000 ALTER TABLE `track_skills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `track_tools`
--

DROP TABLE IF EXISTS `track_tools`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `track_tools` (
  `tool_id` int NOT NULL AUTO_INCREMENT,
  `track_id` int NOT NULL,
  `tool_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`tool_id`),
  UNIQUE KEY `unique_track_tool` (`track_id`,`tool_name`),
  CONSTRAINT `fk_track_tools_track` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`track_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `track_tools`
--

LOCK TABLES `track_tools` WRITE;
/*!40000 ALTER TABLE `track_tools` DISABLE KEYS */;
INSERT INTO `track_tools` VALUES (1,1,'ChatGPT'),(2,1,'Claude'),(10,1,'CrewAI'),(13,1,'Docker'),(3,1,'Gemini'),(12,1,'GitHub'),(8,1,'LangChain'),(9,1,'LangGraph'),(6,1,'Make'),(5,1,'n8n'),(11,1,'Postman'),(4,1,'Python'),(14,1,'Supabase'),(7,1,'Zapier'),(27,2,'Google Colab'),(17,2,'Google Sheets'),(26,2,'Jupyter Notebook'),(23,2,'Matplotlib'),(16,2,'Microsoft Excel'),(19,2,'MySQL'),(22,2,'NumPy'),(21,2,'Pandas'),(24,2,'Power BI'),(20,2,'Python'),(18,2,'SQL'),(25,2,'Tableau'),(45,3,'Docker'),(42,3,'Git'),(43,3,'GitHub'),(38,3,'Google Colab'),(37,3,'Jupyter Notebook'),(35,3,'Matplotlib'),(44,3,'MLflow'),(40,3,'MySQL'),(34,3,'NumPy'),(33,3,'Pandas'),(41,3,'Power BI'),(32,3,'Python'),(36,3,'Scikit-learn'),(39,3,'SQL'),(58,4,'Docker'),(59,4,'FastAPI'),(57,4,'GitHub'),(55,4,'Google Colab'),(60,4,'Hugging Face'),(54,4,'Jupyter Notebook'),(56,4,'MLflow'),(48,4,'NumPy'),(49,4,'Pandas'),(47,4,'Python'),(52,4,'PyTorch'),(50,4,'Scikit-learn'),(51,4,'TensorFlow'),(53,4,'XGBoost'),(74,5,'Bootstrap'),(72,5,'Chrome DevTools'),(63,5,'CSS'),(66,5,'Express.js'),(69,5,'Git'),(70,5,'GitHub'),(62,5,'HTML'),(64,5,'JavaScript'),(67,5,'MySQL'),(65,5,'Node.js'),(68,5,'Postman'),(73,5,'React'),(75,5,'Render'),(71,5,'Visual Studio Code'),(80,6,'Adobe XD'),(84,6,'Canva'),(79,6,'FigJam'),(78,6,'Figma'),(85,6,'Google Forms'),(86,6,'Hotjar'),(82,6,'Maze'),(81,6,'Miro'),(83,6,'Notion'),(87,6,'Optimal Workshop'),(89,6,'Stark'),(88,6,'Zeplin'),(97,7,'Burp Suite'),(103,7,'GitHub'),(94,7,'Kali Linux'),(93,7,'Linux'),(98,7,'Metasploit'),(96,7,'Nmap'),(102,7,'OpenVAS'),(101,7,'OWASP ZAP'),(106,7,'PowerShell'),(105,7,'Python'),(100,7,'SIEM'),(99,7,'Splunk'),(104,7,'VirtualBox'),(95,7,'Wireshark'),(119,8,'Ansible'),(116,8,'AWS'),(109,8,'Bash'),(114,8,'Docker'),(110,8,'Git'),(111,8,'GitHub'),(112,8,'GitHub Actions'),(121,8,'Grafana'),(113,8,'Jenkins'),(115,8,'Kubernetes'),(108,8,'Linux'),(117,8,'Microsoft Azure'),(120,8,'Prometheus'),(118,8,'Terraform');
/*!40000 ALTER TABLE `track_tools` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tracks`
--

DROP TABLE IF EXISTS `tracks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tracks` (
  `track_id` int NOT NULL AUTO_INCREMENT,
  `track_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `short_description` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_description` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `skills` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `tools` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `job_roles` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `roadmap` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `coding_level` enum('Low','Medium','High') COLLATE utf8mb4_unicode_ci NOT NULL,
  `math_level` enum('Low','Medium','High') COLLATE utf8mb4_unicode_ci NOT NULL,
  `creativity_level` enum('Low','Medium','High') COLLATE utf8mb4_unicode_ci NOT NULL,
  `data_level` enum('Low','Medium','High') COLLATE utf8mb4_unicode_ci NOT NULL,
  `has_mini_task` tinyint(1) NOT NULL DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`track_id`),
  UNIQUE KEY `track_name` (`track_name`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tracks`
--

LOCK TABLES `tracks` WRITE;
/*!40000 ALTER TABLE `tracks` DISABLE KEYS */;
INSERT INTO `tracks` VALUES (1,'AI & Automation','Build smart workflows that automate repetitive tasks.','AI & Automation combines artificial intelligence, large language models, APIs, workflow automation, and intelligent agents to build systems that can understand tasks, make decisions, use tools, and automate complete business processes.','AI fundamentals, LLM basics, prompt engineering, Python, JSON, REST APIs, webhooks, workflow design, tool calling, AI agents, memory, planning, reasoning, RAG, vector databases, testing, deployment','ChatGPT, Claude, Gemini, Python, n8n, Make, Zapier, LangChain, LangGraph, CrewAI, OpenAI API, Gemini API, Claude API, Postman, GitHub, Docker, Supabase, Pinecone, Chroma','AI Automation Engineer, AI Agent Developer, AI Solutions Engineer, Workflow Automation Engineer, Intelligent Process Automation Engineer, AI Integration Engineer, Prompt Engineer, Technical AI Consultant','AI Foundations and LLM Basics, Prompt Engineering and AI Ethics, Python Programming and JSON, REST APIs and Webhooks, Workflow Automation with n8n Make and Zapier, AI Agents Fundamentals, Tool Calling Memory Planning and Reasoning, Agent Frameworks with LangChain LangGraph and CrewAI, RAG Embeddings and Vector Databases, Multi-Agent Systems, Testing Monitoring and Security, Docker and Cloud Deployment, Portfolio Projects and Real Business Automations','Medium','Low','Medium','Medium',1,1,'2026-07-31 13:13:27'),(2,'Data Analysis','Transform data into meaningful business insights.','Data Analysis focuses on collecting, cleaning, exploring, and interpreting data to discover useful patterns and support business decisions. Data analysts transform raw data into clear reports, dashboards, visualizations, and actionable insights for stakeholders.','Analytical thinking, Excel, SQL, statistics, visualization','Excel, SQL, Python, Power BI','Data Analyst, Business Intelligence Analyst','Learn Excel, SQL, statistics, Python, visualization, and create dashboard projects.','Medium','Medium','Medium','High',1,1,'2026-07-31 13:13:27'),(3,'Data Science','Use data, statistics, and programming to solve complex problems.','Data Science combines programming, statistics, data analysis, machine learning, and business understanding to solve complex problems using data. Data scientists explore large datasets, build predictive models, test hypotheses, communicate findings, and develop data-driven solutions.','Python, statistics, data preparation, experimentation','Python, Pandas, Jupyter, Scikit-learn','Data Scientist, Junior Data Scientist','Learn Python, statistics, data analysis, machine learning, and complete end-to-end projects.','High','High','Medium','High',1,1,'2026-07-31 13:13:27'),(4,'Machine Learning','Create models that learn patterns from data.','Machine Learning focuses on designing, training, evaluating, and deploying models that learn patterns from data and make predictions or decisions. Machine learning engineers work with algorithms, feature engineering, model optimization, experimentation, deployment pipelines, and production monitoring.','Python, mathematics, algorithms, model evaluation','Python, Scikit-learn, TensorFlow, PyTorch','Machine Learning Engineer, AI Engineer','Learn Python, linear algebra, statistics, machine learning algorithms, deep learning, and deployment.','High','High','Medium','High',1,1,'2026-07-31 13:13:27'),(5,'Web Development','Build websites and interactive web applications.','Web Development focuses on building websites and web applications that users can access through browsers. Web developers create responsive interfaces, develop backend logic, connect databases, build APIs, handle user input securely, and deploy complete applications.','Programming, problem solving, responsive design','HTML, CSS, JavaScript, Node.js, MySQL','Front-End Developer, Back-End Developer, Full-Stack Developer','Learn HTML, CSS, JavaScript, Git, a front-end framework, back-end development, and databases.','High','Low','High','Medium',1,1,'2026-07-31 13:13:27'),(6,'UI/UX Design','Design clear and enjoyable digital experiences.','UI/UX Design focuses on understanding users and creating digital products that are useful, clear, accessible, and visually consistent. UI/UX designers research user needs, organize information, design user flows, create wireframes and prototypes, test usability, and collaborate with developers and product teams.','User research, wireframing, visual design, prototyping','Figma, FigJam, Adobe XD','UI Designer, UX Designer, Product Designer','Learn design principles, user research, wireframes, prototypes, usability testing, and portfolio creation.','Low','Low','High','Low',1,1,'2026-07-31 13:13:27'),(7,'Cybersecurity','Protect systems, networks, and information from threats.','Cybersecurity focuses on protecting systems, networks, applications, and data from unauthorized access, misuse, disruption, and cyberattacks. Cybersecurity professionals identify risks, monitor suspicious activity, secure infrastructure, test vulnerabilities, respond to incidents, and help organizations maintain confidentiality, integrity, and availability.','Analytical thinking, networking, risk awareness, investigation','Linux, Wireshark, Nmap, Security tools','Security Analyst, SOC Analyst, Penetration Tester','Learn networking, operating systems, security fundamentals, defensive security, and practical labs.','Medium','Low','Medium','Medium',1,1,'2026-07-31 13:13:27'),(8,'Cloud & DevOps','Build, deploy, and maintain reliable software systems.','Cloud & DevOps focuses on delivering software reliably through automation, cloud infrastructure, continuous integration, continuous delivery, containers, infrastructure as code, monitoring, and collaboration between development and operations teams. Professionals in this field build repeatable deployment pipelines, manage environments, improve system reliability, and automate operational tasks.','Linux, automation, troubleshooting, infrastructure','AWS, Docker, GitHub Actions, Kubernetes','Cloud Engineer, DevOps Engineer, Site Reliability Engineer','Learn Linux, networking, Git, cloud fundamentals, containers, CI/CD, and monitoring.','High','Low','Medium','Medium',1,1,'2026-07-31 13:13:27');
/*!40000 ALTER TABLE `tracks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-08-01  5:06:48
