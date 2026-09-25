-- ============================================================
-- BANCO DE DADOS - API DE VENDAS
-- Node.js + MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS api_vendas
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE api_vendas;


-- ============================================================
-- 1. CLIENTE
-- ============================================================

CREATE TABLE cliente (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    telefone VARCHAR(20),

    tipo_cliente ENUM('PF', 'PJ') NOT NULL,

    cpf VARCHAR(11) NULL,
    cnpj VARCHAR(14) NULL,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_cliente_email
        UNIQUE (email),

    CONSTRAINT uq_cliente_cpf
        UNIQUE (cpf),

    CONSTRAINT uq_cliente_cnpj
        UNIQUE (cnpj),

    CONSTRAINT chk_cliente_documento
        CHECK (
            (tipo_cliente = 'PF' AND cpf IS NOT NULL AND cnpj IS NULL)
            OR
            (tipo_cliente = 'PJ' AND cnpj IS NOT NULL AND cpf IS NULL)
        )
);


-- ============================================================
-- 2. STATUS
-- ============================================================

CREATE TABLE status (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(50) NOT NULL,

    CONSTRAINT uq_status_nome
        UNIQUE (nome)
);


-- ============================================================
-- 3. REGRA OFERTA
-- ============================================================

CREATE TABLE regra_oferta (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    tipo VARCHAR(30) NOT NULL,

    valor DECIMAL(10,2) NOT NULL,

    valor_minimo DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT chk_regra_oferta_valor
        CHECK (valor >= 0),

    CONSTRAINT chk_regra_oferta_valor_minimo
        CHECK (valor_minimo >= 0)
);


-- ============================================================
-- 4. PRODUTO
-- ============================================================

CREATE TABLE produto (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    nome VARCHAR(150) NOT NULL,

    unidade_medida VARCHAR(30) NOT NULL,

    preco_atual DECIMAL(10,2) NOT NULL,

    CONSTRAINT chk_produto_preco
        CHECK (preco_atual >= 0)
);


-- ============================================================
-- 5. PEDIDO
-- ============================================================

CREATE TABLE pedido (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    cliente_id BIGINT UNSIGNED NOT NULL,

    status_id BIGINT UNSIGNED NOT NULL,

    regra_oferta_id BIGINT UNSIGNED NULL,

    valor_total DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,


    -- ==========================
    -- CHAVES ESTRANGEIRAS
    -- ==========================

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (cliente_id)
        REFERENCES cliente(id),

    CONSTRAINT fk_pedido_status
        FOREIGN KEY (status_id)
        REFERENCES status(id),

    CONSTRAINT fk_pedido_regra_oferta
        FOREIGN KEY (regra_oferta_id)
        REFERENCES regra_oferta(id)
        ON DELETE SET NULL,


    -- ==========================
    -- VALIDAÇÕES
    -- ==========================

    CONSTRAINT chk_pedido_valor_total
        CHECK (valor_total >= 0),


    -- ==========================
    -- ÍNDICES
    -- ==========================

    INDEX idx_pedido_cliente (cliente_id),

    INDEX idx_pedido_status (status_id),

    INDEX idx_pedido_regra_oferta (regra_oferta_id)
);


-- ============================================================
-- 6. ESTOQUE
-- ============================================================

CREATE TABLE estoque (
    produto_id BIGINT UNSIGNED PRIMARY KEY,

    quantidade_atual DECIMAL(12,3) NOT NULL DEFAULT 0.000,

    atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,


    CONSTRAINT fk_estoque_produto
        FOREIGN KEY (produto_id)
        REFERENCES produto(id)
        ON DELETE CASCADE,


    CONSTRAINT chk_estoque_quantidade
        CHECK (quantidade_atual >= 0)
);


-- ============================================================
-- 7. HISTÓRICO DE STATUS
-- ============================================================

CREATE TABLE historico_status (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    pedido_id BIGINT UNSIGNED NOT NULL,

    status_id BIGINT UNSIGNED NOT NULL,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT fk_historico_status_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedido(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_historico_status_status
        FOREIGN KEY (status_id)
        REFERENCES status(id),


    INDEX idx_historico_status_pedido (pedido_id),

    INDEX idx_historico_status_status (status_id)
);


-- ============================================================
-- 8. VENDA
-- ============================================================

CREATE TABLE venda (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    pedido_id BIGINT UNSIGNED NOT NULL,

    produto_id BIGINT UNSIGNED NOT NULL,

    quantidade DECIMAL(12,3) NOT NULL,

    preco_unitario DECIMAL(10,2) NOT NULL,


    CONSTRAINT fk_venda_pedido
        FOREIGN KEY (pedido_id)
        REFERENCES pedido(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_venda_produto
        FOREIGN KEY (produto_id)
        REFERENCES produto(id),


    CONSTRAINT chk_venda_quantidade
        CHECK (quantidade > 0),

    CONSTRAINT chk_venda_preco
        CHECK (preco_unitario >= 0),


    INDEX idx_venda_pedido (pedido_id),

    INDEX idx_venda_produto (produto_id)
);


-- ============================================================
-- 9. MOVIMENTAÇÃO DE ESTOQUE
-- ============================================================

CREATE TABLE movimentacao_estoque (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

    produto_id BIGINT UNSIGNED NOT NULL,

    venda_id BIGINT UNSIGNED NULL,

    tipo ENUM(
        'ENTRADA',
        'SAIDA',
        'AJUSTE'
    ) NOT NULL,

    quantidade DECIMAL(12,3) NOT NULL,

    criado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,


    CONSTRAINT fk_movimentacao_produto
        FOREIGN KEY (produto_id)
        REFERENCES produto(id),

    CONSTRAINT fk_movimentacao_venda
        FOREIGN KEY (venda_id)
        REFERENCES venda(id)
        ON DELETE SET NULL,


    CONSTRAINT chk_movimentacao_quantidade
        CHECK (quantidade > 0),


    INDEX idx_movimentacao_produto (produto_id),

    INDEX idx_movimentacao_venda (venda_id)
);