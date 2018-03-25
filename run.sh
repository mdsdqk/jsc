#!/bin/bash

flex ./jsc_pwc.l

echo "------------------------------"
echo "Printing Tokens and Symbol Table"
echo
gcc ./lex.yy.c -lfl -o jsc && ./jsc inJs.js

echo
echo "------------------------------"
echo "Printing the file"
#echo

cat lex_out.txt