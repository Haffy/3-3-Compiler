/* description: Simple expressions */

%lex
%%

\s+         { /* ignore */ }
\"[a-zA-Z]\" { return 'CARCONST'}
\".*\"      { return 'CADEIACARACTERES'}
"car"	    	{ return 'CAR';}
"e"			    { return 'e';}
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
"ou"        { return 'ou';}
[0-9]+      { return 'INTCONST'; }
[a-zA-Z_][_a-zA-Z0-9]*   { return 'ID'; }
"<="		    { return '<=';}
">="		    { return '>=';}
"=="		    { return '==';}
"!="		    { return '!=';}
";"			    { return ';';}
"{"			    { return '{';}
"}"			    { return '}';}
","			    { return ',';}
":"			    { return ':';}
"="			    { return '=';}
"("			    { return '(';}
")"			    { return ')';}
"["			    { return '[';}
"]"			    { return ']';}
"!"			    { return '!';}
"-"			    { return '-';}
"+"			    { return '+';}
"*"			    { return '*';}
"/"			    { return '/';}
"%"			    { return '%';}
"<"			    { return '<';}
">"			    { return '>';}
"?"			    { return '?';}
\n          { /*new line*/ }
[ \t\v\f] { /* eat useless characters */ }


/lex


%%

Programa
  : DeclFuncVar DeclProg
  ;

DeclFuncVar
  : Tipo ID DeclVar ';' DeclFuncVar
  | Tipo ID '['INTCONST']' DeclVar ';' DeclFuncVar
  | Tipo ID DeclFunc DeclFuncVar
  |
  ;

DeclProg
  : PROGRAMA Bloco
  ;

DeclVar
  : ',' ID DeclVar
  | ',' ID '['INTCONST']' DeclVar
  |
  ;

DeclFunc
  : '('ListaParametros')' Bloco
  ;

ListaParametros
  :
  | ListaParametrosCont
  ;

ListaParametrosCont
  : Tipo ID
  | Tipo ID '['']'
  | Tipo ID ',' ListaParametrosCont
  | Tipo ID '['']' ',' ListaParametrosCont
  ;

Bloco
  : '{' ListaDeclVar ListaComando '}'
  | '{' ListaDeclVar '}'
  ;

ListaDeclVar
  :
  | Tipo ID DeclVar ';' ListaDeclVar
  | Tipo ID '['INTCONST']' DeclVar ';' ListaDeclVar
  ;

Tipo
  : INT
  | CAR
  ;

ListaComando
  : Comando
  | Comando ListaComando
  ;

Comando
  : ';'
  | Expr ';'
  | RETORNE Expr ';'
  | LEIA LValueExpr ';'
  | ESCREVA Expr ';'
  | ESCREVA CADEIACARACTERES ';'
  | NOVALINHA ';'
  | SE '(' Expr ')' ENTAO Comando
  | SE '(' Expr ')' ENTAO Comando SENAO Comando
  | ENQUANTO '(' Expr ')' EXECUTE Comando
  | Bloco
  ;

Expr
  : AssignExpr
  ;

AssignExpr
  : CondExpr
  | ID '=' AssignExpr
  | ID '[' Expr ']' '=' AssignExpr
  ;

CondExpr
  : OrExpr
  | OrExpr '?' Expr ':' CondExpr
  ;

OrExpr
  : OrExpr OU AndExpr
  | AndExpr
  ;

AndExpr
  : AndExpr E EqExpr
  | EqExpr
  ;

EqExpr
  : EqExpr '==' DesigExpr
  | EqExpr '!=' DesigExpr
  | DesigExpr
  ;

DesigExpr
  : DesigExpr '<' AddExpr
  | DesigExpr '>' AddExpr
  | DesigExpr '>=' AddExpr
  | DesigExpr '<=' AddExpr
  | AddExpr
  ;

AddExpr
  : AddExpr '+' MulExpr
  | AddExpr '-' MulExpr
  | MulExpr
  ;

MulExpr
  : MulExpr '*' UnExpr
  | MulExpr '/' UnExpr
  | MulExpr '%' UnExpr
  | UnExpr
  ;

UnExpr
  : '-'PrimExpr
  | '!'PrimExpr
  | PrimExpr
  ;

LValueExpr
  : ID '[' Expr ']'
  | ID
  ;

PrimExpr
  : ID '(' ListExpr ')'
  | ID '('')'
  | ID '['Expr']'
  | ID
  | CARCONST
  | INTCONST
  | '('Expr')'
  ;

ListExpr
  :AssignExpr
  |ListExpr ',' AssignExpr
  ;
