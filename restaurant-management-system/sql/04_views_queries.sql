-- ============================================
-- Sistema de Gerenciamento de Restaurante
-- Views e Consultas Complexas
-- ============================================

USE restaurante_db;

-- ============================================
-- VIEW: Pedidos completos com informações detalhadas
-- ============================================
CREATE OR REPLACE VIEW vw_pedidos_completos AS
SELECT 
    p.id_pedido,
    p.data_hora,
    p.status,
    p.valor_total,
    p.forma_pagamento,
    c.nome AS cliente_nome,
    c.telefone AS cliente_telefone,
    m.numero_mesa,
    m.capacidade AS mesa_capacidade,
    f.nome AS garcom_nome,
    f.cargo AS garcom_cargo
FROM pedidos p
INNER JOIN clientes c ON p.id_cliente = c.id_cliente
INNER JOIN mesas m ON p.id_mesa = m.id_mesa
INNER JOIN funcionarios f ON p.id_funcionario = f.id_funcionario;

-- ============================================
-- VIEW: Detalhamento de itens por pedido
-- ============================================
CREATE OR REPLACE VIEW vw_itens_detalhados AS
SELECT 
    ip.id_item,
    ip.id_pedido,
    p.data_hora AS pedido_data,
    prod.nome_produto,
    cat.nome_categoria,
    ip.quantidade,
    ip.preco_unitario,
    ip.subtotal,
    ip.observacoes,
    ped.status AS pedido_status
FROM itens_pedido ip
INNER JOIN produtos prod ON ip.id_produto = prod.id_produto
INNER JOIN categorias cat ON prod.id_categoria = cat.id_categoria
INNER JOIN pedidos ped ON ip.id_pedido = ped.id_pedido
INNER JOIN clientes p ON ped.id_cliente = p.id_cliente;

-- ============================================
-- VIEW: Resumo de avaliações
-- ============================================
CREATE OR REPLACE VIEW vw_avaliacoes_resumo AS
SELECT 
    a.id_avaliacao,
    a.nota,
    a.comentario,
    a.data_avaliacao,
    c.nome AS cliente_nome,
    p.data_hora AS pedido_data,
    p.valor_total AS pedido_valor,
    f.nome AS garcom_nome
FROM avaliacoes a
INNER JOIN clientes c ON a.id_cliente = c.id_cliente
INNER JOIN pedidos p ON a.id_pedido = p.id_pedido
INNER JOIN funcionarios f ON p.id_funcionario = f.id_funcionario;

-- ============================================
-- VIEW: Dashboard de vendas
-- ============================================
CREATE OR REPLACE VIEW vw_dashboard_vendas AS
SELECT 
    DATE(data_hora) AS data,
    COUNT(DISTINCT id_pedido) AS total_pedidos,
    COUNT(DISTINCT id_cliente) AS clientes_atendidos,
    SUM(valor_total) AS faturamento,
    AVG(valor_total) AS ticket_medio,
    MAX(valor_total) AS maior_venda
FROM pedidos
WHERE status = 'finalizado'
GROUP BY DATE(data_hora);

-- ============================================
-- CONSULTA 1: Top 5 clientes que mais gastaram
-- ============================================
-- Identifica os clientes mais valiosos para estratégias de fidelização
SELECT 
    c.id_cliente,
    c.nome,
    c.email,
    COUNT(p.id_pedido) AS total_pedidos,
    SUM(p.valor_total) AS valor_total_gasto,
    AVG(p.valor_total) AS ticket_medio,
    MAX(p.data_hora) AS ultima_visita
FROM clientes c
INNER JOIN pedidos p ON c.id_cliente = p.id_cliente
WHERE p.status = 'finalizado'
GROUP BY c.id_cliente, c.nome, c.email
ORDER BY valor_total_gasto DESC
LIMIT 5;

-- ============================================
-- CONSULTA 2: Produtos por categoria com performance
-- ============================================
-- Análise de vendas por categoria para gestão de estoque
SELECT 
    cat.nome_categoria,
    COUNT(DISTINCT prod.id_produto) AS total_produtos,
    SUM(ip.quantidade) AS quantidade_vendida,
    SUM(ip.subtotal) AS receita_total,
    AVG(prod.preco) AS preco_medio_categoria,
    ROUND(SUM(ip.subtotal) / SUM(ip.quantidade), 2) AS preco_medio_venda
FROM categorias cat
INNER JOIN produtos prod ON cat.id_categoria = prod.id_categoria
LEFT JOIN itens_pedido ip ON prod.id_produto = ip.id_produto
LEFT JOIN pedidos p ON ip.id_pedido = p.id_pedido AND p.status = 'finalizado'
GROUP BY cat.id_categoria, cat.nome_categoria
ORDER BY receita_total DESC;

-- ============================================
-- CONSULTA 3: Análise de horários de pico
-- ============================================
-- Identifica horários com maior movimento para dimensionamento de equipe
SELECT 
    HOUR(data_hora) AS hora,
    COUNT(id_pedido) AS total_pedidos,
    SUM(valor_total) AS faturamento,
    AVG(valor_total) AS ticket_medio,
    COUNT(DISTINCT id_cliente) AS clientes_unicos
FROM pedidos
WHERE status = 'finalizado'
GROUP BY HOUR(data_hora)
ORDER BY total_pedidos DESC;

-- ============================================
-- CONSULTA 4: Comparativo de formas de pagamento
-- ============================================
-- Análise de preferências de pagamento dos clientes
SELECT 
    forma_pagamento,
    COUNT(id_pedido) AS quantidade_pedidos,
    SUM(valor_total) AS valor_total,
    AVG(valor_total) AS ticket_medio,
    ROUND(COUNT(id_pedido) * 100.0 / (SELECT COUNT(*) FROM pedidos WHERE status = 'finalizado'), 2) AS percentual_uso
FROM pedidos
WHERE status = 'finalizado'
GROUP BY forma_pagamento
ORDER BY quantidade_pedidos DESC;

-- ============================================
-- CONSULTA 5: Produtos que nunca foram vendidos
-- ============================================
-- Identifica produtos com baixa aceitação para revisão de cardápio
SELECT 
    p.id_produto,
    p.nome_produto,
    c.nome_categoria,
    p.preco,
    p.disponivel
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id_categoria
LEFT JOIN itens_pedido ip ON p.id_produto = ip.id_produto
WHERE ip.id_produto IS NULL
ORDER BY c.nome_categoria, p.nome_produto;

-- ============================================
-- CONSULTA 6: Ranking de garçons por avaliação
-- ============================================
-- Avalia desempenho dos garçons com base nas avaliações dos clientes
SELECT 
    f.id_funcionario,
    f.nome,
    COUNT(DISTINCT p.id_pedido) AS total_atendimentos,
    SUM(p.valor_total) AS valor_total_vendido,
    COUNT(a.id_avaliacao) AS total_avaliacoes,
    AVG(a.nota) AS nota_media,
    SUM(CASE WHEN a.nota = 5 THEN 1 ELSE 0 END) AS avaliacoes_5_estrelas,
    ROUND(SUM(CASE WHEN a.nota = 5 THEN 1 ELSE 0 END) * 100.0 / COUNT(a.id_avaliacao), 2) AS percentual_excelencia
FROM funcionarios f
INNER JOIN pedidos p ON f.id_funcionario = p.id_funcionario
LEFT JOIN avaliacoes a ON p.id_pedido = a.id_pedido
WHERE f.cargo = 'garcom' AND p.status = 'finalizado'
GROUP BY f.id_funcionario, f.nome
HAVING COUNT(a.id_avaliacao) > 0
ORDER BY nota_media DESC, total_avaliacoes DESC;

-- ============================================
-- CONSULTA 7: Análise de ocupação de mesas
-- ============================================
-- Verifica eficiência de uso das mesas para otimização de layout
SELECT 
    m.numero_mesa,
    m.capacidade,
    COUNT(p.id_pedido) AS total_usos,
    SUM(p.valor_total) AS receita_gerada,
    AVG(p.valor_total) AS ticket_medio_mesa,
    ROUND(SUM(p.valor_total) / m.capacidade, 2) AS receita_por_lugar
FROM mesas m
LEFT JOIN pedidos p ON m.id_mesa = p.id_mesa AND p.status = 'finalizado'
GROUP BY m.id_mesa, m.numero_mesa, m.capacidade
ORDER BY receita_gerada DESC;

-- ============================================
-- CONSULTA 8: Produtos mais pedidos juntos (Market Basket)
-- ============================================
-- Identifica combinações populares para sugestões de combos
SELECT 
    p1.nome_produto AS produto_1,
    p2.nome_produto AS produto_2,
    COUNT(*) AS vezes_pedidos_juntos,
    SUM(ip1.subtotal + ip2.subtotal) AS receita_combinada
FROM itens_pedido ip1
INNER JOIN itens_pedido ip2 ON ip1.id_pedido = ip2.id_pedido AND ip1.id_produto < ip2.id_produto
INNER JOIN produtos p1 ON ip1.id_produto = p1.id_produto
INNER JOIN produtos p2 ON ip2.id_produto = p2.id_produto
INNER JOIN pedidos ped ON ip1.id_pedido = ped.id_pedido
WHERE ped.status = 'finalizado'
GROUP BY p1.id_produto, p1.nome_produto, p2.id_produto, p2.nome_produto
HAVING COUNT(*) >= 2
ORDER BY vezes_pedidos_juntos DESC
LIMIT 10;

-- ============================================
-- CONSULTA 9: Análise de cancelamentos
-- ============================================
-- Investiga padrões de pedidos cancelados
SELECT 
    DATE(data_hora) AS data,
    COUNT(*) AS total_cancelamentos,
    AVG(valor_total) AS valor_medio_cancelado,
    GROUP_CONCAT(DISTINCT f.nome SEPARATOR ', ') AS garcons_envolvidos
FROM pedidos p
INNER JOIN funcionarios f ON p.id_funcionario = f.id_funcionario
WHERE p.status = 'cancelado'
GROUP BY DATE(data_hora)
ORDER BY data DESC;

-- ============================================
-- CONSULTA 10: Relatório financeiro mensal completo
-- ============================================
-- Visão consolidada para fechamento contábil
SELECT 
    YEAR(data_hora) AS ano,
    MONTH(data_hora) AS mes,
    COUNT(DISTINCT id_pedido) AS total_pedidos,
    COUNT(DISTINCT id_cliente) AS clientes_unicos,
    SUM(valor_total) AS faturamento_bruto,
    AVG(valor_total) AS ticket_medio,
    MIN(valor_total) AS menor_venda,
    MAX(valor_total) AS maior_venda,
    SUM(CASE WHEN forma_pagamento = 'dinheiro' THEN valor_total ELSE 0 END) AS total_dinheiro,
    SUM(CASE WHEN forma_pagamento IN ('cartao_credito', 'cartao_debito') THEN valor_total ELSE 0 END) AS total_cartao,
    SUM(CASE WHEN forma_pagamento = 'pix' THEN valor_total ELSE 0 END) AS total_pix
FROM pedidos
WHERE status = 'finalizado'
GROUP BY YEAR(data_hora), MONTH(data_hora)
ORDER BY ano DESC, mes DESC;
