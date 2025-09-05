# 📱 Gerador de Link SMS

Uma aplicação Node.js que permite gerar links SMS personalizados. Quando clicados, esses links abrem automaticamente o aplicativo de mensagens do dispositivo com o número e texto pré-preenchidos.

## 🚀 Funcionalidades

- **Interface Web Intuitiva**: Página web moderna e responsiva
- **Geração de Links SMS**: Cria links no formato `sms:numero?body=mensagem`
- **Preview em Tempo Real**: Visualize o link antes de usar
- **Cópia Fácil**: Botão para copiar o link gerado
- **Validação de Entrada**: Validação automática do número de telefone
- **Design Responsivo**: Funciona perfeitamente em desktop e mobile

## 📋 Pré-requisitos

- Node.js (versão 14 ou superior)
- npm (gerenciador de pacotes do Node.js)

## 🛠️ Instalação

1. **Clone ou baixe o projeto**
   ```bash
   cd /workspace
   ```

2. **Instale as dependências**
   ```bash
   npm install
   ```

## 🎯 Como Usar

1. **Inicie o servidor**
   ```bash
   npm start
   ```
   
   Ou para desenvolvimento com auto-reload:
   ```bash
   npm run dev
   ```

2. **Acesse a aplicação**
   - Abra seu navegador
   - Navegue para `http://localhost:3000`

3. **Gere seu link SMS**
   - Digite o número de telefone (ex: +7678)
   - Digite a mensagem (ex: PORTABILIDADE)
   - Clique em "Gerar Link SMS"
   - Copie o link ou clique no preview para testar

## 📱 Exemplo de Uso

O link gerado terá o formato:
```
sms:+7678?body=PORTABILIDADE
```

Quando clicado em um dispositivo móvel, abrirá automaticamente o aplicativo de mensagens com:
- **Número**: +7678
- **Mensagem**: PORTABILIDADE

## 🏗️ Estrutura do Projeto

```
/
├── package.json          # Configurações e dependências
├── server.js             # Servidor Express
├── README.md             # Este arquivo
└── public/               # Arquivos estáticos
    ├── index.html        # Página principal
    ├── styles.css        # Estilos CSS
    └── script.js         # JavaScript do cliente
```

## 🔧 Scripts Disponíveis

- `npm start`: Inicia o servidor em modo produção
- `npm run dev`: Inicia o servidor em modo desenvolvimento (com nodemon)

## 🌐 API Endpoints

### GET /
Serve a página principal da aplicação.

### GET /sms-link
Gera um link SMS via API.

**Parâmetros:**
- `phone` (opcional): Número de telefone (padrão: +7678)
- `body` (opcional): Mensagem (padrão: PORTABILIDADE)

**Exemplo:**
```
GET /sms-link?phone=+1234567890&body=Olá%20mundo
```

**Resposta:**
```json
{
  "success": true,
  "smsLink": "sms:+1234567890?body=Olá%20mundo",
  "phoneNumber": "+1234567890",
  "message": "Olá mundo"
}
```

## 🎨 Personalização

### Modificar o Porta
Para alterar a porta do servidor, defina a variável de ambiente `PORT`:
```bash
PORT=8080 npm start
```

### Personalizar Estilos
Edite o arquivo `public/styles.css` para modificar a aparência da aplicação.

## 📱 Compatibilidade

- ✅ **Desktop**: Chrome, Firefox, Safari, Edge
- ✅ **Mobile**: iOS Safari, Chrome Mobile, Samsung Internet
- ✅ **Tablets**: iPad, Android tablets

## 🔒 Segurança

- Validação de entrada no cliente e servidor
- Sanitização de dados para prevenir XSS
- Uso de `encodeURIComponent` para URLs seguras

## 🤝 Contribuição

1. Faça um fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 🆘 Suporte

Se você encontrar algum problema ou tiver dúvidas:

1. Verifique se o Node.js está instalado corretamente
2. Certifique-se de que a porta 3000 não está sendo usada por outro processo
3. Verifique os logs do console para mensagens de erro

## 🔄 Atualizações Futuras

- [ ] Suporte a múltiplos números
- [ ] Histórico de links gerados
- [ ] Exportação de links em diferentes formatos
- [ ] Integração com APIs de SMS
- [ ] Suporte a templates de mensagem