DROP DATABASE IF EXISTS mpaz_db;
CREATE DATABASE mpaz_db CHARACTER SET utf8mb4;
USE mpaz_db;

CREATE TABLE psicologo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL
);

INSERT INTO psicologo (username, password) VALUES
('psicologa1', 'psico123'),
('admin', 'admin123');