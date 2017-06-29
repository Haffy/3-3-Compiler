var parser = require('./grammar').parser;

if (process.argv.length < 3) {
  console.log('Usage: node ' + process.argv[1] + ' FILENAME');
  process.exit(1);
}
// Read the file and print its contents.
var fs = require('fs'),
  filename = process.argv[2];
fs.readFile(filename, 'utf8', function(err, program) {
  if (err) throw err;
console.log('************************ CODIGO EM CAFEZINHO\n'+program+'\n\n\n\n');

  /*
  programa-node
  id-node
  vector-node
  declfuncvar-node
  declprog-node
  intconst-node
  declvar-node
  notype-id-node
  notype-vector-node
  declfunc-node
  listaparametros-node
  nosize-vector-node
  listaparametroscont-node
  listadeclvar-node
  int-node
  car-node
  listacomando-nodew

  comando-vazio-node
  comando-expr-node
  comando-retorne-node
  comando-leia-node
  comando-escreva-node
  comando-novalinha-node
  comando-seentao-node
  comando-seentaosenao
  comando-enquanto-node
  assignexpr-node
  assignexpr-vector-node
  or-node
  and-node
  equals-node
  dif-node
  'less-node'
  'greater-node'
  'greater-equals-node'
  'less-equals-node'
  'plus-node'
  'minus-node'
  'multiplication-node'
  'division-node'
  'modulus-node'
  'negation-node'
  'no-node'
  'access-vector-node'
  'function-node'
  access-vector-node'
  notype-id-node'

  'string-node'
  'listexpr-node'
  */

  function main() {
    var ast = parser.parse(program);
    console.log('#################### ARVORE SINTATICA ABSTRATA\n');
		console.log(ast);
		console.log('\n\n\n')
// console.log(ast)
    var source = codegen(ast);

    console.log(source);
  }

  function codegen(ast) {
    if (ast)
      switch (ast[0]) {
        case 'programa-node':
          return codegen(ast[2]) + '\nmain =function()' + codegen(ast[3]) + '\nmain(); '

        case 'id-node':
          return "var " + ast[1].name;

        case 'vector-node':
          return "var " + ast[1].name + "= new Array(" + codegen(ast[1].size) + ")";

        case 'declfuncvar-node':
          return codegen(ast[3]) + codegen(ast[4]) + '\n' + codegen(ast[5]);

        case 'declprog-node':
          return codegen(ast[2]) + '\n';

        case 'intconst-node':
          return ast[1].val;

        case 'declvar-node':
          return ' , ' + codegen(ast[2]) + codegen(ast[3]);

        case 'notype-id-node':
          return ast[1].name;

        case 'notype-vector-node':
          return ast[1].name + "= new Array(" + codegen(ast[1].size) + ")";

        case 'declfunc-node':
          return '=function(' + codegen(ast[2]) + ')' + codegen(ast[3]);

        case 'listaparametros-node':
          return codegen(ast[2]);

        case 'listaparametroscont-node':
          return codegen(ast[2]) + ' , ' + codegen(ast[3]);

        case 'nosize-vector-node':
          return ast[1].name;

        case 'bloco-listacomando-node':
          return '{\n' + codegen(ast[2]) + '\n' + codegen(ast[3]) + '\n}\n';

        case 'bloco-node':
          return '{\n' + codegen(ast[2]) + '\n}\n';


        case 'listadeclvar-node':
          return codegen(ast[2]) + ' ' + codegen(ast[3]) + ';\n' + codegen(ast[4]);

        case 'comando-node':
          return codegen(ast[2]) + ';\n';

        case 'listacomando-node':
          return codegen(ast[2]) + ' ' + codegen(ast[3]);

        case 'intconst-node':
          return ast[1].val;

        case 'carconst-node':
          return ast[1].val;

        case 'comando-vazio-node':
          return ';';

        case 'comando-expr-node':
          return codegen(ast[2]) + ';\n';

        case 'comando-retorne-node':
          return 'return ' + codegen(ast[2]);

        case 'comando-leia-node':

          return codegen(ast[2]) + '=parseInt(prompt());\n';

        case 'comando-escreva-node':
          return 'console.log(' + codegen(ast[2]) + ');\n';

        case 'comando-novalinha-node':
          return ' ';

        case 'comando-seentao-node':
          return 'if(' + codegen(ast[2]) + '){\n' + codegen(ast[3]) + '}\n';

        case 'comando-seentaosenao':
          return 'if(' + codegen(ast[2]) + '){\n' + codegen(ast[3]) + '}\nelse{ ' + codegen(ast[4]) + '}\n';

        case 'comando-enquanto-node':
          return 'while(' + codegen(ast[2]) + ')' + codegen(ast[3]) + '\n';

        case 'assignexpr-node':
          return codegen(ast[2]) + ' = ' + codegen(ast[3]);

        case 'assignexpr-vector-node':
          return codegen(ast[2]) + '[' + codegen(ast[3]) + '] = ' + codegen(ast[4]);

        case 'or-node':
          return codegen(ast[2]) + ' || ' + codegen(ast[3]);

        case 'and-node':
          return codegen(ast[2]) + ' && ' + codegen(ast[3]);

        case 'equals-node':
          return codegen(ast[2]) + ' == ' + codegen(ast[3]);

        case 'dif-node':
          return codegen(ast[2]) + ' != ' + codegen(ast[3]);

        case 'less-node':
          return codegen(ast[2]) + ' < ' + codegen(ast[3]);

        case 'greater-node':
          return codegen(ast[2]) + ' > ' + codegen(ast[3]);

        case 'greater-equals-node':
          return codegen(ast[2]) + ' >= ' + codegen(ast[3]);

        case 'less-equals-node':
          return codegen(ast[2]) + ' <= ' + codegen(ast[3]);

        case 'plus-node':
          return codegen(ast[2]) + ' + ' + codegen(ast[3]);

        case 'minus-node':
          return codegen(ast[2]) + ' - ' + codegen(ast[3]);

        case 'multiplication-node':
          return codegen(ast[2]) + ' * ' + codegen(ast[3]);

        case 'division-node':
          return codegen(ast[2]) + ' / ' + codegen(ast[3]);

        case 'modulus-node':
          return codegen(ast[2]) + ' % ' + codegen(ast[3]);

        case 'negation-node':
          return '-' + codegen(ast[2]);

        case 'no-node':
          return '!' + codegen(ast[2]);

        case 'access-vector-node':
          return ast[1].name + '[' + codegen(ast[1].position) + ']';

        case 'function-node':
          return ast[1].name + '()';

        case 'function-params-node':
          return ast[1].name + '(' + codegen(ast[2]) + ')';

        case 'string-node':
          return ast[1].text;

        case 'listexpr-node':
          return codegen(ast[2]) + ' , ' + codegen(ast[3]);

        case 'null':
          return '';

        case 'comando-expr-vector-node':
          return codegen(ast[2]);


        default:
          return 'Unknown statement/expression: ' + ast[0];
      }
  }


function codegenList(list) {
  return list.reduce(function(prev, curr) {
    return prev + codegen(curr);
  }, '');
}

main();
});
