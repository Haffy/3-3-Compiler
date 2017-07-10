%lex
%%

\s+         { /* ignore spaces*/ }
\/\*.*\*\/  {  /* ignore comments */  }
\/\*.*      {throw new SyntaxError('ERRO: COMENTÁRIO NÃO TERMINA (L'+yylineno+1+')')}
\"[a-zA-Z]\" { return 'CARCONST'}
\".*\n.*\" {throw new SyntaxError('ERRO: CADEIA DE CARACTERES OCUPA MAIS DE UMA LINHA (L'+yylineno+1+')')}
\"[_a-zA-Z0-9 :]*\"     { return 'CADEIACARACTERES'}
"car"	    	{ return 'CAR';}
"e"			    { return 'E';}
"enquanto"	{ return 'ENQUANTO';}
"entao"		  { return 'ENTAO';}
"escreva" 	{ return 'ESCREVA';}
"execute"	  { return 'EXECUTE';}
"int"		    { return 'INT';}
"leia"		  { return 'LEIA';}
"novalinha"	{ return 'NOVALINHA';}
"programa"	{ return 'PROGRAMA';}
"retorne"	  { return 'RETORNE';}
"se"		    { return 'SE';}
"senao"		  { return 'SENAO';}
"ou"        { return 'OU';}
[0-9]+      { return 'INTCONST'; }
[a-zA-Z_][_a-zA-Z0-9]*   { return 'ID'; }
">="		    { return '>=';}
"<="		    { return '<=';}
"=="		    { return '==';}
"!="		    { return '!=';}
"<"			    { return '<';}
">"			    { return '>';}
"="			    { return '=';}
";"			    { return ';';}
","			    { return ',';}
":"			    { return ':';}
"("			    { return '(';}
")"			    { return ')';}
"["			    { return '[';}
"]"			    { return ']';}
"{"			    { return '{';}
"}"			    { return '}';}
"+"			    { return '+';}
"-"			    { return '-';}
"*"			    { return '*';}
"/"			    { return '/';}
"%"			    { return '%';}
"?"			    { return '?';}
"!"			    { return '!';}
\n          { /* ignore break line*/ }
\f          { /* ignore*/ }
\r          { /* ignore*/ }
\t          { /* ignore*/ }
<<EOF>>         { /* ignore*/ }
.*          {throw new SyntaxError('ERRO: CARACTERE INVÁLIDO (' +yytext+ ', L' +yylineno+1+')')}

/lex


%%

Programa
  : DeclFuncVar DeclProg
     {{ $$=['programa-node', {},$1,$2]; return $$ }}
  ;

DeclFuncVar
  : Tipo ID DeclVar ';' DeclFuncVar
    {{
        id=['id-node', {type:$1,name:$2}];
        $$ = ['declfuncvar-node', {}, $1, id, $3, $5];
    }}
  | Tipo ID '['INTCONST']' DeclVar ';' DeclFuncVar
    {{
        intconst=['intconst-node',{val:$4}];
        vector=['vector-node', {type:$1, name:$2, size:intconst}];

        $$ = ['declfuncvar-node', {}, $1, vector, $6, $8];
    }}
  | Tipo ID DeclFunc DeclFuncVar
    {{
        id=['id-node', {type:$1,name:$2}];
        $$ = ['declfuncvar-node', {},$1, id, $3, $4];
    }}
  |
    {{
        $$ = ['null',{},null] ;
    }}
  ;

DeclProg
  : PROGRAMA Bloco
    {{
        $$ = ['declprog-node',{},$2];
    }}
  ;

DeclVar
  : ',' ID DeclVar
    {{
        id=['notype-id-node', {name:$2}];
        $$=['declvar-node',{},id,$3]
    }}
  | ',' ID '['INTCONST']' DeclVar
    {{
        intconst=['intconst-node',{val:$4}];
        vector=['notype-vector-node', {name:$2, size:intconst}];
        $$=['declvar-node',{},vector,$6];
    }}
  |
    {{
        $$=['null',{},null];
    }}
  ;

DeclFunc
  : '('ListaParametros')' Bloco
    {{
        $$=['declfunc-node',{},$2,$4];
    }}
  ;

ListaParametros
  :
    {{
        $$=['null',{},null];
    }}
  | ListaParametrosCont
    {{
        $$=$1;
    }}
  ;

ListaParametrosCont
  : Tipo ID
    {{
        id=['notype-id-node', {type:$1,name:$2}]; //###  ALTERE AQUI PARA COMPILAR PARA LINGUAGENS QUE DECLARAM VARIAVEI EM PARAMETROS, id-node
        $$=['listaparametros-node',{},id];
    }}
  | Tipo ID '['']'
    {{
        vector=['nosize-vector-node',{type:$1, name:$2}];
        $$=['listaparametros-node',{},vector];
    }}
  | Tipo ID ',' ListaParametrosCont
    {{
        id=['notype-id-node', {type:$1,name:$2}];
        $$=['listaparametroscont-node',{},id,$4];
    }}
  | Tipo ID '['']' ',' ListaParametrosCont
    {{
        vector=['nosize-vector-node',{type:$1, name:$2}];
        $$=['listaparametroscont-node',{},vector,$6];
    }}
  ;

Bloco
  : '{' ListaDeclVar ListaComando '}'
    {{
        $$=['bloco-listacomando-node',{},$2,$3]
    }}
  | '{' ListaDeclVar '}'
    {{
        $$=['bloco-node',{},$2]
    }}
  ;

ListaDeclVar
  :
    {{
        $$=['null',{},null];
    }}
  | Tipo ID DeclVar ';' ListaDeclVar
    {{
        id=['id-node', {type:$1,name:$2}];
        $$=['listadeclvar-node',{},id,$3,$5];
    }}
  | Tipo ID '['INTCONST']' DeclVar ';' ListaDeclVar
    {{
      intconst=['intconst-node',{val:$4}];
      vector=['vector-node', {type:$1, name:$2, size:intconst}];
      $$=['listadeclvar-node',{}, vector,$6,$8];
    }}
  ;

Tipo
  : INT
    {{
      $$=$1
    }}
  | CAR
    {{
      $$=$1
    }}
  ;

ListaComando
  : Comando
    {{
      $$=['comando-node',{},$1];
    }}
  | Comando ListaComando
    {{
      $$=['listacomando-node',{},$1,$2];
    }}
  ;

Comando
  : ';'
    {{
      $$=['comando-vazio-node'];
    }}
  | Expr ';'
    {{
      $$=['comando-expr-node',{},$1];
    }}
  | RETORNE Expr ';'
    {{
      $$=['comando-retorne-node',{},$2];
    }}
  | LEIA LValueExpr ';'
    {{
      $$=['comando-leia-node',{},$2];
    }}
  | ESCREVA Expr ';'
    {{
      expr=['comando-expr-vector-node',{},$2]
      $$=['comando-escreva-node',{},expr];
    }}
  | ESCREVA CADEIACARACTERES ';'
    {{
      string=['string-node',{text:$2}]
      $$=['comando-escreva-node',{},string];
    }}
  | NOVALINHA ';'
    {{
      $$=['comando-novalinha-node'];
    }}
  | SE '(' Expr ')' ENTAO Comando
    {{
      $$=['comando-seentao-node',{},$3,$6];
    }}
  | SE '(' Expr ')' ENTAO Comando SENAO Comando
    {{
      $$=['comando-seentaosenao',{},$3,$6,$8];
    }}
  | ENQUANTO '(' Expr ')' EXECUTE Comando
    {{
      $$=['comando-enquanto-node',{},$3,$6];
    }}
  | Bloco
    {{
        $$=$1;
    }}
  ;

Expr
  : AssignExpr
    {{
        $$=$1;
    }}
  ;

AssignExpr
  : CondExpr
    {{
      $$=$1;
    }}
  | ID '=' AssignExpr
    {{
      id=['notype-id-node', {name:$1}];
      $$=['assignexpr-node',{},id,$3];
    }}
  | ID '[' Expr ']' '=' AssignExpr
    {{
      id=['notype-id-node', {name:$1}];
      $$=['assignexpr-vector-node',{},id,$3,$6];
    }}
  ;

CondExpr
  : OrExpr
    {{
      $$=$1;
    }}
  | OrExpr '?' Expr ':' CondExpr
    {{
      $$=['comando-seentaosenao',{},$1,$2,$5];
    }}
  ;

OrExpr
  : OrExpr OU AndExpr
    {{
      $$=['or-node',{},$1,$3];
    }}
  | AndExpr
    {{
      $$=$1;
    }}
  ;

AndExpr
  : AndExpr E EqExpr
    {{
      $$=['and-node',{},$1,$3];
    }}
  | EqExpr
    {{
      $$=$1;
    }}
  ;

EqExpr
  : EqExpr '==' DesigExpr
    {{
      $$=['equals-node',{},$1,$3];
    }}
  | EqExpr '!=' DesigExpr
    {{
      $$=['dif-node',{},$1,$3];
    }}
  | DesigExpr
    {{
      $$=$1;
    }}
  ;

DesigExpr
  : DesigExpr '<' AddExpr
    {{
      $$=['less-node',{},$1,$3];
    }}
  | DesigExpr '>' AddExpr
    {{
      $$=['greater-node',{},$1,$3];
    }}
  | DesigExpr '>=' AddExpr
    {{
      $$=['greater-equals-node',{},$1,$3];
    }}
  | DesigExpr '<=' AddExpr
    {{
      $$=['less-equals-node',{},$1,$3];
    }}
  | AddExpr
    {{
      $$=$1;
    }}
  ;

AddExpr
  : AddExpr '+' MulExpr
    {{
      $$=['plus-node',{},$1,$3];
    }}
  | AddExpr '-' MulExpr
    {{
      $$=['minus-node',{},$1,$3];
    }}
  | MulExpr
    {{
      $$=$1;
    }}
  ;

MulExpr
  : MulExpr '*' UnExpr
    {{
      $$=['multiplication-node',{},$1,$3];
    }}
  | MulExpr '/' UnExpr
    {{
      $$=['division-node',{},$1,$3];
    }}
  | MulExpr '%' UnExpr
    {{
      $$=['modulus-node',{},$1,$3];
    }}
  | UnExpr
    {{
      $$=$1;
    }}
  ;

UnExpr
  : '-'PrimExpr
    {{
      $$=['negation-node',{},$2];
    }}
  | '!'PrimExpr
    {{
      $$=['no-node',{},$2];
    }}
  | PrimExpr
    {{
      $$=$1;
    }}
  ;

LValueExpr
  : ID '[' Expr ']'
    {{
      $$=['access-vector-node', {name:$1, position:$3}];
    }}
  | ID
    {{
      $$=['notype-id-node', {name:$1}];
    }}
  ;

PrimExpr
  : ID '(' ListExpr ')'
    {{
      $$=['function-params-node', {name:$1},$3];
    }}
  | ID '('')'
    {{
      $$=['function-node', {name:$1}];
    }}
  | ID '['Expr']'
    {{
      $$=['access-vector-node', {name:$1, position:$3}];
    }}
  | ID
    {{
      $$=['notype-id-node', {name:$1}];
    }}
  | CARCONST
    {{
      $$=['carconst-node', {val:$1}];
    }}
  | INTCONST
  {{
    $$=['intconst-node', {val:$1}];
  }}
  | '('Expr')'
    {{
      $$=$2;
    }}
  | CADEIACARACTERES
    {{
      $$=['string-node', {text:$1}];
    }}
  ;

ListExpr
  :AssignExpr
    {{
      $$=$1;
    }}
  |ListExpr ',' AssignExpr
  {{
    $$=['listexpr-node', {},$1,$3];
  }}
  ;
