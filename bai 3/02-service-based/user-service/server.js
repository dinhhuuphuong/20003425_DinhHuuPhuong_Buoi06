const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());

const PORT = process.env.PORT || 6001;
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'db',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'demo',
  password: process.env.DB_PASSWORD || 'demo123',
  database: process.env.DB_NAME || 'bai3db',
  waitForConnections: true,
  connectionLimit: 10
});

app.get('/api/users', async (_req, res) => {
  const [rows] = await pool.query('SELECT id, full_name, gender FROM users ORDER BY id');
  res.json(rows);
});

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', service: 'user-service' });
});

app.listen(PORT, () => {
  console.log(`User service running on ${PORT}`);
});
