-- Criação do DataBase
CREATE DATABASE oficina;
USE oficina;

-- Criação das Tabelas
-- Criação da tabela Cliente
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    telefone VARCHAR(20)
);

-- Criação da tabela Veículo
CREATE TABLE Veiculo (
    placa VARCHAR(10) PRIMARY KEY,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    ano INT NOT NULL,
    cor VARCHAR(30),
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

-- Criação da tabela EquipeMecanicos
CREATE TABLE EquipeMecanicos (
    id_equipe INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    especialidade VARCHAR(50) NOT NULL
);

-- Criação da tabela Serviço
CREATE TABLE Servico (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL
);

-- Criação da tabela Peça
CREATE TABLE Peca (
    id_peca INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(100) NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL
);

-- Criação da tabela OrdemServico
CREATE TABLE OrdemServico (
    numero_os INT PRIMARY KEY AUTO_INCREMENT,
    data_emissao DATE NOT NULL,
    data_entrega DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    id_cliente INT,
    placa_veiculo VARCHAR(10),
    id_equipe INT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
    FOREIGN KEY (placa_veiculo) REFERENCES Veiculo(placa),
    FOREIGN KEY (id_equipe) REFERENCES EquipeMecanicos(id_equipe)
);

-- Criação da tabela OrdemServicoServico
CREATE TABLE OrdemServicoServico (
    numero_os INT,
    id_servico INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (numero_os, id_servico),
    FOREIGN KEY (numero_os) REFERENCES OrdemServico(numero_os),
    FOREIGN KEY (id_servico) REFERENCES Servico(id_servico)
);

-- Criação da tabela OrdemServicoPeca
CREATE TABLE OrdemServicoPeca (
    numero_os INT,
    id_peca INT,
    quantidade INT NOT NULL,
    PRIMARY KEY (numero_os, id_peca),
    FOREIGN KEY (numero_os) REFERENCES OrdemServico(numero_os),
    FOREIGN KEY (id_peca) REFERENCES Peca(id_peca)
);

-- Inserção de Dados

-- Inserir Clientes
INSERT INTO Cliente (nome, endereco, telefone) VALUES ('João Silva', 'Rua A, 123', '123456789');
INSERT INTO Cliente (nome, endereco, telefone) VALUES ('Maria Oliveira', 'Rua B, 456', '987654321');

-- Inserir Veículos
INSERT INTO Veiculo (placa, marca, modelo, ano, cor, id_cliente) VALUES ('ABC1234', 'Fiat', 'Uno', 2020, 'Prata', 1);
INSERT INTO Veiculo (placa, marca, modelo, ano, cor, id_cliente) VALUES ('XYZ5678', 'Ford', 'Fiesta', 2019, 'Preto', 2);

-- Inserir Equipes de Mecânicos
INSERT INTO EquipeMecanicos (nome, endereco, especialidade) VALUES ('Equipe A', 'Rua C, 789', 'Motor');
INSERT INTO EquipeMecanicos (nome, endereco, especialidade) VALUES ('Equipe B', 'Rua D, 101', 'Transmissão');

-- Inserir Serviços
INSERT INTO Servico (descricao, valor_unitario) VALUES ('Troca de Óleo', 100.00);
INSERT INTO Servico (descricao, valor_unitario) VALUES ('Alinhamento', 150.00);

-- Inserir Peças
INSERT INTO Peca (descricao, valor_unitario) VALUES ('Filtro de Óleo', 30.00);
INSERT INTO Peca (descricao, valor_unitario) VALUES ('Correia Dentada', 120.00);

-- Inserir Ordens de Serviço
INSERT INTO OrdemServico (data_emissao, data_entrega, valor_total, status, id_cliente, placa_veiculo, id_equipe) VALUES ('2024-07-01', '2024-07-10', 350.00, 'Aberta', 1, 'ABC1234', 1);

-- Inserir relacionamentos de Serviços e Peças
INSERT INTO OrdemServicoServico (numero_os, id_servico, quantidade) VALUES (1, 1, 1);
INSERT INTO OrdemServicoPeca (numero_os, id_peca, quantidade) VALUES (1, 1, 1);

-- Consultas SQL

-- 1. Recuperações Simples
SELECT * FROM Cliente;
SELECT * FROM OrdemServico;

-- 2. Filtros com WHERE
SELECT * FROM Veiculo WHERE id_cliente = 1;
SELECT * FROM OrdemServico WHERE status = 'Aberta';

-- 3. Atributos Derivados
SELECT numero_os, SUM(s.valor_unitario * oss.quantidade) AS valor_servicos
FROM OrdemServicoServico oss
JOIN Servico s ON oss.id_servico = s.id_servico
GROUP BY numero_os;

-- 4. Ordenações com ORDER BY
SELECT * FROM OrdemServico ORDER BY data_emissao DESC;
SELECT * FROM Cliente ORDER BY nome;

-- 5. Condições de Filtros aos Grupos – HAVING
SELECT descricao, valor_unitario
FROM Servico
GROUP BY descricao, valor_unitario
HAVING valor_unitario > 100.00;

-- 6. Junções Entre Tabelas
-- Detalhes da ordem de serviço com cliente e veículo
SELECT os.numero_os, os.data_emissao, c.nome AS cliente, v.marca, v.modelo
FROM OrdemServico os
JOIN Cliente c ON os.id_cliente = c.id_cliente
JOIN Veiculo v ON os.placa_veiculo = v.placa
WHERE os.numero_os = 1;

-- Serviços e peças para uma ordem de serviço específica
SELECT os.numero_os, s.descricao AS servico, oss.quantidade, p.descricao AS peca, osp.quantidade
FROM OrdemServico os
LEFT JOIN OrdemServicoServico oss ON os.numero_os = oss.numero_os
LEFT JOIN Servico s ON oss.id_servico = s.id_servico
LEFT JOIN OrdemServicoPeca osp ON os.numero_os = osp.numero_os
LEFT JOIN Peca p ON osp.id_peca = p.id_peca
WHERE os.numero_os = 1;
