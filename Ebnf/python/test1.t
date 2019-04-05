
// A.1 Source text
// A.1.1 Library source text

library_text : 
    { library_description }
;

library_description : 
      library_declaration 
    | include_statement 
    | config_declaration 
    | ';'
;

library_declaration : 
    'library' library_identifier file_path_spec { ',' file_path_spec } [ '-incdir' file_path_spec { ',' file_path_spec } ] ';'
;

include_statement : 
    'include' file_path_spec ';'
;

include_statement2 : 
    'include' (file_path_spec|abc) ';'
;
