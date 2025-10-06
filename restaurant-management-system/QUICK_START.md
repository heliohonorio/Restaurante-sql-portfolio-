# Guia Rápido de Uso

Este documento fornece instruções rápidas para começar a usar o banco de dados do Sistema de Gerenciamento de Restaurante.

## Instalação Rápida

```bash
# 1. Conecte-se ao MySQL
mysql -u root -p

# 2. Execute os scripts na ordem
SOURCE /caminho/para/sql/01_create_database.sql;
SOURCE /caminho/para/sql/02_insert_data.sql;
SOURCE /caminho/para/sql/03_triggers_procedures.sql;
SOURCE /caminho/para/sql/04_views_queries.sql;
SOURCE /caminho/para/sql/05_indexes.sql;

# 3. Verifique a instalação
USE restaurante_db;
SHOW TABLES;
```

## Comandos Úteis

### Consultar Pedidos Completos

```sql
SELECT * FROM vw_pedidos_completos WHERE status = 'finalizado';
```

### Ver Produtos Mais Vendidos

```sql
CALL produtos_mais_vendidos(10);
```

### Adicionar Item a um Pedido

```sql
CALL adicionar_item_pedido(4, 7, 2, 'Sem cebola');
```

### Finalizar um Pedido

```sql
CALL finalizar_pedido(4, 'cartao_credito');
```

### Relatório de Vendas por Período

```sql
CALL relatorio_vendas_periodo('2025-10-01', '2025-10-31');
```

### Ver Desempenho dos Garçons

```sql
CALL desempenho_funcionarios(10, 2025);
```

## Consultas Analíticas Prontas

Todas as consultas analíticas estão disponíveis no arquivo `sql/04_views_queries.sql`. Você pode executá-las diretamente ou adaptá-las conforme sua necessidade.

### Exemplos de Análises Disponíveis:

- Top 5 clientes mais valiosos
- Produtos por categoria com performance
- Análise de horários de pico
- Comparativo de formas de pagamento
- Produtos que nunca foram vendidos
- Ranking de garçons por avaliação
- Análise de ocupação de mesas
- Produtos mais pedidos juntos (Market Basket)
- Relatório financeiro mensal completo

## Estrutura de Dados

Para entender melhor a estrutura do banco, consulte:

- **Diagrama Visual:** `diagrams/database_diagram.png`
- **Documentação Técnica:** `docs/database_design.md`
- **README Principal:** `README.md`

## Dicas de Performance

- Os índices já estão otimizados para as consultas mais comuns
- Use as views criadas para simplificar consultas complexas
- Execute `ANALYZE TABLE` periodicamente para manter as estatísticas atualizadas
- Utilize `EXPLAIN` antes de consultas complexas para verificar o uso de índices

## Suporte

Para dúvidas, sugestões ou contribuições, consulte o arquivo `CONTRIBUTING.md` ou abra uma issue no repositório do GitHub.
