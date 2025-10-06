# Design do Banco de Dados - Sistema de Gerenciamento de Restaurante

## Entidades Principais

### 1. CLIENTES
- **id_cliente** (PK)
- nome
- telefone
- email
- data_cadastro

### 2. MESAS
- **id_mesa** (PK)
- numero_mesa
- capacidade
- status (disponível, ocupada, reservada)

### 3. FUNCIONARIOS
- **id_funcionario** (PK)
- nome
- cargo (garçom, cozinheiro, gerente, caixa)
- telefone
- salario
- data_contratacao

### 4. CATEGORIAS
- **id_categoria** (PK)
- nome_categoria
- descricao

### 5. PRODUTOS
- **id_produto** (PK)
- id_categoria (FK)
- nome_produto
- descricao
- preco
- disponivel

### 6. PEDIDOS
- **id_pedido** (PK)
- id_cliente (FK)
- id_mesa (FK)
- id_funcionario (FK - garçom responsável)
- data_hora
- status (aberto, em_preparo, finalizado, cancelado)
- valor_total
- forma_pagamento

### 7. ITENS_PEDIDO
- **id_item** (PK)
- id_pedido (FK)
- id_produto (FK)
- quantidade
- preco_unitario
- subtotal
- observacoes

### 8. AVALIACOES
- **id_avaliacao** (PK)
- id_pedido (FK)
- id_cliente (FK)
- nota (1-5)
- comentario
- data_avaliacao

## Relacionamentos

- **CLIENTES → PEDIDOS**: 1:N (um cliente pode fazer vários pedidos)
- **MESAS → PEDIDOS**: 1:N (uma mesa pode ter vários pedidos ao longo do tempo)
- **FUNCIONARIOS → PEDIDOS**: 1:N (um funcionário atende vários pedidos)
- **PEDIDOS → ITENS_PEDIDO**: 1:N (um pedido contém vários itens)
- **PRODUTOS → ITENS_PEDIDO**: 1:N (um produto pode estar em vários itens de pedido)
- **CATEGORIAS → PRODUTOS**: 1:N (uma categoria agrupa vários produtos)
- **PEDIDOS → AVALIACOES**: 1:1 (um pedido pode ter uma avaliação)

## Normalização

O banco está na **3ª Forma Normal (3FN)**:
- **1FN**: Todos os atributos são atômicos
- **2FN**: Não há dependências parciais (todas as chaves primárias são simples)
- **3FN**: Não há dependências transitivas (atributos dependem apenas da chave primária)

## Índices Planejados

- Índice em `pedidos.data_hora` para consultas por período
- Índice em `produtos.id_categoria` para filtros por categoria
- Índice em `clientes.email` para buscas rápidas
- Índice em `funcionarios.cargo` para relatórios por função
