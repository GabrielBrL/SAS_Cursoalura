/*
 * PROGRAMA CADASTRO PRODUTO E CLIENTE
 */

/* É necessario nomear o caminho do diretorio da biblioteca */
LIBNAME alura "/home/u59047362/AluraPlay";

* Checa diretorio;
PROC DATASETS
	lib=alura details;
RUN;

*Para receber os atributos da tabela juntamente com seus indices;
PROC CONTENTS
	data=alura.cadastro_produto;
RUN;

PROC CONTENTS
	data=alura.cadastro_cliente;
RUN;

*Para imprimir as informações contidas na tabela;
PROC PRINT
	data=alura.cadastro_produto;
RUN;

PROC PRINT
	data=alura.cadastro_cliente;
RUN;

*Para mostrar a frenquencia de determinados valores dentro dos atributos;
PROC FREQ
	data=alura.cadastro_cliente;
	table nome sexo;
RUN;

*Para mostrar quantas informações existem daquele mesmo tipo em determinado atributo. Exemplo: Quantos nomes existem na tabela;
PROC FREQ
	data=alura.cadastro_produto nlevels;
	table genero plataforma nome;
RUN;

*Para criar variavel;
DATA teste;
set alura.cadastro_produto;
*Condição;

LENGTH lancamento 3;

IF	data > 201606
	THEN lancamento = 1;
	ELSE lancamento = 0;
	
	
IF preco > 100
	THEN acimadopreco = "sim";
	ELSE acimadopreco = "nao";
RUN;

*imprime nova base;
PROC PRINT
	data=teste noobs;
RUN;

PROC FREQ
	data=teste;
	table lancamento acimadopreco;
RUN;

*Para mesclar tabelas;
PROC FREQ
	data=teste;
	table genero*lancamento
	/nocol norow nopercent;*sem coluna sem linha e sem porcentagem;
RUN;

*Imprime em forma de lista;
PROC FREQ
	data=alura.cadastro_produto nlevels;
	table nome;
	table nome*genero
	/list;
RUN;

*Cria um novo banco no diretorio;
DATA alura.cadastro_produto_v2;
set teste;*Atribui as modificações feitas anteriormente;
rename lancamento = flag_lancamento
		acimadopreco = flag_precoalto; *renomeia os atributos;
label Genero = "Gênero"
	lancamento = "Marca 1 para lançamentos e 0 para não lançamentos"
	acimadopreco = "sim para acima do preço e não para um preço aceitável";*descreve os atributos;
RUN;

PROC CONTENTS
	data=alura.cadastro_produto_v2; *mostra as modificações da tabela;
RUN;










