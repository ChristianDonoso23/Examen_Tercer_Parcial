-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: eduhack
-- ------------------------------------------------------
-- Server version	5.5.5-10.4.32-MariaDB

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
-- Table structure for table `equipo_participantes`
--

DROP TABLE IF EXISTS `equipo_participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo_participantes` (
  `equipo_id` varchar(50) NOT NULL,
  `participante_id` varchar(50) NOT NULL,
  `rol_en_equipo` varchar(100) DEFAULT 'miembro',
  PRIMARY KEY (`equipo_id`,`participante_id`),
  KEY `participante_id` (`participante_id`),
  CONSTRAINT `equipo_participantes_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `equipo_participantes_ibfk_2` FOREIGN KEY (`participante_id`) REFERENCES `participantes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipo_participantes`
--

/*!40000 ALTER TABLE `equipo_participantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipo_participantes` ENABLE KEYS */;

--
-- Table structure for table `equipo_retos`
--

DROP TABLE IF EXISTS `equipo_retos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo_retos` (
  `equipo_id` varchar(50) NOT NULL,
  `reto_id` varchar(50) NOT NULL,
  `estado` enum('asignado','en_progreso','completado','abandonado') DEFAULT 'asignado',
  `progreso_porcentaje` int(11) DEFAULT 0,
  PRIMARY KEY (`equipo_id`,`reto_id`),
  KEY `reto_id` (`reto_id`),
  CONSTRAINT `equipo_retos_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id`) ON DELETE CASCADE,
  CONSTRAINT `equipo_retos_ibfk_2` FOREIGN KEY (`reto_id`) REFERENCES `retos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipo_retos`
--

/*!40000 ALTER TABLE `equipo_retos` DISABLE KEYS */;
/*!40000 ALTER TABLE `equipo_retos` ENABLE KEYS */;

--
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `hackathon_id` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `hackathon_id` (`hackathon_id`),
  CONSTRAINT `equipos_ibfk_1` FOREIGN KEY (`hackathon_id`) REFERENCES `hackathons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos`
--

/*!40000 ALTER TABLE `equipos` DISABLE KEYS */;
INSERT INTO `equipos` VALUES ('eq1','Equipo Alfa','hack1'),('eq2','Equipo Beta','hack2');
/*!40000 ALTER TABLE `equipos` ENABLE KEYS */;

--
-- Table structure for table `estudiantes`
--

DROP TABLE IF EXISTS `estudiantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudiantes` (
  `id` varchar(50) NOT NULL,
  `grado` enum('6','7','8','9','10','11','12') NOT NULL,
  `institucion` varchar(255) NOT NULL,
  `tiempo_disponible_semanal` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `estudiantes_ibfk_1` FOREIGN KEY (`id`) REFERENCES `participantes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estudiantes`
--

/*!40000 ALTER TABLE `estudiantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `estudiantes` ENABLE KEYS */;

--
-- Table structure for table `hackathons`
--

DROP TABLE IF EXISTS `hackathons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hackathons` (
  `id` varchar(50) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `lugar` varchar(255) DEFAULT NULL,
  `estado` enum('planificado','activo','finalizado') DEFAULT 'planificado',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hackathons`
--

/*!40000 ALTER TABLE `hackathons` DISABLE KEYS */;
INSERT INTO `hackathons` VALUES ('hack1','Hackathon Escolar','Evento para estudiantes','2025-08-20','2025-08-22','Colegio Central','planificado'),('hack2','Hackathon IA','Desafíos de inteligencia artificial','2025-09-10','2025-09-12','Universidad Técnica','activo');
/*!40000 ALTER TABLE `hackathons` ENABLE KEYS */;

--
-- Table structure for table `mentores_tecnicos`
--

DROP TABLE IF EXISTS `mentores_tecnicos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mentores_tecnicos` (
  `id` varchar(50) NOT NULL,
  `especialidad` enum('Desarrollo Web','Desarrollo Mobile','Inteligencia Artificial','Data Science','UI/UX Design','Backend','Frontend') NOT NULL,
  `experiencia` int(11) NOT NULL,
  `disponibilidad_horaria` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `mentores_tecnicos_ibfk_1` FOREIGN KEY (`id`) REFERENCES `participantes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mentores_tecnicos`
--

/*!40000 ALTER TABLE `mentores_tecnicos` DISABLE KEYS */;
/*!40000 ALTER TABLE `mentores_tecnicos` ENABLE KEYS */;

--
-- Table structure for table `participante_habilidades`
--

DROP TABLE IF EXISTS `participante_habilidades`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participante_habilidades` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `participante_id` varchar(50) NOT NULL,
  `habilidad` enum('JavaScript','Python','Java','HTML','CSS','React','Node.js','PHP','MySQL','Git','UI/UX','Figma','Machine Learning','IA','Mobile','Android','iOS','Unity','Photoshop') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `participante_id` (`participante_id`),
  CONSTRAINT `participante_habilidades_ibfk_1` FOREIGN KEY (`participante_id`) REFERENCES `participantes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participante_habilidades`
--

/*!40000 ALTER TABLE `participante_habilidades` DISABLE KEYS */;
/*!40000 ALTER TABLE `participante_habilidades` ENABLE KEYS */;

--
-- Table structure for table `participantes`
--

DROP TABLE IF EXISTS `participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `participantes` (
  `id` varchar(50) NOT NULL,
  `tipo` enum('estudiante','mentorTecnico') NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `nivel_habilidad` enum('basico','intermedio','avanzado') NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participantes`
--

/*!40000 ALTER TABLE `participantes` DISABLE KEYS */;
INSERT INTO `participantes` VALUES ('est1','estudiante','Ana Torres','ana1@correo.com','basico'),('est2','estudiante','Luis Pérez','luis2@correo.com','intermedio'),('est3','estudiante','María López','maria3@correo.com','avanzado'),('est4','estudiante','Carlos Ruiz','carlos4@correo.com','intermedio'),('est5','estudiante','Sofía Díaz','sofia5@correo.com','basico'),('men1','mentorTecnico','Pedro Gómez','pedro1@correo.com','avanzado'),('men2','mentorTecnico','Lucía Fernández','lucia2@correo.com','intermedio'),('men3','mentorTecnico','Javier Castro','javier3@correo.com','basico'),('men4','mentorTecnico','Marta Salas','marta4@correo.com','intermedio'),('men5','mentorTecnico','Diego Rivas','diego5@correo.com','avanzado');
/*!40000 ALTER TABLE `participantes` ENABLE KEYS */;

--
-- Table structure for table `reto_areas_conocimiento`
--

DROP TABLE IF EXISTS `reto_areas_conocimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reto_areas_conocimiento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `reto_id` varchar(50) NOT NULL,
  `area_conocimiento` enum('Desarrollo Web','Desarrollo Mobile','Inteligencia Artificial','UI/UX Design','Base de datos','Geolocalización','Medioambiente','Sostenibilidad','Educación','Salud','Ecología','Simulación') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `reto_id` (`reto_id`),
  CONSTRAINT `reto_areas_conocimiento_ibfk_1` FOREIGN KEY (`reto_id`) REFERENCES `retos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reto_areas_conocimiento`
--

/*!40000 ALTER TABLE `reto_areas_conocimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `reto_areas_conocimiento` ENABLE KEYS */;

--
-- Table structure for table `retos`
--

DROP TABLE IF EXISTS `retos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retos` (
  `id` varchar(50) NOT NULL,
  `tipo` enum('retoReal','retoExperimental') NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `complejidad` enum('facil','media','dificil') NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retos`
--

/*!40000 ALTER TABLE `retos` DISABLE KEYS */;
INSERT INTO `retos` VALUES ('reto1','retoReal','App de Reciclaje','Crear una app para fomentar el reciclaje.','media'),('reto2','retoExperimental','Simulación Solar','Simular el uso de energía solar en escuelas.','dificil'),('reto3','retoReal','Plataforma de Tutorías','Desarrollar una plataforma para tutorías online.','facil');
/*!40000 ALTER TABLE `retos` ENABLE KEYS */;

--
-- Table structure for table `retos_experimentales`
--

DROP TABLE IF EXISTS `retos_experimentales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retos_experimentales` (
  `id` varchar(50) NOT NULL,
  `enfoque_pedagogico` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `retos_experimentales_ibfk_1` FOREIGN KEY (`id`) REFERENCES `retos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retos_experimentales`
--

/*!40000 ALTER TABLE `retos_experimentales` DISABLE KEYS */;
/*!40000 ALTER TABLE `retos_experimentales` ENABLE KEYS */;

--
-- Table structure for table `retos_reales`
--

DROP TABLE IF EXISTS `retos_reales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `retos_reales` (
  `id` varchar(50) NOT NULL,
  `entidad_colaboradora` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `retos_reales_ibfk_1` FOREIGN KEY (`id`) REFERENCES `retos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `retos_reales`
--

/*!40000 ALTER TABLE `retos_reales` DISABLE KEYS */;
/*!40000 ALTER TABLE `retos_reales` ENABLE KEYS */;

--
-- Dumping routines for database 'eduhack'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_participante_equipo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_participante_equipo`(
    IN p_equipo_id VARCHAR(50),
    IN p_participante_id VARCHAR(50),
    IN p_rol_en_equipo VARCHAR(100)
)
BEGIN
    INSERT INTO equipo_participantes (equipo_id, participante_id, rol_en_equipo)
    VALUES (p_equipo_id, p_participante_id, p_rol_en_equipo)
    ON DUPLICATE KEY UPDATE rol_en_equipo = p_rol_en_equipo;
    
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_add_reto_equipo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_reto_equipo`(
    IN p_equipo_id VARCHAR(50),
    IN p_reto_id VARCHAR(50),
    IN p_estado ENUM('asignado', 'en_progreso', 'completado', 'abandonado'),
    IN p_progreso_porcentaje INT
)
BEGIN
    INSERT INTO equipo_retos (equipo_id, reto_id, estado, progreso_porcentaje)
    VALUES (p_equipo_id, p_reto_id, p_estado, p_progreso_porcentaje)
    ON DUPLICATE KEY UPDATE 
        estado = p_estado,
        progreso_porcentaje = p_progreso_porcentaje;
    
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_equipo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_equipo`(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_hackathon_id VARCHAR(50)
)
BEGIN
    INSERT INTO equipos (id, nombre, hackathon_id)
    VALUES (p_id, p_nombre, p_hackathon_id);
    
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_estudiante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_estudiante`(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_nivel_habilidad ENUM('basico', 'intermedio', 'avanzado'),
    IN p_grado ENUM('6', '7', '8', '9', '10', '11', '12'),
    IN p_institucion VARCHAR(255),
    IN p_tiempo_disponible_semanal INT,
    IN p_habilidades JSON
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE habilidad_item VARCHAR(100);
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(p_habilidades, CONCAT('$[', idx, ']')))
        FROM (SELECT 0 AS idx UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t
        WHERE JSON_EXTRACT(p_habilidades, CONCAT('$[', idx, ']')) IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO participantes (id, tipo, nombre, email, nivel_habilidad)
    VALUES (p_id, 'estudiante', p_nombre, p_email, p_nivel_habilidad);

    INSERT INTO estudiantes (id, grado, institucion, tiempo_disponible_semanal)
    VALUES (p_id, p_grado, p_institucion, p_tiempo_disponible_semanal);

    -- Insertar habilidades
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO habilidad_item;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO participante_habilidades (participante_id, habilidad)
        VALUES (p_id, habilidad_item);
    END LOOP;
    CLOSE cur;

    COMMIT;
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_hackathon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_hackathon`(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_lugar VARCHAR(255),
    IN p_estado ENUM('planificado', 'activo', 'finalizado')
)
BEGIN
    INSERT INTO hackathons (id, nombre, descripcion, fecha_inicio, fecha_fin, lugar, estado)
    VALUES (p_id, p_nombre, p_descripcion, p_fecha_inicio, p_fecha_fin, p_lugar, p_estado);
    
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_mentor_tecnico` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_mentor_tecnico`(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_nivel_habilidad ENUM('basico', 'intermedio', 'avanzado'),
    IN p_especialidad ENUM('Desarrollo Web', 'Desarrollo Mobile', 'Inteligencia Artificial', 'Data Science', 'UI/UX Design', 'Backend', 'Frontend'),
    IN p_experiencia INT,
    IN p_disponibilidad_horaria VARCHAR(255),
    IN p_habilidades JSON
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE habilidad_item VARCHAR(100);
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(p_habilidades, CONCAT('$[', idx, ']')))
        FROM (SELECT 0 AS idx UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t
        WHERE JSON_EXTRACT(p_habilidades, CONCAT('$[', idx, ']')) IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO participantes (id, tipo, nombre, email, nivel_habilidad)
    VALUES (p_id, 'mentorTecnico', p_nombre, p_email, p_nivel_habilidad);

    INSERT INTO mentores_tecnicos (id, especialidad, experiencia, disponibilidad_horaria)
    VALUES (p_id, p_especialidad, p_experiencia, p_disponibilidad_horaria);

    -- Insertar habilidades
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO habilidad_item;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO participante_habilidades (participante_id, habilidad)
        VALUES (p_id, habilidad_item);
    END LOOP;
    CLOSE cur;

    COMMIT;
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_reto_experimental` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_reto_experimental`(
    IN p_id VARCHAR(50),
    IN p_titulo VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_complejidad ENUM('facil', 'media', 'dificil'),
    IN p_enfoque_pedagogico VARCHAR(255),
    IN p_areas_conocimiento JSON
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE area_item VARCHAR(100);
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(p_areas_conocimiento, CONCAT('$[', idx, ']')))
        FROM (SELECT 0 AS idx UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t
        WHERE JSON_EXTRACT(p_areas_conocimiento, CONCAT('$[', idx, ']')) IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO retos (id, tipo, titulo, descripcion, complejidad)
    VALUES (p_id, 'retoExperimental', p_titulo, p_descripcion, p_complejidad);

    INSERT INTO retos_experimentales (id, enfoque_pedagogico)
    VALUES (p_id, p_enfoque_pedagogico);

    -- Insertar áreas de conocimiento
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO area_item;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO reto_areas_conocimiento (reto_id, area_conocimiento)
        VALUES (p_id, area_item);
    END LOOP;
    CLOSE cur;

    COMMIT;
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_create_reto_real` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_create_reto_real`(
    IN p_id VARCHAR(50),
    IN p_titulo VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_complejidad ENUM('facil', 'media', 'dificil'),
    IN p_entidad_colaboradora VARCHAR(255),
    IN p_areas_conocimiento JSON
)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE area_item VARCHAR(100);
    DECLARE cur CURSOR FOR 
        SELECT JSON_UNQUOTE(JSON_EXTRACT(p_areas_conocimiento, CONCAT('$[', idx, ']')))
        FROM (SELECT 0 AS idx UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) t
        WHERE JSON_EXTRACT(p_areas_conocimiento, CONCAT('$[', idx, ']')) IS NOT NULL;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO retos (id, tipo, titulo, descripcion, complejidad)
    VALUES (p_id, 'retoReal', p_titulo, p_descripcion, p_complejidad);

    INSERT INTO retos_reales (id, entidad_colaboradora)
    VALUES (p_id, p_entidad_colaboradora);

    -- Insertar áreas de conocimiento
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO area_item;
        IF done THEN
            LEAVE read_loop;
        END IF;
        INSERT INTO reto_areas_conocimiento (reto_id, area_conocimiento)
        VALUES (p_id, area_item);
    END LOOP;
    CLOSE cur;

    COMMIT;
    SELECT p_id AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_equipo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_equipo`(IN p_id VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM equipo_participantes WHERE equipo_id = p_id;
    DELETE FROM equipo_retos WHERE equipo_id = p_id;
    DELETE FROM equipos WHERE id = p_id;

    COMMIT;
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_hackathon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_hackathon`(IN p_id VARCHAR(50))
BEGIN
    DELETE FROM hackathons WHERE id = p_id;
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_participante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_participante`(IN p_id VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM participante_habilidades WHERE participante_id = p_id;
    DELETE FROM estudiantes WHERE id = p_id;
    DELETE FROM mentores_tecnicos WHERE id = p_id;
    DELETE FROM participantes WHERE id = p_id;

    COMMIT;
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_delete_reto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_reto`(IN p_id VARCHAR(50))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM reto_areas_conocimiento WHERE reto_id = p_id;
    DELETE FROM retos_reales WHERE id = p_id;
    DELETE FROM retos_experimentales WHERE id = p_id;
    DELETE FROM retos WHERE id = p_id;

    COMMIT;
    SELECT 1 AS OK;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_equipos_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_equipos_list`()
BEGIN
    SELECT 
        e.id,
        e.nombre,
        e.hackathon_id,
        h.nombre AS hackathon_nombre,
        COUNT(DISTINCT ep.participante_id) AS total_participantes,
        COUNT(DISTINCT er.reto_id) AS total_retos
    FROM equipos e
    LEFT JOIN hackathons h ON e.hackathon_id = h.id
    LEFT JOIN equipo_participantes ep ON e.id = ep.equipo_id
    LEFT JOIN equipo_retos er ON e.id = er.equipo_id
    GROUP BY e.id
    ORDER BY e.nombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_find_equipo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_equipo`(IN p_id VARCHAR(50))
BEGIN
    SELECT 
        e.id,
        e.nombre,
        e.hackathon_id,
        h.nombre AS hackathon_nombre,
        -- Participantes
        GROUP_CONCAT(DISTINCT CONCAT(p.id, ':', p.nombre) SEPARATOR ';') AS participantes,
        -- Retos
        GROUP_CONCAT(DISTINCT CONCAT(r.id, ':', r.titulo) SEPARATOR ';') AS retos
    FROM equipos e
    LEFT JOIN hackathons h ON e.hackathon_id = h.id
    LEFT JOIN equipo_participantes ep ON e.id = ep.equipo_id
    LEFT JOIN participantes p ON ep.participante_id = p.id
    LEFT JOIN equipo_retos er ON e.id = er.equipo_id
    LEFT JOIN retos r ON er.reto_id = r.id
    WHERE e.id = p_id
    GROUP BY e.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_find_hackathon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_hackathon`(IN p_id VARCHAR(50))
BEGIN
    SELECT 
        id,
        nombre,
        descripcion,
        fecha_inicio,
        fecha_fin,
        lugar,
        estado
    FROM hackathons
    WHERE id = p_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_find_participante` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_participante`(IN p_id VARCHAR(50))
BEGIN
    SELECT 
        p.id,
        p.tipo,
        p.nombre,
        p.email,
        p.nivel_habilidad,
        GROUP_CONCAT(ph.habilidad) AS habilidades,
        -- Campos específicos de estudiantes
        CASE WHEN p.tipo = 'estudiante' THEN e.grado END AS grado,
        CASE WHEN p.tipo = 'estudiante' THEN e.institucion END AS institucion,
        CASE WHEN p.tipo = 'estudiante' THEN e.tiempo_disponible_semanal END AS tiempo_disponible_semanal,
        -- Campos específicos de mentores
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.especialidad END AS especialidad,
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.experiencia END AS experiencia,
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.disponibilidad_horaria END AS disponibilidad_horaria
    FROM participantes p
    LEFT JOIN participante_habilidades ph ON p.id = ph.participante_id
    LEFT JOIN estudiantes e ON p.id = e.id AND p.tipo = 'estudiante'
    LEFT JOIN mentores_tecnicos mt ON p.id = mt.id AND p.tipo = 'mentorTecnico'
    WHERE p.id = p_id
    GROUP BY p.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_find_reto` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_find_reto`(IN p_id VARCHAR(50))
BEGIN
    SELECT 
        r.id,
        r.tipo,
        r.titulo,
        r.descripcion,
        r.complejidad,
        GROUP_CONCAT(rac.area_conocimiento) AS areas_conocimiento,
        -- Campos específicos de retos reales
        CASE WHEN r.tipo = 'retoReal' THEN rr.entidad_colaboradora END AS entidad_colaboradora,
        -- Campos específicos de retos experimentales
        CASE WHEN r.tipo = 'retoExperimental' THEN re.enfoque_pedagogico END AS enfoque_pedagogico
    FROM retos r
    LEFT JOIN reto_areas_conocimiento rac ON r.id = rac.reto_id
    LEFT JOIN retos_reales rr ON r.id = rr.id AND r.tipo = 'retoReal'
    LEFT JOIN retos_experimentales re ON r.id = re.id AND r.tipo = 'retoExperimental'
    WHERE r.id = p_id
    GROUP BY r.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_hackathons_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_hackathons_list`()
BEGIN
    SELECT 
        id,
        nombre,
        descripcion,
        fecha_inicio,
        fecha_fin,
        lugar,
        estado
    FROM hackathons
    ORDER BY fecha_inicio DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_participantes_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_participantes_list`()
BEGIN
    SELECT 
        p.id,
        p.tipo,
        p.nombre,
        p.email,
        p.nivel_habilidad,
        GROUP_CONCAT(ph.habilidad) AS habilidades,
        -- Campos específicos de estudiantes
        CASE WHEN p.tipo = 'estudiante' THEN e.grado END AS grado,
        CASE WHEN p.tipo = 'estudiante' THEN e.institucion END AS institucion,
        CASE WHEN p.tipo = 'estudiante' THEN e.tiempo_disponible_semanal END AS tiempo_disponible_semanal,
        -- Campos específicos de mentores
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.especialidad END AS especialidad,
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.experiencia END AS experiencia,
        CASE WHEN p.tipo = 'mentorTecnico' THEN mt.disponibilidad_horaria END AS disponibilidad_horaria
    FROM participantes p
    LEFT JOIN participante_habilidades ph ON p.id = ph.participante_id
    LEFT JOIN estudiantes e ON p.id = e.id AND p.tipo = 'estudiante'
    LEFT JOIN mentores_tecnicos mt ON p.id = mt.id AND p.tipo = 'mentorTecnico'
    GROUP BY p.id
    ORDER BY p.nombre;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_retos_list` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_retos_list`()
BEGIN
    SELECT 
        r.id,
        r.tipo,
        r.titulo,
        r.descripcion,
        r.complejidad,
        GROUP_CONCAT(rac.area_conocimiento) AS areas_conocimiento,
        -- Campos específicos de retos reales
        CASE WHEN r.tipo = 'retoReal' THEN rr.entidad_colaboradora END AS entidad_colaboradora,
        -- Campos específicos de retos experimentales
        CASE WHEN r.tipo = 'retoExperimental' THEN re.enfoque_pedagogico END AS enfoque_pedagogico
    FROM retos r
    LEFT JOIN reto_areas_conocimiento rac ON r.id = rac.reto_id
    LEFT JOIN retos_reales rr ON r.id = rr.id AND r.tipo = 'retoReal'
    LEFT JOIN retos_experimentales re ON r.id = re.id AND r.tipo = 'retoExperimental'
    GROUP BY r.id
    ORDER BY r.titulo;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_hackathon` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'IGNORE_SPACE,NO_ZERO_IN_DATE,NO_ZERO_DATE,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_hackathon`(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_descripcion TEXT,
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_lugar VARCHAR(255),
    IN p_estado ENUM('planificado', 'activo', 'finalizado')
)
BEGIN
    UPDATE hackathons
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin,
        lugar = p_lugar,
        estado = p_estado
    WHERE id = p_id;
    
    SELECT ROW_COUNT() AS affected_rows;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-08-14 19:00:02
