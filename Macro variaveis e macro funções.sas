LIBNAME alura "/home/u59047362/AluraPlay";

/*
 * Analise de quantos jogos cada cliente alugou no 4º trimestre de 2017 
 */

PROC CONTENTS data=alura.operacoes_201710 varnum;RUN;
PROC CONTENTS data=alura.operacoes_201711 varnum;RUN;
PROC CONTENTS data=alura.operacoes_201712 varnum;RUN;


/* Empilhar as bases do quarto trimestre de 2017 */

PROC SQL;
	create table operacoes_2017T4 as
	select *
	from alura.operacoes_201710
	union all
	select *
	from alura.operacoes_201711
	union all
	select *
	from alura.operacoes_201712
;QUIT;

DATA operacoes_2017T4;
set alura.operacoes_201710
	alura.operacoes_201711
	alura.operacoes_201712;
RUN;


PROC SQL;
	create table CADASTRO_CLIENTE_JOGOS_2017T4 as
	select a.*,
		b.Total_contratos_2017T4,
		b.Contratos_validos_2017T4
	from alura.cadastro_cliente_v3 as A
	left join (
		select CPF,
		count(*) as Total_contratos_2017T4,
		sum(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 or CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) as Contratos_validos_2017T4
		from operacoes_2017T4
		group by cpf
		) as B
	on input(substr(a.cpf,1,11), COMMAX11.0) = b.CPF;
QUIT;

/* Analisar a quantidade de jogos dos clientes em cada um dos meses do 4º trimestre de 2017 */

PROC SQL;
	create table operacoes_2017T4_consolidada as
	select SAFRA, CPF,
		count(*) as Total_contratos_2017T4,
		sum(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 or CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) as Contratos_validos_2017T4
	from operacoes_2017T4
	group by 1,2
;QUIT;

/* Separar cada mês da base de operações consolidadas */

DATA operacoes_201710_consolidada
	 operacoes_201711_consolidada
	 operacoes_201712_consolidada;
set  operacoes_2017T4_consolidada;

IF SAFRA = 201710 THEN OUTPUT operacoes_201710_consolidada;ELSE
IF SAFRA = 201711 THEN OUTPUT operacoes_201711_consolidada;ELSE
IF SAFRA = 201712 THEN OUTPUT operacoes_201712_consolidada;

RUN;

/* Cruzamento da base de clientes com as operações de 2017 */
%LET safra = 201710; /*Criar uma macro variavel */


%MACRO cruza_clientes_jogos (safra);
PROC SQL;
	create table cadastro_cliente_jogos_&safra as
	select a.*,
		b.Total_contratos_2017T4 as Total_contratos_&safra.,
		b.Contratos_validos_2017T4 as Contratos_validos_&safra.
	from alura.cadastro_cliente_v3 as A
	left join operacoes_&safra._consolidada as B
	on input(substr(a.cpf,1,11), COMMAX11.0) = b.CPF
;QUIT;

%MEND cruza_clientes_jogos;

%cruza_clientes_jogos(201710);
%cruza_clientes_jogos(201711);
%cruza_clientes_jogos(201712);



















	
