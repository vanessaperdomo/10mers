CREATE DATABASE EventosCulturales;
USE EventosCulturales;

CREATE TABLE Lugar (
  lugar_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(100)
);

CREATE TABLE Evento (
  evento_id INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  fecha DATE,
  lugar_id INT,
  FOREIGN KEY (lugar_id) REFERENCES Lugar(lugar_id)
);

CREATE TABLE Artista (
  artista_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Participante (
  participante_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE Categoria (
  categoria_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

-- Pivote: Evento - Artista
CREATE TABLE Evento_Artista (
  evento_id INT,
  artista_id INT,
  PRIMARY KEY (evento_id, artista_id),
  FOREIGN KEY (evento_id) REFERENCES Evento(evento_id),
  FOREIGN KEY (artista_id) REFERENCES Artista(artista_id)
);

-- Pivote: Participante - Evento
CREATE TABLE Participante_Evento (
  participante_id INT,
  evento_id INT,
  PRIMARY KEY (participante_id, evento_id),
  FOREIGN KEY (participante_id) REFERENCES Participante(participante_id),
  FOREIGN KEY (evento_id) REFERENCES Evento(evento_id)
);

-- ALTER TABLE
ALTER TABLE Lugar ADD capacidad INT;
ALTER TABLE Lugar DROP COLUMN direccion;

-- INSERTS (3 por tabla)
INSERT INTO Lugar (nombre, capacidad) VALUES 
('Teatro Nacional', 300),
('Museo de Arte Moderno', 150),
('Plaza Cultural', 500);

INSERT INTO Categoria (nombre) VALUES 
('Música'),
('Artes Visuales'),
('Teatro');

INSERT INTO Evento (titulo, fecha, lugar_id) VALUES 
('Concierto Sinfónico', '2025-08-10', 1),
('Exposición Fotográfica', '2025-09-05', 2),
('Obra de Teatro Clásica', '2025-10-15', 3);

INSERT INTO Artista (nombre, especialidad) VALUES 
('Orquesta Filarmónica', 'Música'),
('Sofía Torres', 'Fotografía'),
('Grupo Dramático Escena', 'Teatro');

INSERT INTO Participante (nombre, email) VALUES 
('Juan Rivas', 'juanr@mail.com'),
('Laura Ramírez', 'laura@mail.com'),
('Carlos Medina', 'carlos@mail.com');

INSERT INTO Evento_Artista (evento_id, artista_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

INSERT INTO Participante_Evento (participante_id, evento_id) VALUES 
(1, 1),
(2, 2),
(3, 3);

-- UPDATE (5)
UPDATE Lugar SET capacidad = 350 WHERE lugar_id = 1;
UPDATE Evento SET titulo = 'Gran Concierto Sinfónico' WHERE evento_id = 1;
UPDATE Artista SET nombre = 'Sofía T. Torres' WHERE artista_id = 2;
UPDATE Participante SET nombre = 'Juan P. Rivas' WHERE participante_id = 1;
UPDATE Categoria SET nombre = 'Música Clásica' WHERE categoria_id = 1;

-- DELETE (5) registros existentes
DELETE FROM Participante_Evento WHERE participante_id = 1 AND evento_id = 1;
DELETE FROM Evento_Artista WHERE evento_id = 1 AND artista_id = 1;
DELETE FROM Evento WHERE evento_id = 1;
DELETE FROM Lugar WHERE lugar_id = 1;
DELETE FROM Artista WHERE artista_id = 1;

-- SELECT JOIN (5)
SELECT Evento.titulo, Lugar.nombre AS lugar, Evento.fecha
FROM Evento
JOIN Lugar ON Evento.lugar_id = Lugar.lugar_id;

SELECT Artista.nombre AS artista, Evento.titulo AS evento
FROM Evento_Artista
JOIN Artista ON Evento_Artista.artista_id = Artista.artista_id
JOIN Evento ON Evento_Artista.evento_id = Evento.evento_id;

SELECT Participante.nombre, Evento.titulo
FROM Participante_Evento
JOIN Participante ON Participante_Evento.participante_id = Participante.participante_id
JOIN Evento ON Participante_Evento.evento_id = Evento.evento_id;

SELECT Categoria.nombre, COUNT(*) AS total_eventos
FROM Categoria
JOIN Evento ON Categoria.categoria_id = 1
GROUP BY Categoria.categoria_id;

SELECT Lugar.nombre AS lugar, COUNT(*) AS eventos_realizados
FROM Lugar
JOIN Evento ON Lugar.lugar_id = Evento.lugar_id
GROUP BY Lugar.lugar_id;

-- SUBCONSULTAS (5)
SELECT nombre FROM Lugar
WHERE lugar_id IN (
  SELECT lugar_id FROM Evento WHERE fecha > '2025-08-01'
);

SELECT nombre FROM Participante
WHERE participante_id IN (
  SELECT participante_id FROM Participante_Evento WHERE evento_id = 2
);

SELECT titulo FROM Evento
WHERE evento_id = (
  SELECT evento_id FROM Evento_Artista WHERE artista_id = 2
);

SELECT nombre FROM Artista
WHERE artista_id = (
  SELECT artista_id FROM Evento_Artista WHERE evento_id = 2
);

SELECT nombre FROM Lugar
WHERE capacidad = (
  SELECT MAX(capacidad) FROM Lugar
);

-- FUNCIONES (10)
SELECT COUNT(*) FROM Evento;
SELECT COUNT(*) FROM Artista;
SELECT COUNT(*) FROM Participante;
SELECT SUM(capacidad) FROM Lugar;
SELECT AVG(capacidad) FROM Lugar;
SELECT MAX(capacidad) FROM Lugar;
SELECT MIN(capacidad) FROM Lugar;
SELECT COUNT(*) FROM Evento_Artista;
SELECT COUNT(DISTINCT lugar_id) FROM Evento;
SELECT COUNT(*) FROM Participante_Evento;

DELIMITER $$
CREATE PROCEDURE RegistrarParticipacion (
  IN p_participante_id INT,
  IN p_evento_id INT
)
BEGIN
  INSERT INTO Participante_Evento (participante_id, evento_id)
  VALUES (p_participante_id, p_evento_id);
END $$
DELIMITER ;
