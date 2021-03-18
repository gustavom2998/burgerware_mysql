/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
USE `lanchonete`;

/* ----------------------------------------------------- STORED PROCEDURES ----------------------------------------------------- */
/* Procedure para registrar Ingredientes: Garante que nao vai ser inserido um ingrediente com quantidade inicial */
DELIMITER $$
DROP PROCEDURE IF EXISTS `pcd_Registrar_Ingredientes` $$
CREATE PROCEDURE `pcd_Registrar_Ingredientes`(IN _dcrMercadoria VARCHAR(63),IN _percentVenda FLOAT,IN _precoCustoUnitario FLOAT,IN _dcrIngrediente VARCHAR(63), IN _quantMercadoria FLOAT)
BEGIN
insert into Ingredientes(dcrMercadoria,percentVenda,precoCustoUnitario,dcrIngrediente,quantMercadoria) values
(_dcrMercadoria,_percentVenda,_precoCustoUnitario,_dcrIngrediente,_quantMercadoria);
END $$

/* Procedure para registrar entrada de ingredientes (movimentos) */
DROP PROCEDURE IF EXISTS `pcd_Entrada_Ingredientes` $$
CREATE PROCEDURE `pcd_Entrada_Ingredientes`(IN _quantRegistro INT UNSIGNED,IN _dataVencimento FLOAT,IN _Gerentes_cpf BIGINT ,IN _idIngrediente MEDIUMINT)
BEGIN
insert into Registros_Mercadorias(quantRegistro,dataEntrada,dataVencimento,fk_Gerentes_cpf,fk_Ingredientes_idMercadoria) values
(_quantRegistro,current_timestamp(),_dataVencimento, _Gerentes_cpf,_idIngrediente);
END $$

/* Procedure para registrar Mercadorias Prontas */
DROP PROCEDURE IF EXISTS `pcd_Registrar_Mercadorias_Prontas` $$
CREATE PROCEDURE `pcd_Registrar_Mercadorias_Prontas`(IN _dcrMercadoria VARCHAR(63),IN _percentVenda FLOAT,IN _precoCustoUnitario FLOAT,IN _dcrMercadoriaPronta VARCHAR(63), IN _quantConsumo FLOAT)
BEGIN
insert into Mercadorias_Prontas(dcrMercadoria,percentVenda,precoCustoUnitario,dcrMercadoriaPronta,quantConsumo) values
(_dcrMercadoria,_percentVenda,_precoCustoUnitario,_dcrMercadoriaPronta,_quantConsumo);
END $$

/* Procedure para registrar entrada de Mercadorias Prontas (movimentos) */
DROP PROCEDURE IF EXISTS `pcd_Entrada_Mercadorias_Prontas` $$
CREATE PROCEDURE `pcd_Entrada_Mercadorias_Prontas`(IN _quantRegistro INT UNSIGNED,IN _dataVencimento FLOAT,IN _Gerentes_cpf BIGINT ,IN _idMercadoriaPronta MEDIUMINT)
BEGIN
insert into Registros_Mercadorias(quantRegistro,dataEntrada,dataVencimento,fk_Gerentes_cpf,fk_Mercadorias_Prontas_idMercadoria) values
(_quantRegistro,current_timestamp(),_dataVencimento, _Gerentes_cpf,_idMercadoriaPronta);
END $$


/* Procedures para abrir pedidos de lanches - Registra os lanches vazios */
DROP PROCEDURE IF EXISTS `pcd_Registrar_Lanches` $$
CREATE PROCEDURE `pcd_Registrar_Lanches`(IN fk_Atendimentos_Locais SMALLINT,IN fk_Atendimentos_Entregas SMALLINT)
BEGIN
IF (isnull(fk_Atendimentos_Entregas) AND NOT isnull(fk_Atendimentos_Locais)) THEN
	INSERT INTO Lanches(dcrLanche,horaSolicitado ,fk_Atendimentos_Locais_idAtendimento) 
			SELECT CONCAT("LANCHE CUSTOMIZADO LOCAL: Mesa ", Atendimentos_Locais.numeroMesa),now(),fk_Atendimentos_Locais
			FROM Atendimentos_Locais
			WHERE Atendimentos_Locais.idAtendimento = fk_Atendimentos_Locais;
ELSEIF (isnull(fk_Atendimentos_Locais) AND NOT isnull(fk_Atendimentos_Entregas)) THEN
	INSERT INTO Lanches(dcrLanche,horaSolicitado,fk_Atendimentos_Entregas_idAtendimento) 
			SELECT CONCAT("LANCHE CUSTOMIZADO ENTREGA: ", Atendimentos_Entregas.nomeCliente),now(),fk_Atendimentos_Entregas
			FROM Atendimentos_Entregas
			WHERE Atendimentos_Entregas.idAtendimento = fk_Atendimentos_Entregas;
END IF;
END $$

/* Procedure para encerrar atendimentos - vai tambem realizar entrada no caixa */
DROP PROCEDURE IF EXISTS `pcd_Encerrar_Atendimentos` $$
CREATE PROCEDURE `pcd_Encerrar_Atendimentos`(IN _idAtendimento INT, IN _troco FLOAT, IN _idCaixa BIGINT)
BEGIN
	IF (isnull(_troco)) THEN
		/* Atualiza o estado do atendimento local */
		UPDATE Atendimentos_Locais
		SET estadoAtendimento = "ENCERRADO"
		WHERE Atendimentos_Locais.idAtendimento =_idAtendimento;
       
        /* Cria entrada no caixa com valor do atendimento local */ 
        INSERT INTO Pagamentos_Atendimentos_Caixas(dcrDeposito,tipoDeposito,valorDeposito,horaDeposito,fk_Atendimentos_Locais_idAtendimento,fk_Atendimentos_Entregas_idAtendimento,fk_Caixas_idCaixa)
		SELECT CONCAT("ENCERRAMENTO ATENDIMENTO LOCAL: ", Atendimentos_Locais.nomeCliente),"Dinheiro",Atendimentos_Locais.valorTotal,now(),_idAtendimento,NULL, _idCaixa
		FROM Atendimentos_Locais
		WHERE Atendimentos_Locais.idAtendimento = _idAtendimento;

    ELSE
		/* Atualiza o estado do atendimento entrega */
		UPDATE Atendimentos_Entregas
		SET estadoAtendimento = "ENCERRADO", trocoPagamento = _troco
		WHERE Atendimentos_Entregas.idAtendimento =_idAtendimento;
        
        /* Cria entrada no caixa com valor do atendimento de entrega */ 
        INSERT INTO Pagamentos_Atendimentos_Caixas(dcrDeposito,tipoDeposito,valorDeposito,horaDeposito,fk_Atendimentos_Entregas_idAtendimento,fk_Caixas_idCaixa)
		SELECT CONCAT("ENCERRAMENTO ATENDIMENTO ENTREGA: ", Atendimentos_Entregas.nomeCliente),"Dinheiro",Atendimentos_Entregas.valorTotal,now(),_idAtendimento, _idCaixa
		FROM Atendimentos_Entregas
		WHERE Atendimentos_Entregas.idAtendimento = _idAtendimento;
    END IF;
    
    
END $$

/* Stored Procedure que permite visualizar os pedidos de um determinado atendimento - Tipo Atendimento 0 - eh Local, 1 - eh Entrega  */
DROP PROCEDURE IF EXISTS `pcd_Consultar_Pedidos_Atedimentos` $$
CREATE PROCEDURE `pcd_Consultar_Pedidos_Atedimentos`(IN _idAtendimento INT, IN _tipoAtendimento INT)
BEGIN
	IF (_tipoAtendimento = 0) THEN
		SELECT dcrMercadoriaPronta as "Produto","-" as "Descricacao", quantMercConsumo as "Quantidade",FORMAT(precoVenda * quantConsumo,2) as "Valor_Unitario", FORMAT(precoVenda * quantConsumo * quantMercConsumo,2) as "Valor_Total",horaSolicitado as "Hora pedido"
		FROM ((Consumo_Mercadorias_Prontas
        INNER JOIN Mercadorias_Prontas ON Consumo_Mercadorias_Prontas.fk_Mercadorias_Prontas_idMercadoria = Mercadorias_Prontas.idMercadoria)
        INNER JOIN Atendimentos_Locais ON Consumo_Mercadorias_Prontas.fk_Atendimentos_Locais_idAtendimento = Atendimentos_Locais.idAtendimento)
        WHERE Consumo_Mercadorias_Prontas.fk_Atendimentos_Locais_idAtendimento = _idAtendimento
        UNION ALL
        SELECT dcrLanche as "Produto",dcrIngrediente as "Descricacao", quantIngrediente as "Quantidade",FORMAT(precoVenda * quantMercadoria,2) as "Valor_Unitario", FORMAT(precoVenda * quantMercadoria * quantIngrediente,2) as "Valor_Total",horaSolicitado as "Hora pedido"
		FROM ((Uso_Ingredientes_Em_Lanches
        INNER JOIN Ingredientes ON Uso_Ingredientes_Em_Lanches.fk_Ingredientes_idMercadoria = Ingredientes.idMercadoria)
        INNER JOIN Lanches ON Uso_Ingredientes_Em_Lanches.fk_Lanches_idLanche = Lanches.idLanche)
        WHERE Lanches.fk_Atendimentos_Locais_idAtendimento = _idAtendimento;
        
	ELSE
		SELECT dcrMercadoriaPronta as "Produto","-" as "Descricacao", quantMercConsumo as "Quantidade",FORMAT(precoVenda * quantConsumo,2) as "Valor_Unitario", FORMAT(precoVenda * quantConsumo * quantMercConsumo,2) as "Valor_Total",horaSolicitado as "Hora pedido"
		FROM ((Consumo_Mercadorias_Prontas
        INNER JOIN Mercadorias_Prontas ON Consumo_Mercadorias_Prontas.fk_Mercadorias_Prontas_idMercadoria = Mercadorias_Prontas.idMercadoria)
        INNER JOIN Atendimentos_Entregas ON Consumo_Mercadorias_Prontas.fk_Atendimentos_Entregas_idAtendimento = Atendimentos_Entregas.idAtendimento)
        WHERE Consumo_Mercadorias_Prontas.fk_Atendimentos_Locais_idAtendimento = _idAtendimento
        UNION ALL
        SELECT dcrLanche as "Produto",dcrIngrediente as "Descricacao", quantIngrediente as "Quantidade",FORMAT(precoVenda * quantMercadoria,2) as "Valor_Unitario", FORMAT(precoVenda * quantMercadoria * quantIngrediente,2) as "Valor_Total",horaSolicitado as "Hora pedido"
		FROM ((Uso_Ingredientes_Em_Lanches
        INNER JOIN Ingredientes ON Uso_Ingredientes_Em_Lanches.fk_Ingredientes_idMercadoria = Ingredientes.idMercadoria)
        INNER JOIN Lanches ON Uso_Ingredientes_Em_Lanches.fk_Lanches_idLanche = Lanches.idLanche)
        WHERE Lanches.fk_Atendimentos_Entregas_idAtendimento = _idAtendimento;
    END IF;
	
END $$

/* Stored Procedure para encontrar os produtos que vencem um determinado prazo */
DROP PROCEDURE IF EXISTS `pcd_Consultar_Mercadorias_Vencendo` $$
CREATE PROCEDURE `pcd_Consultar_Mercadorias_Vencendo`(IN _quantDias INT)
BEGIN
	SELECT dcrMercadoria as "Mercadoria", quantRegistro as "Quantidade", dataVencimento as "Data_Vencimento",nomeCompleto as "Gerente_Responsavel"
    FROM ((Registros_Mercadorias
	JOIN Mercadorias_Prontas ON Registros_Mercadorias.fk_Mercadorias_Prontas_idMercadoria = Mercadorias_Prontas.idMercadoria)
    JOIN Gerentes ON Registros_Mercadorias.fk_Gerentes_cpf = Gerentes.cpf)
    WHERE (DATEDIFF(Registros_Mercadorias.dataVencimento,DATE(DATE_ADD(now(),INTERVAL _quantDias DAY))) < 0)
    UNION ALL
    SELECT dcrMercadoria as "Mercadoria", quantRegistro as "Quantidade", dataVencimento as "Data Vencimento",nomeCompleto as "Gerente_Responsavel"
    FROM ((Registros_Mercadorias
	JOIN Ingredientes ON Registros_Mercadorias.fk_Ingredientes_idMercadoria = Ingredientes.idMercadoria)
    JOIN Gerentes ON Registros_Mercadorias.fk_Gerentes_cpf = Gerentes.cpf)
    WHERE (DATEDIFF(Registros_Mercadorias.dataVencimento,DATE(DATE_ADD(now(),INTERVAL _quantDias DAY))) < 0);
    
END $$
DELIMITER ;