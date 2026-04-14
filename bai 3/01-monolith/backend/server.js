const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 5000;
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'db',
  port: Number(process.env.DB_PORT || 3306),
  user: process.env.DB_USER || 'demo',
  password: process.env.DB_PASSWORD || 'demo123',
  database: process.env.DB_NAME || 'bai3db',
  waitForConnections: true,
  connectionLimit: 10
});

async function waitForDb(retry = 30) {
  for (let i = 1; i <= retry; i += 1) {
    try {
      await pool.query('SELECT 1');
      console.log('Connected to MariaDB');
      return;
    } catch (err) {
      console.log(`DB not ready (${i}/${retry})`);
      await new Promise((r) => setTimeout(r, 2000));
    }
  }
  throw new Error('Cannot connect to DB');
}

app.get('/api/users', async (_req, res) => {
  const [rows] = await pool.query('SELECT id, full_name, gender FROM users ORDER BY id');
  res.json(rows);
});

app.get('/api/products', async (_req, res) => {
  const [rows] = await pool.query('SELECT id, product_name, price FROM products ORDER BY id');
  res.json(rows);
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
  res.json({ status: 'ok', architecture: 'monolith', functions: 3 });
});

waitForDb()
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Monolith API running at http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error(err.message);
    process.exit(1);
  });
