lexer grammar HtmlLexer;

OPEN: '<' -> pushMode(INSIDE) ;
COMMENT: '<!--' .*? '-->' ;
S: [ \t\r\n]+ -> skip;
TEXT: ~('<')+ ;

mode INSIDE;
CLOSE: '>' -> popMode;
SLASH_CLOSE: '/>' -> popMode;
STRING: SINGLE_QUOTE .*? SINGLE_QUOTE ;

HTML_TAGB: 'html';
HTML_TAGE: '/html';
BODY_TAGB: 'body';
BODY_TAGE: '/body';
HEAD_TAGB: 'head';
HEAD_TAGE: '/head';
SPAN_TAGB: 'span';
SPAN_TAGE: '/span';
PAR_TAGB: 'p';
PAR_TAGE: '/p';

SLASH_ID: '/' ALPHA (ALPHA|DIGIT)* ;
ID: ALPHA (ALPHA|DIGIT)* ;
EQUAL: '=' ;
SINGLE_QUOTE: ['] ;

fragment 
ALPHA:[a-zA-Z] ;

fragment
DIGIT:[0-9] ;

WS: [ \t\r\n] -> skip;
