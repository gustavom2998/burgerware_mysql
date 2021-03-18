/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
USE `lanchonete`;

/* ----------------------------------------------------- Views ----------------------------------------------------- */
/* Visualizacao de atendimentos ativos - nao foram marcados como encerrados ainda */
DROP VIEW IF EXISTS vw_Atendimentos_Ativos;
CREATE VIEW vw_Atendimentos_Ativos AS
	SELECT CONCAT("LOCAL - MESA ", numeroMesa) as "Tipo_Atendimento",nomeCliente as "Cliente",valorTotal as "Consumo_Atual",nomeCompleto as "Responsavel",time(dataAtendimento) as "Inicio_Atendimento"
	FROM Funcionarios 
	INNER JOIN Atendimentos_Locais ON  Funcionarios.cpf = fk_Funcionarios_cpf
	WHERE estadoAtendimento = "ABERTO"
    UNION ALL
    SELECT CONCAT("ENTREGA - ",telefoneCliente) as "Tipo_Atendimento",nomeCliente,valorTotal as "Consumo_Atual",nomeCompleto as "Responsavel",time(dataAtendimento) as "Inicio_Atendimento"
	FROM Funcionarios 
	INNER JOIN Atendimentos_Entregas ON  Funcionarios.cpf = fk_Funcionarios_cpf
	WHERE estadoAtendimento = "ABERTO";
    
 /* Relatorio Estoque - Levanta quantidade de Mercadorias Prontas e Ingredientes atualmente ha no estoque */
 DROP VIEW IF EXISTS vw_Relatorio_Estoque;
 CREATE VIEW vw_Relatorio_Estoque AS
	SELECT dcrMercadoria as "Mercadoria", quantEstoque as "Quantidade", dcrIngrediente as "Usado_para", quantMercadoria as "Quantidade_por_uso"
    FROM Ingredientes
    UNION ALL
    SELECT dcrMercadoria as "Mercadoria", quantEstoque as "Quantidade", dcrMercadoriaPronta as "Usado_para", quantConsumo as "Quantidade_por_uso"
    FROM Mercadorias_Prontas;
    
 /* Balanco Caixas - Identifica todas as movimentacoes de cada caixa e quem foi o responsavel */
 DROP VIEW IF EXISTS vw_Balanco_Caixas;
 CREATE VIEW vw_Balanco_Caixas AS
	SELECT "Deposito" as "Tipo_Movimento",dcrDeposito as "Descricao_Movimento",valorDeposito as "Valor",idCaixa as "Id_Caixa", nomeCompleto as "Responsavel_Caixa", horaDeposito as "Horario"
    FROM ((Pagamentos_Atendimentos_Caixas
    INNER JOIN Caixas ON Caixas.idCaixa = Pagamentos_Atendimentos_Caixas.fk_Caixas_idCaixa) 
    INNER JOIN Gerentes ON Gerentes.cpf = Pagamentos_Atendimentos_Caixas.fk_Caixas_idCaixa)
    UNION ALL
    SELECT "Debito" as "Tipo_Movimento",dcrDebito as "Descricao_Movimento",valorDebito as "Valor",idCaixa as "Id_Caixa", nomeCompleto as "Responsavel_Caixa", horaDebito as "Horario"
    FROM ((Debitos_Gerentes_Caixas
    INNER JOIN Caixas ON Caixas.idCaixa = Debitos_Gerentes_Caixas.fk_Caixas_idCaixa) 
    INNER JOIN Gerentes ON Gerentes.cpf = Debitos_Gerentes_Caixas.fk_Caixas_idCaixa);    