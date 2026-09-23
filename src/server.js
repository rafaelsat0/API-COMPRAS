require('dotenv').config();

const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req, res) => {
  res.json({
    message: 'API de compras funcionando!',
    status: 'ok'
  });
});

app.get('/health', (req, res) => {
  res.json({
    ok: true,
    service: 'api-compras',
    uptime: process.uptime()
  });
});

app.listen(PORT, () => {
  console.log(`Servidor rodando em http://localhost:${PORT}`);
});
