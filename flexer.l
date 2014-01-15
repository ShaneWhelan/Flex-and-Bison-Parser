%{

#include "grammar.tab.h"

%}

%option yylineno

%%

(?i:BEGIN)      {return T_BEGIN; }
(?i:END)        {return T_END;}
(?i:[S]+)       {yylval.length = yyleng; return T_INT;}
(?i:MOVE)       {return T_MOVE;}
(?i:ADD)        {return T_ADD;}
(?i:TO)         {return T_TO;}
(?i:READ)       {return T_READ;}
[,]             {return T_COMMA;}
[.]             {return T_FULLSTOP; }
(?i:PRINT)      {return T_PRINT;}
(?i:FOR)        {return T_FOR;}
[(]             {return T_OPAREN;}
[)]             {return T_CPAREN;}
(?i:STARTFOR)   {return T_STARTFOR;}
(?i:ENDFOR)     {return T_ENDFOR;}
[<]             {return T_LESSTHAN;}
[>]             {return T_GREATERTHAN;}
[?]             {return T_QMARK;}
[+]             {return T_PLUS;}
[=]             {return T_ASSIGNMENT;}
[0-9]+          {yylval.length = atoi(yytext); return T_NUMBER;}
\"([^"]*?)\"    {return T_STRING;}
[ ]+            /* Ignore whitespace*/;
(?i:[a-z][A-Z0-9_-]+)|(?i:[a-z]+) {yylval.strval = strdup(yytext); return T_IDENTIFIER; }
\n              /* Doing nothing increments yylineno */

%%
