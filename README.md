Flex-and-Bison-Parser
=====================
This is a fun project that I completed for a University module "Programming Language Technology" by Jim Buckley. I achieved 25/25 for it and I'm pretty proud of how it turned out.

The file will check the syntax and semantics of a basic programming language and if an error is found the parser will report the line number and the error type. 

Flexer.l
========
The file flexer.l checks for valid regular expressions

Grammar.y
=========
Verifies the regular expression tokens fit into a grammmar. If the input file does not adhere to the grammar this file reports an error
