
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

// A.1.2 SystemVerilog source text

source_text : 
    [ timeunits_declaration ] { description }
;

description : 
      module_declaration 
    | udp_declaration 
    | interface_declaration 
    | program_declaration 
    | package_declaration 
    | { attribute_instance } package_item 
    | { attribute_instance } bind_directive 
    | config_declaration
;

module_nonansi_header : 
    { attribute_instance } module_keyword [ lifetime ] module_identifier { package_import_declaration } [ parameter_port_list ] list_of_ports ';'
;

module_ansi_header : 
    { attribute_instance } module_keyword [ lifetime ] module_identifier { package_import_declaration }[ parameter_port_list ] [ list_of_port_declarations ] ';'
;

module_declaration : 
      module_nonansi_header [ timeunits_declaration ] { module_item } 'endmodule' [ ':' module_identifier ] 
    | module_ansi_header  [ timeunits_declaration ] { non_port_module_item } 'endmodule' [ ':' module_identifier ]
    | { attribute_instance } module_keyword [ lifetime ] module_identifier '( .* ) ;' [ timeunits_declaration ] { module_item } 'endmodule' [ ':' module_identifier ] 
    | 'extern' module_nonansi_header 
    | 'extern' module_ansi_header
;

module_keyword : 
      'module' 
    | 'macromodule'
;

interface_declaration : 
    interface_nonansi_header [ timeunits_declaration ] { interface_item } 'endinterface' [ ':' interface_identifier ] 
    | interface_ansi_header  [ timeunits_declaration ] { non_port_interface_item } 'endinterface' [ ':' interface_identifier ] 
    | { attribute_instance } 'interface' interface_identifier '(' '.*' ')' ';' [ timeunits_declaration ] { interface_item } 'endinterface' [ ':' interface_identifier ] 
    | 'extern' interface_nonansi_header 
    | 'extern' interface_ansi_header
;

interface_nonansi_header :
    { attribute_instance } 'interface' [ lifetime ] interface_identifier { package_import_declaration } [ parameter_port_list ] list_of_ports ';'
    
;

interface_ansi_header :
    {attribute_instance } 'interface' [ lifetime ] interface_identifier { package_import_declaration }[ parameter_port_list ] [ list_of_port_declarations ] ';'
;

program_declaration :
      program_nonansi_header [ timeunits_declaration ] { program_item }          'endprogram' [ ':' program_identifier ]
    | program_ansi_header    [ timeunits_declaration ] { non_port_program_item } 'endprogram' [ ':' program_identifier ] 
    | { attribute_instance } 'program' program_identifier '(' '.*' ')' ';' [ timeunits_declaration ] { program_item } 'endprogram' [ ':' program_identifier
] 
    | 'extern 'program_nonansi_header
    | 'extern 'program_ansi_header
;

program_nonansi_header :
    { attribute_instance } 'program' [ lifetime ] program_identifier { package_import_declaration } [ parameter_port_list ] list_of_ports ';'
;

program_ansi_header :
    { attribute_instance } 'program' [ lifetime ] program_identifier { package_import_declaration } [ parameter_port_list ] [ list_of_port_declarations ] ';'
;

checker_declaration :
    'checker' checker_identifier [ '(' [ checker_port_list ] ')' ] ';' { { attribute_instance } checker_or_generate_item } 'endchecker' [ ':' checker_identifier ]
;

class_declaration :
    [ 'virtual'] 'class' [ lifetime ] class_identifier [ parameter_port_list ] [ 'extends' class_type [ '(' list_of_arguments ')' ] ] [ 'implements' interface_class_type { ',' interface_class_type } ] ';' { class_item } 'endclass' [ ':' class_identifier]
;

interface_class_type : 
    ps_class_identifier [ parameter_value_assignment ] 
;

interface_class_declaration : 
    'interface' 'class' class_identifier [ parameter_port_list ] [ 'extends' interface_class_type { ',' interface_class_type } ] ';' { interface_class_item } 'endclass' [ ':' class_identifier]
;

interface_class_item : 
      type_declaration 
    | { attribute_instance } interface_class_method 
    | local_parameter_declaration ';' 
    | parameter_declaration ';'
    | ';'
;

interface_class_method :
    'pure' 'virtual' method_prototype ';'
;

package_declaration : 
    { attribute_instance } 'package' [ lifetime ] package_identifier ';' [ timeunits_declaration ] { { attribute_instance } package_item } 'endpackage' [ ':' package_identifier ]
;

timeunits_declaration :
      'timeunit'      time_literal [ '/' time_literal ] ';' 
    | 'timeprecision' time_literal ';' 
    | 'timeunit'      time_literal ';'  'timeprecision' time_literal ';' 
    | 'timeprecision' time_literal ';'  'timeunit' time_literal ';'
;


// A.1.3 Module parameters and ports

parameter_port_list : 
    '#' '(' list_of_param_assignments  { ',' parameter_port_declaration } ')' 
  | '#' '(' parameter_port_declaration { ',' parameter_port_declaration } ')' 
  | '#' '(' ')'
;

parameter_port_declaration : 
      parameter_declaration
    | local_parameter_declaration 
    | data_type list_of_param_assignments 
    | 'type' list_of_type_assignments 
;

list_of_ports : 
    '(' port { ',' port } ')'
;

list_of_port_declarations:
    '(' [ {attribute_instance} ansi_port_declaration { ',' { attribute_instance} ansi_port_declaration } ] ')'
;

port_declaration :
      { attribute_instance } inout_declaration
    | { attribute_instance } input_declaration
    | { attribute_instance } output_declaration
    | { attribute_instance } ref_declaration
    | { attribute_instance } interface_port_declaration
;

port :
      [ port_expression ]
    | '.' port_identifier '(' [ port_expression ] ')'
;

port_expression : 
      port_reference
    | '{' port_reference { ',' port_reference } '}' 
;
