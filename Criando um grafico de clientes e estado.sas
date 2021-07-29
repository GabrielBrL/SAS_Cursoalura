LIBNAME alura "/home/u59047362/AluraPlay";

PROC FORMAT;
	VALUE estados_
		1 	  = "Grande SP"
		2 	  = "Interior SP"
		3 	  = "Rio de Janeiro"
		4 	  = "Minas Gerais"
		5     = "Parana"
		OTHER = "Demais Estados";
RUN;

DATA alura.CADASTRO_CLIENTE_V3;
set alura.CADASTRO_CLIENTE_V2;

/* FORMAT Estado estados_.; */
Estado = put(input(estado, best.), estados_.)

Idade = intck('YEAR', input(nascimento, YYMMDD10.), mdy(12,1,2017), 'c');

RUN;

TITLE "Quantidade de clientes por estado e idade.";
PROC FREQ
	data=alura.cadastro_cliente_v3;
	table estado idade;
RUN;
TITLE;

/* Cria um gráfico de clientes por estado */
TITLE "Quantidade de clientes por estado.";
PROC SGPLOT
	data=alura.CADASTRO_CLIENTE_V3;
/*Gráfico de barra na vertical	*/ /* Variavel do gráfico */  /* Preenchimento = cor = verde */
	         vbar                          estado             /fillattrs=(color=green);
/*eixo Y*/ /*legenda no eixo*/       /* exibirá os valores de Y de 0 a 35 indo de 5 em 5 */   /* linhas de grade no eixo e sublinhas */
	yaxis label="Número de clientes"                 values=(0 to 35 by 5)                               grid minor minorcount=4;
RUN;
TITLE;

TITLE "Quantidade de clientes por faixa de idade.";
PROC SGPLOT
	data=alura.cadastro_cliente_v3;
/* Histograma das idades */
/* Escolhe intervalos de idade. Ex: 16 a 20, 21 a 25... */
	histogram idade /fillattrs=(color=green);
	yaxis grid minor minorcount=9 label="Número de clientes";
	xaxis grid minor minorcount=9 label="Idade(anos)";
RUN;
TITLE;

PROC UNIVARIATE
	data=alura.cadastro_cliente_v3;
	var idade;
	histogram;
RUN;








