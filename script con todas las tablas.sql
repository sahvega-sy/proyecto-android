DROP DATABASE IF EXISTS mpaz_db;
CREATE DATABASE mpaz_db CHARACTER SET utf8mb4;
USE mpaz_db;

CREATE TABLE psicologo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    passwordHash VARCHAR(255) NOT NULL
);

CREATE TABLE instrumento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    instrucciones TEXT NOT NULL,
    tiempoMin INT NOT NULL,
    estado VARCHAR(30) NOT NULL,
    esPsicometrico TINYINT(1) NOT NULL DEFAULT 0,
    escalaMax INT NOT NULL,
    etiquetaEscala TEXT NOT NULL
);

CREATE TABLE pregunta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instrumentoId INT NOT NULL,
    orden INT NOT NULL,
    texto TEXT NOT NULL,
    CONSTRAINT fk_pregunta_instrumento
        FOREIGN KEY (instrumentoId) REFERENCES instrumento(id)
        ON DELETE CASCADE
);

CREATE TABLE aplicacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    instrumentoId INT NOT NULL,
    psicologoId INT NOT NULL,
    estudianteIdFicticio VARCHAR(20) NOT NULL,
    cursoFicticio VARCHAR(20) NOT NULL,
    codigoTemporal VARCHAR(20) NOT NULL,
    codigoExpira BIGINT NOT NULL,
    estado VARCHAR(30) NOT NULL,
    fechaInicio BIGINT NULL,
    fechaFin BIGINT NULL,
    puntajePrueba INT NULL,
    observacion TEXT NULL,
    CONSTRAINT fk_aplicacion_instrumento
        FOREIGN KEY (instrumentoId) REFERENCES instrumento(id),
    CONSTRAINT fk_aplicacion_psicologo
        FOREIGN KEY (psicologoId) REFERENCES psicologo(id)
);

CREATE TABLE respuesta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    aplicacionId INT NOT NULL,
    preguntaId INT NOT NULL,
    valor INT NOT NULL,
    CONSTRAINT fk_respuesta_aplicacion
        FOREIGN KEY (aplicacionId) REFERENCES aplicacion(id)
        ON DELETE CASCADE,
    CONSTRAINT fk_respuesta_pregunta
        FOREIGN KEY (preguntaId) REFERENCES pregunta(id)
);

CREATE TABLE registro_auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    psicologoId INT NOT NULL,
    accion VARCHAR(50) NOT NULL,
    aplicacionId INT NULL,
    fechaHora BIGINT NOT NULL,
    CONSTRAINT fk_auditoria_psicologo
        FOREIGN KEY (psicologoId) REFERENCES psicologo(id),
    CONSTRAINT fk_auditoria_aplicacion
        FOREIGN KEY (aplicacionId) REFERENCES aplicacion(id)
        ON DELETE SET NULL
);

