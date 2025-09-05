document.addEventListener('DOMContentLoaded', function() {
    const copyBtn = document.getElementById('copyBtn');
    const smsLink = 'sms:+7678?body=PORTABILIDADE';

    copyBtn.addEventListener('click', function() {
        try {
            // Usar a API moderna de clipboard
            navigator.clipboard.writeText(smsLink).then(() => {
                showSuccessMessage('Link copiado para a área de transferência!');
                
                // Feedback visual
                copyBtn.textContent = 'Copiado!';
                copyBtn.style.background = '#38a169';
                
                setTimeout(() => {
                    copyBtn.textContent = 'Copiar Link';
                    copyBtn.style.background = '#48bb78';
                }, 2000);
                
            }).catch(() => {
                // Fallback para navegadores mais antigos
                fallbackCopyTextToClipboard(smsLink);
            });
        } catch (err) {
            fallbackCopyTextToClipboard(smsLink);
        }
    });

    // Função fallback para copiar texto
    function fallbackCopyTextToClipboard(text) {
        const textArea = document.createElement("textarea");
        textArea.value = text;
        textArea.style.top = "0";
        textArea.style.left = "0";
        textArea.style.position = "fixed";
        
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        
        try {
            const successful = document.execCommand('copy');
            if (successful) {
                showSuccessMessage('Link copiado para a área de transferência!');
            } else {
                showSuccessMessage('Não foi possível copiar automaticamente. O link é: ' + text);
            }
        } catch (err) {
            showSuccessMessage('Não foi possível copiar o link. Tente selecionar e copiar manualmente.');
        }
        
        document.body.removeChild(textArea);
    }

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
        
        // Inserir após o botão de copiar
        copyBtn.parentNode.appendChild(successDiv);
        
        // Remover após 3 segundos
        setTimeout(() => {
            successDiv.style.display = 'none';
        }, 3000);
    }
});