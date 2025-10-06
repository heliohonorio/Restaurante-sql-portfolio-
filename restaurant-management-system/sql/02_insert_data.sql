-- ============================================
-- Sistema de Gerenciamento de Restaurante
-- Script de Inserção de Dados de Exemplo
-- ============================================

USE restaurante_db;

-- ============================================
-- Inserção: CLIENTES
-- ============================================
INSERT INTO clientes (nome, telefone, email) VALUES
('João Silva', '11987654321', 'joao.silva@email.com'),
('Maria Oliveira', '11976543210', 'maria.oliveira@email.com'),
('Pedro Santos', '11965432109', 'pedro.santos@email.com'),
('Ana Costa', '11954321098', 'ana.costa@email.com'),
('Carlos Ferreira', '11943210987', 'carlos.ferreira@email.com'),
('Juliana Lima', '11932109876', 'juliana.lima@email.com'),
('Roberto Alves', '11921098765', 'roberto.alves@email.com'),
('Fernanda Souza', '11910987654', 'fernanda.souza@email.com'),
('Lucas Pereira', '11909876543', 'lucas.pereira@email.com'),
('Camila Rocha', '11998765432', 'camila.rocha@email.com');

-- ============================================
-- Inserção: MESAS
-- ============================================
INSERT INTO mesas (numero_mesa, capacidade, status) VALUES
(1, 2, 'disponivel'),
(2, 2, 'disponivel'),
(3, 4, 'ocupada'),
(4, 4, 'disponivel'),
(5, 6, 'reservada'),
(6, 6, 'disponivel'),
(7, 8, 'disponivel'),
(8, 4, 'ocupada'),
(9, 2, 'disponivel'),
(10, 4, 'disponivel');

-- ============================================
-- Inserção: FUNCIONARIOS
-- ============================================
INSERT INTO funcionarios (nome, cargo, telefone, salario, data_contratacao) VALUES
('Ricardo Mendes', 'gerente', '11988887777', 4500.00, '2020-01-15'),
('Patrícia Gomes', 'garcom', '11977776666', 2200.00, '2021-03-10'),
('Marcos Ribeiro', 'garcom', '11966665555', 2200.00, '2021-06-20'),
('Tatiana Martins', 'cozinheiro', '11955554444', 3000.00, '2019-11-05'),
('Bruno Cardoso', 'cozinheiro', '11944443333', 3000.00, '2020-08-12'),
('Vanessa Dias', 'caixa', '11933332222', 2500.00, '2022-02-01'),
('Felipe Araújo', 'garcom', '11922221111', 2200.00, '2022-07-15'),
('Aline Castro', 'cozinheiro', '11911110000', 3000.00, '2021-09-30');

-- ============================================
-- Inserção: CATEGORIAS
-- ============================================
INSERT INTO categorias (nome_categoria, descricao) VALUES
('Entradas', 'Pratos leves para começar a refeição'),
('Pratos Principais', 'Pratos principais do cardápio'),
('Sobremesas', 'Doces e sobremesas variadas'),
('Bebidas', 'Bebidas alcoólicas e não alcoólicas'),
('Massas', 'Massas italianas e variações'),
('Carnes', 'Carnes grelhadas e assadas'),
('Saladas', 'Saladas frescas e saudáveis');

-- ============================================
-- Inserção: PRODUTOS
-- ============================================
INSERT INTO produtos (id_categoria, nome_produto, descricao, preco, disponivel) VALUES
-- Entradas
(1, 'Bruschetta', 'Pão italiano com tomate, manjericão e azeite', 18.90, TRUE),
(1, 'Carpaccio', 'Fatias finas de carne bovina com molho especial', 32.90, TRUE),
(1, 'Bolinho de Bacalhau', 'Porção com 6 unidades', 28.50, TRUE),

-- Pratos Principais
(2, 'Filé à Parmegiana', 'Filé mignon empanado com molho e queijo', 52.90, TRUE),
(2, 'Salmão Grelhado', 'Salmão grelhado com legumes', 58.90, TRUE),
(2, 'Picanha na Chapa', 'Picanha grelhada com arroz e fritas', 64.90, TRUE),

-- Massas
(5, 'Espaguete à Carbonara', 'Massa com bacon, ovos e queijo', 42.90, TRUE),
(5, 'Lasanha Bolonhesa', 'Lasanha tradicional com molho bolonhesa', 38.90, TRUE),
(5, 'Risoto de Funghi', 'Risoto cremoso com cogumelos', 46.90, TRUE),

-- Carnes
(6, 'Costela BBQ', 'Costela suína ao molho barbecue', 54.90, TRUE),
(6, 'Frango à Milanesa', 'Filé de frango empanado', 36.90, TRUE),

-- Saladas
(7, 'Salada Caesar', 'Alface romana, croutons e molho caesar', 28.90, TRUE),
(7, 'Salada Caprese', 'Tomate, mussarela de búfala e manjericão', 32.90, TRUE),

-- Sobremesas
(3, 'Petit Gateau', 'Bolo de chocolate quente com sorvete', 24.90, TRUE),
(3, 'Tiramisù', 'Sobremesa italiana com café e mascarpone', 22.90, TRUE),
(3, 'Cheesecake', 'Torta de queijo com calda de frutas vermelhas', 26.90, TRUE),

-- Bebidas
(4, 'Refrigerante Lata', 'Coca-Cola, Guaraná ou Sprite', 6.00, TRUE),
(4, 'Suco Natural', 'Laranja, limão ou abacaxi', 12.00, TRUE),
(4, 'Água Mineral', 'Garrafa 500ml', 4.50, TRUE),
(4, 'Cerveja Artesanal', 'Garrafa 600ml', 18.00, TRUE),
(4, 'Vinho Tinto', 'Taça 150ml', 22.00, TRUE);

-- ============================================
-- Inserção: PEDIDOS
-- ============================================
INSERT INTO pedidos (id_cliente, id_mesa, id_funcionario, data_hora, status, valor_total, forma_pagamento) VALUES
(1, 3, 2, '2025-10-05 12:30:00', 'finalizado', 145.80, 'cartao_credito'),
(2, 8, 3, '2025-10-05 13:15:00', 'finalizado', 98.70, 'pix'),
(3, 1, 2, '2025-10-05 19:00:00', 'finalizado', 187.60, 'cartao_debito'),
(4, 4, 7, '2025-10-06 12:00:00', 'em_preparo', 0.00, NULL),
(5, 5, 2, '2025-10-06 13:30:00', 'aberto', 0.00, NULL),
(6, 2, 3, '2025-10-05 20:15:00', 'finalizado', 124.50, 'dinheiro'),
(7, 6, 7, '2025-10-05 18:45:00', 'finalizado', 156.80, 'cartao_credito'),
(8, 7, 2, '2025-10-05 14:20:00', 'finalizado', 203.40, 'pix'),
(9, 9, 3, '2025-10-06 11:30:00', 'em_preparo', 0.00, NULL),
(10, 10, 7, '2025-10-05 21:00:00', 'finalizado', 89.80, 'cartao_debito');

-- ============================================
-- Inserção: ITENS_PEDIDO
-- ============================================
-- Pedido 1
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(1, 1, 1, 18.90, 18.90, NULL),
(1, 4, 1, 52.90, 52.90, 'Mal passado'),
(1, 14, 1, 24.90, 24.90, NULL),
(1, 17, 2, 6.00, 12.00, NULL),
(1, 21, 2, 18.00, 36.00, NULL);

-- Pedido 2
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(2, 7, 1, 42.90, 42.90, NULL),
(2, 12, 1, 28.90, 28.90, 'Sem cebola'),
(2, 18, 2, 12.00, 24.00, 'Suco de laranja'),
(2, 19, 1, 4.50, 4.50, NULL);

-- Pedido 3
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(3, 2, 1, 32.90, 32.90, NULL),
(3, 5, 1, 58.90, 58.90, NULL),
(3, 15, 1, 22.90, 22.90, NULL),
(3, 16, 1, 26.90, 26.90, NULL),
(3, 22, 2, 22.00, 44.00, NULL);

-- Pedido 4
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(4, 6, 2, 64.90, 129.80, 'Bem passado'),
(4, 20, 2, 18.00, 36.00, NULL);

-- Pedido 5
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(5, 8, 2, 38.90, 77.80, NULL),
(5, 17, 3, 6.00, 18.00, NULL);

-- Pedido 6
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(6, 11, 1, 36.90, 36.90, NULL),
(6, 13, 1, 32.90, 32.90, NULL),
(6, 16, 1, 26.90, 26.90, NULL),
(6, 18, 2, 12.00, 24.00, NULL);

-- Pedido 7
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(7, 3, 1, 28.50, 28.50, NULL),
(7, 9, 1, 46.90, 46.90, NULL),
(7, 14, 1, 24.90, 24.90, NULL),
(7, 21, 2, 18.00, 36.00, NULL),
(7, 19, 1, 4.50, 4.50, NULL);

-- Pedido 8
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(8, 6, 2, 64.90, 129.80, NULL),
(8, 12, 1, 28.90, 28.90, NULL),
(8, 15, 1, 22.90, 22.90, NULL),
(8, 22, 1, 22.00, 22.00, NULL);

-- Pedido 9
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(9, 7, 1, 42.90, 42.90, NULL),
(9, 18, 1, 12.00, 12.00, NULL);

-- Pedido 10
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes) VALUES
(10, 10, 1, 54.90, 54.90, NULL),
(10, 16, 1, 26.90, 26.90, NULL),
(10, 19, 2, 4.50, 9.00, NULL);

-- ============================================
-- Inserção: AVALIACOES
-- ============================================
INSERT INTO avaliacoes (id_pedido, id_cliente, nota, comentario) VALUES
(1, 1, 5, 'Excelente atendimento e comida maravilhosa!'),
(2, 2, 4, 'Muito bom, mas demorou um pouco.'),
(3, 3, 5, 'Perfeito! Voltarei com certeza.'),
(6, 6, 3, 'Comida boa, mas o ambiente estava barulhento.'),
(7, 7, 5, 'Tudo impecável, recomendo!'),
(8, 8, 4, 'Ótima experiência, apenas o preço um pouco alto.'),
(10, 10, 5, 'Adorei! Melhor restaurante da região.');
