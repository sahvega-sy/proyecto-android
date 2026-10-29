const express = require('express');
const mysql = require('mysql2');
const app = express();

app.use(express.json());

// ---------- Conexión a MySQL ----------
const conexion = mysql.createConnection({
    host: 'localhost',
    user: 'root',      // Cambia tu usuario de MySQL si es necesario
    password: '',      // Cambia tu contraseña de MySQL
    database: 'mpaz_db',
    port: 3306
});

conexion.connect(err => {
    if (err) {
        console.error('Error al conectar a MySQL:', err);
        return;
    }
    console.log('Conectado exitosamente a MySQL.');
});

const db = conexion.promise();

// ---------- LOGIN ----------

app.post('/login', async (req, res) => {
    try {
        const { username, password } = req.body;
        const [filas] = await db.query(
            'SELECT id, username FROM psicologo WHERE username = ? AND password = ?',
            [username, password]
        );
        if (filas.length === 0) {
            return res.status(401).json({ error: 'Usuario o contraseña incorrectos' });
        }
        res.json(filas[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Iniciar servidor en el puerto 3000
app.listen(3000, '0.0.0.0', () => {
    console.log('Servidor Node.js corriendo en http://localhost:3000');
});
