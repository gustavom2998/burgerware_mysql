# BurgerWare - BD para Hamburguerias
Banco de dados desenvolvido como trabalho prático voltado para gerenciamento de uma hamburgueria fictícia. Todo o código disponbilizado foi gerado na disciplina de Banco de Dados como trabalho prático.  O objetivo foi modelar e implementar um banco de dados que poderia auxiliar no processo de gerenciamento de um negócio (neste caso uma hamburgueria). Primeiro toda a definição de requisitos foi feita, destacando os objetivos a serem atingidos por este banco de dados. Então, iniciou-se uma etapa de modelagem conceitual, buscando documentar através de diagramas UML o processo de desenvolvimento do banco de dados. Dois diagramas que foram elaborados na etapa de modelagem foram disponibilizados, além de um dicionário de dados. Então, utilizando o SGBD MySQL, implementou-se a solução. 

Vale ressaltar que este repositório contém um banco de dados criado como trabalho acadêmico, e pode possuir falhas e casos que não foram tratados. O objetivo é apenas realizar um exercício que simula uma aplicação prática. 

## Requisitos deste software
Hoje no mercado há uma crescente demanda por alimentos com um padrão de qualidade elevado, e que seja um produto diferenciado. No ramo de hamburgueria
os lanches gourmet ganharam seu espaço por oferecer uma experiência diferente, associada a uma ideia de alta cozinha que engloba cultura e arte culinária, ingredientes mais refinados, e com qualidade elevada.

As hamburguerias que oferecem esse tipo de serviço necessitam de um sistema de gerenciamento eficiente, que otimize o tempo dos funcionários com tarefas como atendimento ao cliente, recebimento e cadastro de mercadorias, controle de estoque, gerenciamento das finanças, e fornecendo históricos de venda, entrada e saída dos caixas, para que o foco principal seja o desenvolvimento do hambúrguer com a qualidade esperada pelos clientes.

A hamburgueria em questão, tem como foco oferecer ao cliente o lanche gourmet, e uma variação do mesmo, como a inclusão e exclusão de ingredientes, personalizando o lanche gourmet.

Em geral, o software para essa hamburgueria deve fornecer uma série de ferramentas, que foram agrupadas em quatro módulos individuais, que em conjunto, fornecem um serviço completo para gerenciamento da hamburgueria. Esses módulos serão detalhados a seguir. Além destes módulos com suas respectivas funcionalidades, o software deve fornecer uma interface gráfica para os usuários, sendo implementado em uma plataforma flexível, que permita o funcionamento em dispositivos móveis integrado com o banco de dados desenvolvido.

### Gerenciamento Administrativo

O modulo de gerenciamento administrativo é responsável por fornecer ferramentas para controle de finanças, controle de funcionários, e controle de mercadorias para o estoque. Na hamburgueria há uma divisão de tarefas entre funcionários, gerentes, e administrador. 
	
Os gerentes são responsáveis por controlar as finanças da hamburgueria, receber e cadastrar mercadorias, e controlar o caixa do estabelecimento. O quadro de gerentes da hamburgueria em questão conta com quatro gerentes, cada gerente é responsável por um caixa da hamburgueria, logo, cada caixa, no total de quatro, será associado com um gerente, e apenas ele poderá acessar o mesmo para entrada de dinheiro. O gerente também pode debitar uma quantia para eventuais gastos, como pagamento de mercadoria, ou pagamento de funcionário. O funcionário recebe o pagamento do atendimento e esse dinheiro é recolhido pelo gerente, esse gerente faz a entrada desse valor no caixa de sua responsabilidade. O gerente também terá acesso a relatórios de movimentações no caixa, como o histórico de entrada e saída de dinheiro, relatório de atendimentos da hamburgueria, que especifica os atendimentos feitos durante um período de interesse, uma relação dos lanches e produtos vendidos e os respectivos valores, e um relatório de estoque para controle da quantidade de  mercadoria disponível na hamburgueria. 
	
Os demais funcionários que utilizarão o sistema são responsáveis por realizar o atendimento ao cliente, e gerar os pedidos no sistema. O funcionamento do atendimento será abordado mais adiante.
	
O administrador é responsável por gerenciar o cadastro dos funcionários no sistema de gerenciamento, atualizando informações do tipo, nome, cpf, senha de acesso ao sistema, salário, data de admissão, entre outros.  

### Gerenciamento de Atendimentos

O modulo de atendimento é responsável por gerenciar o atendimento ao cliente. 
	
O funcionário inicia um atendimento, e esse atendimento é identificado por um numero e tem o status “aberto”, no atendimento deve constar a data do mesmo, os pedidos que foram realizados durante o atendimento e os respectivos horários dos pedidos, sendo que o atendimento pode conter um ou mais pedidos. O pedido pode ser de um produto pronto, como refrigerante, ou pode ser de um lanche. No caso do lanche, o cliente pode personalizar o mesmo, incluindo ou retirando algum ingrediente, sendo que no caso de inclusão, o preço do lanche pode ser modificado de acordo com o ingrediente. O atendimento também deverá ser classificado entre local ou para entrega, no caso do atendimento local é solicitado o nome do cliente, e a mesa que o cliente se encontra, já no atendimento voltado para entrega, é solicitado o nome, endereço para entrega, forma de pagamento e telefone para contato. 
	
Ao finalizar um atendimento é calculado o valor total do pedido,  o funcionário recebe a quantia calculada, e modifica o status do atendimento para “encerrado”. Ao fechar todos atendimentos do dia, o funcionário repassa a quantia para o gerente, que por sua vez faz a entrada dessa quantia no caixa de sua responsabilidade. No caso de entregas, o entregador é responsável em repassar o dinheiro para o funcionário que iniciou o atendimento, logo, ele não tem contato com o sistema. 

### Gerenciamento de Usuários do Sistemas
O gerenciamento de usuários do sistema é responsável por controlar os acessos na plataforma de acordo com o nível de prioridade do usuário.
	
O administrador pode ter acesso ao sistema apenas para controlar os acessos dos outros usuários a certas funcionalidades do sistema, e atualizar dados dos funcionários, bem como incluir ou excluir algum funcionário.
	
O gerente pode ter acesso ao caixa de sua responsabilidade, pode consultar relatórios administrativos, e ao sistema de gerenciamento de mercadoria e estoque, a fim de cadastrar as mercadorias ao receber. 
	
O funcionário pode ter acesso apenas ao sistema de atendimento, para iniciar ou encerrar um atendimento, e acompanhar o status do mesmo. 
	
Logo, o sistema de gerenciamento de usuários do sistema tem como obrigação lidar com essas particularidades de cada classe de usuário, permitindo o acesso de cada funcionalidade através do CPF e senha de cada usuário permitido.

## Compilação

Para compilar os arquivos criados basta abrir uma sessão no sistema de gerenciamento de banco de dados MySQL. Tendo uma configuração válida, basta executar cada um dos arquivos na ordem numérica fornecida no nome dos arquivos:

1. `definicaoEsquemaTabelas.sql` : Declaração das tabelas deste banco de dados.
2. `definicaoTriggers.sql` : Declaração dos triggers para as tabelas definidas.
3. `definicaoViews.sql` : Algumas views simples que poderiam ser utilizadas de forma recorrente.
4. `definicaoStoredProcedures.sql` : Stored procedures que são definidas para evitar repetição de código.
5. `carragamentoDados.sql` : Carregamento de dados fictícios para execução de testes.
6. `testes.sql` : Execução de testes que utilizam (de forma bem simples) todas as funcionalidades implementadas. 

## Funcionamento

Aqui será postado um vídeo que mostra o banco de dados sendo definido e os testes sendo realizados. 