CREATE DATABASE ServiciosDomicilio;
USE ServiciosDomicilio;

CREATE TABLE Categoria (
  categoria_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Servicio (
  servicio_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  categoria_id INT,
  FOREIGN KEY (categoria_id) REFERENCES Categoria(categoria_id)
);

CREATE TABLE Cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Tecnico (
  tecnico_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Pedido (
  pedido_id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT,
  fecha DATE,
  FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id)
);

CREATE TABLE Pedido_Servicio (
  pedido_id INT,
  servicio_id INT,
  PRIMARY KEY (pedido_id, servicio_id),
  FOREIGN KEY (pedido_id) REFERENCES Pedido(pedido_id),
  FOREIGN KEY (servicio_id) REFERENCES Servicio(servicio_id)
);

CREATE TABLE Tecnico_Servicio (
  tecnico_id INT,
  servicio_id INT,
  PRIMARY KEY (tecnico_id, servicio_id),
  FOREIGN KEY (tecnico_id) REFERENCES Tecnico(tecnico_id),
  FOREIGN KEY (servicio_id) REFERENCES Servicio(servicio_id)
);

ALTER TABLE Cliente ADD email VARCHAR(100);

INSERT INTO Categoria (nombre) VALUES 
('Electricidad'),
('Limpieza'),
('Plomería');

INSERT INTO Servicio (nombre, precio, categoria_id) VALUES 
('Instalación eléctrica', 100.00, 1),
('Limpieza profunda', 80.00, 2),
('Reparación de fugas', 90.00, 3);

INSERT INTO Cliente (nombre, direccion, telefono, email) VALUES 
('Mario Ruiz', 'Calle 10 #23-45', '3001234567', 'mario@mail.com'),
('Andrea Torres', 'Cra 15 #5-22', '3012345678', 'andrea@mail.com'),
('Luis Peña', 'Av 9 #99-10', '3023456789', 'luis@mail.com');

INSERT INTO Tecnico (nombre, especialidad) VALUES 
('Carlos López', 'Electricista'),
('Julia Díaz', 'Aseo'),
('Oscar Ramírez', 'Fontanero');

INSERT INTO Pedido (cliente_id, fecha) VALUES 
(1, '2025-08-01'),
(2, '2025-08-02'),
(3, '2025-08-03');

INSERT INTO Pedido_Servicio (pedido_id, servicio_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Tecnico_Servicio (tecnico_id, servicio_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

UPDATE Categoria SET nombre = 'Electricidad Residencial' WHERE categoria_id = 1;
UPDATE Servicio SET precio = 110.00 WHERE servicio_id = 1;
UPDATE Cliente SET nombre = 'Mario A. Ruiz' WHERE cliente_id = 1;
UPDATE Tecnico SET nombre = 'Carlos A. López' WHERE tecnico_id = 1;
UPDATE Pedido SET fecha = '2025-08-05' WHERE pedido_id = 1;

DELETE FROM Pedido_Servicio WHERE pedido_id = 1 AND servicio_id = 1;
DELETE FROM Tecnico_Servicio WHERE tecnico_id = 1 AND servicio_id = 1;
DELETE FROM Pedido WHERE pedido_id = 1;
DELETE FROM Cliente WHERE cliente_id = 1;
DELETE FROM Servicio WHERE servicio_id = 1;

SELECT Pedido.fecha, Cliente.nombre
FROM Pedido
JOIN Cliente ON Pedido.cliente_id = Cliente.cliente_id;

SELECT Servicio.nombre, Categoria.nombre
FROM Servicio
JOIN Categoria ON Servicio.categoria_id = Categoria.categoria_id;

SELECT Pedido.pedido_id, Servicio.nombre
FROM Pedido_Servicio
JOIN Servicio ON Pedido_Servicio.servicio_id = Servicio.servicio_id
JOIN Pedido ON Pedido_Servicio.pedido_id = Pedido.pedido_id;

SELECT Tecnico.nombre, COUNT(*) AS total_servicios
FROM Tecnico
JOIN Tecnico_Servicio ON Tecnico.tecnico_id = Tecnico_Servicio.tecnico_id
GROUP BY Tecnico.tecnico_id;

SELECT Categoria.nombre, COUNT(*) AS cantidad_servicios
FROM Categoria
JOIN Servicio ON Categoria.categoria_id = Servicio.categoria_id
GROUP BY Categoria.categoria_id;

SELECT nombre FROM Cliente
WHERE cliente_id IN (
  SELECT cliente_id FROM Pedido WHERE fecha = '2025-08-02'
);

SELECT nombre FROM Servicio
WHERE servicio_id IN (
  SELECT servicio_id FROM Pedido_Servicio WHERE pedido_id = 2
);

SELECT nombre FROM Tecnico
WHERE tecnico_id IN (
  SELECT tecnico_id FROM Tecnico_Servicio WHERE servicio_id = 2
);

SELECT nombre FROM Categoria
WHERE categoria_id = (
  SELECT categoria_id FROM Servicio WHERE nombre = 'Limpieza profunda'
);

SELECT nombre FROM Servicio
WHERE precio = (
  SELECT MAX(precio) FROM Servicio
);

SELECT COUNT(*) FROM Servicio;
SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM Tecnico;
SELECT COUNT(*) FROM Pedido;
SELECT COUNT(*) FROM Pedido_Servicio;
SELECT COUNT(*) FROM Tecnico_Servicio;
SELECT SUM(precio) FROM Servicio;
SELECT AVG(precio) FROM Servicio;
SELECT MAX(precio) FROM Servicio;
SELECT MIN(precio) FROM Servicio;

DELIMITER $$

CREATE PROCEDURE RegistrarPedido (
  IN p_cliente_id INT,
  IN p_fecha DATE
)
BEGIN
  INSERT INTO Pedido(cliente_id, fecha)
  VALUES (p_cliente_id, p_fecha);
END $$

DELIMITER ;

TRUNCATE TABLE Tecnico_Servicio;

DROP TABLE Pedido_Servicio;
DROP TABLE Tecnico_Servicio;
DROP TABLE Pedido;
DROP TABLE Cliente;
DROP TABLE Servicio;
DROP TABLE Tecnico;
DROP TABLE Categoria;

DROP DATABASE ServiciosDomicilio;
