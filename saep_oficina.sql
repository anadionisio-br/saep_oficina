

CREATE DATABASE IF NOT EXISTS saep_oficina
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE saep_oficina;



SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS agendamentos;
DROP TABLE IF EXISTS veiculos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS usuarios;

SET FOREIGN_KEY_CHECKS = 1;


CREATE TABLE usuarios (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;



CREATE TABLE clientes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    cpf VARCHAR(255) NULL,
    telefone VARCHAR(20) NOT NULL,
    email VARCHAR(150) NULL,
    endereco VARCHAR(255) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;


CREATE TABLE veiculos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT UNSIGNED NOT NULL,
    marca VARCHAR(80) NOT NULL,
    modelo VARCHAR(100) NOT NULL,
    ano YEAR NOT NULL,
    placa VARCHAR(10) NOT NULL UNIQUE,
    cor VARCHAR(50) NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_veiculos_clientes
    FOREIGN KEY (cliente_id)
    REFERENCES clientes(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE agendamentos (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    veiculo_id BIGINT UNSIGNED NOT NULL,
    data_agendamento DATE NOT NULL,
    hora_agendamento TIME NOT NULL,
    servico VARCHAR(150) NOT NULL,
    status ENUM(
        'Pendente',
        'Confirmado',
        'Concluido',
        'Cancelado'
    ) NOT NULL DEFAULT 'Pendente',
    observacoes TEXT NULL,
    created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_agendamentos_veiculos
    FOREIGN KEY (veiculo_id)
    REFERENCES veiculos(id)
    ON UPDATE CASCADE
    ON DELETE RESTRICT,

    INDEX idx_agendamentos_data (data_agendamento)
) ENGINE=InnoDB;



INSERT INTO usuarios (nome, email, password) VALUES
('Administrador', 'admin@oficina.com', 'SUBSTITUIR_POR_HASH_LARAVEL'),
('Carlos Oliveira', 'carlos@oficina.com', 'SUBSTITUIR_POR_HASH_LARAVEL'),
('Mariana Santos', 'mariana@oficina.com', 'SUBSTITUIR_POR_HASH_LARAVEL');



INSERT INTO clientes
(nome, cpf, telefone, email, endereco) VALUES
('Joao da Silva', NULL, '(19) 99999-1111',
 'joao@email.com', 'Rua das Flores, 100'),

('Maria Oliveira', NULL, '(19) 99999-2222',
 'maria@email.com', 'Rua Central, 250'),

('Pedro Santos', NULL, '(19) 99999-3333',
 'pedro@email.com', 'Avenida Brasil, 500');


INSERT INTO veiculos
(cliente_id, marca, modelo, ano, placa, cor) VALUES
(1, 'Chevrolet', 'Onix', 2022, 'ABC1D23', 'Prata'),
(2, 'Volkswagen', 'Gol', 2020, 'DEF4G56', 'Branco'),
(3, 'Fiat', 'Argo', 2023, 'HIJ7K89', 'Preto');



INSERT INTO agendamentos
(veiculo_id, data_agendamento, hora_agendamento,
 servico, status, observacoes) VALUES

(1, '2026-11-20', '08:00:00',
 'Troca de oleo', 'Confirmado',
 'Troca de oleo e verificacao dos filtros'),

(2, '2026-11-21', '09:30:00',
 'Revisao completa', 'Pendente',
 'Verificar freios e suspensao'),

(3, '2026-11-22', '14:00:00',
 'Alinhamento e balanceamento', 'Confirmado',
 'Verificar alinhamento das rodas');



SELECT * FROM usuarios;
SELECT * FROM clientes;
SELECT * FROM veiculos;
SELECT * FROM agendamentos;


SELECT
    a.id AS agendamento,
    a.data_agendamento,
    a.hora_agendamento,
    a.servico,
    a.status,
    c.nome AS cliente,
    c.telefone,
    v.marca,
    v.modelo,
    v.ano,
    v.placa
FROM agendamentos a
INNER JOIN veiculos v
    ON a.veiculo_id = v.id
INNER JOIN clientes c
    ON v.cliente_id = c.id
ORDER BY a.data_agendamento ASC, a.hora_agendamento ASC;
