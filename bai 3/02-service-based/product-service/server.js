const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());

const PORT = process.env.PORT || 6002;
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'db',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'demo',
  password: process.env.DB_PASSWORD || 'demo123',
  database: process.env.DB_NAME || 'bai3db',
  waitForConnections: true,
  connectionLimit: 10
});

app.get('/api/products', async (_req, res) => {
  const [rows] = await pool.query('SELECT id, product_name, price FROM products ORDER BY id');
  res.json(rows);
});

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', service: 'product-service' });
});

app.listen(PORT, () => {
  console.log(`Product service running on ${PORT}`);
});
