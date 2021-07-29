LIBNAME alura "/home/u59047362/AluraPlay";

PROC SQL;
	create table contratos_cpf as
	select CPF, count(*) as Quantidade_jogos
	from alura.operacoes_201709
	group by cpf;
QUIT;

DATA cad_cli_cpf_raiz;
set alura.cadastro_cliente_v3;
CPF_RAIZ = input(substr(cpf,1,11), COMMAX11.0);
RUN;

/* Cruzamento das bases usando o PROC SQL */

PROC SQL;
	create table cadastro_cliente_jogos as
	select a.*, b.Quantidade_jogos
	from cad_cli_cpf_raiz as A
	left join contratos_cpf as B
	on a.CPF_RAIZ = b.CPF;
QUIT;

PROC SQL;
	create table cadastro_cliente_jogos as
	select a.*, b.Quantidade_jogos
	from alura.cadastro_cliente_v3 as A
	left join (
		select CPF, count(*) as Quantidade_jogos
		from alura.operacoes_201709
		group by cpf 
	) as B
	on input(substr(a.cpf,1,11), COMMAX11.0) = b.CPF;
QUIT;


PROC PRINT data=alura.operacoes_201709;RUN;

/* Código auxiliar */

PROC SQL;
	create table contratos_validos_cpf as
	select CPF,
		count(*) as Total_contratos,
		sum(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 or CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) as Contratos_validos
	from alura.operacoes_201709
/* 	having flag_valida = 1 */
	group by cpf
;QUIT;

/* Adicionando a base de clientes o total de jogos e a qualidade de operações válidas */

PROC SQL;
	create table alura.CADASTRO_CLIENTE_JOGOS as
	select a.*, b.Total_contratos, b.Contratos_validos
	from alura.cadastro_cliente_v3 as A
	left join (
		select CPF,
		count(*) as Total_contratos,
		sum(CASE WHEN DATA_RETORNO - DATA_RETIRADA > 30 or CUSTO_REPARO > 0
			THEN 0
			ELSE 1
			END) as Contratos_validos
		from alura.operacoes_201709
		group by cpf
		) as B
	on input(substr(a.cpf,1,11), COMMAX11.0) = b.CPF;
QUIT;





















