CREATE DATABASE CentroFitness;
USE CentroFitness;

CREATE TABLE Categoria (
  categoria_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Rutina (
  rutina_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  duracion INT,
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Entrenador (
  entrenador_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Clase (
  clase_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE,
  cliente_id INT,
  FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

CREATE TABLE Clase_Rutina (
  clase_id INT,
  rutina_id INT,
  PRIMARY KEY (clase_id, rutina_id),
  FOREIGN KEY (clase_id) REFERENCES Clase(clase_id),
  FOREIGN KEY (rutina_id) REFERENCES Rutina(rutina_id)
);

CREATE TABLE Entrenador_Rutina (
  entrenador_id INT,
  rutina_id INT,
  PRIMARY KEY (entrenador_id, rutina_id),
  FOREIGN KEY (entrenador_id) REFERENCES Entrenador(entrenador_id),
  FOREIGN KEY (rutina_id) REFERENCES Rutina(rutina_id)
);

ALTER TABLE Cliente ADD direccion VARCHAR(100);

INSERT INTO Categoria (nombre) VALUES 
('Cardio'),
('Fuerza'),
('Flexibilidad');

INSERT INTO Rutina (nombre, duracion, categoria_id) VALUES 
('Caminadora', 30, 1),
('Pesas', 45, 2),
('Estiramientos', 20, 3);

INSERT INTO Cliente (nombre, email, telefono, direccion) VALUES 
('Laura Martínez', 'laura@mail.com', '3001122334', 'Calle 1 #1-11'),
('Fernando Pérez', 'fer@mail.com', '3012233445', 'Cra 2 #2-22'),
('Camila Díaz', 'camila@mail.com', '3023344556', 'Av 3 #3-33');

INSERT INTO Entrenador (nombre, especialidad) VALUES 
('Sergio López', 'Cardio'),
('Daniela Torres', 'Musculación'),
('Natalia Ruiz', 'Yoga');

INSERT INTO Clase (nombre, fecha, cliente_id) VALUES 
('Entrenamiento Cardio', '2025-10-01', 1),
('Sesión de Pesas', '2025-10-02', 2),
('Clase de Estiramiento', '2025-10-03', 3);

INSERT INTO Clase_Rutina (clase_id, rutina_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Entrenador_Rutina (entrenador_id, rutina_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Categoria SET nombre = 'Cardio Intenso' WHERE categoria_id = 1;
UPDATE Rutina SET duracion = 35 WHERE rutina_id = 1;
UPDATE Cliente SET nombre = 'Laura M. Martínez' WHERE cliente_id = 1;
UPDATE Entrenador SET nombre = 'Sergio A. López' WHERE entrenador_id = 1;
UPDATE Clase SET nombre = 'Cardio Extremo' WHERE clase_id = 1;

DELETE FROM Clase_Rutina WHERE clase_id = 1 AND rutina_id = 1;
DELETE FROM Entrenador_Rutina WHERE entrenador_id = 1 AND rutina_id = 1;
DELETE FROM Clase WHERE clase_id = 1;
DELETE FROM Cliente WHERE cliente_id = 1;
DELETE FROM Rutina WHERE rutina_id = 1;

SELECT Clase.nombre, Cliente.nombre AS cliente
FROM Clase
JOIN Cliente ON Clase.cliente_id = Cliente.cliente_id;

SELECT Rutina.nombre, Categoria.nombre AS categoria
FROM Rutina
JOIN Categoria ON Rutina.categoria_id = Categoria.categoria_id;

SELECT Clase.nombre, Rutina.nombre
FROM Clase_Rutina
JOIN Clase ON Clase_Rutina.clase_id = Clase.clase_id
JOIN Rutina ON Clase_Rutina.rutina_id = Rutina.rutina_id;

SELECT Entrenador.nombre, COUNT(*) AS rutinas_asignadas
FROM Entrenador
JOIN Entrenador_Rutina ON Entrenador.entrenador_id = Entrenador_Rutina.entrenador_id
GROUP BY Entrenador.entrenador_id;

SELECT Categoria.nombre, COUNT(*) AS rutinas_total
FROM Categoria
JOIN Rutina ON Categoria.categoria_id = Rutina.categoria_id
GROUP BY Categoria.categoria_id;

SELECT nombre FROM Cliente
WHERE cliente_id IN (
  SELECT cliente_id FROM Clase WHERE fecha = '2025-10-02'
);

SELECT nombre FROM Rutina
WHERE rutina_id IN (
  SELECT rutina_id FROM Clase_Rutina WHERE clase_id = 2
);

SELECT nombre FROM Entrenador
WHERE entrenador_id IN (
  SELECT entrenador_id FROM Entrenador_Rutina WHERE rutina_id = 2
);

SELECT nombre FROM Categoria
WHERE categoria_id = (
  SELECT categoria_id FROM Rutina WHERE nombre = 'Pesas'
);

SELECT nombre FROM Rutina
WHERE duracion = (
  SELECT MAX(duracion) FROM Rutina
);

SELECT COUNT(*) AS total_rutinas FROM Rutina;
SELECT COUNT(*) AS total_clientes FROM Cliente;
SELECT COUNT(*) AS total_entrenadores FROM Entrenador;
SELECT COUNT(*) AS total_clases FROM Clase;
SELECT COUNT(*) AS total_clase_rutina FROM Clase_Rutina;
SELECT COUNT(*) AS total_entrenador_rutina FROM Entrenador_Rutina;
SELECT SUM(duracion) AS total_duracion FROM Rutina;
SELECT AVG(duracion) AS promedio_duracion FROM Rutina;
SELECT MAX(duracion) AS max_duracion FROM Rutina;
SELECT LENGTH(nombre) AS longitud_nombre_rutina FROM Rutina LIMIT 1;

DELIMITER $$

CREATE PROCEDURE RegistrarClase (
  IN p_nombre VARCHAR(100),
  IN p_fecha DATE,
  IN p_cliente_id INT
)
BEGIN
  INSERT INTO Clase(nombre, fecha, cliente_id)
  VALUES (p_nombre, p_fecha, p_cliente_id);
END $$

DELIMITER ;

TRUNCATE TABLE Entrenador_Rutina;

DROP TABLE Clase_Rutina;
DROP TABLE Entrenador_Rutina;
DROP TABLE Clase;
DROP TABLE Cliente;
DROP TABLE Rutina;
DROP TABLE Entrenador;
DROP TABLE Categoria;

DROP DATABASE CentroFitness;
