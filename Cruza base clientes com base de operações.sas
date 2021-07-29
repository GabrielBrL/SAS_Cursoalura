LIBNAME alura "/home/u59047362/AluraPlay";

/* Analise de quantos jogos cada cliente alugou em 201709 */

PROC CONTENTS
	data=alura.operacoes_201709 varnum;
RUN;

PROC CONTENTS
	data=alura.cadastro_cliente_v3 varnum;
RUN;

/* Agrupado a base de operações de 201709 por cpf */
PROC SQL;
	CREATE TABLE contratos_cpf AS
	SELECT cpf, count(*) AS Quantidade_jogos
	FROM alura.operacoes_201709
	GROUP BY cpf;
QUIT;

/* Converter o CPF da base clientes em CPF raiz */

DATA cad_cli_cpf_raiz;
set alura.cadastro_cliente_v3;

CPF_RAIZ = input(substr(cpf, 1,11), COMMAX11.0);

RUN;

/* Ordenar base clientes */
PROC SORT
	data=cad_cli_cpf_raiz
	out=cad_cli_cpf_sort
	nodupkey;
	by CPF_RAIZ;
RUN;

PROC CONTENTS
	data=cad_cli_cpf_sort;
RUN;

PROC CONTENTS
	data=contratos_cpf;
RUN;

/* Cruzamento das bases usando data merge */

DATA cad_cli_jogos;
merge cad_cli_cpf_sort (in=A)/* Um verificador para concluir se todos os dados mesclados tem a mesma chave */
	contratos_cpf
	(rename=(CPF=CPF_RAIZ));
by CPF_RAIZ;
if a; /* Caso algum CPF não exista na outra tabela, a linha não recebe o A, logo não será incluida no merge */
RUN;

PROC PRINT data=cad_cli_jogos; RUN;
PROC PRINT data=contratos_cpf; RUN;


