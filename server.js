const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Configuración de la conexión a MySQL
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'DarkKitchen',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0,
    decimalNumbers: true // 
});

// ==================== PLATILLOS ====================

// GET: Obtener todos los platillos
app.get('/api/platillos', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [platillos] = await connection.query('SELECT * FROM Platillos');
        connection.release();
        res.json(platillos);
    } catch (error) {
        console.error('Error en GET /api/platillos:', error);
        res.status(500).json({ error: 'Error al obtener platillos', details: error.message });
    }
});

// POST: Crear nuevo platillo
app.post('/api/platillos', async (req, res) => {
    try {
        const { nombre, precio, costo_preparacion } = req.body;
        
        if (!nombre || !precio || !costo_preparacion) {
            return res.status(400).json({ error: 'Faltan campos requeridos' });
        }

        const connection = await pool.getConnection();
        const [result] = await connection.query(
            'INSERT INTO Platillos (nombre, precio, costo_preparacion) VALUES (?, ?, ?)',
            [nombre, precio, costo_preparacion]
        );
        connection.release();
        
        res.json({ 
            id: result.insertId, 
            nombre, 
            precio, 
            costo_preparacion,
            mensaje: 'Platillo creado exitosamente'
        });
    } catch (error) {
        console.error('Error en POST /api/platillos:', error);
        res.status(500).json({ error: 'Error al crear platillo', details: error.message });
    }
});

// PUT: Actualizar platillo
app.put('/api/platillos/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { nombre, precio, costo_preparacion } = req.body;

        const connection = await pool.getConnection();
        await connection.query(
            'UPDATE Platillos SET nombre = ?, precio = ?, costo_preparacion = ? WHERE id_platillo = ?',
            [nombre, precio, costo_preparacion, id]
        );
        connection.release();

        res.json({ mensaje: 'Platillo actualizado exitosamente' });
    } catch (error) {
        console.error('Error en PUT /api/platillos:', error);
        res.status(500).json({ error: 'Error al actualizar platillo', details: error.message });
    }
});

// DELETE: Eliminar platillo
app.delete('/api/platillos/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const connection = await pool.getConnection();
        await connection.query('DELETE FROM Platillos WHERE id_platillo = ?', [id]);
        connection.release();

        res.json({ mensaje: 'Platillo eliminado exitosamente' });
    } catch (error) {
        console.error('Error en DELETE /api/platillos:', error);
        res.status(500).json({ error: 'Error al eliminar platillo', details: error.message });
    }
});

// ==================== PEDIDOS ====================

// GET: Obtener todos los pedidos
app.get('/api/pedidos', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [pedidos] = await connection.query(`
            SELECT p.*, c.nombre as cliente_nombre, c.telefono, c.correo, c.direccion, plat.nombre as plataforma_nombre
            FROM Pedidos p
            JOIN Clientes c ON p.id_cliente = c.id_cliente
            JOIN Plataformas plat ON p.id_plataforma = plat.id_plataforma
            ORDER BY p.fecha DESC
        `);
        connection.release();
        res.json(pedidos);
    } catch (error) {
        console.error('Error en GET /api/pedidos:', error);
        res.status(500).json({ error: 'Error al obtener pedidos', details: error.message });
    }
});

// POST: Crear nuevo pedido
app.post('/api/pedidos', async (req, res) => {
    try {
        const { id_cliente, id_plataforma, items, total } = req.body;

        const connection = await pool.getConnection();
        
        // Insertar pedido
        const [result] = await connection.query(
            'INSERT INTO Pedidos (id_cliente, id_plataforma, estado, total) VALUES (?, ?, ?, ?)',
            [id_cliente, id_plataforma, 'Pendiente', total]
        );
        
        const pedidoId = result.insertId;
        
        // Insertar detalles del pedido
        for (const item of items) {
            await connection.query(
                'INSERT INTO Detalle_Pedido (id_pedido, id_platillo, cantidad, precio_unitario) VALUES (?, ?, ?, ?)',
                [pedidoId, item.id_platillo, item.cantidad, item.precio_unitario]
            );
        }
        
        connection.release();
        res.json({ id: pedidoId, mensaje: 'Pedido creado exitosamente' });
    } catch (error) {
        console.error('Error en POST /api/pedidos:', error);
        res.status(500).json({ error: 'Error al crear pedido', details: error.message });
    }
});

// PUT: Actualizar estado del pedido
app.put('/api/pedidos/:id/estado', async (req, res) => {
    try {
        const { id } = req.params;
        const { estado } = req.body;

        const connection = await pool.getConnection();
        await connection.query('UPDATE Pedidos SET estado = ? WHERE id_pedido = ?', [estado, id]);
        connection.release();

        res.json({ mensaje: 'Estado del pedido actualizado' });
    } catch (error) {
        console.error('Error en PUT /api/pedidos/:id/estado:', error);
        res.status(500).json({ error: 'Error al actualizar pedido', details: error.message });
    }
});

// ==================== CLIENTES ====================

// GET: Obtener todos los clientes
app.get('/api/clientes', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [clientes] = await connection.query('SELECT * FROM Clientes');
        connection.release();
        res.json(clientes);
    } catch (error) {
        console.error('Error en GET /api/clientes:', error);
        res.status(500).json({ error: 'Error al obtener clientes', details: error.message });
    }
});

// POST: Crear nuevo cliente (con sp_InsertarClienteNuevo)
app.post('/api/clientes', async (req, res) => {
    try {
        const { nombre, telefono, direccion, correo } = req.body;

        if (!nombre || !telefono || !correo) {
            return res.status(400).json({ error: 'Faltan campos requeridos' });
        }

        const connection = await pool.getConnection();
        
        try {
            const [result] = await connection.query(
                'CALL sp_InsertarClienteNuevo(?, ?, ?, ?)',
                [nombre, telefono, direccion, correo]
            );
            connection.release();
            res.json({ id: result[0][0]?.id_cliente || 0, nombre, mensaje: 'Cliente registrado exitosamente' });
        } catch (spError) {
            connection.release();
            if (spError.message.includes('ERROR: Excepción de restricción única')) {
                return res.status(400).json({ error: 'Este correo ya está registrado' });
            }
            throw spError;
        }
    } catch (error) {
        console.error('Error en POST /api/clientes:', error);
        res.status(500).json({ error: 'Error al crear cliente', details: error.message });
    }
});

// ==================== REPORTES ====================

// GET: Ventas diarias (sp_VentasDiarias)
app.get('/api/reportes/ventas-diarias/:fecha', async (req, res) => {
    try {
        const { fecha } = req.params;

        const connection = await pool.getConnection();
        const [result] = await connection.query(
            'CALL sp_VentasDiarias(?)',
            [fecha]
        );
        connection.release();

        res.json({
            pedidos: result[0] || [],
            total_ventas: result[1]?.[0]?.total_ventas_dia || 0
        });
    } catch (error) {
        console.error('Error en GET /api/reportes/ventas-diarias:', error);
        res.status(500).json({ error: 'Error al obtener ventas diarias', details: error.message });
    }
});

// GET: Clientes vigentes Q1 (sp_ClientesVigentesQ1)
app.get('/api/reportes/clientes-vigentes/:anio', async (req, res) => {
    try {
        const { anio } = req.params;

        const connection = await pool.getConnection();
        const [result] = await connection.query(
            'CALL sp_ClientesVigentesQ1(?)',
            [anio]
        );
        connection.release();

        res.json(result[0] || []);
    } catch (error) {
        console.error('Error en GET /api/reportes/clientes-vigentes:', error);
        res.status(500).json({ error: 'Error al obtener clientes Q1', details: error.message });
    }
});

// GET: Platillos más vendidos (vw_topplatillos)
app.get('/api/reportes/platillos-top', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [platillos] = await connection.query('SELECT * FROM vw_topplatillos');
        connection.release();
        res.json(platillos);
    } catch (error) {
        console.error('Error en GET /api/reportes/platillos-top:', error);
        res.status(500).json({ error: 'Error al obtener platillos top', details: error.message });
    }
});

// GET: Clientes frecuentes (vw_frecuenciaclientes)
app.get('/api/reportes/clientes-frecuentes', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [clientes] = await connection.query('SELECT * FROM vw_frecuenciaclientes');
        connection.release();
        res.json(clientes);
    } catch (error) {
        console.error('Error en GET /api/reportes/clientes-frecuentes:', error);
        res.status(500).json({ error: 'Error al obtener clientes frecuentes', details: error.message });
    }
});

// GET: Seguimiento de clientes (tabla Seguimiento_Clientes)
app.get('/api/reportes/auditoria', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [audits] = await connection.query(
            'SELECT * FROM Seguimiento_Clientes ORDER BY fecha_hora DESC'
        );
        connection.release();
        res.json(audits);
    } catch (error) {
        console.error('Error en GET /api/reportes/auditoria:', error);
        res.status(500).json({ error: 'Error al obtener auditoría', details: error.message });
    }
});

// ==================== PLATAFORMAS ====================

// GET: Obtener todas las plataformas
app.get('/api/plataformas', async (req, res) => {
    try {
        const connection = await pool.getConnection();
        const [plataformas] = await connection.query('SELECT * FROM Plataformas');
        connection.release();
        res.json(plataformas);
    } catch (error) {
        console.error('Error en GET /api/plataformas:', error);
        res.status(500).json({ error: 'Error al obtener plataformas', details: error.message });
    }
});

// ==================== HEALTH CHECK ====================

app.get('/api/health', (req, res) => {
    res.json({ status: 'API JokerPoker funcionando correctamente ✅' });
});

// ==================== INICIO DEL SERVIDOR ====================

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`
╔════════════════════════════════════════════════════════════╗
║                  🃏 JOKERPOKER API                         ║
║                   Escuchando en puerto ${PORT}                   ║
╚════════════════════════════════════════════════════════════╝

📍 Endpoints disponibles:

PLATILLOS:
  GET    /api/platillos           - Obtener todos los platillos
  POST   /api/platillos           - Crear nuevo platillo
  PUT    /api/platillos/:id       - Actualizar platillo
  DELETE /api/platillos/:id       - Eliminar platillo

PEDIDOS:
  GET    /api/pedidos             - Obtener todos los pedidos
  POST   /api/pedidos             - Crear nuevo pedido
  PUT    /api/pedidos/:id/estado  - Actualizar estado del pedido

CLIENTES:
  GET    /api/clientes            - Obtener todos los clientes
  POST   /api/clientes            - Crear nuevo cliente

REPORTES:
  GET    /api/reportes/ventas-diarias/:fecha      - Ventas del día
  GET    /api/reportes/clientes-vigentes/:anio    - Clientes Q1
  GET    /api/reportes/platillos-top              - Platillos más vendidos
  GET    /api/reportes/clientes-frecuentes        - Clientes frecuentes
  GET    /api/reportes/auditoria                  - Tabla de auditoría

OTROS:
  GET    /api/plataformas         - Obtener todas las plataformas
  GET    /api/health              - Verificar que el API funciona

🔗 Base de datos: ${process.env.DB_NAME || 'DarkKitchen'}
👤 Usuario: ${process.env.DB_USER || 'root'}
🖥️  Host: ${process.env.DB_HOST || 'localhost'}

    `);
});

module.exports = app;
