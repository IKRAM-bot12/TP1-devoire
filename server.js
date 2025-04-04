const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const path = require('path');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Chemin vers le fichier de données
const dataPath = path.join(__dirname, 'data.json');

// Initialiser le fichier data.json s'il n'existe pas
if (!fs.existsSync(dataPath)) {
  fs.writeFileSync(dataPath, JSON.stringify({ products: [], orders: [] }, null, 2));
}

// Charger les données
const loadData = () => {
  try {
    const data = fs.readFileSync(dataPath, 'utf8');
    return JSON.parse(data);
  } catch (err) {
    console.error("Erreur lors de la lecture du fichier data.json:", err);
    return { products: [], orders: [] };
  }
};

// Sauvegarder les données
const saveData = (data) => {
  try {
    fs.writeFileSync(dataPath, JSON.stringify(data, null, 2));
  } catch (err) {
    console.error("Erreur lors de l'écriture dans data.json:", err);
  }
};

// Routes pour les produits
app.get('/products', (req, res) => {
  const data = loadData();
  res.json(data.products);
});

app.post('/products', (req, res) => {
  const data = loadData();
  const newProduct = req.body;
  
  // Validation simple
  if (!newProduct.name || !newProduct.price) {
    return res.status(400).send('Nom et prix sont requis');
  }
  
  data.products.push(newProduct);
  saveData(data);
  res.status(201).json(newProduct);
});

// Routes pour les commandes
app.get('/orders', (req, res) => {
  const data = loadData();
  res.json(data.orders);
});

app.post('/orders', (req, res) => {
  const data = loadData();
  const newOrder = req.body;
  
  // Validation simple
  if (!newOrder.product || !newOrder.quantity) {
    return res.status(400).send('Produit et quantité sont requis');
  }
  
  data.orders.push(newOrder);
  saveData(data);
  res.status(201).json(newOrder);
});

// Route de test
app.get('/', (req, res) => {
  res.send('API Backend fonctionne!');
});

// Gestion des erreurs
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Quelque chose a mal tourné!');
});

app.listen(port, () => {
  console.log(`Serveur API démarré sur http://localhost:${port}`);
});