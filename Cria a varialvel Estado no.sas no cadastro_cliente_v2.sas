LIBNAME alura "/home/u59047362/AluraPlay";

/* 
 * CRIAR UMA VARIÁVEL DE ESTADO
 */

*Aplica um novo formato;
PROC FORMAT;
	VALUE estados_
		low - 09 	= "Grande SP"
		10 - 19 	= "Interior SP"
		19 <-< 29 	= "Rio de Janeiro"
		30 - 39 	= "Minas Gerais"
		80 - high 	= "Região Sul"
		OTHER 		= "Demais Estados";
RUN;


DATA teste1;
set alura.cadastro_cliente (obs=15 keep=CPF cep);*obs serve para limitar o numeros de observações ou linhas
e keep para manter apenas as variaveis ou atributos da tabela mencionadas;
/* Há tambem o DROP que retira as variaveis da tabela  */
	/*Transforma o cep numerico em string*/  /*Aplica o formato acima, necessita do ponto*/
Estado = put(input(substr(cep, 1, 2), best.), estados_.);

RUN;

PROC FORMAT;
	*Inicio do CEP => lista numerica ordenada;
	INVALUE estadosnum_
		low   -  "09" 	= 1
		"10"  -  "19" 	= 2
		"20"  -  "28" 	= 3
		"30"  -  "39" 	= 4
		"80"  -  "87" 	= 5
		OTHER 			= 6;
	*Lista numerica => Nome do estado;
	VALUE estadotxt_
		1 	  = "Grande SP"
		2 	  = "Interior SP"
		3 	  = "Rio de Janeiro"
		4 	  = "Minas Gerais"
		5     = "Região Sul"
		OTHER = "Demais Estados";
RUN;

*Crio uma base com minha variável Estado;
DATA alura.cadastro_cliente_v2;
set alura.cadastro_cliente;

Estado = input(substr(cep, 1, 2), estadosnum_.);
format Estado estadotxt_.;

RUN;

PROC FREQ
	data=alura.cadastro_cliente_v2;
	table estado;
RUN;





















