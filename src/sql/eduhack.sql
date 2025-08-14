-- Base de datos para EduHack Platform
CREATE DATABASE IF NOT EXISTS eduhack CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE eduhack;

CREATE TABLE participantes (
    id VARCHAR(50) PRIMARY KEY,
    tipo ENUM('estudiante', 'mentorTecnico') NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    nivel_habilidad ENUM('basico', 'intermedio', 'avanzado') NOT NULL
);

CREATE TABLE participante_habilidades (
    id INT AUTO_INCREMENT PRIMARY KEY,
    participante_id VARCHAR(50) NOT NULL,
    habilidad ENUM('JavaScript', 'Python', 'Java', 'HTML', 'CSS', 'React', 'Node.js', 
                  'PHP', 'MySQL', 'Git', 'UI/UX', 'Figma', 'Machine Learning', 'IA', 
                  'Mobile', 'Android', 'iOS', 'Unity', 'Photoshop') NOT NULL,
    
    FOREIGN KEY (participante_id) REFERENCES participantes(id) ON DELETE CASCADE
);

CREATE TABLE estudiantes (
    id VARCHAR(50) PRIMARY KEY,
    grado ENUM('6', '7', '8', '9', '10', '11', '12') NOT NULL,
    institucion VARCHAR(255) NOT NULL,
    tiempo_disponible_semanal INT NOT NULL,
    
    FOREIGN KEY (id) REFERENCES participantes(id) ON DELETE CASCADE
);

CREATE TABLE mentores_tecnicos (
    id VARCHAR(50) PRIMARY KEY,
    especialidad ENUM('Desarrollo Web', 'Desarrollo Mobile', 'Inteligencia Artificial', 
                     'Data Science', 'UI/UX Design', 'Backend', 'Frontend') NOT NULL,
    experiencia INT NOT NULL,
    disponibilidad_horaria VARCHAR(255) NOT NULL,
    
    FOREIGN KEY (id) REFERENCES participantes(id) ON DELETE CASCADE
);

CREATE TABLE hackathons (
    id VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    lugar VARCHAR(255),
    estado ENUM('planificado', 'activo', 'finalizado') DEFAULT 'planificado'
);

CREATE TABLE retos (
    id VARCHAR(50) PRIMARY KEY,
    tipo ENUM('retoReal', 'retoExperimental') NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    descripcion TEXT NOT NULL,
    complejidad ENUM('facil', 'media', 'dificil') NOT NULL
);

CREATE TABLE reto_areas_conocimiento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    reto_id VARCHAR(50) NOT NULL,
    area_conocimiento ENUM('Desarrollo Web', 'Desarrollo Mobile', 'Inteligencia Artificial', 
                          'UI/UX Design', 'Base de datos', 'Geolocalización', 'Medioambiente', 
                          'Sostenibilidad', 'Educación', 'Salud', 'Ecología', 'Simulación') NOT NULL,
    
    FOREIGN KEY (reto_id) REFERENCES retos(id) ON DELETE CASCADE
);

CREATE TABLE retos_reales (
    id VARCHAR(50) PRIMARY KEY,
    entidad_colaboradora VARCHAR(255) NOT NULL,
    
    FOREIGN KEY (id) REFERENCES retos(id) ON DELETE CASCADE
);

CREATE TABLE retos_experimentales (
    id VARCHAR(50) PRIMARY KEY,
    enfoque_pedagogico VARCHAR(255) NOT NULL,
    
    FOREIGN KEY (id) REFERENCES retos(id) ON DELETE CASCADE
);

CREATE TABLE equipos (
    id VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    hackathon_id VARCHAR(50) NOT NULL,
    
    FOREIGN KEY (hackathon_id) REFERENCES hackathons(id) ON DELETE CASCADE
);

CREATE TABLE equipo_participantes (
    equipo_id VARCHAR(50),
    participante_id VARCHAR(50),
    rol_en_equipo VARCHAR(100) DEFAULT 'miembro',
    
    PRIMARY KEY (equipo_id, participante_id),
    FOREIGN KEY (equipo_id) REFERENCES equipos(id) ON DELETE CASCADE,
    FOREIGN KEY (participante_id) REFERENCES participantes(id) ON DELETE CASCADE
);

CREATE TABLE equipo_retos (
    equipo_id VARCHAR(50),
    reto_id VARCHAR(50),
    estado ENUM('asignado', 'en_progreso', 'completado', 'abandonado') DEFAULT 'asignado',
    progreso_porcentaje INT DEFAULT 0,
    
    PRIMARY KEY (equipo_id, reto_id),
    FOREIGN KEY (equipo_id) REFERENCES equipos(id) ON DELETE CASCADE,
    FOREIGN KEY (reto_id) REFERENCES retos(id) ON DELETE CASCADE
);

