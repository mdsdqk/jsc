#!/bin/bash

#cleanup
rm y.* lex.yy.c

#run flex/bison
flex ./jsc_pwc.l
yacc -d -v ./jsc.yacc

echo "------------------------------"
echo "Printing Tokens and Symbol Table"
echo

gcc ./lex.yy.c y.tab.c -lfl -o jsc && ./jsc inJs.js

echo
#echo "------------------------------"
#echo "Printing the file"
#echo

#cat lex_out.txt