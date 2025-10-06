-- ============================================
-- Sistema de Gerenciamento de Restaurante
-- Índices para Otimização de Performance
-- ============================================

USE restaurante_db;

-- ============================================
-- Índices já criados nas tabelas principais
-- ============================================
-- clientes: idx_email
-- funcionarios: idx_cargo
-- produtos: idx_categoria
-- pedidos: idx_data_hora, idx_status

-- ============================================
-- Índices adicionais para otimização
-- ============================================

-- Otimizar buscas por cliente em pedidos
CREATE INDEX idx_pedidos_cliente ON pedidos(id_cliente);

-- Otimizar buscas por mesa em pedidos
CREATE INDEX idx_pedidos_mesa ON pedidos(id_mesa);

-- Otimizar buscas por funcionário em pedidos
CREATE INDEX idx_pedidos_funcionario ON pedidos(id_funcionario);

-- Otimizar consultas de itens por pedido
CREATE INDEX idx_itens_pedido ON itens_pedido(id_pedido);

-- Otimizar consultas de itens por produto
CREATE INDEX idx_itens_produto ON itens_pedido(id_produto);

-- Otimizar buscas por avaliações de cliente
CREATE INDEX idx_avaliacoes_cliente ON avaliacoes(id_cliente);

-- Otimizar consultas por data de avaliação
CREATE INDEX idx_avaliacoes_data ON avaliacoes(data_avaliacao);

-- Índice composto para relatórios de vendas por período e status
CREATE INDEX idx_pedidos_data_status ON pedidos(data_hora, status);

-- Índice composto para análise de produtos disponíveis por categoria
CREATE INDEX idx_produtos_categoria_disponivel ON produtos(id_categoria, disponivel);

-- Índice para otimizar buscas por nome de cliente
CREATE INDEX idx_clientes_nome ON clientes(nome);

-- Índice para otimizar buscas por nome de produto
CREATE INDEX idx_produtos_nome ON produtos(nome_produto);

-- Índice para status de mesa
CREATE INDEX idx_mesas_status ON mesas(status);

-- ============================================
-- Análise de uso de índices
-- ============================================
-- Para verificar se os índices estão sendo utilizados, execute:
-- EXPLAIN SELECT ... (suas consultas aqui)

-- Exemplo de análise:
-- EXPLAIN SELECT * FROM pedidos WHERE data_hora BETWEEN '2025-10-01' AND '2025-10-31' AND status = 'finalizado';

-- ============================================
-- Estatísticas de tabelas
-- ============================================
-- Para atualizar estatísticas e otimizar o uso de índices:
ANALYZE TABLE clientes;
ANALYZE TABLE mesas;
ANALYZE TABLE funcionarios;
ANALYZE TABLE categorias;
ANALYZE TABLE produtos;
ANALYZE TABLE pedidos;
ANALYZE TABLE itens_pedido;
ANALYZE TABLE avaliacoes;
