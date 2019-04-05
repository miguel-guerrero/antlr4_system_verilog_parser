grammar SimpleHtml;

top:  '<html>' header body '</html>';

header: '<head>' '</head>' ;
body:   '<body>' bodyStm* '</body>' ;

bodyStm: paragraph ;

paragraph: '<p>' pText '</p>' ;

pText: TEXT? span? TEXT?  ;


span: '<span' attrib? '>' TEXT? '</span>' ;
attrib: ID '=' QUOTED_STR ;

WS: [\t\n\r ]+ -> skip;

QUOTED_STR: ['] .*? ['] ;

TEXT: (ID | FRAG)+ ;

ID: [a-zA-Z_] [a-zA-Z0-9_$]* ;

FRAG: ~[<>'=]+ ;

