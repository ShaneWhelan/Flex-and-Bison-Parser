A Flex and Bison Parser for Basic Programming Language
=====================
This project is a Parser (using Bison) and Lexical analysis tool (using Flex) which will check the syntax and semantics of a basic programming language. 
- If a semantic error is found the parser will report the line number and a detailed error. 
- If a syntax error is found the parser will report the line number and error type.

This is a fun project that I completed for a University module "Programming Language Technology" by Jim Buckley. I achieved 25/25 for the project and I'm pretty proud of how it turned out.

Flexer.l
--------
The file flexer.l checks for valid regular expressions. If a valid expression is found an identifting token is returned to Grammar.y.

Grammar.y
---------
Verifies the regular expression tokens fit into a grammar. If the input file does not adhere to the grammar, this file reports an error.

Makefile
--------
Just run the makefile with flex and bison installed to see what it does.
