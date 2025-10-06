-- ============================================
-- Sistema de Gerenciamento de Restaurante
-- Triggers e Stored Procedures
-- ============================================

USE restaurante_db;

-- ============================================
-- TRIGGER: Atualizar valor total do pedido
-- ============================================
DELIMITER $$

CREATE TRIGGER atualizar_valor_pedido_insert
AFTER INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT SUM(subtotal)
        FROM itens_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

CREATE TRIGGER atualizar_valor_pedido_update
AFTER UPDATE ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT SUM(subtotal)
        FROM itens_pedido
        WHERE id_pedido = NEW.id_pedido
    )
    WHERE id_pedido = NEW.id_pedido;
END$$

CREATE TRIGGER atualizar_valor_pedido_delete
AFTER DELETE ON itens_pedido
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT COALESCE(SUM(subtotal), 0)
        FROM itens_pedido
        WHERE id_pedido = OLD.id_pedido
    )
    WHERE id_pedido = OLD.id_pedido;
END$$

-- ============================================
-- TRIGGER: Atualizar status da mesa
-- ============================================
CREATE TRIGGER atualizar_status_mesa_pedido
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.status = 'finalizado' OR NEW.status = 'cancelado' THEN
        UPDATE mesas
        SET status = 'disponivel'
        WHERE id_mesa = NEW.id_mesa
        AND NOT EXISTS (
            SELECT 1 FROM pedidos
            WHERE id_mesa = NEW.id_mesa
            AND status IN ('aberto', 'em_preparo')
            AND id_pedido != NEW.id_pedido
        );
    ELSEIF NEW.status = 'aberto' OR NEW.status = 'em_preparo' THEN
        UPDATE mesas
        SET status = 'ocupada'
        WHERE id_mesa = NEW.id_mesa;
    END IF;
END$$

-- ============================================
-- TRIGGER: Validar disponibilidade do produto
-- ============================================
CREATE TRIGGER validar_produto_disponivel
BEFORE INSERT ON itens_pedido
FOR EACH ROW
BEGIN
    DECLARE produto_disponivel BOOLEAN;
    
    SELECT disponivel INTO produto_disponivel
    FROM produtos
    WHERE id_produto = NEW.id_produto;
    
    IF NOT produto_disponivel THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não disponível para pedido';
    END IF;
END$$

-- ============================================
-- PROCEDURE: Finalizar pedido
-- ============================================
CREATE PROCEDURE finalizar_pedido(
    IN p_id_pedido INT,
    IN p_forma_pagamento ENUM('dinheiro', 'cartao_credito', 'cartao_debito', 'pix')
)
BEGIN
    DECLARE v_status VARCHAR(20);
    
    -- Verificar se o pedido existe e está em preparo
    SELECT status INTO v_status
    FROM pedidos
    WHERE id_pedido = p_id_pedido;
    
    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pedido não encontrado';
    END IF;
    
    IF v_status = 'finalizado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pedido já foi finalizado';
    END IF;
    
    IF v_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pedido foi cancelado';
    END IF;
    
    -- Finalizar o pedido
    UPDATE pedidos
    SET status = 'finalizado',
        forma_pagamento = p_forma_pagamento
    WHERE id_pedido = p_id_pedido;
    
    SELECT 'Pedido finalizado com sucesso!' AS mensagem;
END$$

-- ============================================
-- PROCEDURE: Cancelar pedido
-- ============================================
CREATE PROCEDURE cancelar_pedido(IN p_id_pedido INT)
BEGIN
    DECLARE v_status VARCHAR(20);
    
    SELECT status INTO v_status
    FROM pedidos
    WHERE id_pedido = p_id_pedido;
    
    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pedido não encontrado';
    END IF;
    
    IF v_status = 'finalizado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível cancelar um pedido finalizado';
    END IF;
    
    UPDATE pedidos
    SET status = 'cancelado'
    WHERE id_pedido = p_id_pedido;
    
    SELECT 'Pedido cancelado com sucesso!' AS mensagem;
END$$

-- ============================================
-- PROCEDURE: Adicionar item ao pedido
-- ============================================
CREATE PROCEDURE adicionar_item_pedido(
    IN p_id_pedido INT,
    IN p_id_produto INT,
    IN p_quantidade INT,
    IN p_observacoes TEXT
)
BEGIN
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_subtotal DECIMAL(10,2);
    DECLARE v_status VARCHAR(20);
    
    -- Verificar status do pedido
    SELECT status INTO v_status
    FROM pedidos
    WHERE id_pedido = p_id_pedido;
    
    IF v_status NOT IN ('aberto', 'em_preparo') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível adicionar itens a este pedido';
    END IF;
    
    -- Obter preço do produto
    SELECT preco INTO v_preco
    FROM produtos
    WHERE id_produto = p_id_produto;
    
    SET v_subtotal = v_preco * p_quantidade;
    
    -- Inserir item
    INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal, observacoes)
    VALUES (p_id_pedido, p_id_produto, p_quantidade, v_preco, v_subtotal, p_observacoes);
    
    SELECT 'Item adicionado com sucesso!' AS mensagem;
END$$

-- ============================================
-- PROCEDURE: Relatório de vendas por período
-- ============================================
CREATE PROCEDURE relatorio_vendas_periodo(
    IN p_data_inicio DATE,
    IN p_data_fim DATE
)
BEGIN
    SELECT 
        DATE(data_hora) AS data,
        COUNT(id_pedido) AS total_pedidos,
        SUM(valor_total) AS faturamento_total,
        AVG(valor_total) AS ticket_medio,
        MIN(valor_total) AS menor_pedido,
        MAX(valor_total) AS maior_pedido
    FROM pedidos
    WHERE status = 'finalizado'
    AND DATE(data_hora) BETWEEN p_data_inicio AND p_data_fim
    GROUP BY DATE(data_hora)
    ORDER BY data;
END$$

-- ============================================
-- PROCEDURE: Produtos mais vendidos
-- ============================================
CREATE PROCEDURE produtos_mais_vendidos(IN p_limite INT)
BEGIN
    SELECT 
        p.id_produto,
        p.nome_produto,
        c.nome_categoria,
        SUM(ip.quantidade) AS quantidade_vendida,
        SUM(ip.subtotal) AS receita_total,
        COUNT(DISTINCT ip.id_pedido) AS numero_pedidos
    FROM itens_pedido ip
    INNER JOIN produtos p ON ip.id_produto = p.id_produto
    INNER JOIN categorias c ON p.id_categoria = c.id_categoria
    INNER JOIN pedidos ped ON ip.id_pedido = ped.id_pedido
    WHERE ped.status = 'finalizado'
    GROUP BY p.id_produto, p.nome_produto, c.nome_categoria
    ORDER BY quantidade_vendida DESC
    LIMIT p_limite;
END$$

-- ============================================
-- PROCEDURE: Desempenho de funcionários
-- ============================================
CREATE PROCEDURE desempenho_funcionarios(IN p_mes INT, IN p_ano INT)
BEGIN
    SELECT 
        f.id_funcionario,
        f.nome,
        f.cargo,
        COUNT(p.id_pedido) AS total_atendimentos,
        SUM(p.valor_total) AS valor_total_vendido,
        AVG(p.valor_total) AS ticket_medio,
        AVG(COALESCE(a.nota, 0)) AS avaliacao_media
    FROM funcionarios f
    LEFT JOIN pedidos p ON f.id_funcionario = p.id_funcionario
        AND MONTH(p.data_hora) = p_mes
        AND YEAR(p.data_hora) = p_ano
        AND p.status = 'finalizado'
    LEFT JOIN avaliacoes a ON p.id_pedido = a.id_pedido
    WHERE f.cargo = 'garcom'
    GROUP BY f.id_funcionario, f.nome, f.cargo
    ORDER BY valor_total_vendido DESC;
END$$

DELIMITER ;

-- ============================================
-- Executar triggers para atualizar pedidos existentes
-- ============================================
UPDATE pedidos SET valor_total = (
    SELECT SUM(subtotal)
    FROM itens_pedido
    WHERE itens_pedido.id_pedido = pedidos.id_pedido
)
WHERE id_pedido IN (SELECT DISTINCT id_pedido FROM itens_pedido);
