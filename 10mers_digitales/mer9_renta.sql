CREATE DATABASE RentaAutos;
USE RentaAutos;

CREATE TABLE Tipo_Auto (
  tipo_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Auto (
  auto_id INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10),
  modelo VARCHAR(50),
  tipo_id INT,
  FOREIGN KEY (tipo_id) REFERENCES Tipo_Auto(tipo_id)
);

CREATE TABLE Cliente (
  cliente_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Agencia (
  agencia_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  ciudad VARCHAR(50)
);

CREATE TABLE Mantenimiento (
  mantenimiento_id INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100),
  costo DECIMAL(10,2)
);

CREATE TABLE Auto_Mantenimiento (
  auto_id INT,
  mantenimiento_id INT,
  PRIMARY KEY (auto_id, mantenimiento_id),
  FOREIGN KEY (auto_id) REFERENCES Auto(auto_id),
  FOREIGN KEY (mantenimiento_id) REFERENCES Mantenimiento(mantenimiento_id)
);

CREATE TABLE Contrato_Auto (
  contrato_id INT AUTO_INCREMENT PRIMARY KEY,
  auto_id INT,
  cliente_id INT,
  agencia_id INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  FOREIGN KEY (auto_id) REFERENCES Auto(auto_id),
  FOREIGN KEY (cliente_id) REFERENCES Cliente(cliente_id),
  FOREIGN KEY (agencia_id) REFERENCES Agencia(agencia_id)
);

ALTER TABLE Cliente ADD direccion VARCHAR(100);

INSERT INTO Tipo_Auto (nombre) VALUES 
('Sedán'),
('SUV'),
('Pickup');

INSERT INTO Auto (placa, modelo, tipo_id) VALUES 
('ABC123', 'Mazda 3', 1),
('DEF456', 'Toyota RAV4', 2),
('GHI789', 'Ford Ranger', 3);

INSERT INTO Cliente (nombre, email, telefono, direccion) VALUES 
('Carlos Pérez', 'carlos@mail.com', '3001112233', 'Calle 10 #15-23'),
('Mariana Díaz', 'mariana@mail.com', '3011223344', 'Carrera 20 #45-67'),
('Juan Gómez', 'juan@mail.com', '3022334455', 'Av 30 #50-10');

INSERT INTO Agencia (nombre, ciudad) VALUES 
('RentaFácil', 'Bogotá'),
('AutosYa', 'Medellín'),
('ViajaMás', 'Cali');

INSERT INTO Mantenimiento (descripcion, costo) VALUES 
('Cambio de aceite', 120000),
('Alineación', 80000),
('Frenos nuevos', 200000);

INSERT INTO Auto_Mantenimiento (auto_id, mantenimiento_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Contrato_Auto (auto_id, cliente_id, agencia_id, fecha_inicio, fecha_fin) VALUES 
(1, 1, 1, '2025-08-01', '2025-08-05'),
(2, 2, 2, '2025-08-10', '2025-08-12'),
(3, 3, 3, '2025-08-15', '2025-08-20');

UPDATE Tipo_Auto SET nombre = 'Sedán Compacto' WHERE tipo_id = 1;
UPDATE Auto SET modelo = 'Mazda 3 Touring' WHERE auto_id = 1;
UPDATE Cliente SET nombre = 'Carlos E. Pérez' WHERE cliente_id = 1;
UPDATE Agencia SET nombre = 'RentaFácil Express' WHERE agencia_id = 1;
UPDATE Mantenimiento SET costo = 130000 WHERE mantenimiento_id = 1;

DELETE FROM Auto_Mantenimiento WHERE auto_id = 1 AND mantenimiento_id = 1;
DELETE FROM Contrato_Auto WHERE contrato_id = 1;
DELETE FROM Auto WHERE auto_id = 1;
DELETE FROM Cliente WHERE cliente_id = 1;
DELETE FROM Mantenimiento WHERE mantenimiento_id = 1;

SELECT Auto.modelo, Tipo_Auto.nombre AS tipo
FROM Auto
JOIN Tipo_Auto ON Auto.tipo_id = Tipo_Auto.tipo_id;

SELECT Auto.placa, Mantenimiento.descripcion
FROM Auto_Mantenimiento
JOIN Auto ON Auto_Mantenimiento.auto_id = Auto.auto_id
JOIN Mantenimiento ON Auto_Mantenimiento.mantenimiento_id = Mantenimiento.mantenimiento_id;

SELECT Auto.placa, Cliente.nombre AS cliente
FROM Contrato_Auto
JOIN Auto ON Contrato_Auto.auto_id = Auto.auto_id
JOIN Cliente ON Contrato_Auto.cliente_id = Cliente.cliente_id;

SELECT Agencia.ciudad, COUNT(*) AS total_contratos
FROM Agencia
JOIN Contrato_Auto ON Agencia.agencia_id = Contrato_Auto.agencia_id
GROUP BY Agencia.ciudad;

SELECT Tipo_Auto.nombre, COUNT(*) AS total_autos
FROM Tipo_Auto
JOIN Auto ON Tipo_Auto.tipo_id = Auto.tipo_id
GROUP BY Tipo_Auto.tipo_id;

SELECT nombre FROM Cliente
WHERE cliente_id IN (
  SELECT cliente_id FROM Contrato_Auto WHERE agencia_id = 2
);

SELECT modelo FROM Auto
WHERE auto_id IN (
  SELECT auto_id FROM Auto_Mantenimiento WHERE mantenimiento_id = 2
);

SELECT nombre FROM Agencia
WHERE agencia_id IN (
  SELECT agencia_id FROM Contrato_Auto WHERE auto_id = 2
);

SELECT nombre FROM Tipo_Auto
WHERE tipo_id = (
  SELECT tipo_id FROM Auto WHERE placa = 'DEF456'
);

SELECT modelo FROM Auto
WHERE auto_id = (
  SELECT auto_id FROM Contrato_Auto ORDER BY fecha_fin DESC LIMIT 1
);

SELECT COUNT(*) FROM Auto;
SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM Agencia;
SELECT COUNT(*) FROM Mantenimiento;
SELECT COUNT(*) FROM Contrato_Auto;
SELECT SUM(costo) FROM Mantenimiento;
SELECT AVG(costo) FROM Mantenimiento;
SELECT MAX(costo) FROM Mantenimiento;
SELECT LENGTH(modelo) FROM Auto LIMIT 1;
SELECT COUNT(*) FROM Auto_Mantenimiento;

DELIMITER $$

CREATE PROCEDURE RegistrarContrato (
  IN p_auto_id INT,
  IN p_cliente_id INT,
  IN p_agencia_id INT,
  IN p_fecha_inicio DATE,
  IN p_fecha_fin DATE
)
BEGIN
  INSERT INTO Contrato_Auto(auto_id, cliente_id, agencia_id, fecha_inicio, fecha_fin)
  VALUES (p_auto_id, p_cliente_id, p_agencia_id, p_fecha_inicio, p_fecha_fin);
END $$

DELIMITER ;

TRUNCATE TABLE Auto_Mantenimiento;

DROP TABLE Auto_Mantenimiento;
DROP TABLE Contrato_Auto;
DROP TABLE Auto;
DROP TABLE Cliente;
DROP TABLE Agencia;
DROP TABLE Mantenimiento;
DROP TABLE Tipo_Auto;

DROP DATABASE RentaAutos;
