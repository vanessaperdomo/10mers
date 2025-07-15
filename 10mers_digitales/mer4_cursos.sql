CREATE DATABASE PlataformaCursos;
USE PlataformaCursos;

CREATE TABLE Categoria (
  categoria_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Curso (
  curso_id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Estudiante (
  estudiante_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE Instructor (
  instructor_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Leccion (
  leccion_id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  duracion INT,
  curso_id INT,
  FOREIGN KEY (curso_id) REFERENCES Curso(curso_id)
);

CREATE TABLE Curso_Estudiante (
  curso_id INT,
  estudiante_id INT,
  PRIMARY KEY (curso_id, estudiante_id),
  FOREIGN KEY (curso_id) REFERENCES Curso(curso_id),
  FOREIGN KEY (estudiante_id) REFERENCES Estudiante(estudiante_id)
);

CREATE TABLE Leccion_Instructor (
  leccion_id INT,
  instructor_id INT,
  PRIMARY KEY (leccion_id, instructor_id),
  FOREIGN KEY (leccion_id) REFERENCES Leccion(leccion_id),
  FOREIGN KEY (instructor_id) REFERENCES Instructor(instructor_id)
);

ALTER TABLE Estudiante ADD telefono VARCHAR(20);

INSERT INTO Categoria (nombre) VALUES 
('Programación'),
('Diseño'),
('Marketing');

INSERT INTO Curso (titulo, categoria_id) VALUES 
('Curso de Python', 1),
('Diseño UX/UI', 2),
('Marketing Digital', 3);

INSERT INTO Estudiante (nombre, email, telefono) VALUES 
('Ana Pérez', 'ana@mail.com', '3001234567'),
('Luis Torres', 'luis@mail.com', '3012345678'),
('María Gómez', 'maria@mail.com', '3023456789');

INSERT INTO Instructor (nombre, especialidad) VALUES 
('Carlos Díaz', 'Backend'),
('Laura Ruiz', 'Diseño UX'),
('Pedro López', 'Publicidad');

INSERT INTO Leccion (titulo, duracion, curso_id) VALUES 
('Variables y tipos', 45, 1),
('Principios de UX', 60, 2),
('SEO básico', 50, 3);

INSERT INTO Curso_Estudiante (curso_id, estudiante_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Leccion_Instructor (leccion_id, instructor_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Categoria SET nombre = 'Desarrollo' WHERE categoria_id = 1;
UPDATE Curso SET titulo = 'Curso Profesional de Python' WHERE curso_id = 1;
UPDATE Estudiante SET nombre = 'Ana M. Pérez' WHERE estudiante_id = 1;
UPDATE Instructor SET nombre = 'Carlos D. Díaz' WHERE instructor_id = 1;
UPDATE Leccion SET duracion = 50 WHERE leccion_id = 1;

DELETE FROM Curso_Estudiante WHERE curso_id = 1 AND estudiante_id = 1;
DELETE FROM Leccion_Instructor WHERE leccion_id = 1 AND instructor_id = 1;
DELETE FROM Leccion WHERE leccion_id = 1;
DELETE FROM Curso WHERE curso_id = 1;
DELETE FROM Estudiante WHERE estudiante_id = 1;

SELECT Curso.titulo, Categoria.nombre AS categoria
FROM Curso
JOIN Categoria ON Curso.categoria_id = Categoria.categoria_id;

SELECT Estudiante.nombre, Curso.titulo
FROM Curso_Estudiante
JOIN Estudiante ON Curso_Estudiante.estudiante_id = Estudiante.estudiante_id
JOIN Curso ON Curso_Estudiante.curso_id = Curso.curso_id;

SELECT Leccion.titulo, Instructor.nombre
FROM Leccion_Instructor
JOIN Leccion ON Leccion_Instructor.leccion_id = Leccion.leccion_id
JOIN Instructor ON Leccion_Instructor.instructor_id = Instructor.instructor_id;

SELECT Categoria.nombre, COUNT(*) AS total_cursos
FROM Categoria
JOIN Curso ON Categoria.categoria_id = Curso.categoria_id
GROUP BY Categoria.categoria_id;

SELECT Instructor.nombre, COUNT(*) AS lecciones_asignadas
FROM Instructor
JOIN Leccion_Instructor ON Instructor.instructor_id = Leccion_Instructor.instructor_id
GROUP BY Instructor.instructor_id;

SELECT nombre FROM Estudiante
WHERE estudiante_id IN (
  SELECT estudiante_id FROM Curso_Estudiante WHERE curso_id = 2
);

SELECT titulo FROM Curso
WHERE curso_id IN (
  SELECT curso_id FROM Leccion WHERE duracion > 45
);

SELECT nombre FROM Instructor
WHERE instructor_id IN (
  SELECT instructor_id FROM Leccion_Instructor WHERE leccion_id = 2
);

SELECT titulo FROM Leccion
WHERE duracion = (
  SELECT MAX(duracion) FROM Leccion
);

SELECT nombre FROM Categoria
WHERE categoria_id = (
  SELECT categoria_id FROM Curso WHERE titulo = 'Diseño UX/UI'
);

SELECT COUNT(*) FROM Curso;
SELECT COUNT(*) FROM Leccion;
SELECT COUNT(*) FROM Estudiante;
SELECT COUNT(*) FROM Instructor;
SELECT SUM(duracion) FROM Leccion;
SELECT AVG(duracion) FROM Leccion;
SELECT MAX(duracion) FROM Leccion;
SELECT MIN(duracion) FROM Leccion;
SELECT COUNT(*) FROM Curso_Estudiante;
SELECT COUNT(DISTINCT categoria_id) FROM Curso;

DELIMITER $$

CREATE PROCEDURE RegistrarEstudianteCurso (
  IN p_estudiante_id INT,
  IN p_curso_id INT
)
BEGIN
  INSERT INTO Curso_Estudiante (curso_id, estudiante_id)
  VALUES (p_curso_id, p_estudiante_id);
END $$

DELIMITER ;

TRUNCATE TABLE Leccion_Instructor;

DROP TABLE Curso_Estudiante;
DROP TABLE Leccion_Instructor;
DROP TABLE Leccion;
DROP TABLE Curso;
DROP TABLE Estudiante;
DROP TABLE Instructor;
DROP TABLE Categoria;

DROP DATABASE PlataformaCursos;
