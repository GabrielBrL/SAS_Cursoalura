/*
 * Análise sobre a variavel de data da base de cadastro
 */

*Verifica quantos jogos estão com as datas sem numeração;
PROC FREQ
	data=alura.cadastro_produto_v2;
	table data /missing;
RUN;

*Verifica quais jogos estão sem a data
DATA teste;
set alura.cadastro_produto_v2;

WHERE data = .;

RUN;

*Verifica quais jogos estão sem a data
DATA teste2;
set alura.cadastro_produto_v2;

WHERE nome in ("Soccer", "Forgotten Echo", "Fireshock");

PROC FREQ
	data=teste2;
	table nome*data
	/list missing;
RUN;

*Verifica quais jogos estão sem a data;
PROC FREQ
	data=alura.cadastro_produto_v2
		(where=(nome in ("Soccer", "Forgotten Echo", "Fireshock")));
	table nome*data
		/list missing;
RUN;

DATA teste3;
set alura.cadastro_produto_v2;

IF data = . THEN DO; *Quais jogos tem na data = . portanto faça...;
	IF nome = "Soccer" 			THEN data = 201709;
	IF nome = "Forgotten Echo" 	THEN data = 201411;
	IF nome = "Fireshock" 		THEN data = 201706;
END; *Para a execução do primeiro IF;

RUN;


DATA teste3;
set alura.cadastro_produto_v2;

IF data = . THEN DO; *Quais jogos tem na data = . portanto faça...;
	SELECT(nome); *Estrutura de seleção;
		WHEN ("Fireshock") 		data = 201706; *Quando for tal nome atribua o valor X na data;
		WHEN ("Forgotten Echo") data = 201411; *Quando for tal nome atribua o valor X na data;
		WHEN ("Soccer") 		data = 201709; *Quando for tal nome atribua o valor X na data;
		OTHERWISE; *Caso nenhuma das seleções anteriores seja verdadeira faça...;
	END; *Termina a execução do SELECT;
END; *Para a execução do primeiro IF;

RUN;

*Mostra as modificações feitas na data;
PROC FREQ
	data=teste3
		(where=(nome in ("Soccer", "Forgotten Echo", "Fireshock")));
	table nome*data
		/list missing;
RUN;

*Cria um novo arquivo sobre o teste3;
DATA alura.cadastro_produto_v3;
set teste3;

*Atribui na nova variavel já criada flag_lancamento os valores;
IF	data > 201606
	THEN flag_lancamento = 1;
	ELSE flag_lancamento = 0;
	
	label flag_lancamento = "Marca 1 para lançamentos e 0 para não lançamentos";

RUN;

PROC FREQ
	data=alura.cadastro_produto_v3
		(where=(nome in ("Soccer", "Forgotten Echo", "Fireshock")));
	table nome*data
		/list missing;
RUN;

PROC FREQ 
	data=alura.cadastro_produto_v3;
	table flag_lancamento;
RUN;

PROC FREQ 
	data=alura.cadastro_produto_v2;
	table flag_lancamento;
RUN;


DATA teste4;
set alura.cadastro_produto_v3;

IF data > 201606 THEN identificador_idade = "Lançamento"; ELSE
IF data < 201401 THEN identificador_idade = "Antigo";
ELSE identificador_idade = "Outro";

RUN;


DATA alura.cadastro_produto_v4;
set teste4;

label identificador_idade = "Identifica se um jogo é 
Lançamento(a partir de 06/2016), 
se é Antigo (anterior a 01/2014) 
e Outro(quando não obedece nenhuma das outras condições)";

RUN;

DATA teste4;
set alura.cadastro_produto_v3;

IF data > 201606 THEN DO;
	identificador_idade = "Lançamento";
	preco = preco - 10;
END;
	ELSE IF data < 201401 THEN DO;
		identificador_idade = "Antigo";
		preco = preco * 1.1;
	END; 
		ELSE DO;
			identificador_idade = "Outro";
		END;
RUN;

PROC FREQ	
	data=teste4;
	table nome*preco
		/list;
RUN;