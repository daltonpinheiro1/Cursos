const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware para servir arquivos estáticos
app.use(express.static(path.join(__dirname, 'public')));

// Rota principal
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Rota para gerar link SMS
app.get('/sms-link', (req, res) => {
    const phoneNumber = req.query.phone || '+7678';
    const message = req.query.body || 'PORTABILIDADE';
    
    const smsLink = `sms:${phoneNumber}?body=${encodeURIComponent(message)}`;
    
    res.json({
        success: true,
        smsLink: smsLink,
        phoneNumber: phoneNumber,
        message: message
    });
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`🚀 Servidor rodando em http://localhost:${PORT}`);
    console.log(`📱 Acesse a página para gerar seu link SMS`);
});