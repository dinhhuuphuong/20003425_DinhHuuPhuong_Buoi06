const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());

const PORT = process.env.PORT || 6003;
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'db',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'demo',
  password: process.env.DB_PASSWORD || 'demo123',
  database: process.env.DB_NAME || 'bai3db',
  waitForConnections: true,
  connectionLimit: 10
});

app.get('/api/orders', async (_req, res) => {
  const [rows] = await pool.query(`
    SELECT o.id, u.full_name AS user_name, p.product_name, o.quantity,
           (o.quantity * p.price) AS total_amount
    FROM orders o
    JOIN users u ON u.id = o.user_id
    JOIN products p ON p.id = o.product_id
    ORDER BY o.id
  `);
  res.json(rows);
});

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', service: 'order-service' });
});

app.listen(PORT, () => {
  console.log(`Order service running on ${PORT}`);
});
