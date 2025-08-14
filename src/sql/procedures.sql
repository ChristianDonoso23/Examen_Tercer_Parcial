DELIMITER $$

-- =====================================================
-- STORED PROCEDURES PARA PARTICIPANTES
-- =====================================================

-- LISTAR TODOS LOS PARTICIPANTES
CREATE OR REPLACE PROCEDURE sp_participantes_list()
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
END$$

-- BUSCAR PARTICIPANTE POR ID
CREATE OR REPLACE PROCEDURE sp_find_participante(IN p_id VARCHAR(50))
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
END$$

-- CREAR ESTUDIANTE
CREATE OR REPLACE PROCEDURE sp_create_estudiante(
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
END$$

-- CREAR MENTOR TÉCNICO
CREATE OR REPLACE PROCEDURE sp_create_mentor_tecnico(
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
END$$

-- ELIMINAR PARTICIPANTE
CREATE OR REPLACE PROCEDURE sp_delete_participante(IN p_id VARCHAR(50))
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
END$$

-- =====================================================
-- STORED PROCEDURES PARA RETOS
-- =====================================================

-- LISTAR TODOS LOS RETOS
CREATE OR REPLACE PROCEDURE sp_retos_list()
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
END$$

-- BUSCAR RETO POR ID
CREATE OR REPLACE PROCEDURE sp_find_reto(IN p_id VARCHAR(50))
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
END$$

-- CREAR RETO REAL
CREATE OR REPLACE PROCEDURE sp_create_reto_real(
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
END$$

-- CREAR RETO EXPERIMENTAL
CREATE OR REPLACE PROCEDURE sp_create_reto_experimental(
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
END$$

-- ELIMINAR RETO
CREATE OR REPLACE PROCEDURE sp_delete_reto(IN p_id VARCHAR(50))
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
END$$

-- =====================================================
-- STORED PROCEDURES PARA HACKATHONS
-- =====================================================

-- LISTAR TODOS LOS HACKATHONS
CREATE OR REPLACE PROCEDURE sp_hackathons_list()
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
END$$

-- BUSCAR HACKATHON POR ID
CREATE OR REPLACE PROCEDURE sp_find_hackathon(IN p_id VARCHAR(50))
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
END$$

-- CREAR HACKATHON
CREATE OR REPLACE PROCEDURE sp_create_hackathon(
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
END$$

-- ACTUALIZAR HACKATHON
CREATE OR REPLACE PROCEDURE sp_update_hackathon(
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
END$$

-- ELIMINAR HACKATHON
CREATE OR REPLACE PROCEDURE sp_delete_hackathon(IN p_id VARCHAR(50))
BEGIN
    DELETE FROM hackathons WHERE id = p_id;
    SELECT 1 AS OK;
END$$

-- =====================================================
-- STORED PROCEDURES PARA EQUIPOS
-- =====================================================

-- LISTAR TODOS LOS EQUIPOS
CREATE OR REPLACE PROCEDURE sp_equipos_list()
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
END$$

-- BUSCAR EQUIPO POR ID
CREATE OR REPLACE PROCEDURE sp_find_equipo(IN p_id VARCHAR(50))
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
END$$

-- CREAR EQUIPO
CREATE OR REPLACE PROCEDURE sp_create_equipo(
    IN p_id VARCHAR(50),
    IN p_nombre VARCHAR(255),
    IN p_hackathon_id VARCHAR(50)
)
BEGIN
    INSERT INTO equipos (id, nombre, hackathon_id)
    VALUES (p_id, p_nombre, p_hackathon_id);
    
    SELECT p_id AS id;
END$$

-- AGREGAR PARTICIPANTE A EQUIPO
CREATE OR REPLACE PROCEDURE sp_add_participante_equipo(
    IN p_equipo_id VARCHAR(50),
    IN p_participante_id VARCHAR(50),
    IN p_rol_en_equipo VARCHAR(100)
)
BEGIN
    INSERT INTO equipo_participantes (equipo_id, participante_id, rol_en_equipo)
    VALUES (p_equipo_id, p_participante_id, p_rol_en_equipo)
    ON DUPLICATE KEY UPDATE rol_en_equipo = p_rol_en_equipo;
    
    SELECT 1 AS OK;
END$$

-- AGREGAR RETO A EQUIPO
CREATE OR REPLACE PROCEDURE sp_add_reto_equipo(
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
END$$

-- ELIMINAR EQUIPO
CREATE OR REPLACE PROCEDURE sp_delete_equipo(IN p_id VARCHAR(50))
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
END$$

DELIMITER ;