CREATE DATABASE ClinicaVeterinaria;
USE ClinicaVeterinaria;

CREATE TABLE Especialidad (
  especialidad_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Veterinario (
  veterinario_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  experiencia INT
);

CREATE TABLE Dueno (
  dueno_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  telefono VARCHAR(20),
  email VARCHAR(100)
);

CREATE TABLE Mascota (
  mascota_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especie VARCHAR(50),
  edad INT,
  dueno_id INT,
  FOREIGN KEY (dueno_id) REFERENCES Dueno(dueno_id)
);

CREATE TABLE Tratamiento (
  tratamiento_id INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100),
  costo DECIMAL(10,2)
);

CREATE TABLE Veterinario_Especialidad (
  veterinario_id INT,
  especialidad_id INT,
  PRIMARY KEY (veterinario_id, especialidad_id),
  FOREIGN KEY (veterinario_id) REFERENCES Veterinario(veterinario_id),
  FOREIGN KEY (especialidad_id) REFERENCES Especialidad(especialidad_id)
);

CREATE TABLE Mascota_Tratamiento (
  mascota_id INT,
  tratamiento_id INT,
  PRIMARY KEY (mascota_id, tratamiento_id),
  FOREIGN KEY (mascota_id) REFERENCES Mascota(mascota_id),
  FOREIGN KEY (tratamiento_id) REFERENCES Tratamiento(tratamiento_id)
);

ALTER TABLE Dueno ADD direccion VARCHAR(100);

INSERT INTO Especialidad (nombre) VALUES 
('Dermatología'),
('Cardiología'),
('Odontología');

INSERT INTO Veterinario (nombre, experiencia) VALUES 
('Dra. Marta Ríos', 7),
('Dr. Julián Pérez', 5),
('Dra. Ana Torres', 10);

INSERT INTO Dueno (nombre, telefono, email, direccion) VALUES 
('Laura Gómez', '3001234567', 'laura@mail.com', 'Calle 10 #20-30'),
('Carlos Mejía', '3012345678', 'carlos@mail.com', 'Cra 15 #12-45'),
('Sandra Beltrán', '3023456789', 'sandra@mail.com', 'Av 9 #5-55');

INSERT INTO Mascota (nombre, especie, edad, dueno_id) VALUES 
('Max', 'Perro', 3, 1),
('Mia', 'Gato', 2, 2),
('Rocky', 'Perro', 5, 3);

INSERT INTO Tratamiento (descripcion, costo) VALUES 
('Vacuna antirrábica', 45000),
('Limpieza dental', 70000),
('Desparasitación', 30000);

INSERT INTO Veterinario_Especialidad (veterinario_id, especialidad_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Mascota_Tratamiento (mascota_id, tratamiento_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Especialidad SET nombre = 'Dermatología Canina' WHERE especialidad_id = 1;
UPDATE Veterinario SET experiencia = 8 WHERE veterinario_id = 1;
UPDATE Dueno SET nombre = 'Laura G. Gómez' WHERE dueno_id = 1;
UPDATE Mascota SET edad = 4 WHERE mascota_id = 1;
UPDATE Tratamiento SET costo = 50000 WHERE tratamiento_id = 1;

DELETE FROM Veterinario_Especialidad WHERE veterinario_id = 1 AND especialidad_id = 1;
DELETE FROM Mascota_Tratamiento WHERE mascota_id = 1 AND tratamiento_id = 1;
DELETE FROM Mascota WHERE mascota_id = 1;
DELETE FROM Dueno WHERE dueno_id = 1;
DELETE FROM Tratamiento WHERE tratamiento_id = 1;

SELECT Mascota.nombre, Dueno.nombre AS dueno
FROM Mascota
JOIN Dueno ON Mascota.dueno_id = Dueno.dueno_id;

SELECT Mascota.nombre, Tratamiento.descripcion
FROM Mascota_Tratamiento
JOIN Mascota ON Mascota_Tratamiento.mascota_id = Mascota.mascota_id
JOIN Tratamiento ON Mascota_Tratamiento.tratamiento_id = Tratamiento.tratamiento_id;

SELECT Veterinario.nombre, Especialidad.nombre AS especialidad
FROM Veterinario_Especialidad
JOIN Veterinario ON Veterinario_Especialidad.veterinario_id = Veterinario.veterinario_id
JOIN Especialidad ON Veterinario_Especialidad.especialidad_id = Especialidad.especialidad_id;

SELECT Especialidad.nombre, COUNT(*) AS veterinarios
FROM Especialidad
JOIN Veterinario_Especialidad ON Especialidad.especialidad_id = Veterinario_Especialidad.especialidad_id
GROUP BY Especialidad.especialidad_id;

SELECT Dueno.nombre, COUNT(*) AS mascotas
FROM Dueno
JOIN Mascota ON Dueno.dueno_id = Mascota.dueno_id
GROUP BY Dueno.dueno_id;

SELECT nombre FROM Mascota
WHERE mascota_id IN (
  SELECT mascota_id FROM Mascota_Tratamiento WHERE tratamiento_id = 2
);

SELECT nombre FROM Veterinario
WHERE veterinario_id IN (
  SELECT veterinario_id FROM Veterinario_Especialidad WHERE especialidad_id = 2
);

SELECT nombre FROM Dueno
WHERE dueno_id = (
  SELECT dueno_id FROM Mascota WHERE nombre = 'Mia'
);

SELECT descripcion FROM Tratamiento
WHERE costo = (
  SELECT MAX(costo) FROM Tratamiento
);

SELECT nombre FROM Mascota
WHERE edad = (
  SELECT MAX(edad) FROM Mascota
);

SELECT COUNT(*) FROM Mascota;
SELECT COUNT(*) FROM Dueno;
SELECT COUNT(*) FROM Veterinario;
SELECT COUNT(*) FROM Tratamiento;
SELECT COUNT(*) FROM Mascota_Tratamiento;
SELECT SUM(costo) FROM Tratamiento;
SELECT AVG(costo) FROM Tratamiento;
SELECT MAX(costo) FROM Tratamiento;
SELECT LENGTH(nombre) FROM Mascota LIMIT 1;
SELECT COUNT(*) FROM Veterinario_Especialidad;

DELIMITER $$

CREATE PROCEDURE RegistrarMascota (
  IN p_nombre VARCHAR(100),
  IN p_especie VARCHAR(50),
  IN p_edad INT,
  IN p_dueno_id INT
)
BEGIN
  INSERT INTO Mascota(nombre, especie, edad, dueno_id)
  VALUES (p_nombre, p_especie, p_edad, p_dueno_id);
END $$

DELIMITER ;

TRUNCATE TABLE Mascota_Tratamiento;

DROP TABLE Mascota_Tratamiento;
DROP TABLE Veterinario_Especialidad;
DROP TABLE Mascota;
DROP TABLE Dueno;
DROP TABLE Veterinario;
DROP TABLE Tratamiento;
DROP TABLE Especialidad;

DROP DATABASE ClinicaVeterinaria;
