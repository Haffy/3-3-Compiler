# 3<3  Compiler

## A compiler using JS to Cafezinho language.

### To Run be sure that nodejs is installed

    sudo apt-get install nodejs
    sudo apt-get install nodejs-legacy
    sudo apt-get install npm
### Now install jison and used packages
    npm install jison
    npm install fs
### Open the dir
    cd 3-3-Compiler
### To generate grammar.js use
    jison grammar.jison


# To run an example
    node codegen.js geracaoCodigo/fatorialCorreto.txt

* #### This will return the code in JS, then copy the code, you can run this code in https://jsfiddle.net/ , paste the code in the javascript area;
* #### Open the browser console with right click anywhere and inspect element, then click in console tab.
* #### Now click in run on jsfiddle
* #### Now you can cry a lot because we dont have a symbol table yet, all that we do is translate(using a AST - abstract sintax tree), from cafezinho to JavaScript.

## Thanx; kisses; vlw flw.
