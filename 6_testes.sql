/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
USE `lanchonete`;

/* ----------------------------------------------------- Teste Carga Dados ----------------------------------------------------- */
SELECT * FROM Administradores;
SELECT * FROM Gerentes;
SELECT * FROM Funcionarios;
SELECT * FROM Atendimentos_Locais;
SELECT * FROM Atendimentos_Entregas;
SELECT * FROM Ingredientes;
SELECT * FROM Mercadorias_Prontas;
SELECT * FROM Lanches;
SELECT * FROM Caixas;
SELECT * FROM Pagamentos_Atendimentos_Caixas;
SELECT * FROM Debitos_Gerentes_Caixas;

/* ----------------------------------------------------- Teste Views ----------------------------------------------------- */
Select * FROM vw_Atendimentos_Ativos;
Select * FROM vw_Relatorio_Estoque;
Select * FROM vw_Balanco_Caixas;

/* ----------------------------------------------------- Teste Stored Procedures -----------------------------------------------------  */
/* Teste de encerramento */
SELECT idAtendimento,valorTotal,estadoAtendimento FROM Atendimentos_Locais
WHERE Atendimentos_Locais.estadoAtendimento = "ENCERRADO"
UNION ALL
SELECT idAtendimento,valorTotal,estadoAtendimento FROM Atendimentos_Entregas
WHERE Atendimentos_Entregas.estadoAtendimento = "ENCERRADO";

CALL pcd_Encerrar_Atendimentos(13,NULL,59623507268);

/* Verificando se foi realmente encerrado */
SELECT idAtendimento,valorTotal,estadoAtendimento FROM Atendimentos_Locais
WHERE Atendimentos_Locais.estadoAtendimento = "ENCERRADO"
UNION ALL
SELECT idAtendimento,valorTotal,estadoAtendimento FROM Atendimentos_Entregas
WHERE Atendimentos_Entregas.estadoAtendimento = "ENCERRADO";

/* Verificando diferentes dias para vencer - Primeiro 10; Depois 25 */
CALL pcd_Consultar_Mercadorias_Vencendo(10);
CALL pcd_Consultar_Mercadorias_Vencendo(25);

/* Visualizando os pedidos para o atendimento 13 Local e 2 para Entrega */
CALL pcd_Consultar_Pedidos_Atedimentos(13,0);
CALL pcd_Consultar_Pedidos_Atedimentos(2,1);