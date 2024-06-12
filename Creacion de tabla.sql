CREATE DATABASE Revista;


CREATE TABLE Equipos (
    codEquipo VARCHAR(3), 
    nomEquipo VARCHAR(20), 
    presEquipo VARCHAR(20), 
    fundacionEquipo DATE, 
    regionEquipo VARCHAR(10), 
    colorEquipo VARCHAR(10),
    CONSTRAINT PK_Equipos PRIMARY KEY (codEquipo),
    CONSTRAINT CK_Equipos_Region CHECK (regionEquipo IN('Sur','Norte')),
    CONSTRAINT CK_Equipos_Fundacion CHECK (fundacionEquipo <= GETDATE()),
    CONSTRAINT CK_Equipos_CodEquipo CHECK (LEN(codEquipo) = 3)
);

CREATE TABLE Jugadores (
    carnJug NUMERIC(5),
    ciJug NUMERIC(8),
    nomJug VARCHAR(20) NOT NULL,
    apeJug VARCHAR(20) NOT NULL,
    nacJug VARCHAR(15),
    telJug NUMERIC(9),
    tipoJug VARCHAR(11),
    carnetNro NUMERIC(5),
    carnetVto DATE,
    codEquipo VARCHAR(3),
    CONSTRAINT PK_Jugadores PRIMARY KEY (carnJug),
    CONSTRAINT FK_Jugadores_CodEqui FOREIGN KEY (codEquipo) REFERENCES Equipos(codEquipo),
    CONSTRAINT UC_Jugadores_Ci UNIQUE (ciJug),
    CONSTRAINT UC_Jugadores_Tel UNIQUE (telJug),
    CONSTRAINT CK_Jugadores_Tipo CHECK (tipoJug IN('Profesional','Amateur'))
);

CREATE TABLE Canchas (
    nomCancha VARCHAR(10),
    capCancha NUMERIC(5),
    codEquipo VARCHAR(3),
    CONSTRAINT PK_Cancha PRIMARY KEY (nomCancha),
    CONSTRAINT FK_Cancha_Cod FOREIGN KEY (codEquipo) REFERENCES Equipos(codEquipo),
    CONSTRAINT CK_Cancha_Cap CHECK (capCancha >= 1000)
);

CREATE TABLE Arbitros (
    ciArbitro NUMERIC(8),
    nomArbitro VARCHAR(10) NOT NULL,
    apelArbitro VARCHAR(10) NOT NULL,
    celularArbitro NUMERIC(9),
    dirArbitro VARCHAR(20),
    mailArbitro VARCHAR(20),
    CONSTRAINT PK_Arbitros PRIMARY KEY (ciArbitro),
    CONSTRAINT UK_Arbitros_Mail UNIQUE (mailArbitro)
);

CREATE TABLE Formularios (
    numForm NUMERIC(10),
    fchForm DATE,
    ciArbitro NUMERIC(8),
    CONSTRAINT PK_Formularios PRIMARY KEY (numForm),
    CONSTRAINT FK_Formularios_CiArbitro FOREIGN KEY (ciArbitro) REFERENCES Arbitros(ciArbitro)
);

CREATE TABLE Detalles (
    numForm NUMERIC(10),
    linDet VARCHAR(100),
    cntRojas NUMERIC(2),
    cntAmarillas NUMERIC(2),
    cntGoles NUMERIC(2),
    carnJug NUMERIC(5),
    CONSTRAINT PK_Detalles PRIMARY KEY (numForm, linDet),
    CONSTRAINT FK_Detalles_NumForm FOREIGN KEY (numForm) REFERENCES Formularios(numForm),
    CONSTRAINT FK_Detalles_CarnJug FOREIGN KEY (carnJug) REFERENCES Jugadores(carnJug)
);

CREATE TABLE Partidos (
    codEquipo_local VARCHAR(3),
    codEquipo_visita VARCHAR(3),
    fecha DATE,
    GL NUMERIC(2),
    GV NUMERIC(2),
    ciArbitro NUMERIC(8),
    nomCancha VARCHAR(10),
    CONSTRAINT PK_Partidos PRIMARY KEY (codEquipo_local, codEquipo_visita, fecha),
    CONSTRAINT FK_Partidos_CodLocal FOREIGN KEY (codEquipo_local) REFERENCES Equipos(codEquipo),
    CONSTRAINT FK_Partidos_CodVisita FOREIGN KEY (codEquipo_visita) REFERENCES Equipos(codEquipo),
    CONSTRAINT FK_Partidos_CiArbitro FOREIGN KEY (ciArbitro) REFERENCES Arbitros(ciArbitro),
    CONSTRAINT FK_Partidos_Cancha FOREIGN KEY (nomCancha) REFERENCES Canchas(nomCancha)
);

INSERT INTO Equipos (codEquipo, nomEquipo, presEquipo, fundacionEquipo, regionEquipo, colorEquipo)
VALUES 
('E01', 'Equipo Uno', 'Juan Perez', '2000-01-01', 'Sur', 'Rojo'),
('E02', 'Equipo Dos', 'Maria Lopez', '1995-05-10', 'Norte', 'Azul'),
('E03', 'Equipo Tres', 'Carlos Sanchez', '2010-12-15', 'Sur', 'Verde'),
('E04', 'Equipo Cuatro', 'Laura Gomez', '2005-07-20', 'Norte', 'Amarillo'),
('E05', 'Equipo Cinco', 'Pedro Martinez', '1950-11-30', 'Sur', 'Naranja'),
('E06', 'Equipo Seis', 'Sofia Fernandez', '1950-03-25', 'Norte', 'Violeta'),
('E07', 'Equipo Siete', 'Miguel Torres', '2015-09-10', 'Sur', 'Negro'),
('E08', 'Equipo Ocho', 'Ana Rios', '1997-08-05', 'Norte', 'Blanco'),
('E09', 'Equipo Nueve', 'Luis Ramirez', '1950-12-01', 'Sur', 'Gris'),
('E10', 'Equipo Diez', 'Elena Suarez', '2007-06-15', 'Norte', 'Rosa');

INSERT INTO Canchas (nomCancha, capCancha, codEquipo)
VALUES 
('Cancha1', 1500, 'E01'),
('Cancha2', 2000, 'E02'),
('Cancha3', 1800, 'E03'),
('Cancha4', 2200, 'E04'),
('Cancha5', 1600, 'E05'),
('Cancha6', 1700, 'E06'),
('Cancha7', 1900, 'E07'),
('Cancha8', 2100, 'E08'),
('Cancha9', 2300, 'E09'),
('Cancha10', 2400, 'E10');

INSERT INTO Arbitros (ciArbitro, nomArbitro, apelArbitro, celularArbitro, dirArbitro, mailArbitro)
VALUES 
(34567890, 'Luis', 'Fernandez', 765432109, 'Calle Falsa 123', 'luis@mail.com'),
(45678901, 'Jose', 'Perez', 654321098, 'Avenida Siempre Viva', 'jose@mail.com'),
(56789012, 'Carlos', 'Ramirez', 543210987, 'Boulevard Principal 45', 'carlos@mail.com'),
(67890123, 'Miguel', 'Torres', 432109876, 'Calle Secundaria 12', 'miguel@mail.com'),
(78901234, 'Ana', 'Rios', 321098765, 'Calle Tercera 78', 'ana@mail.com'),
(89012345, 'Laura', 'Gomez', 210987654, 'Avenida Cuarta 56', 'laura@mail.com'),
(90123456, 'Sofia', 'Fernandez', 109876543, 'Calle Quinta 34', 'sofia@mail.com'),
(91234567, 'Pedro', 'Gomez', 198765432, 'Calle Sexta 90', 'pedro@mail.com'),
(12345678, 'Elena', 'Suarez', 987654321, 'Boulevard Sexta 23', 'elena@mail.com'),
(23456789, 'Maria', 'Lopez', 876543210, 'Calle Septima 67', 'maria@mail.com');

ALTER TABLE Arbitros
ALTER COLUMN dirArbitro VARCHAR(50);

INSERT INTO Formularios (numForm, fchForm, ciArbitro)
VALUES 
(1, '2024-06-01', 34567890),
(2, '2024-06-02', 45678901),
(3, '2024-06-03', 56789012),
(4, '2024-06-04', 67890123),
(5, '2024-06-05', 78901234),
(6, '2024-06-06', 89012345),
(7, '2024-06-07', 90123456),
(8, '2024-06-08', 91234567),
(9, '2024-06-09', 12345678),
(10, '2024-06-10', 23456789);

INSERT INTO Jugadores (carnJug, ciJug, nomJug, apeJug, nacJug, telJug, tipoJug, carnetNro, carnetVto, codEquipo)
VALUES 
(10001, 12345678, 'Pedro', 'Gomez', 'Uruguay', 987654321, 'Profesional', 5001, '2025-01-01', 'E01'),
(10002, 23456789, 'Ana', 'Martinez', 'Argentina', 876543210, 'Amateur', 5002, '2024-12-31', 'E02'),
(10003, 34567890, 'Luis', 'Fernandez', 'Chile', 765432109, 'Profesional', 5003, '2026-05-20', 'E03'),
(10004, 45678901, 'Jose', 'Perez', 'Paraguay', 654321098, 'Amateur', 5004, '2023-11-15', 'E04'),
(10005, 56789012, 'Miguel', 'Torres', 'Brasil', 543210987, 'Profesional', 5005, '2025-03-10', 'E05'),
(10006, 67890123, 'Laura', 'Gomez', 'Uruguay', 432109876, 'Amateur', 5006, NULL, 'E06'),
(10007, 78901234, 'Sofia', 'Fernandez', 'Argentina', 321098765, 'Profesional', 5007, NULL, 'E07'),
(10008, 89012345, 'Elena', 'Suarez', 'Chile', 210987654, 'Amateur', 5008, '2026-06-05', 'E08'),
(10009, 90123456, 'Carlos', 'Sanchez', 'Paraguay', 109876543, 'Profesional', 5009, '2023-07-15', 'E09'),
(10010, 91234567, 'Maria', 'Lopez', 'Brasil', 198765432, 'Amateur', 5010, '2024-10-20', 'E10');

INSERT INTO Detalles (numForm, linDet, cntRojas, cntAmarillas, cntGoles, carnJug)
VALUES 
(1, 'Detalle1', 1, 2, 3, 10001),
(2, 'Detalle2', 0, 1, 2, 10002),
(3, 'Detalle3', 2, 0, 1, 10003),
(4, 'Detalle4', 1, 1, 1, 10004),
(5, 'Detalle5', 0, 0, 2, 10005),
(6, 'Detalle6', 1, 2, 3, 10006),
(7, 'Detalle7', 0, 1, 2, 10007),
(8, 'Detalle8', 2, 0, 1, 10008),
(9, 'Detalle9', 1, 1, 1, 10009),
(10, 'Detalle10', 0, 0, 2, 10010);

INSERT INTO Partidos (codEquipo_local, codEquipo_visita, fecha, GL, GV, ciArbitro, nomCancha)
VALUES 
('E01', 'E02', '2024-06-03', 2, 1, 34567890, 'Cancha1'),
('E02', 'E03', '2024-06-04', 1, 1, 45678901, 'Cancha2'),
('E03', 'E04', '2024-06-05', 3, 2, 56789012, 'Cancha3'),
('E04', 'E05', '2024-06-06', 0, 2, 67890123, 'Cancha4'),
('E05', 'E06', '2024-06-07', 1, 3, 78901234, 'Cancha5'),
('E06', 'E07', '2024-06-08', 2, 2, 89012345, 'Cancha6'),
('E07', 'E08', '2024-06-09', 1, 0, 90123456, 'Cancha7'),
('E08', 'E09', '2024-06-10', 2, 1, 91234567, 'Cancha8'),
('E09', 'E10', '2024-06-11', 3, 3, 12345678, 'Cancha9'),
('E10', 'E01', '2024-06-12', 0, 0, 23456789, 'Cancha10'),
('E01', 'E02', '2024-07-03', 2, 1, 34567890, 'Cancha1'),
('E02', 'E03', '2024-07-04', 1, 1, 45678901, 'Cancha1'),
('E03', 'E04', '2024-07-05', 3, 2, 56789012, 'Cancha1'),
('E04', 'E05', '2024-07-06', 1, 0, 67890123, 'Cancha1'),
('E05', 'E06', '2024-07-07', 2, 0, 78901234, 'Cancha1'),
('E06', 'E07', '2024-07-08', 0, 3, 89012345, 'Cancha1'),
('E07', 'E08', '2024-07-09', 1, 1, 90123456, 'Cancha1'),
('E08', 'E09', '2024-07-10', 2, 1, 91234567, 'Cancha1'),
('E09', 'E10', '2024-07-11', 3, 2, 12345678, 'Cancha1'),
('E10', 'E01', '2024-07-12', 0, 1, 23456789, 'Cancha1'); 
