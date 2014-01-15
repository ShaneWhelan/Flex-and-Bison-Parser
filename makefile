clear;
bison -dv grammar.y
flex flexer.l ;
gcc -c lex.yy.c grammar.tab.c ;
gcc -o parser lex.yy.o grammar.tab.o; 
./parser testfile1 > result.txt ;
nohup sublime result.txt > /dev/null 2>&1&
