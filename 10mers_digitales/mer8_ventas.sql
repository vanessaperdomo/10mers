CREATE DATABASE VentaCasas;
USE VentaCasas;

CREATE TABLE Tipo_Casa (
  tipo_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Casa (
  casa_id INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(100),
  precio DECIMAL(12,2),
  tipo_id INT,
  FOREIGN KEY (tipo_id) REFERENCES Tipo_Casa(tipo_id)
);

CREATE TABLE Cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Agente (
  agente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  experiencia INT
);

CREATE TABLE Caracteristica (
  caracteristica_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Casa_Caracteristica (
  casa_id INT,
  caracteristica_id INT,
  PRIMARY KEY (casa_id, caracteristica_id),
  FOREIGN KEY (casa_id) REFERENCES Casa(casa_id),
  FOREIGN KEY (caracteristica_id) REFERENCES Caracteristica(caracteristica_id)
);

CREATE TABLE Agente_Casa (
  agente_id INT,
  casa_id INT,
  PRIMARY KEY (agente_id, casa_id),
  FOREIGN KEY (agente_id) REFERENCES Agente(agente_id),
  FOREIGN KEY (casa_id) REFERENCES Casa(casa_id)
);

ALTER TABLE Cliente ADD direccion VARCHAR(100);

INSERT INTO Tipo_Casa (nombre) VALUES 
('Apartamento'),
('Casa'),
('Penthouse');

INSERT INTO Casa (direccion, precio, tipo_id) VALUES 
('Calle 100 #20-50', 250000000, 1),
('Carrera 15 #45-30', 380000000, 2),
('Av 9 #10-99', 600000000, 3);

INSERT INTO Cliente (nombre, email, telefono, direccion) VALUES 
('Sebastián Muñoz', 'sebastian@mail.com', '3001234567', 'Calle 10 #1-11'),
('Valeria Cruz', 'valeria@mail.com', '3012345678', 'Cra 25 #12-34'),
('Julián Torres', 'julian@mail.com', '3023456789', 'Av 30 #67-89');

INSERT INTO Agente (nombre, experiencia) VALUES 
('Carolina Pérez', 5),
('Miguel Rojas', 8),
('Laura Vélez', 3);

INSERT INTO Caracteristica (nombre) VALUES 
('3 habitaciones'),
('Parqueadero'),
('Piscina');

INSERT INTO Casa_Caracteristica (casa_id, caracteristica_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Agente_Casa (agente_id, casa_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Tipo_Casa SET nombre = 'Apartamento Familiar' WHERE tipo_id = 1;
UPDATE Casa SET precio = 265000000 WHERE casa_id = 1;
UPDATE Cliente SET nombre = 'Sebastián A. Muñoz' WHERE cliente_id = 1;
UPDATE Agente SET experiencia = 6 WHERE agente_id = 1;
UPDATE Caracteristica SET nombre = '3 habitaciones y 2 baños' WHERE caracteristica_id = 1;

DELETE FROM Casa_Caracteristica WHERE casa_id = 1 AND caracteristica_id = 1;
DELETE FROM Agente_Casa WHERE agente_id = 1 AND casa_id = 1;
DELETE FROM Casa WHERE casa_id = 1;
DELETE FROM Cliente WHERE cliente_id = 1;
DELETE FROM Caracteristica WHERE caracteristica_id = 1;

SELECT Casa.direccion, Tipo_Casa.nombre AS tipo
FROM Casa
JOIN Tipo_Casa ON Casa.tipo_id = Tipo_Casa.tipo_id;

SELECT Casa.direccion, Caracteristica.nombre AS caracteristica
FROM Casa_Caracteristica
JOIN Casa ON Casa_Caracteristica.casa_id = Casa.casa_id
JOIN Caracteristica ON Casa_Caracteristica.caracteristica_id = Caracteristica.caracteristica_id;

SELECT Casa.direccion, Agente.nombre AS agente
FROM Agente_Casa
JOIN Casa ON Agente_Casa.casa_id = Casa.casa_id
JOIN Agente ON Agente_Casa.agente_id = Agente.agente_id;

SELECT Tipo_Casa.nombre, COUNT(*) AS total_casas
FROM Tipo_Casa
JOIN Casa ON Tipo_Casa.tipo_id = Casa.tipo_id
GROUP BY Tipo_Casa.tipo_id;

SELECT Agente.nombre, COUNT(*) AS total_casas
FROM Agente
JOIN Agente_Casa ON Agente.agente_id = Agente_Casa.agente_id
GROUP BY Agente.agente_id;

SELECT nombre FROM Cliente
WHERE cliente_id IN (
  SELECT cliente_id FROM Cliente WHERE nombre LIKE 'Valeria%'
);

SELECT nombre FROM Caracteristica
WHERE caracteristica_id IN (
  SELECT caracteristica_id FROM Casa_Caracteristica WHERE casa_id = 2
);

SELECT nombre FROM Agente
WHERE agente_id IN (
  SELECT agente_id FROM Agente_Casa WHERE casa_id = 2
);

SELECT nombre FROM Tipo_Casa
WHERE tipo_id = (
  SELECT tipo_id FROM Casa WHERE direccion = 'Carrera 15 #45-30'
);

SELECT direccion FROM Casa
WHERE precio = (
  SELECT MAX(precio) FROM Casa
);

SELECT COUNT(*) AS total_casas FROM Casa;
SELECT COUNT(*) AS total_clientes FROM Cliente;
SELECT COUNT(*) AS total_agentes FROM Agente;
SELECT COUNT(*) AS total_caracteristicas FROM Caracteristica;
SELECT COUNT(*) AS total_casa_caracteristica FROM Casa_Caracteristica;
SELECT COUNT(*) AS total_agente_casa FROM Agente_Casa;
SELECT SUM(precio) AS suma_precios FROM Casa;
SELECT AVG(precio) AS promedio_precio FROM Casa;
SELECT MAX(precio) AS casa_mas_cara FROM Casa;
SELECT LENGTH(direccion) AS longitud_direccion FROM Casa LIMIT 1;

DELIMITER $$

CREATE PROCEDURE RegistrarCasa (
  IN p_direccion VARCHAR(100),
  IN p_precio DECIMAL(12,2),
  IN p_tipo_id INT
)
BEGIN
  INSERT INTO Casa(direccion, precio, tipo_id)
  VALUES (p_direccion, p_precio, p_tipo_id);
END $$

DELIMITER ;
