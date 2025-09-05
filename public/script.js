document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('smsForm');
    const resultSection = document.getElementById('resultSection');
    const generatedLink = document.getElementById('generatedLink');
    const previewLink = document.getElementById('previewLink');
    const copyBtn = document.getElementById('copyBtn');

    form.addEventListener('submit', function(e) {
        e.preventDefault();
        
        const phoneNumber = document.getElementById('phoneNumber').value.trim();
        const message = document.getElementById('message').value.trim();
        
        if (!phoneNumber || !message) {
            alert('Por favor, preencha todos os campos!');
            return;
        }
        
        // Gerar link SMS
        const smsLink = `sms:${phoneNumber}?body=${encodeURIComponent(message)}`;
        
        // Atualizar interface
        generatedLink.value = smsLink;
        previewLink.href = smsLink;
        
        // Mostrar seção de resultado
        resultSection.style.display = 'block';
        resultSection.scrollIntoView({ behavior: 'smooth' });
        
        // Mostrar mensagem de sucesso
        showSuccessMessage('Link SMS gerado com sucesso!');
    });

    copyBtn.addEventListener('click', function() {
        generatedLink.select();
        generatedLink.setSelectionRange(0, 99999); // Para dispositivos móveis
        
        try {
            document.execCommand('copy');
            showSuccessMessage('Link copiado para a área de transferência!');
            
            // Feedback visual
            copyBtn.textContent = 'Copiado!';
            copyBtn.style.background = '#38a169';
            
            setTimeout(() => {
                copyBtn.textContent = 'Copiar';
                copyBtn.style.background = '#48bb78';
            }, 2000);
            
        } catch (err) {
            // Fallback para navegadores mais antigos
            navigator.clipboard.writeText(generatedLink.value).then(() => {
                showSuccessMessage('Link copiado para a área de transferência!');
            }).catch(() => {
                alert('Não foi possível copiar o link. Tente selecionar e copiar manualmente.');
            });
        }
    });

    // Função para mostrar mensagens de sucesso
    function showSuccessMessage(message) {
        // Remover mensagem anterior se existir
        const existingMessage = document.querySelector('.success-message');
        if (existingMessage) {
            existingMessage.remove();
        }
        
        // Criar nova mensagem
        const successDiv = document.createElement('div');
        successDiv.className = 'success-message';
        successDiv.textContent = message;
        successDiv.style.display = 'block';
        
        // Inserir após o botão
        const form = document.getElementById('smsForm');
        form.appendChild(successDiv);
        
        // Remover após 3 segundos
        setTimeout(() => {
            successDiv.style.display = 'none';
        }, 3000);
    }

    // Validação em tempo real do número de telefone
    const phoneInput = document.getElementById('phoneNumber');
    phoneInput.addEventListener('input', function() {
        let value = this.value;
        
        // Remover caracteres não numéricos exceto + no início
        if (value.length > 0 && value[0] !== '+') {
            value = value.replace(/[^\d]/g, '');
        } else if (value.length > 1) {
            value = '+' + value.slice(1).replace(/[^\d]/g, '');
        }
        
        this.value = value;
    });

    // Auto-resize do textarea
    const messageTextarea = document.getElementById('message');
    messageTextarea.addEventListener('input', function() {
        this.style.height = 'auto';
        this.style.height = this.scrollHeight + 'px';
    });
});