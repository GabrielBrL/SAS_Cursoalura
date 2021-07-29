LIBNAME alura "/home/u59047362/AluraPlay";

/* Classificação da variável idade */

/* Cria uma variavel que classifica a Idade em 5 faixas */

PROC RANK
	data=alura.cadastro_cliente_v3
	out=base_ranks /* Cria uma base da tabela alura.cadastro_cliente_v3 */
	groups=5; /* Número de grupos para cada intervalo, nesse caso, intervalos de idade */
	var idade; /* Variavel dos intervalos */
	ranks Faixa_Idade; /* Nova variavel para a classe */
RUN;

PROC FREQ
	data=base_ranks;
	table Faixa_Idade;
RUN;

/* Necessario ordenar a base_ranks */
PROC SORT
	data=base_ranks;
	by Faixa_Idade;
RUN;

/* PROC UNIVARIATE */
/* 	data=base_ranks; */
/* 	var Idade; */
/* 	by Faixa_Idade; */
/* RUN; */

/* PROC MEANS */
/* 	data=base_ranks noprint; */
/* 	var Idade; */
/* 	by Faixa_Idade; */
/* 	output out=base_faixas_idades  */
/* 		(drop=_TYPE_ _FREQ_) */
/* 		N=Quantidade */
/* 		MIN=Minimo */
/* 		MAX=Maximo; */
/* RUN; */


/* Resume a base_ranks por idade e seus intervalos */
PROC SUMMARY
	data=base_ranks;
	var Idade;
	by Faixa_Idade;
	output out=base_faixas_idades /* Gera um output data */
		(drop=_TYPE_ _FREQ_) /* Retira as variaveis _TYPE_ e _FREQ_ */
		N=Quantidade /* Renomeia o N para Quantidade */
		MIN=Minimo /* Renomeia MIN para Minimo */
		MAX=Maximo /* Renomeia MAX para Maximo */;
RUN;


PROC SQL;
	CREATE TABLE alura.FAIXAS_IDADE AS
	SELECT 
		Faixa_Idade label="Faixas de idade", 
		count(*) AS Quantidade label="Quantidade de idades", 
		min(idade) AS Minimo label="Idade mínima", 
		max(idade) AS Maximo label="Idade máxima"
	FROM base_ranks
	group by Faixa_Idade
;QUIT;
























