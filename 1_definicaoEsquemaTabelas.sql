/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
/* Definicao de Esquema: */
DROP SCHEMA IF EXISTS `lanchonete`;
CREATE SCHEMA `lanchonete`;
USE `lanchonete`;

/* Definicao de tabelas */

CREATE TABLE Administradores (
	# Atributos de Usuarios
    cpf BIGINT PRIMARY KEY,
    nomeCompleto VARCHAR(63),
    senha VARCHAR(63),
    salarioMensal FLOAT,
    dataIngresso DATETIME,
    # Restricoes de integridade de Administradores
    fk_Administradores_cpf BIGINT,
    CONSTRAINT CHK_Administradores CHECK (salarioMensal>=0) 
);

CREATE TABLE Gerentes (
	# Atributos de Usuarios
    cpf BIGINT PRIMARY KEY,
    nomeCompleto VARCHAR(63),
    senha VARCHAR(63),
    salarioMensal FLOAT,
    dataIngresso DATETIME,
     # Restricoes de integridade de Gerentes
    fk_Administradores_cpf BIGINT,
    CONSTRAINT FK_Gerentes FOREIGN KEY (fk_Administradores_cpf)
		REFERENCES Administradores (cpf)
		ON DELETE CASCADE,
	CONSTRAINT CHK_Gerentes CHECK (salarioMensal>=0) 
);

CREATE TABLE Funcionarios(
    # Atributos de Usuarios
    cpf BIGINT PRIMARY KEY,
    nomeCompleto VARCHAR(63),
    senha VARCHAR(63),
    salarioMensal FLOAT,
    dataIngresso DATETIME,
    # Restricoes de integridade de Usuarios
    fk_Administradores_cpf BIGINT,
    CONSTRAINT FK_Funcionarios FOREIGN KEY (fk_Administradores_cpf)
        REFERENCES Administradores (cpf)
        ON DELETE CASCADE,
    CONSTRAINT CHK_Funcionarios CHECK (salarioMensal>=0) 
);


CREATE TABLE Atendimentos_Locais (
	# Atributos de Atedimentos
	idAtendimento SMALLINT AUTO_INCREMENT PRIMARY KEY,
    valorTotal FLOAT DEFAULT 0,
    dataAtendimento DATETIME DEFAULT current_timestamp,
    estadoAtendimento VARCHAR (10) DEFAULT "ABERTO",
    # Atributos de Atedimentos Locais
    numeroMesa TINYINT UNSIGNED,
    nomeCliente VARCHAR(63),
    # Restricoes de integridade de Atendimentos Locais
    fk_Funcionarios_cpf BIGINT,
    CONSTRAINT FK_Atendimentos_Locais FOREIGN KEY (fk_Funcionarios_cpf)
		REFERENCES Funcionarios (cpf)
		ON DELETE CASCADE,
	CONSTRAINT CHK_Atendimentos_Locais CHECK (valorTotal >= 0 AND estadoAtendimento IN("ABERTO","ENCERRADO"))
);

CREATE TABLE Atendimentos_Entregas (
	# Atributos de Atendimentos
    idAtendimento SMALLINT AUTO_INCREMENT PRIMARY KEY,
    valorTotal FLOAT DEFAULT 0,
    dataAtendimento DATETIME DEFAULT current_timestamp,
    estadoAtendimento VARCHAR (10) DEFAULT "ABERTO",
    # Atributos de Antedimentos Entregas
    nomeCliente VARCHAR(63),
    ruaEndereco VARCHAR(63),
    bairroEndereco VARCHAR(63),
    complementoEndereco VARCHAR(63),
    telefoneCliente BIGINT UNSIGNED,
    formaPagamento VARCHAR(63),
    trocoPagamento FLOAT DEFAULT 0,
    numeroEndereco SMALLINT UNSIGNED,
    # Restricoes de integridade de atedimento entrega
    fk_Funcionarios_cpf BIGINT,
    CONSTRAINT FK_Atendimentos_Entregas FOREIGN KEY (fk_Funcionarios_cpf)
		REFERENCES Funcionarios (cpf)
		ON DELETE CASCADE,
	CONSTRAINT CHK_Atendimentos_Entregas CHECK (valorTotal >= 0 AND trocoPagamento >=0 AND estadoAtendimento IN("ABERTO","ENCERRADO"))
);

CREATE TABLE Ingredientes (
	# Atributos de Mercadorias
	idMercadoria MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    dcrMercadoria VARCHAR(63),
    quantEstoque FLOAT DEFAULT 0,
    percentVenda FLOAT,	# Utilizado como multiplicador decimal - 1 = 100% de lucro sobre o produto - utilizei unsigned para evitar problemas. 
    precoCustoUnitario FLOAT,
    # Atributos de Ingredientes
    dcrIngrediente VARCHAR(63),
    precoVenda FLOAT GENERATED ALWAYS AS ((percentVenda + 1) * precoCustoUnitario), # Coluna calculada - evita calculos na mao
    quantMercadoria FLOAT,
    # Restricoes de integridade de ingredientes
    CONSTRAINT CHK_Ingredientes CHECK (quantEstoque >=0 AND percentVenda >= 0 AND precoCustoUnitario >= 0 AND quantMercadoria >= 0)
);

CREATE TABLE Mercadorias_Prontas (
	# Atributos de Mercadorias
    idMercadoria MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    dcrMercadoria VARCHAR(63),
    percentVenda FLOAT,
    precoCustoUnitario FLOAT,
    quantEstoque FLOAT DEFAULT 0,
    # Atributos de Mercadorias Prontas
    dcrMercadoriaPronta VARCHAR(63),
    precoVenda FLOAT GENERATED ALWAYS AS ((percentVenda + 1) * precoCustoUnitario),
    quantConsumo TINYINT UNSIGNED,
    # Restricoes de integridade de Mercadorias Prontas
    CONSTRAINT CHK_Mercadorias_Prontas CHECK (quantEstoque >=0 AND percentVenda >= 0 AND precoCustoUnitario >= 0)
);

CREATE TABLE Registros_Mercadorias (
	# Atributos de Registros Mercadorias
    quantRegistro INT UNSIGNED,
    dataEntrada DATETIME DEFAULT NOW(), # Valor default para que seja possivel realizar entrada sem informar a data de hoje
    dataVencimento DATE,
    # Restricoes de integridade de Mercadorias Prontas
    fk_Gerentes_cpf BIGINT,
    CONSTRAINT FK_Registros_Mercadorias_1 FOREIGN KEY (fk_Gerentes_cpf)
		REFERENCES Gerentes (cpf),
    fk_Mercadorias_Prontas_idMercadoria MEDIUMINT,
    CONSTRAINT FK_Registros_Mercadorias_2 FOREIGN KEY (fk_Mercadorias_Prontas_idMercadoria)
		REFERENCES Mercadorias_Prontas (idMercadoria),
    fk_Ingredientes_idMercadoria MEDIUMINT,
	CONSTRAINT FK_Registros_Mercadorias_3 FOREIGN KEY (fk_Ingredientes_idMercadoria)
		REFERENCES Ingredientes (idMercadoria)
);


CREATE TABLE Lanches (
	# Atributos de Lanches
    idLanche MEDIUMINT AUTO_INCREMENT PRIMARY KEY,
    dcrLanche VARCHAR(63),
    precoLanche FLOAT DEFAULT 0,
    horaSolicitado TIME,
    # Restricoes de integridade de Lanches
    fk_Atendimentos_Locais_idAtendimento SMALLINT,
    CONSTRAINT FK_Lanches_1 FOREIGN KEY (fk_Atendimentos_Locais_idAtendimento)
		REFERENCES Atendimentos_Locais (idAtendimento)
		ON DELETE CASCADE,
    fk_Atendimentos_Entregas_idAtendimento SMALLINT,
	CONSTRAINT FK_Lanches_2 FOREIGN KEY (fk_Atendimentos_Entregas_idAtendimento)
		REFERENCES Atendimentos_Entregas (idAtendimento)
		ON DELETE CASCADE,
	CONSTRAINT CHK_Lanches CHECK (precoLanche >=0)
);

CREATE TABLE Uso_Ingredientes_Em_Lanches (
    # Atributos de Uso Ingredientes em Lanches
    quantIngrediente FLOAT,
    # Restricoes de integridade de Uso Ingredientes em Lanches
    fk_Ingredientes_idMercadoria MEDIUMINT,
    CONSTRAINT FK_Uso_Ingredientes_Em_Lanches_1 FOREIGN KEY (fk_Ingredientes_idMercadoria)
        REFERENCES Ingredientes (idMercadoria),
    fk_Lanches_idLanche MEDIUMINT,
    CONSTRAINT FK_Uso_Ingredientes_Em_Lanches_2 FOREIGN KEY (fk_Lanches_idLanche)
        REFERENCES Lanches (idLanche),
    CONSTRAINT CHK_Uso_Ingredientes_Em_Lanches CHECK (quantIngrediente >= 0)    
);

CREATE TABLE Consumo_Mercadorias_Prontas (
	# Atributos de Consumo de Mercados Prontas
    quantMercConsumo TINYINT,
    horaSolicitado TIME,
    # Restricoes de integridade de Consumo de Mercadorias Prontas
    fk_Mercadorias_Prontas_idMercadoria MEDIUMINT,
	CONSTRAINT FK_Consumo_Mercadorias_Prontas_1 FOREIGN KEY (fk_Mercadorias_Prontas_idMercadoria)
		REFERENCES Mercadorias_Prontas(idMercadoria),
    fk_Atendimentos_Locais_idAtendimento SMALLINT,
    CONSTRAINT FK_Consumo_Mercadorias_Prontas_2 FOREIGN KEY (fk_Atendimentos_Locais_idAtendimento)
		REFERENCES Atendimentos_Locais(idAtendimento),
    fk_Atendimentos_Entregas_idAtendimento SMALLINT,
	CONSTRAINT FK_Consumo_Mercadorias_Prontas_3 FOREIGN KEY (fk_Atendimentos_Entregas_idAtendimento)
		REFERENCES Atendimentos_Entregas(idAtendimento)
);

CREATE TABLE Caixas (
    idCaixa BIGINT PRIMARY KEY,
    saldoTotal FLOAT DEFAULT 0
);

CREATE TABLE Pagamentos_Atendimentos_Caixas (
	# Atributos de Pagamentos Atendimentos Caixas
    dcrDeposito VARCHAR(63),
    tipoDeposito VARCHAR(63),
    valorDeposito FLOAT,
    horaDeposito TIME,
    # Restricoes de integridade de Pagamentos Atendimentos Caixas
    fk_Atendimentos_Locais_idAtendimento SMALLINT,
    CONSTRAINT FK_Pagamentos_Atendimentos_Caixas_1 FOREIGN KEY (fk_Atendimentos_Locais_idAtendimento)
		REFERENCES Atendimentos_Locais (idAtendimento),
    fk_Atendimentos_Entregas_idAtendimento SMALLINT,
    CONSTRAINT FK_Pagamentos_Atendimentos_Caixas_2 FOREIGN KEY (fk_Atendimentos_Entregas_idAtendimento)
		REFERENCES Atendimentos_Entregas (idAtendimento),
    fk_Caixas_idCaixa BIGINT,
    CONSTRAINT FK_Pagamentos_Atendimentos_Caixas_3 FOREIGN KEY (fk_Caixas_idCaixa)
		REFERENCES Caixas (idCaixa),
	CONSTRAINT CHK_Pagamentos_Atendimentos_Caixas CHECK (valorDeposito >= 0)    
);

CREATE TABLE Debitos_Gerentes_Caixas (
	# Atributos de Debitos Gerentes Caixas
	dcrDebito VARCHAR(63),
    tipoDebito VARCHAR(63),
    horaDebito TIME,
    valorDebito FLOAT,
    # Restricoes de integridade de Debto Gerentes Caixas
    fk_Gerentes_cpf BIGINT,
    CONSTRAINT FK_Debitos_Gerentes_Caixas_1 FOREIGN KEY (fk_Gerentes_cpf)
		REFERENCES Gerentes (cpf),
    fk_Caixas_idCaixa BIGINT,
	CONSTRAINT FK_Debitos_Gerentes_Caixas_2 FOREIGN KEY (fk_Caixas_idCaixa)
		REFERENCES Caixas (idCaixa),
	CONSTRAINT CHK_Debitos_Gerentes_Caixas CHECK (valorDebito >= 0)   
);
