-- Query para unir todas as tabelas considerando que nem todas têm cidade e estado
-- Compatível com SSMS 14 e limitações de formulários complexos
-- INCLUINDO FILTROS DE DATA/HISTÓRICO

-- Opção 1: UNION ALL com tratamento de colunas ausentes e filtro de data
SELECT 
    'Tabela1' AS origem_tabela,
    id,
    nome,
    cidade,
    estado,
    data_cadastro,
    data_atualizacao,
    outros_campos
FROM tabela1
WHERE (cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
       AND estado = 'MG')
   OR (cidade IS NULL AND estado IS NULL) -- Para registros sem localização
   AND (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01') -- Filtro de data

UNION ALL

SELECT 
    'Tabela2' AS origem_tabela,
    id,
    nome,
    NULL AS cidade,  -- Tabela2 não tem coluna cidade
    NULL AS estado,  -- Tabela2 não tem coluna estado
    data_cadastro,
    data_atualizacao,
    outros_campos
FROM tabela2
WHERE (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01') -- Filtro de data
-- Sem filtro de cidade/estado pois não existem

UNION ALL

SELECT 
    'Tabela3' AS origem_tabela,
    id,
    nome,
    cidade,
    estado,
    data_cadastro,
    data_atualizacao,
    outros_campos
FROM tabela3
WHERE (cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
       AND estado = 'MG')
   OR (cidade IS NULL AND estado IS NULL)
   AND (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01') -- Filtro de data

-- Continue adicionando mais tabelas conforme necessário...

ORDER BY origem_tabela, nome;

-- Opção 2: LEFT JOIN com tratamento de colunas ausentes e filtro de data
SELECT 
    COALESCE(t1.id, t2.id, t3.id) AS id,
    COALESCE(t1.nome, t2.nome, t3.nome) AS nome,
    COALESCE(t1.cidade, t3.cidade) AS cidade,
    COALESCE(t1.estado, t3.estado) AS estado,
    COALESCE(t1.data_cadastro, t2.data_cadastro, t3.data_cadastro) AS data_cadastro,
    COALESCE(t1.data_atualizacao, t2.data_atualizacao, t3.data_atualizacao) AS data_atualizacao,
    COALESCE(t1.outros_campos, t2.outros_campos, t3.outros_campos) AS outros_campos,
    CASE 
        WHEN t1.id IS NOT NULL THEN 'Tabela1'
        WHEN t2.id IS NOT NULL THEN 'Tabela2'
        WHEN t3.id IS NOT NULL THEN 'Tabela3'
    END AS origem_tabela
FROM tabela1 t1
FULL OUTER JOIN tabela2 t2 ON t1.id = t2.id
FULL OUTER JOIN tabela3 t3 ON COALESCE(t1.id, t2.id) = t3.id
WHERE 
    -- Filtro para cidades de MG (apenas para tabelas que têm essas colunas)
    ((COALESCE(t1.cidade, t3.cidade) IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
      AND COALESCE(t1.estado, t3.estado) = 'MG')
     OR 
     -- Incluir registros sem cidade/estado
     (COALESCE(t1.cidade, t3.cidade) IS NULL AND COALESCE(t1.estado, t3.estado) IS NULL))
    AND
    -- Filtro de data/histórico
    (COALESCE(t1.data_cadastro, t2.data_cadastro, t3.data_cadastro) >= '2024-01-01' 
     OR COALESCE(t1.data_atualizacao, t2.data_atualizacao, t3.data_atualizacao) >= '2024-01-01')
ORDER BY origem_tabela, nome;

-- Opção 3: Query mais simples usando EXISTS (recomendada para SSMS 14) com filtro de data
SELECT 
    t1.id,
    t1.nome,
    t1.cidade,
    t1.estado,
    t1.data_cadastro,
    t1.data_atualizacao,
    t1.outros_campos,
    'Tabela1' AS origem
FROM tabela1 t1
WHERE EXISTS (
    SELECT 1 
    WHERE ((t1.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
            AND t1.estado = 'MG')
           OR (t1.cidade IS NULL AND t1.estado IS NULL))
          AND (t1.data_cadastro >= '2024-01-01' OR t1.data_atualizacao >= '2024-01-01')
)

UNION ALL

SELECT 
    t2.id,
    t2.nome,
    'N/A' AS cidade,  -- Valor padrão para tabelas sem cidade
    'N/A' AS estado,  -- Valor padrão para tabelas sem estado
    t2.data_cadastro,
    t2.data_atualizacao,
    t2.outros_campos,
    'Tabela2' AS origem
FROM tabela2 t2
WHERE (t2.data_cadastro >= '2024-01-01' OR t2.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t3.id,
    t3.nome,
    t3.cidade,
    t3.estado,
    t3.data_cadastro,
    t3.data_atualizacao,
    t3.outros_campos,
    'Tabela3' AS origem
FROM tabela3 t3
WHERE EXISTS (
    SELECT 1 
    WHERE ((t3.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
            AND t3.estado = 'MG')
           OR (t3.cidade IS NULL AND t3.estado IS NULL))
          AND (t3.data_cadastro >= '2024-01-01' OR t3.data_atualizacao >= '2024-01-01')
)

ORDER BY origem, nome;

-- Opção 4: Query com CTE (Common Table Expression) - mais organizada com filtro de data
WITH TodasTabelas AS (
    -- Tabela1 (com cidade e estado)
    SELECT 
        id, nome, cidade, estado, data_cadastro, data_atualizacao, outros_campos,
        'Tabela1' AS origem_tabela,
        1 AS tem_localizacao
    FROM tabela1
    WHERE ((cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
            AND estado = 'MG')
           OR (cidade IS NULL AND estado IS NULL))
          AND (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01')
    
    UNION ALL
    
    -- Tabela2 (sem cidade e estado)
    SELECT 
        id, nome, NULL AS cidade, NULL AS estado, data_cadastro, data_atualizacao, outros_campos,
        'Tabela2' AS origem_tabela,
        0 AS tem_localizacao
    FROM tabela2
    WHERE (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01')
    
    UNION ALL
    
    -- Tabela3 (com cidade e estado)
    SELECT 
        id, nome, cidade, estado, data_cadastro, data_atualizacao, outros_campos,
        'Tabela3' AS origem_tabela,
        1 AS tem_localizacao
    FROM tabela3
    WHERE ((cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
            AND estado = 'MG')
           OR (cidade IS NULL AND estado IS NULL))
          AND (data_cadastro >= '2024-01-01' OR data_atualizacao >= '2024-01-01')
)
SELECT 
    id,
    nome,
    CASE 
        WHEN tem_localizacao = 1 THEN cidade 
        ELSE 'Sem localização' 
    END AS cidade,
    CASE 
        WHEN tem_localizacao = 1 THEN estado 
        ELSE 'N/A' 
    END AS estado,
    data_cadastro,
    data_atualizacao,
    outros_campos,
    origem_tabela
FROM TodasTabelas
ORDER BY origem_tabela, nome;

-- ========================================
-- QUERY PRINCIPAL RECOMENDADA (OPÇÃO 3)
-- ========================================
-- Esta é a query mais adequada para SSMS 14 com filtros de data

SELECT 
    t1.id,
    t1.nome,
    t1.cidade,
    t1.estado,
    t1.data_cadastro,
    t1.data_atualizacao,
    t1.outros_campos,
    'Tabela1' AS origem
FROM tabela1 t1
WHERE ((t1.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
        AND t1.estado = 'MG')
       OR (t1.cidade IS NULL AND t1.estado IS NULL))
  AND (t1.data_cadastro >= '2024-01-01' OR t1.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t2.id,
    t2.nome,
    'N/A' AS cidade,
    'N/A' AS estado,
    t2.data_cadastro,
    t2.data_atualizacao,
    t2.outros_campos,
    'Tabela2' AS origem
FROM tabela2 t2
WHERE (t2.data_cadastro >= '2024-01-01' OR t2.data_atualizacao >= '2024-01-01')

UNION ALL

SELECT 
    t3.id,
    t3.nome,
    t3.cidade,
    t3.estado,
    t3.data_cadastro,
    t3.data_atualizacao,
    t3.outros_campos,
    'Tabela3' AS origem
FROM tabela3 t3
WHERE ((t3.cidade IN ('Manhuaçu', 'Nova Serrana', 'Perdigão', 'Ouro Preto', 'Mariana', 'Viçosa', 'Passos') 
        AND t3.estado = 'MG')
       OR (t3.cidade IS NULL AND t3.estado IS NULL))
  AND (t3.data_cadastro >= '2024-01-01' OR t3.data_atualizacao >= '2024-01-01')

ORDER BY origem, nome;

-- ========================================
-- FILTROS DE DATA ALTERNATIVOS
-- ========================================

-- Para filtrar por período específico (exemplo: últimos 30 dias)
-- Substitua a condição de data por:
-- AND (data_cadastro >= DATEADD(DAY, -30, GETDATE()) OR data_atualizacao >= DATEADD(DAY, -30, GETDATE()))

-- Para filtrar por mês atual
-- AND (YEAR(data_cadastro) = YEAR(GETDATE()) AND MONTH(data_cadastro) = MONTH(GETDATE())
--      OR YEAR(data_atualizacao) = YEAR(GETDATE()) AND MONTH(data_atualizacao) = MONTH(GETDATE()))

-- Para filtrar por ano específico (exemplo: 2024)
-- AND (YEAR(data_cadastro) = 2024 OR YEAR(data_atualizacao) = 2024)

-- Para filtrar por data específica
-- AND (data_cadastro >= '2024-01-01' AND data_cadastro <= '2024-12-31'
--      OR data_atualizacao >= '2024-01-01' AND data_atualizacao <= '2024-12-31')