/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
USE `lanchonete`;

/* ----------------------------------------------------- TRIGGERS ----------------------------------------------------- */
DELIMITER $$
/* Trigger para inserir um caixa, apos cada insercao de gerente */
DROP TRIGGER IF EXISTS tgr_Registro_Gerente_Registra_Caixa $$
CREATE TRIGGER tgr_Registro_Gerente_Registra_Caixa AFTER INSERT
ON Gerentes
FOR EACH ROW
BEGIN
	INSERT INTO Caixas(idCaixa) values (NEW.cpf);
END $$

/* Trigger para atualizar o caixa, apos ele ser debitado por gerente*/
DROP TRIGGER IF EXISTS tgr_Debito_Gerente_Atualiza_Caixa $$
CREATE TRIGGER tgr_Debito_Gerente_Atualiza_Caixa AFTER INSERT
ON Debitos_Gerentes_Caixas
FOR EACH ROW
BEGIN
    UPDATE Caixas
	SET saldoTotal = saldoTotal - NEW.valorDebito
	WHERE Caixas.idCaixa = NEW.fk_Caixas_idCaixa;
END $$

/* Trigger para atualizar o caixa apos entrada de deposito por atendimento */
DROP TRIGGER IF EXISTS tgr_Deposito_Atendimento_Atualiza_Caixa $$
CREATE TRIGGER tgr_Deposito_Atendimento_Atualiza_Caixa AFTER INSERT
ON Pagamentos_Atendimentos_Caixas
FOR EACH ROW
BEGIN
    UPDATE Caixas
	SET saldoTotal = saldoTotal + NEW.valorDeposito
	WHERE Caixas.idCaixa = NEW.fk_Caixas_idCaixa;
END $$

/* Trigger acionado apos esta insercacao  para atualizar o estoque na tabela de Mercadoria Pronta e Ingrediente apos insercao de um dos dois */
DROP TRIGGER IF EXISTS tgr_Entrada_Mercadoria_Atualiza_Estoque $$
CREATE TRIGGER tgr_Entrada_Mercadoria_Atualiza_Estoque AFTER INSERT
ON Registros_Mercadorias
FOR EACH ROW
BEGIN
	/* Se a FK_Mercadorias_Prontas for NULL - Atualizando a tabela de ingrediente */
    IF(isnull(New.fk_Mercadorias_Prontas_idMercadoria)  AND NOT isnull(New.fk_Ingredientes_idMercadoria)) THEN
		UPDATE Ingredientes SET quantEstoque = quantEstoque + New.quantRegistro
		WHERE idMercadoria = New.fk_Ingredientes_idMercadoria;
        
         /* O gerente ja saca o dinheiro do caixa para realizar o pagamento da Mercadoria que chegou */
		INSERT INTO Debitos_Gerentes_Caixas(dcrDebito,tipoDebito,horaDebito,valorDebito,fk_Gerentes_cpf,fk_Caixas_idCaixa)
		SELECT CONCAT("ENTRADA INGREDIENTE: ", Ingredientes.dcrMercadoria, " - ", New.quantRegistro),"Dinheiro",now(), (New.quantRegistro * Ingredientes.precoCustoUnitario),New.fk_Gerentes_cpf,New.fk_Gerentes_cpf
		FROM Ingredientes
		WHERE Ingredientes.idMercadoria = New.fk_Ingredientes_idMercadoria;
	/* Caso contrario, fk_Ingredientes eh NULL - Atualizando estoque de tabela de Mercadorias Prontas*/
    ELSEIF (isnull(New.fk_Ingredientes_idMercadoria)  AND NOT isnull(New.fk_Mercadorias_Prontas_idMercadoria)) THEN
		UPDATE Mercadorias_Prontas SET quantEstoque = quantEstoque + New.quantRegistro
		WHERE idMercadoria = New.fk_Mercadorias_Prontas_idMercadoria;
        
         /* O gerente ja saca o dinheiro do caixa para realizar o pagamento da Mercadoria que chegou */
		INSERT INTO Debitos_Gerentes_Caixas(dcrDebito,tipoDebito,horaDebito,valorDebito,fk_Gerentes_cpf,fk_Caixas_idCaixa)
		SELECT CONCAT("ENTRADA MERCADORIA: ", Mercadorias_Prontas.dcrMercadoria, " - ", New.quantRegistro),"Dinheiro",now(), (New.quantRegistro * Mercadorias_Prontas.precoCustoUnitario),New.fk_Gerentes_cpf,New.fk_Gerentes_cpf
		FROM Mercadorias_Prontas
		WHERE Mercadorias_Prontas.idMercadoria = New.fk_Mercadorias_Prontas_idMercadoria;
	END IF;
END $$

/* Trigger que verifca se ha quantidade de mercadoria no estoque para produzir os ingrendientes - se nao houver, gera erro. */
DROP TRIGGER IF EXISTS tgr_Verifica_Estoque_Ingrediente_Suficiente $$
CREATE TRIGGER tgr_Verifica_Estoque_Ingrediente_Suficiente BEFORE INSERT
ON Uso_Ingredientes_Em_Lanches
FOR EACH ROW
BEGIN
	IF (0 > (	SELECT quantEstoque - quantMercadoria * NEW.quantIngrediente
				FROM Ingredientes
				WHERE Ingredientes.idMercadoria = NEW.fk_Ingredientes_idMercadoria)) THEN
		
        signal sqlstate '45000' SET MESSAGE_TEXT = 'Nao ha estoque de mercadora suficiente para adicionar o ingrediente.';
    END IF;
END $$

/* Trigger que verifica se ha estoque suficiente para permitir consumo de mercadoria pronta - se nao houver, gera erro*/
DROP TRIGGER IF EXISTS tgr_Verifica_Estoque_Mercadoria_Suficiente $$
CREATE TRIGGER tgr_Verifica_Estoque_Mercadoria_Suficiente BEFORE INSERT
ON Consumo_Mercadorias_Prontas
FOR EACH ROW
BEGIN
	IF (0 > (	SELECT quantEstoque - (quantConsumo * NEW.quantMercConsumo)
				FROM Mercadorias_Prontas
				WHERE Mercadorias_Prontas.idMercadoria = NEW.fk_Mercadorias_Prontas_idMercadoria)) THEN
        signal sqlstate '45000' SET MESSAGE_TEXT = 'Nao ha estoque de mercadora suficiente para adicionar a mercadoria pronta aos consumos.';
    END IF;
END $$

/* Trigger que atualiza o custo de um lanche dado que foi adicionado um novo ingrendiente e atualiza o pedido*/
DROP TRIGGER IF EXISTS tgr_Insere_Ingrediente_Atualiza_Preco_Lanche $$
CREATE TRIGGER tgr_Insere_Ingrediente_Atualiza_Preco_Lanche AFTER INSERT
ON Uso_Ingredientes_Em_Lanches
FOR EACH ROW
BEGIN

	UPDATE Lanches
	SET precoLanche = precoLanche + (NEW.quantIngrediente* (SELECT precoVenda * quantMercadoria
															FROM Ingredientes
															WHERE Ingredientes.idMercadoria = NEW.fk_Ingredientes_idMercadoria))
	WHERE Lanches.idLanche = NEW.fk_Lanches_idLanche;
		
	/* Tambem deve dar baixa no estoque */
	UPDATE Ingredientes
	SET quantEstoque = quantEstoque - (quantMercadoria * NEW.quantIngrediente)
	WHERE Ingredientes.idMercadoria = NEW.fk_Ingredientes_idMercadoria;
END $$

/* Trigger que atualiza o preco do atendimento apos atualizar o preco de um lanche */
DROP TRIGGER IF EXISTS tgr_Atualiza_Preco_Lanche_Atualiza_Preco_Atendimento $$
CREATE TRIGGER tgr_Atualiza_Preco_Lanche_Atualiza_Preco_Atendimento AFTER UPDATE
ON Lanches
FOR EACH ROW
BEGIN
	IF (NEW.precoLanche <> OLD.precoLanche) THEN
		IF (isnull(NEW.fk_Atendimentos_Entregas_idAtendimento)) THEN
			UPDATE Atendimentos_Locais
			SET valorTotal = valorTotal - OLD.precoLanche + NEW.precoLanche
			WHERE Atendimentos_Locais.idAtendimento = NEW.fk_Atendimentos_Locais_idAtendimento;
        ELSE
			UPDATE Atendimentos_Entregas
			SET valorTotal = valorTotal - OLD.precoLanche + NEW.precoLanche
			WHERE Atendimentos_Entregas.idAtendimento = NEW.fk_Atendimentos_Entregas_idAtendimento;
        END IF;
        
	END IF;
END $$

/* Trigger que atualiza o preco do atendimento apos adicionar o consumo de uma mercadoria e tambem da baixa na mercadoria no estoque*/
DROP TRIGGER IF EXISTS tgr_Consumo_Mercadoria_Atualiza_Preco_Atendimento $$
CREATE TRIGGER tgr_Consumo_Mercadoria_Atualiza_Preco_Atendimento AFTER INSERT
ON Consumo_Mercadorias_Prontas
FOR EACH ROW
BEGIN
	/* Se for consumo local*/
	IF (isnull(NEW.fk_Atendimentos_Entregas_idAtendimento)) THEN
		/* Atualiza o custo do atendimento cobrando a mercadoria consumida - Custo eh Numero Mercadorias Prontas pedidas * (Quantidade Mercadoria que isso consome * valorDe Venda) */
		UPDATE Atendimentos_Locais
		SET valorTotal = valorTotal + (NEW.quantMercConsumo * (SELECT quantConsumo * precoVenda
																FROM Mercadorias_Prontas
																WHERE Mercadorias_Prontas.idMercadoria = NEW.fk_Mercadorias_Prontas_idMercadoria))
		WHERE Atendimentos_Locais.idAtendimento = NEW.fk_Atendimentos_Locais_idAtendimento;
	ELSE
			UPDATE Atendimentos_Entregas
			SET valorTotal = valorTotal + (NEW.quantMercConsumo * (SELECT quantConsumo * precoVenda
																FROM Mercadorias_Prontas
																WHERE Mercadorias_Prontas.idMercadoria = NEW.fk_Mercadorias_Prontas_idMercadoria))
			WHERE Atendimentos_Entregas.idAtendimento = NEW.fk_Atendimentos_Entregas_idAtendimento;
	END IF;
    /* Atualiza estoque de mercadorias prontas tirando o consumo */
    UPDATE Mercadorias_Prontas
    SET quantEstoque = quantEstoque - (New.quantMercConsumo * quantConsumo)
    WHERE Mercadorias_Prontas.idMercadoria = NEW.fk_Mercadorias_Prontas_idMercadoria;
END $$

/* Trigger que verifica se o registro de Gerente eh feito por um administrador valido*/
DROP TRIGGER IF EXISTS tgr_Valida_Registro_Gerente $$
CREATE TRIGGER tgr_Valida_Registro_Gerente BEFORE INSERT
ON Gerentes
FOR EACH ROW
BEGIN
	IF (NOT EXISTS(SELECT * FROM Administradores WHERE NEW.fk_Administradores_cpf = Administradores.cpf)) THEN
        signal sqlstate '45000' SET MESSAGE_TEXT = 'Administrador invalido. Nao e possivel registrar o gerente.';
    END IF;
END $$

/* Trigger que verifica se o registro de funcionarios eh feito por um administrador valido */
DROP TRIGGER IF EXISTS tgr_Valida_Registro_Funcionario $$
CREATE TRIGGER tgr_Valida_Registro_Funcionario BEFORE INSERT
ON Funcionarios
FOR EACH ROW
BEGIN
	IF (NOT EXISTS(SELECT * FROM Administradores WHERE NEW.fk_Administradores_cpf = Administradores.cpf)) THEN
        signal sqlstate '45000' SET MESSAGE_TEXT = 'Administrador invalido. Nao e possivel registrar o funcionario.';
    END IF;
END $$
DELIMITER ;