#!/bin/bash

#cleanup
rm y.* lex.yy.c

#run flex/bison and dependencies
flex ./jsc_pwc.l
yacc -d -v -t ./jsc.yacc

echo "------------------------------"
echo "Printing Tokens and Symbol Table"
echo

gcc ./lex.yy.c y.tab.c hash.c -lfl -o jsc -g && ./jsc inJs.js

echo
echo "------------------------------"
echo "Printing the file"
echo

cat lex_out.txt
