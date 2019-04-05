parser grammar SimpleHtml;

options { tokenVocab=HtmlLexer; }

top:  OPEN HTML_TAGB CLOSE header body OPEN HTML_TAGE CLOSE;

header: OPEN HEAD_TAGB CLOSE  OPEN HEAD_TAGE CLOSE;
body:   OPEN BODY_TAGB CLOSE bodyStm* OPEN BODY_TAGE CLOSE;

bodyStm: OPEN PAR_TAGB CLOSE pText* OPEN PAR_TAGE CLOSE;
span: OPEN SPAN_TAGB attrib? CLOSE pText* OPEN SPAN_TAGE CLOSE;

pText: TEXT|span ;

attrib: ID '=' STRING;

