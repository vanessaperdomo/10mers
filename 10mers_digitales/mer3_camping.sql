CREATE DATABASE Camping;
USE Camping;

CREATE TABLE Zona (
  zona_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  capacidad INT
);

CREATE TABLE Visitante (
  visitante_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  documento VARCHAR(20)
);

CREATE TABLE Reserva (
  reserva_id INT AUTO_INCREMENT PRIMARY KEY,
  visitante_id INT,
  fecha DATE,
  zona_id INT,
  FOREIGN KEY (visitante_id) REFERENCES Visitante(visitante_id),
  FOREIGN KEY (zona_id) REFERENCES Zona(zona_id)
);

CREATE TABLE Actividad (
  actividad_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  duracion INT
);

CREATE TABLE Instructor (
  instructor_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Reserva_Actividad (
  reserva_id INT,
  actividad_id INT,
  PRIMARY KEY (reserva_id, actividad_id),
  FOREIGN KEY (reserva_id) REFERENCES Reserva(reserva_id),
  FOREIGN KEY (actividad_id) REFERENCES Actividad(actividad_id)
);

CREATE TABLE Instructor_Actividad (
  instructor_id INT,
  actividad_id INT,
  PRIMARY KEY (instructor_id, actividad_id),
  FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id),
  FOREIGN KEY (actividad_id) REFERENCES Actividad(actividad_id)
);

ALTER TABLE Zona ADD COLUMN ubicacion VARCHAR(100);
ALTER TABLE Zona DROP COLUMN ubicacion;


INSERT INTO Zona (nombre, capacidad) VALUES 
('Bosque Norte', 30),
('Río Azul', 20),
('Montaña Sur', 25);

INSERT INTO Visitante (nombre, documento) VALUES 
('Camila Torres', 'CC12345'),
('Juan Martínez', 'CC67890'),
('Sara Gómez', 'CC11223');

INSERT INTO Reserva (visitante_id, fecha, zona_id) VALUES 
(1, '2025-08-01', 1),
(2, '2025-08-03', 2),
(3, '2025-08-05', 3);

INSERT INTO Actividad (nombre, duracion) VALUES 
('Senderismo', 120),
('Kayak', 90),
('Escalada', 150);

INSERT INTO Instructor (nombre, especialidad) VALUES 
('Andrés López', 'Montañismo'),
('Luisa Rojas', 'Navegación'),
('Pablo Sánchez', 'Escalada');

INSERT INTO Reserva_Actividad (reserva_id, actividad_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Instructor_Actividad (instructor_id, actividad_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Zona SET capacidad = 35 WHERE zona_id = 1;
UPDATE Visitante SET nombre = 'Camila A. Torres' WHERE visitante_id = 1;
UPDATE Actividad SET duracion = 130 WHERE actividad_id = 1;
UPDATE Instructor SET nombre = 'Andrés F. López' WHERE instructor_id = 1;
UPDATE Reserva SET fecha = '2025-08-02' WHERE reserva_id = 1;

DELETE FROM Reserva_Actividad WHERE reserva_id = 1 AND actividad_id = 1;
DELETE FROM Instructor_Actividad WHERE instructor_id = 1 AND actividad_id = 1;
DELETE FROM Reserva WHERE reserva_id = 1;
DELETE FROM Visitante WHERE visitante_id = 1;
DELETE FROM Zona WHERE zona_id = 1;

SELECT Reserva.fecha, Visitante.nombre, Zona.nombre
FROM Reserva
JOIN Visitante ON Reserva.visitante_id = Visitante.visitante_id
JOIN Zona ON Reserva.zona_id = Zona.zona_id;

SELECT Actividad.nombre, Instructor.nombre
FROM Instructor_Actividad
JOIN Actividad ON Instructor_Actividad.actividad_id = Actividad.actividad_id
JOIN Instructor ON Instructor_Actividad.instructor_id = Instructor.instructor_id;

SELECT Reserva.fecha, Actividad.nombre
FROM Reserva_Actividad
JOIN Reserva ON Reserva_Actividad.reserva_id = Reserva.reserva_id
JOIN Actividad ON Reserva_Actividad.actividad_id = Actividad.actividad_id;

SELECT Zona.nombre, COUNT(*) AS reservas_realizadas
FROM Zona
JOIN Reserva ON Zona.zona_id = Reserva.zona_id
GROUP BY Zona.zona_id;

SELECT Instructor.nombre, COUNT(*) AS actividades_asignadas
FROM Instructor
JOIN Instructor_Actividad ON Instructor.instructor_id = Instructor_Actividad.instructor_id
GROUP BY Instructor.instructor_id;

SELECT nombre FROM Zona
WHERE zona_id IN (
  SELECT zona_id FROM Reserva WHERE fecha > '2025-08-01'
);

SELECT nombre FROM Visitante
WHERE visitante_id IN (
  SELECT visitante_id FROM Reserva WHERE zona_id = 2
);

SELECT nombre FROM Actividad
WHERE actividad_id = (
  SELECT actividad_id FROM Instructor_Actividad WHERE instructor_id = 2
);

SELECT nombre FROM Instructor
WHERE instructor_id = (
  SELECT instructor_id FROM Instructor_Actividad WHERE actividad_id = 2
);

SELECT nombre FROM Actividad
WHERE duracion = (
  SELECT MAX(duracion) FROM Actividad
);

SELECT COUNT(*) FROM Zona;
SELECT COUNT(*) FROM Actividad;
SELECT COUNT(*) FROM Instructor;
SELECT COUNT(*) FROM Reserva;
SELECT SUM(duracion) FROM Actividad;
SELECT AVG(duracion) FROM Actividad;
SELECT MAX(duracion) FROM Actividad;
SELECT MIN(duracion) FROM Actividad;
SELECT COUNT(*) FROM Instructor_Actividad;
SELECT COUNT(DISTINCT zona_id) FROM Reserva;

DELIMITER $$

CREATE PROCEDURE RegistrarReserva (
  IN p_visitante_id INT,
  IN p_zona_id INT,
  IN p_fecha DATE
)
BEGIN
  INSERT INTO Reserva(visitante_id, zona_id, fecha)
  VALUES (p_visitante_id, p_zona_id, p_fecha);
END $$

DELIMITER ;

TRUNCATE TABLE Instructor_Actividad;

DROP TABLE Reserva_Actividad;
DROP TABLE Instructor_Actividad;
DROP TABLE Reserva;
DROP TABLE Visitante;
DROP TABLE Actividad;
DROP TABLE Instructor;
DROP TABLE Zona;

DROP DATABASE Camping;
