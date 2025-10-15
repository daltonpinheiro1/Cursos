-- Query unificada para vendas com priorização
-- Prioridade: Vendas Virgens > Cliente Titular > Auditoria_Data mais antiga

WITH VendasUnificadas AS (
    -- Primeira tabela: vVivo_vendas
    SELECT 
        CONCAT([ID],',') AS ID,
        AUDITORIA_SITUACAO_NOME,
        VENDA_DATA,
        AUDITORIA_DATA,
        ID_SRE,
        CLIENTE_TITULAR,
        PAGAMENTO_METODO_NOME,
        AUDITORIA_OBSERVACAO,
        [ID] AS VENDA_ID,
        'vVivo_vendas' AS TABELA_ORIGEM
    FROM [REPORT_CRM].[BKO].[DBO].[vVivo_vendas]
    WHERE VENDA_DATA >= '2025-10-01'
        AND ID_SRE IS NOT NULL
        AND PAGAMENTO_METODO_NOME = 'BOLETO'
        AND AUDITORIA_SITUACAO_ID IN (5, 7, 8, 10, 15, 23, 25, 30, 31, 68, 69, 73, 85, 88, 89, 90)
    
    UNION ALL
    
    -- Segunda tabela: vVivo_up_vendas
    SELECT 
        CONCAT([ID],',') AS ID,
        AUDITORIA_SITUACAO_NOME,
        VENDA_DATA,
        AUDITORIA_DATA,
        ID_SRE,
        CLIENTE_TITULAR,
        PAGAMENTO_METODO_NOME,
        AUDITORIA_OBSERVACAO,
        [ID] AS VENDA_ID,
        'vVivo_up_vendas' AS TABELA_ORIGEM
    FROM [REPORT_CRM].[BKO].[dbo].[vVivo_up_vendas]
    WHERE VENDA_DATA >= '2025-10-01'
        AND AUDITORIA_SITUACAO_ID IN (5, 7, 8, 10, 15, 23, 25, 30, 31, 68, 69, 73, 85, 88, 89, 90)
    
    UNION ALL
    
    -- Terceira tabela: vVivo_ctrl_pos_upgrade_vendas
    SELECT 
        CONCAT([ID],',') AS ID,
        AUDITORIA_SITUACAO_NOME,
        VENDA_DATA,
        AUDITORIA_DATA,
        ID_SRE,
        CLIENTE_TITULAR,
        PAGAMENTO_METODO_NOME,
        AUDITORIA_OBSERVACAO,
        [ID] AS VENDA_ID,
        'vVivo_ctrl_pos_upgrade_vendas' AS TABELA_ORIGEM
    FROM [REPORT_CRM].[BKO].[dbo].[vVivo_ctrl_pos_upgrade_vendas]
    WHERE VENDA_DATA >= '2025-10-01'
        AND AUDITORIA_SITUACAO_ID IN (5, 7, 8, 10, 15, 23, 25, 30, 31, 68, 69, 73, 85, 88, 89, 90)
),

-- Verificação de vendas virgens através das tabelas de auditoria
VendasComStatusVirgem AS (
    SELECT 
        v.*,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM [REPORT_CRM].[BKO].[dbo].[vVivo_migracao_auditoria] ma
                WHERE ma.VENDA_ID = v.VENDA_ID
                    AND ma.MARCACA_ID IN (7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 21, 22, 24, 26, 28, 29, 30, 31, 32, 33, 62, 63, 73, 74, 85, 86, 88)
            ) OR EXISTS (
                SELECT 1 
                FROM [REPORT_CRM].[BKO].[dbo].[vVivo_ctrl_pos_upgrade_auditoria] cpa
                WHERE cpa.VENDA_ID = v.VENDA_ID
                    AND cpa.MARCACA_ID IN (7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 19, 21, 22, 24, 26, 28, 29, 30, 31, 32, 33, 62, 63, 73, 74, 85, 86, 88)
            )
            THEN 0  -- NÃO é virgem (passou por alguma marcação)
            ELSE 1  -- É virgem (não passou por nenhuma marcação)
        END AS IS_VIRGEM
    FROM VendasUnificadas v
)

-- Query final com priorização
SELECT 
    ID,
    AUDITORIA_SITUACAO_NOME,
    VENDA_DATA,
    AUDITORIA_DATA,
    ID_SRE,
    CLIENTE_TITULAR,
    PAGAMENTO_METODO_NOME,
    AUDITORIA_OBSERVACAO,
    TABELA_ORIGEM,
    IS_VIRGEM,
    CASE 
        WHEN IS_VIRGEM = 1 THEN 'VENDAS VIRGENS'
        ELSE 'VENDAS NÃO VIRGENS'
    END AS STATUS_VIRGEM
FROM VendasComStatusVirgem
ORDER BY 
    IS_VIRGEM DESC,  -- 1. Prioridade para vendas virgens (1 = virgem, 0 = não virgem)
    CLIENTE_TITULAR, -- 2. Cliente Titular
    AUDITORIA_DATA ASC -- 3. Auditoria_Data mais antiga primeiro