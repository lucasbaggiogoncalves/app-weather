const express = require('express');
const path = require('path');
const app = express();

app.use(express.static(path.resolve(__dirname, 'public')));

app.listen(process.env.PORT || 3000, () => {
    console.log(`Servidor está rodando em: http://localhost:${process.env.PORT || 3000}`);
});