/* 	Trabalho Especifico de Banco de Dados 2019/02 - Sistema Hamburgueria
	Alunos: Gustavo Fardin Monti, Jessellem Santos Cipriano, Paulo Victor Almeida Santana, Willian Macedo Rodrigues
*/
USE `lanchonete`;
SET SESSION SQL_MODE='ALLOW_INVALID_DATES';
/* ----------------------------------------------------- CARGA DE DADOS ----------------------------------------------------- */
insert into Administradores(cpf,nomeCompleto,senha,salarioMensal,dataIngresso) values
	(60205727812,"RAVIER SEBASTIAO DE CASTRO ROSA",50280290,3000,'2019-01-01 10:34:09');
    
insert into Gerentes(cpf,nomeCompleto,senha,salarioMensal,dataIngresso,fk_Administradores_cpf) values
	(63130672917,	"AMANDA TON BENICA LIMA",	4642522,	1800,	'2019-01-01 10:35:11',	60205727812),
	(59623507268,	"NATALIA VIANNA SCHIAVO",	5526399,	1800,	'2019-03-05 15:10:59',	60205727812),
	(60257661328,	"VIVIANE ALEXIA CORREIA SILVA",	3795103,	1800,	'2019-07-29 16:33:39',	60205727812),
	(59749354512,	"LORENA CARLETTE TEIXEIRA",	72350553,	1850,	'2019-11-10 15:10:01',	60205727812);
    
insert into Funcionarios(cpf,nomeCompleto,senha,salarioMensal,dataIngresso,fk_Administradores_cpf) values
	(61969060026,	"JOAO SOUZE",	53727028,	950,	'2019-01-01 05:10:01',	60205727812),
	(65871422244,	"GUSTAVO FERREIRA",	78291073,	950,	'2019-01-01 05:10:59',	60205727812),
	(68481888514,	"MARIA BARROS",	51819605,	950,	'2019-01-01 05:12:05',	60205727812),
	(58523271046,	"ELIZA SANTOS",	76517408,	950,	'2019-03-05 08:11:50',	60205727812),
	(58818160123,	"PEDRO FIRME DA CRUZ JUNIOR",	75548589,	950,	'2019-03-05 08:11:10',	60205727812),
	(68037363875,	"JEANY DARE",	59805931,	950,	'2019-03-05 08:15:33',	60205727812),
	(66190248371,	"CAMILA VALENTINA BARBIERI",	89781844,	950,	'2019-03-05 08:17:03',	60205727812),
	(60877516682,	"JULIA SENNA DE AZEVEDO",	58184188,	950,	'2019-06-11 11:10:59',	60205727812),
	(58894656514,	"GABRIEL ROCHA FIGUEIRA CALDEIRA",	84688586,	950,	'2019-06-11 11:11:30',	60205727812),
	(65429580242,	"THIAGO ALMENARA MARTINS",	17579490,	950,	'2019-06-11 11:11:50',	60205727812),
	(65748168421,	"LEONE SOROMENHO VIANA",	9012550,	950,	'2019-06-11 11:12:10',	60205727812),
	(58082939719,	"AMANDA BRAGA MUZI",	19512719,	950,	'2019-06-11 11:15:30',	60205727812),
	(60431800530,	"HENRIQUE ORLANDE GABRIEL",	11897969,	950,	'2019-06-11 11:17:20',	60205727812),
	(63531317376,	"MARIA EDUARDA OLIVEIRA CUNHA",	79949988,	1500,	'2019-06-11 11:17:45',	60205727812),
	(59177751396,	"LETICIA JULIA SOUZA PEIXOTO",	6306063,	1500,	'2019-06-11 11:17:59',	60205727812),
	(66281018335,	"MATHEUS RIBEIRO AREAS",	99917480,	1500,	'2019-06-11 11:18:20',	60205727812),
	(58060647799,	"BARBARA RAMOS MOREIRA",	16387966,	1500,	'2019-06-11 11:18:40',	60205727812),
	(61262489391,	"ANA LUIZA FERREIRA SANTOS",	50921778,	2200,	'2019-06-11 11:18:55',	60205727812),
	(66422847979,	"JONATAS FERREIRA DA CRUZ",	94612037,	2200,	'2019-10-10 05:10:01',	60205727812),
	(62141137346,	"DANIEL FERNANDES VANTIL DA COSTA",	14487334,	2990,	'2019-10-10 05:10:31',	60205727812);
    
insert into Atendimentos_Locais(valorTotal,numeroMesa,nomeCliente,fk_Funcionarios_cpf) values
	(0,	1,	"Elissa Young",	65871422244),
    (0,	2,	"Isma Christie",	60877516682),
	(0,	3,	"Kylie Garrison",	60431800530),
	(0,	4,	"Mohammod Fisher",	66281018335),
	(0,	5,	"Brett Irvine",	66422847979),
	(0,	6,	"Winifred Franks",	65871422244),
	(0,	7,	"Johnny White",	60877516682),
	(0,	8,	"Ashwin Robbins",	60431800530),
	(0,	9,	"Macie Obrien",	66281018335),
	(0,	10,	"Hadiqa Craig",	66422847979),
	(0,	11,	"Layla-Mae Browne",	66281018335),
	(0,	12,	"Shaun Beltran",	66422847979),
	(0,	13,	"Rares Weir",	65871422244),
	(0,	14,	"Jayden-Lee Mcdermott",	60877516682),
	(0,	15,	"Enoch Pennington",	60431800530);
    
insert into Atendimentos_Entregas(nomeCliente,ruaEndereco,bairroEndereco,complementoEndereco,telefoneCliente,formaPagamento,numeroEndereco,fk_Funcionarios_cpf) values
("Evie-rose wheatley",	"Rua Sao Joao",	"Sernamby",	NULL,	27990314747,	"DINHEIRO",	314,65871422244),
("Marcie Drummond",	"Rua Rezende",	"Sernamby",	NULL,	27996639695,	"CARTAO CREDITO – VISA",	156,60431800530),
("Arnie Branch",	"Rua Tubarao",	"Sernamby",	"AP 211",	27993282150,	"DINHEIRO",	21,65871422244),
("Cecelia Sierra",	"Primeira Avenida",	"Centro",	NULL,	27993566169,	"DINHEIRO",	10,60431800530),
("Elowen Arnold",	"Segunda Avenida",	"Centro",	NULL,	27992223963,	"DINHEIRO",	7,65871422244);
    
CALL pcd_Registrar_Ingredientes("Acem Bovino Moido -  KG",	0.5,	18.00,	"Hamburger Artesanal 130g",	0.13);
CALL pcd_Registrar_Ingredientes("Pao Brioche - UN",	0.5,	1.00,	"Pao Brioche",	1);
CALL pcd_Registrar_Ingredientes("Alface Crespa - KG",	0.2,	4.00,	"Alface Folha",	0.04);
CALL pcd_Registrar_Ingredientes("Bacon Double Smoked Porco - KG",	0.5,	30.00,	"Bacon Fatias",	0.05);
CALL pcd_Registrar_Ingredientes("Queijo Cheddar Fatiado - KG",	0.4,	45.00,	"Cheddar Fatia",	0.02);
CALL pcd_Registrar_Ingredientes("Queijo Mussarela Fatiado - KG",	0.45,	30.00,	"Mussarela Fatia",	0.02);
CALL pcd_Registrar_Ingredientes("Alcatra Bovino Moido - KG",	0.5,	30.00,	"Hamburger Premium Artesanal 130g",	0.12);
CALL pcd_Registrar_Ingredientes("Cebola Roxa - KG",	0.2,	2.50,	"Cebola Roxa Fatias",	0.02);
CALL pcd_Registrar_Ingredientes("Molho Barbecue Spicy - LT",	0.2,	9.8,	"Molho Barbecue",	0.03);
CALL pcd_Registrar_Ingredientes("Molho Mustarda Inglesa - LT",	0.22,	14.00,	"Molho Mostarda Inglesa",	0.03);
CALL pcd_Registrar_Ingredientes("Molho Ketchup Special - LT",	0.18,	8.00,	"Molho Ketchup",	0.03);
CALL pcd_Registrar_Ingredientes("Molho Maionese Caseira - LT",	0.18,	9.00,	"Molho Maionese Caseira",	0.03);

CALL pcd_Entrada_Ingredientes(10,ADDDATE(CURRENT_DATE(),INTERVAL 2 WEEK),59623507268,1);
CALL pcd_Entrada_Ingredientes(50,ADDDATE(CURRENT_DATE(),INTERVAL 4 WEEK),59749354512,2);
CALL pcd_Entrada_Ingredientes(2,ADDDATE(CURRENT_DATE(),INTERVAL 4 WEEK),60257661328,3);
CALL pcd_Entrada_Ingredientes(10,ADDDATE(CURRENT_DATE(),INTERVAL 3 WEEK),63130672917,4);
CALL pcd_Entrada_Ingredientes(3,ADDDATE(CURRENT_DATE(),INTERVAL 5 WEEK),59623507268,5);
CALL pcd_Entrada_Ingredientes(3,ADDDATE(CURRENT_DATE(),INTERVAL 5 WEEK),59749354512,6);
CALL pcd_Entrada_Ingredientes(10,ADDDATE(CURRENT_DATE(),INTERVAL 6 WEEK),60257661328,7);
CALL pcd_Entrada_Ingredientes(2,ADDDATE(CURRENT_DATE(),INTERVAL 4 WEEK),63130672917,8);
CALL pcd_Entrada_Ingredientes(4,ADDDATE(CURRENT_DATE(),INTERVAL 6 WEEK),59623507268,9);
CALL pcd_Entrada_Ingredientes(4,ADDDATE(CURRENT_DATE(),INTERVAL 6 WEEK),59749354512,10);
CALL pcd_Entrada_Ingredientes(4,ADDDATE(CURRENT_DATE(),INTERVAL 6 WEEK),60257661328,11);
CALL pcd_Entrada_Ingredientes(4,ADDDATE(CURRENT_DATE(),INTERVAL 6 WEEK),63130672917,12);

CALL pcd_Registrar_Mercadorias_Prontas("Coca Cola 2L",	0.45,	6,	"Coca Cola 2L",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Coca Cola 600ML",	0.45,	4,	"Coca Cola 600ML",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Coca Cola Lata 350ML",	0.45,	3,	"Coca Cola Lata 350ML",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Pepsi 2L",	0.45,	5.50,	"Pepsi 2L",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Pepsi 600ML",	0.45,	3.7,	"Pepsi 600ML",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Pepsi Lata 350ML",	0.45,	3,	"Pepsi Lata 350ML",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Fanta Uva 1L",	0.45,	4.5,	"Fanta Uva 1L",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Fanta Uva Lata 350ML",	0.45,	3,	"Fanta Uva Lata 350ML",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Fanta Laranja 1L",	0.45,	4.5,	"Fanta Laranja 1L",	1);
CALL pcd_Registrar_Mercadorias_Prontas("Fanta Laranja Lata 350ML",	0.45,	3,	"Fanta Laranja Lata 350ML",	1);

#CALL pcd_Entrada_Mercadorias_Prontas(20,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),59623507268,1);
CALL pcd_Entrada_Mercadorias_Prontas(20,DATE(DATE_ADD(now(),INTERVAL 48 DAY)),59623507268,1);
CALL pcd_Entrada_Mercadorias_Prontas(20 ,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),59749354512  , 2 );
CALL pcd_Entrada_Mercadorias_Prontas(40 ,DATE(DATE_ADD(now(),INTERVAL 48 WEEK)),60257661328  , 3 );
CALL pcd_Entrada_Mercadorias_Prontas(20 ,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),63130672917  , 4 );
CALL pcd_Entrada_Mercadorias_Prontas(20 ,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),59623507268  , 5 );
CALL pcd_Entrada_Mercadorias_Prontas(40 ,DATE(DATE_ADD(now(),INTERVAL 48 WEEK)),59749354512  , 6 );
CALL pcd_Entrada_Mercadorias_Prontas(20 ,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),60257661328  , 7 );
CALL pcd_Entrada_Mercadorias_Prontas(40 ,DATE(DATE_ADD(now(),INTERVAL 48 WEEK)),63130672917  , 8 );
CALL pcd_Entrada_Mercadorias_Prontas(20 ,DATE(DATE_ADD(now(),INTERVAL 24 WEEK)),59623507268  , 9 );
CALL pcd_Entrada_Mercadorias_Prontas(40 ,DATE(DATE_ADD(now(),INTERVAL 48 WEEK)),59749354512  , 10 );

CALL pcd_Registrar_Lanches(1,NULL);
CALL pcd_Registrar_Lanches(2,NULL);
CALL pcd_Registrar_Lanches(3,NULL);
CALL pcd_Registrar_Lanches(4,NULL);
CALL pcd_Registrar_Lanches(5,NULL);
CALL pcd_Registrar_Lanches(6,NULL);
CALL pcd_Registrar_Lanches(7,NULL);
CALL pcd_Registrar_Lanches(8,NULL);
CALL pcd_Registrar_Lanches(9,NULL);
CALL pcd_Registrar_Lanches(10,NULL);
CALL pcd_Registrar_Lanches(11,NULL);
CALL pcd_Registrar_Lanches(12,NULL);
CALL pcd_Registrar_Lanches(13,NULL);
CALL pcd_Registrar_Lanches(14,NULL);
CALL pcd_Registrar_Lanches(15,NULL);
CALL pcd_Registrar_Lanches(NULL,1);
CALL pcd_Registrar_Lanches(NULL,2);
CALL pcd_Registrar_Lanches(NULL,3);
CALL pcd_Registrar_Lanches(NULL,4);
CALL pcd_Registrar_Lanches(NULL,5);

INSERT INTO Uso_Ingredientes_Em_Lanches (quantIngrediente,fk_Ingredientes_idMercadoria,fk_Lanches_idLanche) VALUES
# Adiciona Pao aos Pedidos - 20 Lanches com Pao
	(1,	2,	1),
	(1,	2,	2),
	(1,	2,	3),
	(1,	2,	4),
	(1,	2,	5),
	(1,	2,	6),
	(1,	2,	7),
	(1,	2,	8),
	(1,	2,	9),
	(1,	2,	10),
	(1,	2,	11),
	(1,	2,	12),
	(1,	2,	13),
	(1,	2,	14),
	(1,	2,	15),
	(1,	2,	16),
	(1,	2,	17),
	(1,	2,	18),
	(1,	2,	19),
	(1,	2,	20),
# Adiciona Carne aos Pedidos - 9 com 1 Bife Normal, 1 com 2 Bife Normal, 8 Com 1 Bife Premium, 2 com 2 Bife Premium
	(1,	1,	1),
	(1,	1,	2),
	(1,	1,	3),
	(2,	1,	4),
	(1,	1,	5),
	(1,	1,	6),
	(1,	1,	7),
	(1,	1,	8),
	(1,	1,	9),
	(1,	1,	10),
	(1,	7,	11),
	(1,	7,	12),
	(1,	7,	13),
	(1,	7,	14),
	(2,	7,	15),
	(2,	7,	16),
	(1,	7,	17),
	(1,	7,	18),
	(1,	7,	19),
	(1,	7,	20),
    # Adicionando Salada para 15 Lanches - 5 Com Cebola e Alface, 5 so com Alface, 5 so com cebola
    (1,	3,	1),
	(1,	3,	2),
	(1,	3,	3),
	(1,	3,	4),
	(1,	3,	5),
	(1,	8,	1),
	(1,	8,	2),
	(1,	8,	3),
	(1,	8,	4),
	(1,	8,	5),
	(1,	3,	6),
	(1,	3,	7),
	(1,	3,	8),
	(1,	3,	9),
	(1,	3,	10),
	(1,	8,	11),
	(1,	8,	12),
	(1,	8,	13),
	(1,	8,	14),
	(1,	8,	15),
    # Adicionando Queijo para 10 Lanches - 5 Cheddar e Mussarela, 3 Mussarela e 2 Cheddar
    (1,	5,	16),
	(1,	5,	17),
	(1,	5,	18),
	(1,	5,	19),
	(1,	5,	20),
	(1,	6,	15),
	(1,	6,	16),
	(1,	6,	17),
	(1,	6,	18),
	(1,	6,	19),
	(1,	5,	20),
	(1,	5,	5),
	(1,	5,	8),
	(1,	6,	11),
	(1,	6,	13),
    # Adicionando 1 Molho para 15 Lanches, e 2 Molhos para 5 Lanches
    (1,	9,	1),
	(1,	10,	2),
	(1,	11,	3),
	(1,	12,	4),
	(1,	9,	5),
	(1,	10,	6),
	(1,	11,	7),
	(2,	12,	8),
	(1,	9,	9),
	(2,	10,	10),
	(1,	11,	11),
	(1,	12,	12),
	(2,	9,	13),
	(1,	10,	14),
	(1,	11,	15),
	(1,	12,	16),
	(1,	9,	17),
	(2,	10,	18),
	(1,	11,	19),
	(2,	12,	20);
    
/* Inserindo 10 Consumos de Mercadorias Prontas aos consumos - 2 Coca 2LT(1 Atendimento Local), 3 Coca Lata (1 em 2 atendimentos Locais, 1 para entrega), 2 Fanta Uva Lata (1 em Local 1 para Entrega) e uma 1 Fanta Laranja Local*/
INSERT INTO Consumo_Mercadorias_Prontas(quantMercConsumo,horaSolicitado,fk_Mercadorias_Prontas_idMercadoria,fk_Atendimentos_Locais_idAtendimento,fk_Atendimentos_Entregas_idAtendimento) values
(2,current_time(),1,1,NULL),
(1,current_time(),3,3,NULL),
(1,current_time(),3,5,NULL),
(1,current_time(),3,NULL,1),
(1,current_time(),8,11,NULL),
(1,current_time(),8,NULL,3),
(1,current_time(),10,13,NULL);


/* Encerrando atendimentos: 4 Atendimentos Locais(ID: 1,3,5,7) e 2 de Entrega Encerrados (ID:2,4) */
CALL pcd_Encerrar_Atendimentos(1,NULL,59623507268);
CALL pcd_Encerrar_Atendimentos(3,NULL,59749354512);
CALL pcd_Encerrar_Atendimentos(5,NULL,59623507268);
CALL pcd_Encerrar_Atendimentos(7,NULL,59749354512);
CALL pcd_Encerrar_Atendimentos(2,40.6,59749354512);
CALL pcd_Encerrar_Atendimentos(4,10.7,59623507268);