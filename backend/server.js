// server.js
const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Connexion MySQL
const db = mysql.createPool({
  host: 'localhost',
  user: 'jules',
  password: 'jules',
  database: 'cryptoinfo',
});

// Test de connexion
db.getConnection((err, connection) => {
  if (err) {
    console.error('❌ Erreur de connexion MySQL :', err);
  } else {
    console.log('✅ Connecté à la base de données cryptoinfo');
    connection.release();
  }
});

// Exemple de route simple
app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'API Crypto !');
});

// Récupération des cryptos
app.get('/cryptos', (req, res) => {
  db.query('SELECT * FROM crypto_monnaie', (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// Lancement du serveur
app.listen(PORT, () => {
  console.log(`🚀 Serveur en écoute sur http://localhost:${PORT}`);
});
