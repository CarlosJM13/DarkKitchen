-- ==============================================================================
-- 1. CREACIÓN DE LA BASE DE DATOS Y USO
-- ==============================================================================
CREATE DATABASE IF NOT EXISTS DarkKitchen;
USE DarkKitchen;

-- ==============================================================================
-- 2. CREACIÓN DE TABLAS Y RESTRICCIONES (DDL)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS Plataformas (
    id_plataforma INT AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(50) NOT NULL, 
    porcentaje_comision DECIMAL(5,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    telefono VARCHAR(15) NOT NULL, 
    direccion VARCHAR(255),
    correo VARCHAR(100) UNIQUE -- [NUEVO] Restricción Única (No permite duplicados)
);

CREATE TABLE IF NOT EXISTS Platillos (
    id_platillo INT AUTO_INCREMENT PRIMARY KEY, 
    nombre VARCHAR(100) NOT NULL, 
    precio DECIMAL(10,2) NOT NULL, 
    costo_preparacion DECIMAL(10,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS Pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY, 
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP, 
    estado VARCHAR(20) DEFAULT 'Pendiente', 
    total DECIMAL(10,2) DEFAULT 0.00, 
    id_plataforma INT, 
    id_cliente INT, 
    FOREIGN KEY (id_plataforma) REFERENCES Plataformas(id_plataforma), 
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

CREATE TABLE IF NOT EXISTS Detalle_Pedido (
    id_pedido INT, 
    id_platillo INT, 
    cantidad INT NOT NULL, 
    precio_unitario DECIMAL(10,2) NOT NULL, 
    PRIMARY KEY (id_pedido, id_platillo), 
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido), 
    FOREIGN KEY (id_platillo) REFERENCES Platillos(id_platillo)
);

-- [NUEVO] Tabla para el seguimiento automático de compras (Auditoría del Trigger)
CREATE TABLE IF NOT EXISTS Seguimiento_Clientes (
    id_seguimiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    fecha_hora DATETIME,
    id_pedido INT,
    plataforma VARCHAR(50)
);

-- ==============================================================================
-- 3. INSERCIÓN DE DATOS INICIALES (DML)
-- ==============================================================================
-- Limpiar tablas si se corre el script múltiples veces para evitar errores
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Detalle_Pedido;
TRUNCATE TABLE Pedidos;
TRUNCATE TABLE Platillos;
TRUNCATE TABLE Clientes;
TRUNCATE TABLE Plataformas;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Plataformas (nombre, porcentaje_comision) VALUES 
('Uber Eats', 30.00), ('Didi Food', 25.00), ('Rappi', 28.00), ('WhatsApp Directo', 0.00), ('Propia Web', 2.00);

/*Inserto 83 clientes*/
INSERT INTO Clientes (nombre, telefono, direccion, correo) VALUES 
('Oscar Ruben', '5588705576', 'Privada 140, Col. Escandon', 'Oz.Lopez@email.com'),
('Luis Vidal', '5565026767', 'Av. Independencia, Col. Centro, Tlaxcala', 'Vidal.Lui67@email.com'),
('Ricardo Morales', '5556555954', 'Calle 139, Col. Mixcoac', 'carlos.lopez3@email.com'),
('Ana Martinez', '5549248723', 'Calzada 911, Col. Coyoacan', 'ana.martinez4@email.com'),
('Luis Fernandez', '5526698279', 'Calle 202, Col. Del Valle', 'luis.fernandez5@email.com'),
('Sofia Hernandez', '5567630720', 'Av. 397, Col. Escandon', 'sofia.hernandez6@email.com'),
('Diego Ramirez', '5574125625', 'Av. 340, Col. Mixcoac', 'diego.ramirez7@email.com'),
('Carlos Estrada', '5597755267', 'Av. 1 de mayo, Col. Centro, Cuautitlán Izcalli', 'estrada.Carlos67@email.com'),
('Miguel Sanchez', '5540648177', 'Calzada 644, Col. Polanco', 'miguel.sanchez9@email.com'),
('Camila Flores', '5514596914', 'Av. 375, Col. Escandon', 'camila.flores10@email.com'),
('Alejandro Rivera', '5585686996', 'Calle 700, Col. Del Valle', 'alejandro.rivera11@email.com'),
('Daniela Gomez', '5545953193', 'Av. 209, Col. Polanco', 'daniela.gomez12@email.com'),
('Jorge Diaz', '5549506714', 'Av. 708, Col. Polanco', 'jorge.diaz13@email.com'),
('Fernanda Cruz', '5521423465', 'Av. 683, Col. Juarez', 'fernanda.cruz14@email.com'),
('Antonio Parra ', '5546068567', 'Av. Madero, Col. Centro, Tangamandapio', 'Parra.Antonio67@email.com'),
('Paola Reyes', '5519957583', 'Calzada 18, Col. Escandon', 'paola.reyes16@email.com'),
('Andres Gutierrez', '5546357115', 'Calzada 469, Col. San Rafael', 'andres.gutierrez17@email.com'),
('Natalia Ortiz', '5521394808', 'Calzada 577, Col. Coyoacan', 'natalia.ortiz18@email.com'),
('Eduardo Castillo', '5549291738', 'Av. 495, Col. Mixcoac', 'eduardo.castillo19@email.com'),
('Mariana Mendoza', '5518541200', 'Privada 759, Col. Mixcoac', 'mariana.mendoza20@email.com'),
('Roberto Vargas', '5513319494', 'Av. 500, Col. Roma Norte', 'roberto.vargas21@email.com'),
('Gabriela Rojas', '5576694131', 'Privada 461, Col. Condesa', 'gabriela.rojas22@email.com'),
('Fernando Navarro', '5592784946', 'Privada 507, Col. Centro', 'fernando.navarro23@email.com'),
('Lucia Jimenez', '5546940674', 'Av. 817, Col. Santa Maria', 'lucia.jimenez24@email.com'),
('Emiliano Moreno', '5550572003', 'Calle 116, Col. Coyoacan', 'emiliano.moreno25@email.com'),
('Renata Silva', '5559144587', 'Privada 442, Col. Condesa', 'renata.silva26@email.com'),
('Sebastian Ramos', '5579890134', 'Calle 950, Col. Polanco', 'sebastian.ramos27@email.com'),
('Atziri Karel', '5584217567', 'Av. Educadores, Col. Amalucan, Puebla', 'atziri.karel10@email.com'),
('Mateo Castro', '5544953232', 'Privada 977, Col. Roma Norte', 'mateo.castro29@email.com'),
('Ximena Romero', '5511857836', 'Calzada 873, Col. Polanco', 'ximena.romero30@email.com'),
('Hector Mendoza', '5554147391', 'Calzada 659, Col. Centro', 'hector.mendoza31@email.com'),
('Andrea Salazar', '5575385767', 'Privada 23, Col. Mixcoac', 'andrea.salazar32@email.com'),
('Joaquin Fuentes', '5592236601', 'Privada 968, Col. Centro', 'joaquin.fuentes33@email.com'),
('Valentina Cabrera', '5520388062', 'Privada 738, Col. Condesa', 'valentina.cabrera34@email.com'),
('Marco Espinoza', '5521121946', 'Calle 568, Col. Condesa', 'marco.espinoza35@email.com'),
('Isabella Medina', '5591953244', 'Privada 240, Col. Narvarte', 'isabella.medina36@email.com'),
('Santiago Nunez', '5555362420', 'Calzada 95, Col. Polanco', 'santiago.nunez37@email.com'),
('Montserrat Aguilar', '5544513686', 'Calle 640, Col. Coyoacan', 'montserrat.aguilar38@email.com'),
('Bruno Valencia', '5568939993', 'Calle 112, Col. Juarez', 'bruno.valencia39@email.com'),
('Regina Ponce', '5597108683', 'Calle 727, Col. Juarez', 'regina.ponce40@email.com'),
('Leonardo Solis', '5549174643', 'Privada 920, Col. Santa Maria', 'leonardo.solis41@email.com'),
('Victoria Campos', '5592136477', 'Av. 898, Col. Escandon', 'victoria.campos42@email.com'),
('Maximiliano Lara', '5536038362', 'Av. 517, Col. San Rafael', 'maximiliano.lara43@email.com'),
('Jimena Duarte', '5589391571', 'Calle 346, Col. Del Valle', 'jimena.duarte44@email.com'),
('Rodrigo Bravo', '5581086330', 'Calle 808, Col. Centro', 'rodrigo.bravo45@email.com'),
('Carolina Meza', '5537675086', 'Privada 900, Col. Mixcoac', 'carolina.meza46@email.com'),
('Ivan Serrano', '5589769394', 'Calle 994, Col. Escandon', 'ivan.serrano47@email.com'),
('Alondra Franco', '5597871391', 'Privada 381, Col. Santa Maria', 'alondra.franco48@email.com'),
('Oscar Padilla', '5557018810', 'Av. 267, Col. Centro', 'oscar.padilla49@email.com'),
('Melissa Acosta', '5551691587', 'Av. 514, Col. Condesa', 'melissa.acosta50@email.com'),
('Adrian Orozco', '5578654186', 'Calle 630, Col. Polanco', 'adrian.orozco51@email.com'),
('Natalia Miranda', '5567774335', 'Privada 188, Col. Mixcoac', 'natalia.miranda52@email.com'),
('Gael Dominguez', '5564926068', 'Privada 369, Col. Narvarte', 'gael.dominguez53@email.com'),
('Elena Valdez', '5556063581', 'Calzada 950, Col. Escandon', 'elena.valdez54@email.com'),
('Tomas Escobar', '5531238112', 'Privada 690, Col. Del Valle', 'tomas.escobar55@email.com'),
('Mia Bautista', '5558484995', 'Privada 313, Col. Polanco', 'mia.bautista56@email.com'),
('Pablo Villanueva', '5583730216', 'Calzada 221, Col. Escandon', 'pablo.villanueva57@email.com'),
('Claudia Rosales', '5584112952', 'Privada 320, Col. Polanco', 'claudia.rosales58@email.com'),
('Manuel Ibarra', '5517076633', 'Calzada 721, Col. Centro', 'manuel.ibarra59@email.com'),
('Abril Zamora', '5570950841', 'Privada 780, Col. Coyoacan', 'abril.zamora60@email.com'),
('Nicolas Cardenas', '5571373156', 'Av. 397, Col. Mixcoac', 'nicolas.cardenas61@email.com'),
('Diana Tapia', '5534489911', 'Av. 890, Col. Narvarte', 'diana.tapia62@email.com'),
('Rafael Montes', '5535847258', 'Calle 805, Col. Juarez', 'rafael.montes63@email.com'),
('Karla Benitez', '5545701017', 'Calzada 376, Col. Santa Maria', 'karla.benitez64@email.com'),
('Cristian Salinas', '5525936596', 'Av. 425, Col. Escandon', 'cristian.salinas65@email.com'),
('Fabiola Correa', '5582646648', 'Privada 363, Col. Escandon', 'fabiola.correa66@email.com'),
('Luisana Mora', '5530873203', 'Av. 442, Col. Escandon', 'luisana.mora67@email.com'),
('Esteban Trejo', '5599991637', 'Calle 41, Col. Santa Maria', 'esteban.trejo68@email.com'),
('Silvana Aguirre', '5526842235', 'Calzada 195, Col. Condesa', 'silvana.aguirre69@email.com'),
('Damian Cortes', '5574715837', 'Av. 81, Col. Centro', 'damian.cortes70@email.com'),
('Aitana Lozano', '5585323478', 'Privada 731, Col. Centro', 'aitana.lozano71@email.com'),
('Alan Galvan', '5591635667', 'Calzada 86, Col. Polanco', 'alan.galvan72@email.com'),
('Bianca Cervantes', '5510839366', 'Calzada 125, Col. Condesa', 'bianca.cervantes73@email.com'),
('Kevin Merino', '5527758868', 'Calle 100, Col. Santa Maria', 'kevin.merino74@email.com'),
('Patricia Solano', '5539851887', 'Calle 189, Col. Condesa', 'patricia.solano75@email.com'),
('Julian Carrillo', '5535849787', 'Privada 148, Col. Juarez', 'julian.carrillo76@email.com'),
('Melissa Nieto', '5552306833', 'Av. 350, Col. Mixcoac', 'melissa.nieto77@email.com'),
('Arturo Beltran', '5536483082', 'Av. 676, Col. Narvarte', 'arturo.beltran78@email.com'),
('Samantha Arias', '5534847700', 'Calzada 99, Col. Escandon', 'samantha.arias79@email.com'),
('Victor Saavedra', '5549686963', 'Av. 765, Col. San Rafael', 'victor.saavedra80@email.com'),
('Monica Lemus', '5545412319', 'Calle 560, Col. Polanco', 'monica.lemus81@email.com'),
('Enrique Arellano', '5533395124', 'Calle 218, Col. San Rafael', 'enrique.arellano82@email.com'),
('Sara Olvera', '5580075640', 'Calzada 932, Col. Mixcoac', 'sara.olvera83@email.com');

INSERT INTO Platillos (nombre, precio, costo_preparacion) VALUES 
('Hamburguesa Clásica', 120.00, 45.00), 
('Pizza Pepperoni', 180.00, 70.00), 
('Alitas BBQ (10 pz)', 150.00, 60.00), 
('Papas Fritas', 50.00, 15.00), 
('Refresco de Cola', 35.00, 10.00);

/*Historial de pedidos del 31 de agosto al 6 de septiembre del 2026 meti 146*/
INSERT INTO Pedidos (fecha, estado, total, id_plataforma, id_cliente) VALUES 
('2026-08-31 18:00:00', 'Entregado', 700.00, 2, 76),
('2026-08-31 11:25:00', 'Entregado', 670.00, 2, 81),
('2026-08-31 12:45:00', 'Entregado', 445.00, 2, 36),
('2026-08-31 20:20:00', 'Entregado', 1085.00, 1, 17),
('2026-08-31 19:10:00', 'Entregado', 70.00, 5, 58),
('2026-08-31 14:30:00', 'Entregado', 540.00, 4, 53),
('2026-08-31 18:55:00', 'Entregado', 1015.00, 4, 45),
('2026-08-31 18:50:00', 'Entregado', 700.00, 2, 31),
('2026-08-31 11:20:00', 'Entregado', 150.00, 5, 57),
('2026-08-31 19:30:00', 'Entregado', 495.00, 2, 77),
('2026-08-31 12:50:00', 'Entregado', 400.00, 3, 3),
('2026-08-31 19:40:00', 'Cancelado', 705.00, 2, 80),
('2026-08-31 18:25:00', 'Entregado', 630.00, 5, 38),
('2026-08-31 11:40:00', 'Entregado', 550.00, 4, 66),
('2026-08-31 22:25:00', 'Entregado', 1120.00, 5, 61),
('2026-08-31 21:15:00', 'Entregado', 525.00, 4, 51),
('2026-08-31 13:10:00', 'Entregado', 240.00, 5, 16),
('2026-08-31 12:10:00', 'Entregado', 35.00, 1, 9),
('2026-08-31 12:15:00', 'Entregado', 335.00, 3, 25),
('2026-08-31 14:15:00', 'Entregado', 1400.00, 2, 33),
('2026-08-31 18:10:00', 'Entregado', 395.00, 2, 28),
('2026-08-31 22:40:00', 'Cancelado', 680.00, 2, 54),
('2026-08-31 21:25:00', 'Cancelado', 405.00, 2, 12),
('2026-09-01 18:50:00', 'Entregado', 35.00, 1, 65),
('2026-09-01 21:30:00', 'Entregado', 305.00, 4, 32),
('2026-09-01 21:00:00', 'Entregado', 570.00, 1, 83),
('2026-09-01 13:35:00', 'Entregado', 375.00, 5, 82),
('2026-09-01 12:55:00', 'Entregado', 370.00, 1, 15),
('2026-09-01 14:10:00', 'Entregado', 590.00, 3, 21),
('2026-09-01 22:00:00', 'Entregado', 85.00, 5, 74),
('2026-09-01 21:35:00', 'Entregado', 420.00, 3, 42),
('2026-09-01 13:30:00', 'Entregado', 520.00, 4, 68),
('2026-09-01 13:00:00', 'Entregado', 445.00, 2, 34),
('2026-09-01 18:10:00', 'Entregado', 640.00, 1, 59),
('2026-09-01 21:55:00', 'Entregado', 480.00, 3, 23),
('2026-09-01 20:45:00', 'Entregado', 830.00, 5, 30),
('2026-09-01 22:20:00', 'Cancelado', 335.00, 4, 56),
('2026-09-01 19:40:00', 'Entregado', 550.00, 2, 75),
('2026-09-02 13:30:00', 'Entregado', 930.00, 1, 27),
('2026-09-02 20:15:00', 'Entregado', 585.00, 5, 40),
('2026-09-02 19:10:00', 'Entregado', 750.00, 5, 14),
('2026-09-02 21:45:00', 'Entregado', 680.00, 2, 73),
('2026-09-02 20:55:00', 'Entregado', 360.00, 3, 10),
('2026-09-02 12:15:00', 'Entregado', 575.00, 1, 49),
('2026-09-02 11:20:00', 'Entregado', 990.00, 3, 29),
('2026-09-02 13:10:00', 'Entregado', 860.00, 3, 37),
('2026-09-02 14:40:00', 'Entregado', 945.00, 3, 35),
('2026-09-02 18:20:00', 'Cancelado', 895.00, 2, 5),
('2026-09-02 20:40:00', 'Cancelado', 820.00, 4, 20),
('2026-09-02 12:10:00', 'Entregado', 545.00, 3, 18),
('2026-09-02 22:10:00', 'Entregado', 205.00, 4, 69),
('2026-09-03 11:45:00', 'Entregado', 240.00, 2, 13),
('2026-09-03 12:10:00', 'Entregado', 435.00, 5, 8),
('2026-09-03 14:15:00', 'Entregado', 1230.00, 5, 41),
('2026-09-03 19:55:00', 'Entregado', 205.00, 5, 7),
('2026-09-03 22:20:00', 'Entregado', 960.00, 2, 22),
('2026-09-03 13:15:00', 'Entregado', 350.00, 3, 79),
('2026-09-03 11:25:00', 'Entregado', 540.00, 1, 78),
('2026-09-03 14:30:00', 'Entregado', 1040.00, 3, 62),
('2026-09-03 21:35:00', 'Entregado', 880.00, 1, 63),
('2026-09-03 20:15:00', 'Entregado', 330.00, 2, 72),
('2026-09-03 21:40:00', 'Entregado', 745.00, 2, 70),
('2026-09-03 19:10:00', 'Entregado', 105.00, 1, 2),
('2026-09-03 20:35:00', 'Entregado', 540.00, 5, 26),
('2026-09-03 19:20:00', 'Entregado', 665.00, 1, 67),
('2026-09-03 18:15:00', 'Entregado', 920.00, 4, 1),
('2026-09-03 14:50:00', 'Entregado', 565.00, 1, 19),
('2026-09-03 14:40:00', 'Entregado', 335.00, 1, 24),
('2026-09-03 22:25:00', 'Entregado', 170.00, 2, 39),
('2026-09-03 11:30:00', 'Entregado', 480.00, 3, 60),
('2026-09-04 19:15:00', 'Entregado', 850.00, 3, 11),
('2026-09-04 18:45:00', 'Entregado', 1150.00, 4, 55),
('2026-09-04 21:00:00', 'Entregado', 300.00, 4, 48),
('2026-09-04 14:35:00', 'Entregado', 375.00, 3, 43),
('2026-09-04 19:30:00', 'Entregado', 520.00, 4, 44),
('2026-09-04 19:45:00', 'Entregado', 760.00, 4, 47),
('2026-09-04 21:35:00', 'Entregado', 405.00, 3, 71),
('2026-09-04 19:10:00', 'Entregado', 465.00, 3, 6),
('2026-09-04 14:40:00', 'Entregado', 770.00, 5, 46),
('2026-09-04 12:30:00', 'Entregado', 400.00, 2, 64),
('2026-09-04 14:25:00', 'Entregado', 675.00, 2, 4),
('2026-09-04 20:30:00', 'Entregado', 885.00, 1, 52),
('2026-09-04 13:45:00', 'Entregado', 1035.00, 5, 50),
('2026-09-04 21:40:00', 'Entregado', 1090.00, 5, 37),
('2026-09-04 18:35:00', 'Entregado', 845.00, 1, 39),
('2026-09-04 11:35:00', 'Entregado', 180.00, 5, 58),
('2026-09-04 18:30:00', 'Entregado', 335.00, 2, 25),
('2026-09-04 22:50:00', 'Entregado', 645.00, 2, 40),
('2026-09-04 13:15:00', 'Entregado', 625.00, 2, 46),
('2026-09-04 11:45:00', 'Entregado', 180.00, 4, 44),
('2026-09-04 22:30:00', 'Entregado', 600.00, 2, 68),
('2026-09-04 13:40:00', 'Cancelado', 750.00, 5, 16),
('2026-09-04 11:30:00', 'Entregado', 170.00, 1, 68),
('2026-09-04 22:25:00', 'Cancelado', 1100.00, 2, 66),
('2026-09-04 12:00:00', 'Entregado', 35.00, 3, 52),
('2026-09-04 14:45:00', 'Entregado', 660.00, 4, 28),
('2026-09-04 12:40:00', 'Entregado', 120.00, 4, 42),
('2026-09-05 22:25:00', 'Entregado', 540.00, 3, 59),
('2026-09-05 19:35:00', 'Entregado', 350.00, 3, 31),
('2026-09-05 14:20:00', 'Cancelado', 105.00, 3, 47),
('2026-09-05 19:45:00', 'Entregado', 150.00, 1, 62),
('2026-09-05 22:20:00', 'Entregado', 465.00, 4, 29),
('2026-09-05 19:20:00', 'Cancelado', 580.00, 5, 20),
('2026-09-05 11:40:00', 'Entregado', 450.00, 3, 15),
('2026-09-05 21:40:00', 'Entregado', 120.00, 5, 49),
('2026-09-05 14:45:00', 'Entregado', 760.00, 2, 26),
('2026-09-05 22:50:00', 'Cancelado', 105.00, 1, 74),
('2026-09-05 11:55:00', 'Entregado', 150.00, 1, 19),
('2026-09-05 20:40:00', 'Entregado', 645.00, 1, 26),
('2026-09-05 18:10:00', 'Entregado', 625.00, 3, 50),
('2026-09-05 22:30:00', 'Entregado', 770.00, 5, 37),
('2026-09-05 22:55:00', 'Entregado', 240.00, 1, 33),
('2026-09-05 21:45:00', 'Cancelado', 680.00, 1, 34),
('2026-09-05 12:35:00', 'Entregado', 495.00, 2, 29),
('2026-09-05 12:00:00', 'Entregado', 360.00, 2, 8),
('2026-09-05 18:20:00', 'Entregado', 850.00, 5, 57),
('2026-09-05 12:10:00', 'Entregado', 570.00, 5, 34),
('2026-09-05 11:20:00', 'Entregado', 690.00, 1, 50),
('2026-09-05 11:25:00', 'Entregado', 1065.00, 2, 31),
('2026-09-05 14:40:00', 'Entregado', 300.00, 1, 49),
('2026-09-05 14:15:00', 'Entregado', 305.00, 1, 71),
('2026-09-05 19:00:00', 'Entregado', 150.00, 4, 21),
('2026-09-05 12:55:00', 'Entregado', 635.00, 3, 22),
('2026-09-05 18:40:00', 'Entregado', 300.00, 4, 17),
('2026-09-05 20:45:00', 'Entregado', 1215.00, 5, 58),
('2026-09-05 22:40:00', 'Entregado', 120.00, 3, 30),
('2026-09-05 13:30:00', 'Entregado', 835.00, 4, 66),
('2026-09-05 21:10:00', 'Entregado', 100.00, 2, 16),
('2026-09-06 18:50:00', 'Cancelado', 480.00, 4, 43),
('2026-09-06 21:55:00', 'Entregado', 610.00, 1, 10),
('2026-09-06 12:35:00', 'Entregado', 180.00, 1, 55),
('2026-09-06 21:10:00', 'Entregado', 100.00, 5, 8),
('2026-09-06 22:55:00', 'Entregado', 515.00, 2, 8),
('2026-09-06 14:10:00', 'Entregado', 450.00, 4, 63),
('2026-09-06 20:00:00', 'Entregado', 845.00, 2, 19),
('2026-09-06 21:50:00', 'Entregado', 660.00, 4, 31),
('2026-09-06 18:30:00', 'Entregado', 555.00, 2, 9),
('2026-09-06 13:45:00', 'Entregado', 1140.00, 4, 4),
('2026-09-06 21:35:00', 'Entregado', 400.00, 2, 37),
('2026-09-06 18:45:00', 'Entregado', 150.00, 5, 13),
('2026-09-06 22:45:00', 'Entregado', 1040.00, 4, 79),
('2026-09-06 11:25:00', 'Cancelado', 660.00, 2, 32),
('2026-09-06 14:55:00', 'Cancelado', 300.00, 4, 81),
('2026-09-06 14:15:00', 'Entregado', 1500.00, 4, 65),
('2026-09-06 12:25:00', 'Entregado', 840.00, 1, 36),
('2026-09-06 19:15:00', 'Entregado', 250.00, 4, 31);

INSERT INTO Detalle_Pedido (id_pedido, id_platillo, cantidad, precio_unitario) VALUES 
(1, 2, 1, 180.00),
(1, 4, 3, 50.00),
(1, 5, 2, 35.00),
(1, 3, 2, 150.00),
(2, 1, 2, 120.00),
(2, 5, 2, 35.00),
(2, 2, 2, 180.00),
(3, 2, 2, 180.00),
(3, 4, 1, 50.00),
(3, 5, 1, 35.00),
(4, 3, 1, 150.00),
(4, 1, 3, 120.00),
(4, 5, 1, 35.00),
(4, 2, 3, 180.00),
(5, 5, 2, 35.00),
(6, 2, 3, 180.00),
(7, 5, 3, 35.00),
(7, 1, 3, 120.00),
(7, 4, 2, 50.00),
(7, 3, 3, 150.00),
(8, 2, 2, 180.00),
(8, 5, 2, 35.00),
(8, 4, 3, 50.00),
(8, 1, 1, 120.00),
(9, 4, 3, 50.00),
(10, 1, 2, 120.00),
(10, 3, 1, 150.00),
(10, 5, 3, 35.00),
(11, 4, 2, 50.00),
(11, 3, 2, 150.00),
(12, 3, 3, 150.00),
(12, 5, 3, 35.00),
(12, 4, 3, 50.00),
(13, 2, 2, 180.00),
(13, 4, 1, 50.00),
(13, 3, 1, 150.00),
(13, 5, 2, 35.00),
(14, 2, 1, 180.00),
(14, 4, 2, 50.00),
(14, 3, 1, 150.00),
(14, 1, 1, 120.00),
(15, 3, 2, 150.00),
(15, 1, 3, 120.00),
(15, 4, 2, 50.00),
(15, 2, 2, 180.00),
(16, 1, 2, 120.00),
(16, 5, 1, 35.00),
(16, 3, 1, 150.00),
(16, 4, 2, 50.00),
(17, 1, 1, 120.00),
(17, 4, 1, 50.00),
(17, 5, 2, 35.00),
(18, 5, 1, 35.00),
(19, 5, 1, 35.00),
(19, 3, 2, 150.00),
(20, 1, 3, 120.00),
(20, 4, 1, 50.00),
(20, 3, 3, 150.00),
(20, 2, 3, 180.00),
(21, 5, 1, 35.00),
(21, 1, 3, 120.00),
(22, 4, 2, 50.00),
(22, 5, 2, 35.00),
(22, 3, 1, 150.00),
(22, 1, 3, 120.00),
(23, 3, 2, 150.00),
(23, 5, 3, 35.00),
(24, 5, 1, 35.00),
(25, 5, 1, 35.00),
(25, 1, 1, 120.00),
(25, 4, 3, 50.00),
(26, 4, 3, 50.00),
(26, 3, 2, 150.00),
(26, 1, 1, 120.00),
(27, 1, 1, 120.00),
(27, 5, 3, 35.00),
(27, 3, 1, 150.00),
(28, 3, 1, 150.00),
(28, 1, 1, 120.00),
(28, 4, 2, 50.00),
(29, 1, 3, 120.00),
(29, 4, 1, 50.00),
(29, 2, 1, 180.00),
(30, 5, 1, 35.00),
(30, 4, 1, 50.00),
(31, 5, 2, 35.00),
(31, 1, 1, 120.00),
(31, 2, 1, 180.00),
(31, 4, 1, 50.00),
(32, 4, 2, 50.00),
(32, 3, 2, 150.00),
(32, 1, 1, 120.00),
(33, 4, 1, 50.00),
(33, 2, 2, 180.00),
(33, 5, 1, 35.00),
(34, 2, 1, 180.00),
(34, 4, 2, 50.00),
(34, 1, 3, 120.00),
(35, 5, 2, 35.00),
(35, 2, 2, 180.00),
(35, 4, 1, 50.00),
(36, 3, 2, 150.00),
(36, 4, 1, 50.00),
(36, 2, 2, 180.00),
(36, 1, 1, 120.00),
(37, 5, 1, 35.00),
(37, 3, 2, 150.00),
(38, 2, 1, 180.00),
(38, 5, 2, 35.00),
(38, 3, 2, 150.00),
(39, 2, 2, 180.00),
(39, 3, 3, 150.00),
(39, 1, 1, 120.00),
(40, 4, 2, 50.00),
(40, 3, 3, 150.00),
(40, 5, 1, 35.00),
(41, 4, 3, 50.00),
(41, 1, 1, 120.00),
(41, 2, 1, 180.00),
(41, 3, 2, 150.00),
(42, 3, 1, 150.00),
(42, 4, 2, 50.00),
(42, 5, 2, 35.00),
(42, 1, 3, 120.00),
(43, 1, 3, 120.00),
(44, 5, 1, 35.00),
(44, 2, 3, 180.00),
(45, 2, 3, 180.00),
(45, 3, 3, 150.00),
(46, 1, 3, 120.00),
(46, 3, 3, 150.00),
(46, 4, 1, 50.00),
(47, 2, 3, 180.00),
(47, 5, 3, 35.00),
(47, 3, 2, 150.00),
(48, 3, 3, 150.00),
(48, 4, 1, 50.00),
(48, 2, 2, 180.00),
(48, 5, 1, 35.00),
(49, 2, 2, 180.00),
(49, 1, 3, 120.00),
(49, 4, 2, 50.00),
(50, 2, 2, 180.00),
(50, 3, 1, 150.00),
(50, 5, 1, 35.00),
(51, 4, 2, 50.00),
(51, 5, 3, 35.00),
(52, 1, 2, 120.00),
(53, 5, 1, 35.00),
(53, 4, 2, 50.00),
(53, 2, 1, 180.00),
(53, 1, 1, 120.00),
(54, 3, 3, 150.00),
(54, 1, 2, 120.00),
(54, 2, 3, 180.00),
(55, 5, 3, 35.00),
(55, 4, 2, 50.00),
(56, 4, 3, 50.00),
(56, 3, 3, 150.00),
(56, 1, 3, 120.00),
(57, 4, 2, 50.00),
(57, 5, 2, 35.00),
(57, 2, 1, 180.00),
(58, 2, 3, 180.00),
(59, 3, 3, 150.00),
(59, 2, 3, 180.00),
(59, 4, 1, 50.00),
(60, 2, 2, 180.00),
(60, 4, 3, 50.00),
(60, 3, 2, 150.00),
(60, 5, 2, 35.00),
(61, 2, 1, 180.00),
(61, 4, 3, 50.00),
(62, 1, 2, 120.00),
(62, 4, 2, 50.00),
(62, 5, 3, 35.00),
(62, 3, 2, 150.00),
(63, 5, 3, 35.00),
(64, 2, 3, 180.00),
(65, 3, 1, 150.00),
(65, 2, 2, 180.00),
(65, 5, 1, 35.00),
(65, 1, 1, 120.00),
(66, 1, 2, 120.00),
(66, 2, 1, 180.00),
(66, 3, 3, 150.00),
(66, 4, 1, 50.00),
(67, 4, 2, 50.00),
(67, 5, 3, 35.00),
(67, 1, 3, 120.00),
(68, 5, 1, 35.00),
(68, 1, 1, 120.00),
(68, 2, 1, 180.00),
(69, 5, 2, 35.00),
(69, 4, 2, 50.00),
(70, 1, 1, 120.00),
(70, 2, 2, 180.00),
(71, 1, 1, 120.00),
(71, 3, 3, 150.00),
(71, 2, 1, 180.00),
(71, 4, 2, 50.00),
(72, 4, 2, 50.00),
(72, 3, 1, 150.00),
(72, 1, 3, 120.00),
(72, 2, 3, 180.00),
(73, 1, 1, 120.00),
(73, 2, 1, 180.00),
(74, 4, 3, 50.00),
(74, 1, 1, 120.00),
(74, 5, 3, 35.00),
(75, 4, 2, 50.00),
(75, 3, 2, 150.00),
(75, 1, 1, 120.00),
(76, 2, 3, 180.00),
(76, 5, 2, 35.00),
(76, 3, 1, 150.00),
(77, 5, 1, 35.00),
(77, 3, 1, 150.00),
(77, 4, 2, 50.00),
(77, 1, 1, 120.00),
(78, 4, 2, 50.00),
(78, 3, 1, 150.00),
(78, 5, 1, 35.00),
(78, 2, 1, 180.00),
(79, 2, 1, 180.00),
(79, 1, 2, 120.00),
(79, 4, 1, 50.00),
(79, 3, 2, 150.00),
(80, 3, 2, 150.00),
(80, 4, 2, 50.00),
(81, 4, 2, 50.00),
(81, 5, 1, 35.00),
(81, 2, 3, 180.00),
(82, 4, 3, 50.00),
(82, 2, 1, 180.00),
(82, 3, 3, 150.00),
(82, 5, 3, 35.00),
(83, 4, 2, 50.00),
(83, 5, 1, 35.00),
(83, 2, 3, 180.00),
(83, 1, 3, 120.00),
(84, 2, 3, 180.00),
(84, 3, 3, 150.00),
(84, 4, 2, 50.00),
(85, 1, 3, 120.00),
(85, 5, 1, 35.00),
(85, 3, 3, 150.00),
(86, 2, 1, 180.00),
(87, 3, 1, 150.00),
(87, 4, 3, 50.00),
(87, 5, 1, 35.00),
(88, 5, 3, 35.00),
(88, 2, 3, 180.00),
(89, 5, 1, 35.00),
(89, 1, 3, 120.00),
(89, 2, 1, 180.00),
(89, 4, 1, 50.00),
(90, 2, 1, 180.00),
(91, 3, 3, 150.00),
(91, 4, 3, 50.00),
(92, 2, 2, 180.00),
(92, 1, 2, 120.00),
(92, 3, 1, 150.00),
(93, 1, 1, 120.00),
(93, 4, 1, 50.00),
(94, 1, 2, 120.00),
(94, 4, 1, 50.00),
(94, 2, 2, 180.00),
(94, 3, 3, 150.00),
(95, 5, 1, 35.00),
(96, 2, 3, 180.00),
(96, 1, 1, 120.00),
(97, 1, 1, 120.00),
(98, 4, 3, 50.00),
(98, 1, 2, 120.00),
(98, 3, 1, 150.00),
(99, 4, 1, 50.00),
(99, 3, 2, 150.00),
(100, 5, 3, 35.00),
(101, 3, 1, 150.00),
(102, 1, 3, 120.00),
(102, 5, 3, 35.00),
(103, 3, 1, 150.00),
(103, 1, 3, 120.00),
(103, 5, 2, 35.00),
(104, 3, 3, 150.00),
(105, 1, 1, 120.00),
(106, 4, 3, 50.00),
(106, 1, 3, 120.00),
(106, 5, 2, 35.00),
(106, 2, 1, 180.00),
(107, 5, 3, 35.00),
(108, 3, 1, 150.00),
(109, 2, 3, 180.00),
(109, 5, 3, 35.00),
(110, 4, 2, 50.00),
(110, 5, 3, 35.00),
(110, 2, 1, 180.00),
(110, 1, 2, 120.00),
(111, 2, 2, 180.00),
(111, 4, 1, 50.00),
(111, 1, 3, 120.00),
(112, 1, 2, 120.00),
(113, 4, 1, 50.00),
(113, 3, 3, 150.00),
(113, 2, 1, 180.00),
(114, 5, 3, 35.00),
(114, 1, 2, 120.00),
(114, 4, 3, 50.00),
(115, 1, 3, 120.00),
(116, 1, 1, 120.00),
(116, 2, 1, 180.00),
(116, 3, 3, 150.00),
(116, 4, 2, 50.00),
(117, 3, 3, 150.00),
(117, 1, 1, 120.00),
(118, 1, 2, 120.00),
(118, 3, 3, 150.00),
(119, 3, 3, 150.00),
(119, 4, 3, 50.00),
(119, 5, 3, 35.00),
(119, 1, 3, 120.00),
(120, 1, 1, 120.00),
(120, 2, 1, 180.00),
(121, 1, 1, 120.00),
(121, 5, 1, 35.00),
(121, 3, 1, 150.00),
(122, 3, 1, 150.00),
(123, 3, 3, 150.00),
(123, 5, 1, 35.00),
(123, 4, 3, 50.00),
(124, 3, 2, 150.00),
(125, 5, 3, 35.00),
(125, 3, 3, 150.00),
(125, 1, 1, 120.00),
(125, 2, 3, 180.00),
(126, 1, 1, 120.00),
(127, 2, 1, 180.00),
(127, 3, 3, 150.00),
(127, 5, 3, 35.00),
(127, 4, 2, 50.00),
(128, 4, 2, 50.00),
(129, 2, 2, 180.00),
(129, 1, 1, 120.00),
(130, 3, 1, 150.00),
(130, 2, 2, 180.00),
(130, 4, 2, 50.00),
(131, 2, 1, 180.00),
(132, 4, 2, 50.00),
(133, 2, 2, 180.00),
(133, 5, 1, 35.00),
(133, 1, 1, 120.00),
(134, 1, 1, 120.00),
(134, 4, 3, 50.00),
(134, 2, 1, 180.00),
(135, 1, 3, 120.00),
(135, 5, 1, 35.00),
(135, 3, 3, 150.00),
(136, 4, 3, 50.00),
(136, 3, 1, 150.00),
(136, 2, 2, 180.00),
(137, 3, 2, 150.00),
(137, 4, 3, 50.00),
(137, 5, 3, 35.00),
(138, 2, 1, 180.00),
(138, 1, 3, 120.00),
(138, 4, 3, 50.00),
(138, 3, 3, 150.00),
(139, 4, 2, 50.00),
(139, 3, 2, 150.00),
(140, 3, 1, 150.00),
(141, 2, 3, 180.00),
(141, 3, 3, 150.00),
(141, 4, 1, 50.00),
(142, 1, 3, 120.00),
(142, 3, 2, 150.00),
(143, 3, 2, 150.00),
(144, 2, 3, 180.00),
(144, 4, 3, 50.00),
(144, 1, 3, 120.00),
(144, 3, 3, 150.00),
(145, 1, 3, 120.00),
(145, 3, 2, 150.00),
(145, 2, 1, 180.00),
(146, 4, 2, 50.00),
(146, 3, 1, 150.00);

-- ==============================================================================
-- 4. VISTAS SQL (Nuevas - Para gráficas y reportes)
-- ==============================================================================
-- Vista: Top Clientes Frecuentes
CREATE OR REPLACE VIEW vw_frecuenciaclientes AS
SELECT 
    c.id_cliente, 
    c.nombre, 
    COUNT(p.id_pedido) AS compras, 
    SUM(p.total) AS total_gastado
FROM Clientes c
JOIN Pedidos p ON c.id_cliente = p.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY compras DESC;

-- Vista: Platillos Más Vendidos
CREATE OR REPLACE VIEW vw_topplatillos AS
SELECT 
    pl.id_platillo, 
    pl.nombre, 
    SUM(dp.cantidad) AS total_vendidos, 
    SUM(dp.cantidad * dp.precio_unitario) AS ingresos_generados
FROM Platillos pl
JOIN Detalle_Pedido dp ON pl.id_platillo = dp.id_platillo
GROUP BY pl.id_platillo, pl.nombre
ORDER BY total_vendidos DESC;

-- ==============================================================================
-- 5. PROCEDIMIENTOS ALMACENADOS
-- ==============================================================================
-- Eliminar procedimientos si ya existen
DROP PROCEDURE IF EXISTS sp_VentasDiarias;
DROP PROCEDURE IF EXISTS sp_ClientesVigentesQ1;
DROP PROCEDURE IF EXISTS sp_InsertarClienteNuevo;

DELIMITER //

-- Procedimiento 1: Reporte de ventas diarias
CREATE PROCEDURE sp_VentasDiarias(IN p_fecha DATE)
BEGIN
    SELECT id_pedido, fecha, estado, total FROM Pedidos WHERE DATE(fecha) = p_fecha;
    SELECT SUM(total) AS total_ventas_dia FROM Pedidos WHERE DATE(fecha) = p_fecha;
END //

-- Procedimiento 2: Reporte de clientes vigentes Q1
CREATE PROCEDURE sp_ClientesVigentesQ1(IN p_anio INT)
BEGIN
    SELECT DISTINCT c.id_cliente, c.nombre, c.telefono, c.correo
    FROM Clientes c
    JOIN Pedidos p ON c.id_cliente = p.id_cliente
    WHERE p.fecha >= CONCAT(p_anio, '-01-01 00:00:00') 
      AND p.fecha <= CONCAT(p_anio, '-03-31 23:59:59');
END //

-- Procedimiento 3: EXCEPCIÓN CON TRY/CATCH para Restricción Única
CREATE PROCEDURE sp_InsertarClienteNuevo(
    IN p_nombre VARCHAR(100),
    IN p_telefono VARCHAR(15),
    IN p_direccion VARCHAR(255),
    IN p_correo VARCHAR(100)
)
BEGIN
    -- Bloque "CATCH" para capturar el error 1062 (Duplicate entry)
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT CONCAT('ERROR: Excepción de restricción única. El correo ', p_correo, ' ya existe.') AS Mensaje;
    END;

    -- Bloque "TRY"
    INSERT INTO Clientes (nombre, telefono, direccion, correo) 
    VALUES (p_nombre, p_telefono, p_direccion, p_correo);
    
    SELECT 'Cliente registrado exitosamente.' AS Mensaje;
END //

DELIMITER ;

-- ==============================================================================
-- 6. TRIGGERS (Disparadores)
-- ==============================================================================
DROP TRIGGER IF EXISTS trg_ControlDuplicadosDetalle;
DROP TRIGGER IF EXISTS trg_SeguimientoNuevasCompras;

DELIMITER //

-- Trigger 1: Control de Inventario (Bloquea duplicados en el mismo ticket)
CREATE TRIGGER trg_ControlDuplicadosDetalle
BEFORE INSERT ON Detalle_Pedido
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count 
    FROM Detalle_Pedido 
    WHERE id_pedido = NEW.id_pedido AND id_platillo = NEW.id_platillo;
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Excepción: No se pueden almacenar datos duplicados. Este platillo ya está en el pedido.';
    END IF;
END //

-- Trigger 2: Auditoría y Seguimiento (Registra quién y cuándo compró)
CREATE TRIGGER trg_SeguimientoNuevasCompras
AFTER INSERT ON Pedidos
FOR EACH ROW
BEGIN
    DECLARE v_nombre_cliente VARCHAR(100);
    DECLARE v_nombre_plataforma VARCHAR(50);
    
    SELECT nombre INTO v_nombre_cliente FROM Clientes WHERE id_cliente = NEW.id_cliente;
    SELECT nombre INTO v_nombre_plataforma FROM Plataformas WHERE id_plataforma = NEW.id_plataforma;
    
    INSERT INTO Seguimiento_Clientes (nombre_cliente, fecha_hora, id_pedido, plataforma)
    VALUES (v_nombre_cliente, NEW.fecha, NEW.id_pedido, v_nombre_plataforma);
END //

DELIMITER ;
USE DarkKitchen;

SELECT COUNT(*) AS clientes FROM Clientes;

SELECT COUNT(*) AS platillos FROM Platillos;

SELECT COUNT(*) AS pedidos FROM Pedidos;

SELECT * FROM vw_frecuenciaclientes;
SELECT * FROM vw_topplatillos;
SELECT  DATE(fecha) AS fecha, COUNT(*) AS pedidos, SUM(total) AS ventas FROM Pedidos GROUP BY DATE(fecha) ORDER BY fecha;
SELECT  estado, COUNT(*) AS cantidad FROM Pedidos GROUP BY estado;