// server.js
const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
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

// 🔹 ROUTE D'ACCUEIL
app.get('/', (req, res) => {
  res.send('Bienvenue sur l\'API Crypto !');
});

// 🔄 ROUTE : Liste des cryptos
app.get('/cryptos', (req, res) => {
  const sql = `
    SELECT cm.id, cm.nom, cm.tag, v.quantite, v.prix
    FROM crypto_monnaie cm
    JOIN valeur v ON cm.id = v.crypto_id
  `;
  
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: err.message });
    res.json(results);
  });
});

// 🔐 ROUTE : Inscription
app.post('/register', async (req, res) => {
  const { email, password } = req.body;

  if (!email.includes('@')) {
    return res.status(400).json({ error: 'Email invalide' });
  }

  const specialCharRegex = /[!@#$%^&*(),.?":{}|<>]/;
  if (password.length < 12 || !specialCharRegex.test(password)) {
    return res.status(400).json({ error: 'Mot de passe trop court ou sans caractère spécial' });
  }

  try {
    const hashedPassword = await bcrypt.hash(password, 10);

    db.query(
      'INSERT INTO utilisateur (email, mot_de_passe) VALUES (?, ?)',
      [email, hashedPassword],
      (err, result) => {
        if (err) {
          if (err.code === 'ER_DUP_ENTRY') {
            return res.status(400).json({ error: 'Email déjà utilisé' });
          }
          return res.status(500).json({ error: 'Erreur lors de l\'inscription', details: err });
        }
        res.status(201).json({ message: 'Inscription réussie' });
      }
    );
  } catch (err) {
    res.status(500).json({ error: 'Erreur serveur', details: err });
  }
});

app.post('/login', (req, res) => {
  const { email, password } = req.body;

  db.query(
    'SELECT * FROM utilisateur WHERE email = ?',
    [email],
    async (err, results) => {
      if (err) return res.status(500).json({ error: 'Erreur serveur' });
      if (results.length === 0) return res.status(401).json({ error: 'Utilisateur non trouvé' });

      const utilisateur = results[0];
      const passwordMatch = await bcrypt.compare(password, utilisateur.mot_de_passe);

      if (!passwordMatch) {
        return res.status(401).json({ error: 'Mot de passe incorrect' });
      }

      res.json({
        message: 'Connexion réussie',
        utilisateur: {
          id: utilisateur.id,
          email: utilisateur.email,
          admin: utilisateur.admin
        }
      });
    }
  );
});


// ▶ LANCEMENT DU SERVEUR
app.listen(PORT, () => {
  console.log(`🚀 Serveur en écoute sur http://localhost:${PORT}`);
});
