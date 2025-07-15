
CREATE DATABASE Colegio;
USE Colegio;


CREATE TABLE Departamento (
  depto_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Profesor (
  prof_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  depto_id INT,
  FOREIGN KEY (depto_id) REFERENCES Departamento(depto_id)
);

CREATE TABLE Curso (
  curso_id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  depto_id INT,
  FOREIGN KEY (depto_id) REFERENCES Departamento(depto_id)
);

CREATE TABLE Estudiante (
  est_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha_ingreso DATE
);

CREATE TABLE Aula (
  aula_id INT AUTO_INCREMENT PRIMARY KEY,
  edificio VARCHAR(50),
  capacidad INT
);

CREATE TABLE Matricula (
  est_id INT,
  curso_id INT,
  fecha DATE,
  PRIMARY KEY (est_id, curso_id),
  FOREIGN KEY (est_id) REFERENCES Estudiante(est_id),
  FOREIGN KEY (curso_id) REFERENCES Curso(curso_id)
);

CREATE TABLE Asignacion (
  prof_id INT,
  curso_id INT,
  horario VARCHAR(50),
  PRIMARY KEY (prof_id, curso_id),
  FOREIGN KEY (prof_id) REFERENCES Profesor(prof_id),
  FOREIGN KEY (curso_id) REFERENCES Curso(curso_id)
);

-- ALTER TABLE
ALTER TABLE Aula ADD piso INT;
ALTER TABLE Aula DROP COLUMN capacidad;

-- INSERTAR 3 REGISTROS EN CADA TABLA
INSERT INTO Departamento (nombre) VALUES 
('Matemáticas'),
('Literatura'),
('Ciencias');

INSERT INTO Profesor (nombre, depto_id) VALUES 
('Ana Pérez', 1),
('Carlos Ruiz', 2),
('Laura Torres', 3);

INSERT INTO Curso (titulo, depto_id) VALUES 
('Cálculo I', 1),
('Redacción', 2),
('Biología', 3);

INSERT INTO Estudiante (nombre, fecha_ingreso) VALUES 
('Luis Gómez','2023-02-01'),
('María López','2023-02-15'),
('Andrés Díaz','2023-03-10');

INSERT INTO Aula (edificio, piso) VALUES 
('A-1', 1),
('B-2', 2),
('C-3', 3);

INSERT INTO Matricula (est_id, curso_id, fecha) VALUES 
(1, 1, '2023-03-01'),
(2, 2, '2023-03-05'),
(3, 3, '2023-03-10');

INSERT INTO Asignacion (prof_id, curso_id, horario) VALUES 
(1, 1, 'Lun 8am'),
(2, 2, 'Mar 10am'),
(3, 3, 'Mié 9am');

-- UPDATE (5)
UPDATE Estudiante SET nombre = 'Luis Miguel Gómez' WHERE est_id = 1;
UPDATE Curso SET titulo = 'Cálculo Avanzado I' WHERE curso_id = 1;
UPDATE Aula SET piso = 4 WHERE aula_id = 1;
UPDATE Profesor SET nombre = 'Ana María Pérez' WHERE prof_id = 1;
UPDATE Departamento SET nombre = 'Depto. de Matemáticas' WHERE depto_id = 1;

-- DELETE (5) 
DELETE FROM Matricula WHERE est_id = 1 AND curso_id = 1;
DELETE FROM Asignacion WHERE prof_id = 1 AND curso_id = 1;
DELETE FROM Aula WHERE aula_id = 1;
DELETE FROM Estudiante WHERE est_id = 1;
DELETE FROM Curso WHERE curso_id = 1;

-- SELECT JOIN (5)
SELECT Estudiante.nombre AS alumno, Curso.titulo
FROM Matricula
JOIN Estudiante ON Matricula.est_id = Estudiante.est_id
JOIN Curso ON Matricula.curso_id = Curso.curso_id;

SELECT Profesor.nombre AS profesor, Departamento.nombre AS departamento
FROM Profesor
JOIN Departamento ON Profesor.depto_id = Departamento.depto_id;

SELECT Curso.titulo, Aula.edificio, Aula.piso
FROM Curso
JOIN Asignacion ON Curso.curso_id = Asignacion.curso_id
JOIN Aula ON Aula.aula_id = 2;

SELECT Estudiante.nombre AS alumno, COUNT(*) AS cursos
FROM Estudiante
JOIN Matricula ON Estudiante.est_id = Matricula.est_id
GROUP BY Estudiante.est_id;

SELECT Departamento.nombre AS departamento, COUNT(*) AS cantidad_profesores
FROM Departamento
JOIN Profesor ON Departamento.depto_id = Profesor.depto_id
GROUP BY Departamento.depto_id;

-- SUBCONSULTAS (5)
SELECT nombre FROM Estudiante
WHERE est_id IN (
  SELECT est_id FROM Matricula WHERE curso_id = 2
);

SELECT titulo FROM Curso
WHERE depto_id = (
  SELECT depto_id FROM Departamento WHERE nombre LIKE '%Matemáticas%'
);

SELECT nombre FROM Profesor
WHERE depto_id = (
  SELECT depto_id FROM Curso WHERE curso_id = 2
);

SELECT nombre FROM Estudiante
WHERE fecha_ingreso > (
  SELECT MIN(fecha_ingreso) FROM Estudiante
);

SELECT edificio FROM Aula
WHERE piso = (
  SELECT MAX(piso) FROM Aula
);

SELECT COUNT(*) AS total_estudiantes FROM Estudiante;
SELECT SUM(est_id) AS suma_id FROM Estudiante;
SELECT AVG(est_id) AS promedio_id FROM Estudiante;
SELECT MIN(fecha_ingreso) FROM Estudiante;
SELECT MAX(fecha_ingreso) FROM Estudiante;
SELECT COUNT(DISTINCT curso_id) FROM Matricula;
SELECT SUM(piso) FROM Aula;
SELECT AVG(piso) FROM Aula;
SELECT COUNT(*) FROM Profesor;
SELECT SUM(depto_id) FROM Profesor;

DELIMITER $$

CREATE PROCEDURE InsertarMatriculaSimple (
  IN p_est_id INT,
  IN p_curso_id INT
)
BEGIN
  INSERT INTO Matricula(est_id, curso_id, fecha)
  VALUES (p_est_id, p_curso_id, CURDATE());
END $$

DELIMITER ;

-- TRUNCATE
TRUNCATE TABLE Matricula;

-- DROP TABLES
DROP TABLE Asignacion;
DROP TABLE Matricula;
DROP TABLE Aula;
DROP TABLE Estudiante;
DROP TABLE Curso;
DROP TABLE Profesor;
DROP TABLE Departamento;

-- DROP DATABASE
DROP DATABASE Colegio;
