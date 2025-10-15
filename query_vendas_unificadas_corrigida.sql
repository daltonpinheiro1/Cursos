WITH VendasUnificadas AS (
    SELECT 
        CONCAT([ID], ',') AS ID,
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
    
    SELECT 
        CONCAT([ID], ',') AS ID,
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
    
    SELECT 
        CONCAT([ID], ',') AS ID,
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
            THEN 0
            ELSE 1
        END AS IS_VIRGEM
    FROM VendasUnificadas v
)

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
        ELSE 'VENDAS NAO VIRGENS'
    END AS STATUS_VIRGEM
FROM VendasComStatusVirgem
ORDER BY 
    IS_VIRGEM DESC,
    CLIENTE_TITULAR,
    AUDITORIA_DATA ASC