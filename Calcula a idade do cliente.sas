LIBNAME alura "/home/u59047362/AluraPlay";

PROC CONTENTS
	data=alura.cadastro_cliente_v2;
RUN;

DATA cad_cli_idade;
set alura.cadastro_cliente_v2;

*data_nascimento = input(nascimento,YYMMDD10.);

*FORMAT data_nascimento YYMMDD10.; /*converte data para o padrão (ano-mes-dia) */
*FORMAT data_nascimento DDMMYYD10.; /*converte data para o padrão (dia-mes-ano) */
*FORMAT data_nascimento date9.; /*converte data para o padrão (diamesporextensoano)*/
*FORMAT data_nascimento YYMMN.;/*converte data para o padrão (anomes)*/

/* hoje = mdy(12,01,2017); cria uma data */

*idade = int((hoje - data_nascimento)/365);

*idade1 = intck('YEAR', data_nascimento, hoje); 


*if idade1 ~= idade2;


*FORMAT data_nascimento DDMMYY10.; /*converte data para o padrão (dia/mes/ano) */
*FORMAT hoje DDMMYY10.; /*converte data para o padrão (dia/mes/ano) */

idade = intck('YEAR', input(nascimento, YYMMDD10.), mdy(12,01,2017), 'c'); *calcula a idade usando um metodo continuo de tempo, ou seja,
os meses e dias contaram no calculo, não apenas o ano em si. USOU O 'c';

RUN;

PROC PRINT
	data=cad_cli_idade;
RUN;
