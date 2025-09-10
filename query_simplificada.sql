-- QUERY SIMPLIFICADA - APENAS TELEFONE, NOME, CIDADE E ESTADO
-- Compatível com SSMS 14 com filtros de data

SELECT 
    t1.telefone,
    t1.nome,
    t1.cidade,
    t1.estado
FROM tabela1 t1
WHERE ((t1.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
        AND t1.estado = 'MG')
       OR (t1.cidade IS NULL AND t1.estado IS NULL))
  AND (t1.data_cadastro >= '2024-01-01' OR t1.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t2.telefone,
    t2.nome,
    'N/A' AS cidade,
    'N/A' AS estado
FROM tabela2 t2
WHERE (t2.data_cadastro >= '2024-01-01' OR t2.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t3.telefone,
    t3.nome,
    t3.cidade,
    t3.estado
FROM tabela3 t3
WHERE ((t3.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
        AND t3.estado = 'MG')
       OR (t3.cidade IS NULL AND t3.estado IS NULL))
  AND (t3.data_cadastro >= '2024-01-01' OR t3.data_atualizacao >= '2024-01-01')

ORDER BY cidade, nome;

-- ========================================
-- VERSÃO AINDA MAIS SIMPLES (SEM FILTRO DE DATA)
-- ========================================

SELECT 
    t1.telefone,
    t1.nome,
    t1.cidade,
    t1.estado
FROM tabela1 t1
WHERE (t1.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
       AND t1.estado = 'MG')
   OR (t1.cidade IS NULL AND t1.estado IS NULL)

UNION ALL

SELECT 
    t2.telefone,
    t2.nome,
    'N/A' AS cidade,
    'N/A' AS estado
FROM tabela2 t2

UNION ALL

SELECT 
    t3.telefone,
    t3.nome,
    t3.cidade,
    t3.estado
FROM tabela3 t3
WHERE (t3.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
       AND t3.estado = 'MG')
   OR (t3.cidade IS NULL AND t3.estado IS NULL)

ORDER BY cidade, nome;

-- ========================================
-- VERSÃO APENAS COM CIDADES DE MG (SEM N/A)
-- ========================================

SELECT 
    t1.telefone,
    t1.nome,
    t1.cidade,
    t1.estado
FROM tabela1 t1
WHERE t1.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
  AND t1.estado = 'MG'
  AND (t1.data_cadastro >= '2024-01-01' OR t1.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t3.telefone,
    t3.nome,
    t3.cidade,
    t3.estado
FROM tabela3 t3
WHERE t3.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
  AND t3.estado = 'MG'
  AND (t3.data_cadastro >= '2024-01-01' OR t3.data_atualizacao >= '2024-01-01')

ORDER BY cidade, nome;