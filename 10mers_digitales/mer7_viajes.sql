CREATE DATABASE AgenciaViajes;
USE AgenciaViajes;

CREATE TABLE Categoria (
  categoria_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Paquete (
  paquete_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Guia (
  guia_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  idioma VARCHAR(50)
);

CREATE TABLE Actividad (
  actividad_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  duracion INT
);

CREATE TABLE Paquete_Actividad (
  paquete_id INT,
  actividad_id INT,
  PRIMARY KEY (paquete_id, actividad_id),
  FOREIGN KEY (paquete_id) REFERENCES Paquete(paquete_id),
  FOREIGN KEY (actividad_id) REFERENCES Actividad(actividad_id)
);

CREATE TABLE Guia_Actividad (
  guia_id INT,
  actividad_id INT,
  PRIMARY KEY (guia_id, actividad_id),
  FOREIGN KEY (guia_id) REFERENCES Guia(guia_id),
  FOREIGN KEY (actividad_id) REFERENCES Actividad(actividad_id)
);

ALTER TABLE Cliente ADD direccion VARCHAR(100);

INSERT INTO Categoria (nombre) VALUES 
('Aventura'),
('Cultural'),
('Relax');

INSERT INTO Paquete (nombre, precio, categoria_id) VALUES 
('Montaña Extrema', 500.00, 1),
('Tour Histórico', 350.00, 2),
('Spa y Playa', 400.00, 3);

INSERT INTO Cliente (nombre, email, telefono, direccion) VALUES 
('Valentina Morales', 'valen@mail.com', '3001111122', 'Calle 12 #34-56'),
('Esteban Ríos', 'esteban@mail.com', '3012223344', 'Cra 15 #11-22'),
('Sara Camacho', 'sara@mail.com', '3023334455', 'Av 7 #66-77');

INSERT INTO Guia (nombre, idioma) VALUES 
('Jorge Herrera', 'Español'),
('Lucía Mendoza', 'Inglés'),
('Carlos Ríos', 'Francés');

INSERT INTO Actividad (nombre, duracion) VALUES 
('Senderismo', 180),
('Visita a museos', 120),
('Masaje relajante', 90);

INSERT INTO Paquete_Actividad (paquete_id, actividad_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Guia_Actividad (guia_id, actividad_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Categoria SET nombre = 'Aventura Extrema' WHERE categoria_id = 1;
UPDATE Paquete SET precio = 520.00 WHERE paquete_id = 1;
UPDATE Cliente SET nombre = 'Valentina M. Morales' WHERE cliente_id = 1;
UPDATE Guia SET nombre = 'Jorge A. Herrera' WHERE guia_id = 1;
UPDATE Actividad SET duracion = 200 WHERE actividad_id = 1;

DELETE FROM Paquete_Actividad WHERE paquete_id = 1 AND actividad_id = 1;
DELETE FROM Guia_Actividad WHERE guia_id = 1 AND actividad_id = 1;
DELETE FROM Paquete WHERE paquete_id = 1;
DELETE FROM Cliente WHERE cliente_id = 1;
DELETE FROM Actividad WHERE actividad_id = 1;

SELECT Paquete.nombre, Categoria.nombre AS categoria
FROM Paquete
JOIN Categoria ON Paquete.categoria_id = Categoria.categoria_id;

SELECT Actividad.nombre, Paquete.nombre
FROM Paquete_Actividad
JOIN Actividad ON Paquete_Actividad.actividad_id = Actividad.actividad_id
JOIN Paquete ON Paquete_Actividad.paquete_id = Paquete.paquete_id;

SELECT Actividad.nombre, Guia.nombre
FROM Guia_Actividad
JOIN Actividad ON Guia_Actividad.actividad_id = Actividad.actividad_id
JOIN Guia ON Guia_Actividad.guia_id = Guia.guia_id;

SELECT Categoria.nombre, COUNT(*) AS total_paquetes
FROM Categoria
JOIN Paquete ON Categoria.categoria_id = Paquete.categoria_id
GROUP BY Categoria.categoria_id;

SELECT Guia.nombre, COUNT(*) AS total_actividades
FROM Guia
JOIN Guia_Actividad ON Guia.guia_id = Guia_Actividad.guia_id
GROUP BY Guia.guia_id;

SELECT nombre FROM Cliente
WHERE cliente_id IN (
  SELECT cliente_id FROM Cliente WHERE nombre LIKE 'Esteban%'
);

SELECT nombre FROM Actividad
WHERE actividad_id IN (
  SELECT actividad_id FROM Paquete_Actividad WHERE paquete_id = 2
);

SELECT nombre FROM Guia
WHERE guia_id IN (
  SELECT guia_id FROM Guia_Actividad WHERE actividad_id = 2
);

SELECT nombre FROM Categoria
WHERE categoria_id = (
  SELECT categoria_id FROM Paquete WHERE nombre = 'Tour Histórico'
);

SELECT nombre FROM Actividad
WHERE duracion = (
  SELECT MAX(duracion) FROM Actividad
);

SELECT COUNT(*) AS total_paquetes FROM Paquete;
SELECT COUNT(*) AS total_clientes FROM Cliente;
SELECT COUNT(*) AS total_guias FROM Guia;
SELECT COUNT(*) AS total_actividades FROM Actividad;
SELECT COUNT(*) AS total_paquete_actividad FROM Paquete_Actividad;
SELECT COUNT(*) AS total_guia_actividad FROM Guia_Actividad;
SELECT SUM(precio) AS suma_precios FROM Paquete;
SELECT AVG(precio) AS promedio_precio FROM Paquete;
SELECT MAX(precio) AS precio_mas_alto FROM Paquete;
SELECT LENGTH(nombre) AS longitud_nombre_paquete FROM Paquete LIMIT 1;

DELIMITER $$

CREATE PROCEDURE RegistrarPaquete (
  IN p_nombre VARCHAR(100),
  IN p_precio DECIMAL(10,2),
  IN p_categoria_id INT
)
BEGIN
  INSERT INTO Paquete(nombre, precio, categoria_id)
  VALUES (p_nombre, p_precio, p_categoria_id);
END $$

DELIMITER ;
