grammar SvSpec;

top: (sentence|comment)+ ;

sentence: ruleName equals oredExpr ';' ;

equals: ':'|'='|'*=' ;

ruleName: ID ;

oredExpr:  expr ('|' expr)* ;

expr:
    terminal         
  | nonTerminal      
  | expr expr        
  | zeroOrMoreExpr   
  | optionalExpr     
  | attribExpr
  | '(' oredExpr ')'
;

attrib: '<' ID '=' ID '>' ;

nonTerminal: ID ;

zeroOrMoreExpr: '{' oredExpr '}' ;

optionalExpr: '[' oredExpr ']' ;

attribExpr: attrib expr ;

terminal: QUOTED_STR ;

comment: COMMENT ;

COMMENT: '//' .*? CR ;

WS: [ \t\r\n]+ -> skip ;

ML_COMMENT: '/*' .*? '*/' -> skip ;

fragment CR: '\r'? '\n' ;

ID: [a-zA-Z$_] [a-zA-Z_0-9]* ;

QUOTED_STR: ['] (~' ')+? ['] ;

