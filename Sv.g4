grammar Sv;

// A.1 Source text
// A.1.1 Library source text
// ROOT node

library_text :
      library_description* EOF
;

library_description :
      library_declaration
    | include_statement
    | config_declaration
    | ';'
;

library_declaration :
      'library' library_identifier file_path_spec (',' file_path_spec)* ('-incdir' file_path_spec (',' file_path_spec)*)? ';'
;

include_statement :
      'include' file_path_spec ';'
;


// TODO not defined on original spec

file_path_spec :
      STRING_LITERAL
;


// A.1.2 SystemVerilog source text
// ROOT node

source_text :
      timeunits_declaration? description* EOF
;

description :
      module_declaration
    | udp_declaration
    | interface_declaration
    | program_declaration
    | package_declaration
    | attribute_instance* package_item
    | attribute_instance* bind_directive
    | config_declaration
;

module_nonansi_header :
      attribute_instance* module_keyword lifetime? module_identifier package_import_declaration* parameter_port_list? ('(' port (',' port)* ')') ';'
;

module_ansi_header :
      attribute_instance* module_keyword lifetime? module_identifier package_import_declaration* parameter_port_list? list_of_port_declarations? ';'
;

module_declaration :
      module_nonansi_header timeunits_declaration? module_item* 'endmodule' (':' module_identifier)?
    | module_ansi_header timeunits_declaration? non_port_module_item* 'endmodule' (':' module_identifier)?
    | attribute_instance* module_keyword lifetime? module_identifier '(' '.*' ')' ';' timeunits_declaration? module_item* 'endmodule' (':' module_identifier)?
    | 'extern' module_nonansi_header
    | 'extern' module_ansi_header
;

module_keyword :
      'module'
    | 'macromodule'
;

interface_declaration :
      interface_nonansi_header timeunits_declaration? interface_item* 'endinterface' (':' interface_identifier)?
    | interface_ansi_header timeunits_declaration? non_port_interface_item* 'endinterface' (':' interface_identifier)?
    | attribute_instance* 'interface' interface_identifier '(' '.*' ')' ';' timeunits_declaration? interface_item* 'endinterface' (':' interface_identifier)?
    | 'extern' interface_nonansi_header
    | 'extern' interface_ansi_header
;

interface_nonansi_header :
      attribute_instance* 'interface' lifetime? interface_identifier package_import_declaration* parameter_port_list? ('(' port (',' port)* ')') ';'
;

interface_ansi_header :
      attribute_instance* 'interface' lifetime? interface_identifier package_import_declaration* parameter_port_list? list_of_port_declarations? ';'
;

program_declaration :
      program_nonansi_header timeunits_declaration? program_item* 'endprogram' (':' program_identifier)?
    | program_ansi_header timeunits_declaration? non_port_program_item* 'endprogram' (':' program_identifier)?
    | attribute_instance* 'program' program_identifier '(' '.*' ')' ';' timeunits_declaration? program_item* 'endprogram' (':' program_identifier)?
    | 'extern' program_nonansi_header
    | 'extern' program_ansi_header
;

program_nonansi_header :
      attribute_instance* 'program' lifetime? program_identifier package_import_declaration* parameter_port_list? ('(' port (',' port)* ')') ';'
;

program_ansi_header :
      attribute_instance* 'program' lifetime? program_identifier package_import_declaration* parameter_port_list? list_of_port_declarations? ';'
;

checker_declaration :
      'checker' checker_identifier ('(' checker_port_list? ')')? ';' (attribute_instance* checker_or_generate_item)* 'endchecker' (':' checker_identifier)?
;

class_declaration :
      'virtual'? 'class' lifetime? class_identifier parameter_port_list? ('extends' class_type ('(' list_of_arguments ')')?)? ('implements' interface_class_type (',' interface_class_type)*)? ';' class_item* 'endclass' (':' class_identifier)?
;

interface_class_type :
      ps_class_identifier parameter_value_assignment?
;


// ROOT node

interface_class_declaration :
      'interface' 'class' class_identifier parameter_port_list? ('extends' interface_class_type (',' interface_class_type)*)? ';' interface_class_item* 'endclass' (':' class_identifier)?
;

interface_class_item :
      type_declaration
    | attribute_instance* interface_class_method
    | local_parameter_declaration ';'
    | parameter_declaration ';'
    | ';'
;

interface_class_method :
      'pure' 'virtual' method_prototype ';'
;

package_declaration :
      attribute_instance* 'package' lifetime? package_identifier ';' timeunits_declaration? (attribute_instance* package_item)* 'endpackage' (':' package_identifier)?
;

timeunits_declaration :
      'timeunit' time_literal ('/' time_literal)? ';'
    | 'timeprecision' time_literal ';'
    | 'timeunit' time_literal ';' 'timeprecision' time_literal ';'
    | 'timeprecision' time_literal ';' 'timeunit' time_literal ';'
;


// A.1.3 Module parameters and ports

parameter_port_list :
      '#' '(' list_of_param_assignments (',' parameter_port_declaration)* ')'
    | '#' '(' parameter_port_declaration (',' parameter_port_declaration)* ')'
    | '#' '(' ')'
;

parameter_port_declaration :
      parameter_declaration
    | local_parameter_declaration
    | data_type list_of_param_assignments
    | 'type' list_of_type_assignments
;

list_of_port_declarations :
      '(' (attribute_instance* ansi_port_declaration (',' attribute_instance* ansi_port_declaration)*)? ')'
;

port_declaration :
      attribute_instance* inout_declaration
    | attribute_instance* input_declaration
    | attribute_instance* output_declaration
    | attribute_instance* ref_declaration
    | attribute_instance* interface_port_declaration
;

port :
      port_expression?
    | '.' port_identifier '(' port_expression? ')'
;

port_expression :
      (port_identifier constant_select)
    | '{' (port_identifier constant_select) (',' (port_identifier constant_select))* '}'
;

port_direction :
      'input'
    | 'output'
    | 'inout'
    | 'ref'
;

net_port_header :
      port_direction? net_port_type
;

variable_port_header :
      port_direction? variable_port_type
;

interface_port_header :
      interface_identifier ('.' modport_identifier)?
    | 'interface' ('.' modport_identifier)?
;


// NOTE removed optionality in [net_port_type | interface_port_header] as net_port_header can be empty

ansi_port_declaration :
      net_port_header port_identifier unpacked_dimension* ('=' constant_expression)?
    | interface_port_header port_identifier unpacked_dimension* ('=' constant_expression)?
    | variable_port_header port_identifier variable_dimension* ('=' constant_expression)?
    | port_direction? '.' port_identifier '(' expression? ')'
;


// A.1.4 Module items

elaboration_system_task :
      '$fatal' ('(' finish_number (',' list_of_arguments)? ')')? ';'
    | '$error' ('(' list_of_arguments ')')? ';'
    | '$warning' ('(' list_of_arguments ')')? ';'
    | '$info' ('(' list_of_arguments ')')? ';'
;


// TODO restrict to: '0' | '1' | '2'

finish_number :
      DECIMAL_NUMBER
;

module_common_item :
      module_or_generate_item_declaration
    | interface_instantiation
    | program_instantiation
    | assertion_item
    | bind_directive
    | continuous_assign
    | net_alias
    | initial_construct
    | final_construct
    | always_construct
    | loop_generate_construct
    | conditional_generate_construct
    | elaboration_system_task
;

module_item :
      port_declaration ';'
    | non_port_module_item
;

module_or_generate_item :
      attribute_instance* parameter_override
    | attribute_instance* gate_instantiation
    | attribute_instance* udp_instantiation
    | attribute_instance* module_instantiation
    | attribute_instance* module_common_item
;

module_or_generate_item_declaration :
      package_or_generate_item_declaration
    | genvar_declaration
    | clocking_declaration
    | 'default' 'clocking' clocking_identifier ';'
    | 'default' 'disable' 'iff' expression_or_dist ';'
;

non_port_module_item :
      generate_region
    | module_or_generate_item
    | specify_block
    | attribute_instance* specparam_declaration
    | program_declaration
    | module_declaration
    | interface_declaration
    | timeunits_declaration
;

parameter_override :
      'defparam' list_of_defparam_assignments ';'
;

bind_directive :
      'bind' bind_target_scope (':' bind_target_instance_list)? bind_instantiation ';'
    | 'bind' bind_target_instance bind_instantiation ';'
;

bind_target_scope :
      module_identifier
    | interface_identifier
;

bind_target_instance :
      hierarchical_identifier (('[' constant_expression ']')*)
;

bind_target_instance_list :
      bind_target_instance (',' bind_target_instance)*
;

bind_instantiation :
      program_instantiation
    | module_instantiation
    | interface_instantiation
    | checker_instantiation
;


// A.1.5 Configuration source text

config_declaration :
      'config' config_identifier ';' (local_parameter_declaration ';')* design_statement config_rule_statement* 'endconfig' (':' config_identifier)?
;

design_statement :
      'design' ((library_identifier '.')? cell_identifier)* ';'
;

config_rule_statement :
      default_clause liblist_clause ';'
    | inst_clause liblist_clause ';'
    | inst_clause use_clause ';'
    | cell_clause liblist_clause ';'
    | cell_clause use_clause ';'
;

default_clause :
      'default'
;

inst_clause :
      'instance' inst_name
;

inst_name :
      topmodule_identifier ('.' instance_identifier)*
;

cell_clause :
      'cell' (library_identifier '.')? cell_identifier
;

liblist_clause :
      'liblist' library_identifier*
;

use_clause :
      'use' (library_identifier '.')? cell_identifier (':' 'config')?
    | 'use' named_parameter_assignment (',' named_parameter_assignment)* (':' 'config')?
    | 'use' (library_identifier '.')? cell_identifier named_parameter_assignment (',' named_parameter_assignment)* (':' 'config')?
;


// A.1.6 Interface items

interface_or_generate_item :
      attribute_instance* module_common_item
    | attribute_instance* extern_tf_declaration
;

extern_tf_declaration :
      'extern' method_prototype ';'
    | 'extern' 'forkjoin' task_prototype ';'
;

interface_item :
      port_declaration ';'
    | non_port_interface_item
;

non_port_interface_item :
      generate_region
    | interface_or_generate_item
    | program_declaration
    | modport_declaration
    | interface_declaration
    | timeunits_declaration
;


// A.1.7 Program items

program_item :
      port_declaration ';'
    | non_port_program_item
;

non_port_program_item :
      attribute_instance* continuous_assign
    | attribute_instance* module_or_generate_item_declaration
    | attribute_instance* initial_construct
    | attribute_instance* final_construct
    | attribute_instance* concurrent_assertion_item
    | timeunits_declaration
    | program_generate_item
;

program_generate_item :
      loop_generate_construct
    | conditional_generate_construct
    | generate_region
    | elaboration_system_task
;


// A.1.8 Checker items

checker_port_list :
      checker_port_item (',' checker_port_item)*
;

checker_port_item :
      attribute_instance* checker_port_direction? property_formal_type formal_port_identifier variable_dimension* ('=' property_actual_arg)?
;

checker_port_direction :
      'input'
    | 'output'
;

checker_or_generate_item :
      checker_or_generate_item_declaration
    | initial_construct
    | always_construct
    | final_construct
    | assertion_item
    | continuous_assign
    | checker_generate_item
;

checker_or_generate_item_declaration :
      'rand'? data_declaration
    | function_declaration
    | checker_declaration
    | assertion_item_declaration
    | covergroup_declaration
    | genvar_declaration
    | clocking_declaration
    | 'default' 'clocking' clocking_identifier ';'
    | 'default' 'disable' 'iff' expression_or_dist ';'
    | ';'
;

checker_generate_item :
      loop_generate_construct
    | conditional_generate_construct
    | generate_region
    | elaboration_system_task
;


// A.1.9 Class items

class_item :
      attribute_instance* class_property
    | attribute_instance* class_method
    | attribute_instance* class_constraint
    | attribute_instance* class_declaration
    | attribute_instance* covergroup_declaration
    | local_parameter_declaration ';'
    | parameter_declaration ';'
    | ';'
;

class_property :
      property_qualifier* data_declaration
    | 'const' class_item_qualifier* data_type const_identifier ('=' constant_expression)? ';'
;

class_method :
      method_qualifier* task_declaration
    | method_qualifier* function_declaration
    | 'pure' 'virtual' class_item_qualifier* method_prototype ';'
    | 'extern' method_qualifier* method_prototype ';'
    | method_qualifier* class_constructor_declaration
    | 'extern' method_qualifier* class_constructor_prototype
;

class_constructor_prototype :
      'function' 'new' ('(' tf_port_list ')')? ';'
;

class_constraint :
      constraint_prototype
    | constraint_declaration
;

class_item_qualifier :
      'static'
    | 'protected'
    | 'local'
;

property_qualifier :
      random_qualifier
    | class_item_qualifier
;

random_qualifier :
      'rand'
    | 'randc'
;

method_qualifier :
      'pure'? 'virtual'
    | class_item_qualifier
;

method_prototype :
      task_prototype
    | function_prototype
;

class_constructor_declaration :
      'function' class_scope? 'new' ('(' tf_port_list ')')? ';' block_item_declaration* ('super' '.' 'new' ('(' list_of_arguments ')')? ';')? function_statement_or_null* 'endfunction' (':' 'new')?
;


// A.1.10 Constraints

constraint_declaration :
      'static'? 'constraint' constraint_identifier constraint_block
;

constraint_block :
      '{' constraint_block_item* '}'
;

constraint_block_item :
      'solve' solve_before_list 'before' solve_before_list ';'
    | constraint_expression
;

solve_before_list :
      constraint_primary (',' constraint_primary)*
;

constraint_primary :
      (implicit_class_handle '.' | class_scope)? hierarchical_identifier select
;

constraint_expression :
      'soft'? expression_or_dist ';'
    | uniqueness_constraint ';'
    | expression '->' constraint_set
    | 'if' '(' expression ')' constraint_set ('else' constraint_set)?
    | 'foreach' '(' ps_or_hierarchical_array_identifier '[' loop_variables ']' ')' constraint_set
    | 'disable' 'soft' constraint_primary ';'
;

uniqueness_constraint :
      'unique' '{' open_range_list '}'
;

constraint_set :
      constraint_expression
    | '{' constraint_expression* '}'
;

dist_list :
      dist_item (',' dist_item)*
;

dist_item :
      value_range dist_weight?
;

dist_weight :
      ':=' expression
    | ':/' expression
;

constraint_prototype :
      constraint_prototype_qualifier? 'static'? 'constraint' constraint_identifier ';'
;

constraint_prototype_qualifier :
      'extern'
    | 'pure'
;

extern_constraint_declaration :
      'static'? 'constraint' class_scope constraint_identifier constraint_block
;

identifier_list :
      IDENTIFIER (',' IDENTIFIER)*
;


// A.1.11 Package items

package_item :
      package_or_generate_item_declaration
    | anonymous_program
    | package_export_declaration
    | timeunits_declaration
;

package_or_generate_item_declaration :
      net_declaration
    | data_declaration
    | task_declaration
    | function_declaration
    | checker_declaration
    | dpi_import_export
    | extern_constraint_declaration
    | class_declaration
    | class_constructor_declaration
    | local_parameter_declaration ';'
    | parameter_declaration ';'
    | covergroup_declaration
    | assertion_item_declaration
    | ';'
;

anonymous_program :
      'program' ';' anonymous_program_item* 'endprogram'
;

anonymous_program_item :
      task_declaration
    | function_declaration
    | class_declaration
    | covergroup_declaration
    | class_constructor_declaration
    | ';'
;


// A.2 Declarations
// A.2.1 Declaration types
// A.2.1.1 Module parameter declarations

local_parameter_declaration :
      'localparam' data_type_or_implicit list_of_param_assignments
    | 'localparam' 'type' list_of_type_assignments
;

parameter_declaration :
      'parameter' data_type_or_implicit list_of_param_assignments
    | 'parameter' 'type' list_of_type_assignments
;

specparam_declaration :
      'specparam' packed_dimension? list_of_specparam_assignments ';'
;


// A.2.1.2 Port declarations

inout_declaration :
      'inout' net_port_type list_of_port_identifiers
;

input_declaration :
      'input' net_port_type list_of_port_identifiers
    | 'input' variable_port_type list_of_variable_identifiers
;

output_declaration :
      'output' net_port_type list_of_port_identifiers
    | 'output' variable_port_type list_of_variable_port_identifiers
;

interface_port_declaration :
      interface_identifier list_of_interface_identifiers
    | interface_identifier '.' modport_identifier list_of_interface_identifiers
;

ref_declaration :
      'ref' variable_port_type list_of_variable_identifiers
;


// A.2.1.3 Type declarations

data_declaration :
      'const'? 'var'? lifetime? data_type_or_implicit list_of_variable_decl_assignments ';'
    | type_declaration
    | package_import_declaration
    | net_type_declaration
;

package_import_declaration :
      'import' package_import_item (',' package_import_item)* ';'
;

package_import_item :
      package_identifier '::' IDENTIFIER
    | package_identifier '::' '*'
;


// TODO check *::*

package_export_declaration :
      'export' '*::*' ';'
    | 'export' package_import_item (',' package_import_item)* ';'
;

genvar_declaration :
      'genvar' list_of_genvar_identifiers ';'
;

net_declaration :
      net_type (drive_strength | charge_strength)? ('vectored' | 'scalared')? data_type_or_implicit delay3? list_of_net_decl_assignments ';'
    | net_type_identifier delay_control? list_of_net_decl_assignments ';'
    | 'interconnect' implicit_data_type ('#' delay_value)? net_identifier unpacked_dimension* (',' net_identifier unpacked_dimension*)? ';'
;

type_declaration :
      'typedef' data_type type_identifier variable_dimension* ';'
    | 'typedef' interface_instance_identifier (('[' constant_expression ']')*) '.' type_identifier type_identifier ';'
    | 'typedef' ('enum' | 'struct' | 'union' | 'class' | 'interface' 'class')? type_identifier ';'
;

net_type_declaration :
      'nettype' data_type net_type_identifier ('with' (package_scope | class_scope)? tf_identifier)? ';'
    | 'nettype' (package_scope | class_scope)? net_type_identifier net_type_identifier ';'
;

lifetime :
      'static'
    | 'automatic'
;


// A.2.2 Declaration data types
// A.2.2.1 Net and variable types
// TODO UNUSED casting_type - got replaced inline

data_type :
      integer_vector_type signing? packed_dimension*
    | integer_atom_type signing?
    | non_integer_type
    | struct_union ('packed' signing?)? '{' struct_union_member struct_union_member* '}' packed_dimension*
    | 'enum' enum_base_type? '{' enum_name_declaration (',' enum_name_declaration)* '}' packed_dimension*
    | 'string'
    | 'chandle'
    | 'virtual' 'interface'? interface_identifier parameter_value_assignment? ('.' modport_identifier)?
    | (class_scope | package_scope)? type_identifier packed_dimension*
    | class_type
    | 'event'
    | ps_covergroup_identifier
    | type_reference
;

data_type_or_implicit :
      data_type
    | implicit_data_type
;

implicit_data_type :
      signing? packed_dimension*
;

enum_base_type :
      integer_atom_type signing?
    | integer_vector_type signing? packed_dimension?
    | type_identifier packed_dimension?
;

enum_name_declaration :
      enum_identifier ('[' integral_number (':' integral_number)? ']')? ('=' constant_expression)?
;

class_scope :
      class_type '::'
;

class_type :
      ps_class_identifier parameter_value_assignment? ('::' class_identifier parameter_value_assignment?)*
;

integer_type :
      integer_vector_type
    | integer_atom_type
;

integer_atom_type :
      'byte'
    | 'shortint'
    | 'int'
    | 'longint'
    | 'integer'
    | 'time'
;

integer_vector_type :
      'bit'
    | 'logic'
    | 'reg'
;

non_integer_type :
      'shortreal'
    | 'real'
    | 'realtime'
;

net_type :
      'supply0'
    | 'supply1'
    | 'tri'
    | 'triand'
    | 'trior'
    | 'trireg'
    | 'tri0'
    | 'tri1'
    | 'uwire'
    | 'wire'
    | 'wand'
    | 'wor'
;

net_port_type :
      net_type? data_type_or_implicit
    | net_type_identifier
    | 'interconnect' implicit_data_type
;

variable_port_type :
      var_data_type
;

var_data_type :
      data_type
    | 'var' data_type_or_implicit
;

signing :
      'signed'
    | 'unsigned'
;

simple_type :
      integer_type
    | non_integer_type
    | ps_type_identifier
    | ps_parameter_identifier
;

struct_union_member :
      attribute_instance* random_qualifier? data_type_or_void list_of_variable_decl_assignments ';'
;

data_type_or_void :
      data_type
    | 'void'
;

struct_union :
      'struct'
    | 'union' 'tagged'?
;

type_reference :
      'type' '(' expression ')'
    | 'type' '(' data_type ')'
;


// A.2.2.2 Strengths

drive_strength :
      '(' strength0 ',' strength1 ')'
    | '(' strength1 ',' strength0 ')'
    | '(' strength0 ',' 'highz1' ')'
    | '(' strength1 ',' 'highz0' ')'
    | '(' 'highz0' ',' strength1 ')'
    | '(' 'highz1' ',' strength0 ')'
;

strength0 :
      'supply0'
    | 'strong0'
    | 'pull0'
    | 'weak0'
;

strength1 :
      'supply1'
    | 'strong1'
    | 'pull1'
    | 'weak1'
;

charge_strength :
      '(' 'small' ')'
    | '(' 'medium' ')'
    | '(' 'large' ')'
;


// A.2.2.3 Delays

delay3 :
      '#' delay_value
    | '#' '(' mintypmax_expression (',' mintypmax_expression (',' mintypmax_expression)?)? ')'
;

delay2 :
      '#' delay_value
    | '#' '(' mintypmax_expression (',' mintypmax_expression)? ')'
;


// TODO restrict DECIMAL_NUMBER to UNSIGNED_NUMBER

delay_value :
      DECIMAL_NUMBER
    | real_number
    | ps_identifier
    | time_literal
    | '1step'
;


// A.2.3 Declaration lists

list_of_defparam_assignments :
      defparam_assignment (',' defparam_assignment)*
;

list_of_genvar_identifiers :
      genvar_identifier (',' genvar_identifier)*
;

list_of_interface_identifiers :
      interface_identifier unpacked_dimension* (',' interface_identifier unpacked_dimension*)*
;

list_of_net_decl_assignments :
      net_decl_assignment (',' net_decl_assignment)*
;

list_of_param_assignments :
      param_assignment (',' param_assignment)*
;

list_of_port_identifiers :
      port_identifier unpacked_dimension* (',' port_identifier unpacked_dimension*)*
;

list_of_udp_port_identifiers :
      port_identifier (',' port_identifier)*
;

list_of_specparam_assignments :
      specparam_assignment (',' specparam_assignment)*
;

list_of_tf_variable_identifiers :
      port_identifier variable_dimension* ('=' expression)? (',' port_identifier variable_dimension* ('=' expression)?)*
;

list_of_type_assignments :
      type_assignment (',' type_assignment)*
;

list_of_variable_decl_assignments :
      variable_decl_assignment (',' variable_decl_assignment)*
;

list_of_variable_identifiers :
      variable_identifier variable_dimension* (',' variable_identifier variable_dimension*)*
;

list_of_variable_port_identifiers :
      port_identifier variable_dimension* ('=' constant_expression)? (',' port_identifier variable_dimension* ('=' constant_expression)?)*
;


// A.2.4 Declaration assignments

defparam_assignment :
      hierarchical_parameter_identifier '=' constant_mintypmax_expression
;

net_decl_assignment :
      net_identifier unpacked_dimension* ('=' expression)?
;

param_assignment :
      parameter_identifier unpacked_dimension* ('=' constant_param_expression)?
;

specparam_assignment :
      specparam_identifier '=' constant_mintypmax_expression
    | pulse_control_specparam
;

type_assignment :
      type_identifier ('=' data_type)?
;

pulse_control_specparam :
      'PATHPULSE$' '=' '(' reject_limit_value (',' error_limit_value)? ')'
    | 'PATHPULSE$' specify_input_terminal_descriptor '$' specify_output_terminal_descriptor '=' '(' reject_limit_value (',' error_limit_value)? ')'
;

error_limit_value :
      limit_value
;

reject_limit_value :
      limit_value
;

limit_value :
      constant_mintypmax_expression
;

variable_decl_assignment :
      variable_identifier variable_dimension* ('=' expression)?
    | dynamic_array_variable_identifier unsized_dimension variable_dimension* ('=' dynamic_array_new)?
    | class_variable_identifier ('=' class_new)?
;

class_new :
      class_scope? 'new' ('(' list_of_arguments ')')?
    | 'new' expression
;

dynamic_array_new :
      'new' '[' expression ']' ('(' expression ')')?
;


// A.2.5 Declaration ranges

unpacked_dimension :
      '[' constant_range ']'
    | '[' constant_expression ']'
;

packed_dimension :
      '[' constant_range ']'
    | unsized_dimension
;

associative_dimension :
      '[' data_type ']'
    | '[' '*' ']'
;

variable_dimension :
      unsized_dimension
    | unpacked_dimension
    | associative_dimension
    | queue_dimension
;

queue_dimension :
      '[' '$' (':' constant_expression)? ']'
;

unsized_dimension :
      '[' ']'
;


// A.2.6 Function declarations

function_data_type_or_implicit :
      data_type_or_void
    | implicit_data_type
;

function_declaration :
      'function' lifetime? function_body_declaration
;

function_body_declaration :
      function_data_type_or_implicit (interface_identifier '.' | class_scope)? function_identifier ';' tf_item_declaration* function_statement_or_null* 'endfunction' (':' function_identifier)?
    | function_data_type_or_implicit (interface_identifier '.' | class_scope)? function_identifier '(' tf_port_list ')' ';' block_item_declaration* function_statement_or_null* 'endfunction' (':' function_identifier)?
;

function_prototype :
      'function' data_type_or_void function_identifier ('(' tf_port_list ')')?
;

dpi_import_export :
      'import' dpi_spec_string dpi_function_import_property? (C_IDENTIFIER '=')? dpi_function_proto ';'
    | 'import' dpi_spec_string dpi_task_import_property? (C_IDENTIFIER '=')? dpi_task_proto ';'
    | 'export' dpi_spec_string (C_IDENTIFIER '=')? 'function' function_identifier ';'
    | 'export' dpi_spec_string (C_IDENTIFIER '=')? 'task' task_identifier ';'
;

dpi_spec_string :
      '"DPI-C"'
    | '"DPI"'
;

dpi_function_import_property :
      'context'
    | 'pure'
;

dpi_task_import_property :
      'context'
;

dpi_function_proto :
      function_prototype
;

dpi_task_proto :
      task_prototype
;


// A.2.7 Task declarations

task_declaration :
      'task' lifetime? task_body_declaration
;

task_body_declaration :
      (interface_identifier '.' | class_scope)? task_identifier ';' tf_item_declaration* statement_or_null* 'endtask' (':' task_identifier)?
    | (interface_identifier '.' | class_scope)? task_identifier '(' tf_port_list ')' ';' block_item_declaration* statement_or_null* 'endtask' (':' task_identifier)?
;

tf_item_declaration :
      block_item_declaration
    | tf_port_declaration
;

tf_port_list :
      tf_port_item (',' tf_port_item)*
;

tf_port_item :
      attribute_instance* tf_port_direction? 'var'? data_type_or_implicit (port_identifier variable_dimension* ('=' expression)?)?
;

tf_port_direction :
      port_direction
    | 'const' 'ref'
;

tf_port_declaration :
      attribute_instance* tf_port_direction 'var'? data_type_or_implicit list_of_tf_variable_identifiers ';'
;

task_prototype :
      'task' task_identifier ('(' tf_port_list ')')?
;


// A.2.8 Block item declarations

block_item_declaration :
      attribute_instance* data_declaration
    | attribute_instance* local_parameter_declaration ';'
    | attribute_instance* parameter_declaration ';'
    | attribute_instance* let_declaration
;


// A.2.9 Interface declarations

modport_declaration :
      'modport' modport_item (',' modport_item)* ';'
;

modport_item :
      modport_identifier '(' modport_ports_declaration (',' modport_ports_declaration)* ')'
;

modport_ports_declaration :
      attribute_instance* modport_simple_ports_declaration
    | attribute_instance* modport_tf_ports_declaration
    | attribute_instance* modport_clocking_declaration
;

modport_clocking_declaration :
      'clocking' clocking_identifier
;

modport_simple_ports_declaration :
      port_direction modport_simple_port (',' modport_simple_port)*
;

modport_simple_port :
      port_identifier
    | '.' port_identifier '(' expression? ')'
;

modport_tf_ports_declaration :
      import_export modport_tf_port (',' modport_tf_port)*
;

modport_tf_port :
      method_prototype
    | tf_identifier
;

import_export :
      'import'
    | 'export'
;


// A.2.10 Assertion declarations

concurrent_assertion_item :
      (block_identifier ':')? concurrent_assertion_statement
    | checker_instantiation
;

concurrent_assertion_statement :
      assert_property_statement
    | assume_property_statement
    | cover_property_statement
    | cover_sequence_statement
    | restrict_property_statement
;

assert_property_statement :
      'assert' 'property' '(' property_spec ')' action_block
;

assume_property_statement :
      'assume' 'property' '(' property_spec ')' action_block
;

cover_property_statement :
      'cover' 'property' '(' property_spec ')' statement_or_null
;

expect_property_statement :
      'expect' '(' property_spec ')' action_block
;

cover_sequence_statement :
      'cover' 'sequence' '(' clocking_event? ('disable' 'iff' '(' expression_or_dist ')')? sequence_expr ')' statement_or_null
;

restrict_property_statement :
      'restrict' 'property' '(' property_spec ')' ';'
;

property_instance :
      ps_or_hierarchical_property_identifier ('(' property_list_of_arguments ')')?
;

property_list_of_arguments :
      property_actual_arg? (',' property_actual_arg?)* (',' '.' IDENTIFIER '(' property_actual_arg? ')')*
    | '.' IDENTIFIER '(' property_actual_arg? ')' (',' '.' IDENTIFIER '(' property_actual_arg? ')')*
;

property_actual_arg :
      property_expr
    | sequence_actual_arg
;

assertion_item_declaration :
      property_declaration
    | sequence_declaration
    | let_declaration
;

property_declaration :
      'property' property_identifier ('(' property_port_list? ')')? ';' assertion_variable_declaration* property_spec ';'? 'endproperty' (':' property_identifier)?
;

property_port_list :
      property_port_item (',' property_port_item)*
;

property_port_item :
      attribute_instance* ('local' property_lvar_port_direction?)? property_formal_type formal_port_identifier variable_dimension* ('=' property_actual_arg)?
;

property_lvar_port_direction :
      'input'
;

property_formal_type :
      sequence_formal_type
    | 'property'
;

property_spec :
      clocking_event? ('disable' 'iff' '(' expression_or_dist ')')? property_expr
;

property_expr :
      sequence_expr
    | 'strong' '(' sequence_expr ')'
    | 'weak' '(' sequence_expr ')'
    | '(' property_expr ')'
    | 'not' property_expr
    | property_expr 'or' property_expr
    | property_expr 'and' property_expr
    | sequence_expr '|->' property_expr
    | sequence_expr '|=>' property_expr
    | 'if' '(' expression_or_dist ')' property_expr ('else' property_expr)?
    | 'case' '(' expression_or_dist ')' property_case_item property_case_item* 'endcase'
    | sequence_expr '#=#' property_expr
    | 'nexttime' property_expr
    | 'nexttime' '[' constant_expression ']' property_expr
    | 's_nexttime' property_expr
    | 's_nexttime' '[' constant_expression ']' property_expr
    | 'always' property_expr
    | 'always' '[' cycle_delay_const_range_expression ']' property_expr
    | 's_always' '[' constant_range ']' property_expr
    | 's_eventually' property_expr
    | 'eventually' '[' constant_range ']' property_expr
    | 's_eventually' '[' cycle_delay_const_range_expression ']' property_expr
    | property_expr 'until' property_expr
    | property_expr 's_until' property_expr
    | property_expr 'until_with' property_expr
    | property_expr 's_until_with' property_expr
    | property_expr 'implies' property_expr
    | property_expr 'iff' property_expr
    | 'accept_on' '(' expression_or_dist ')' property_expr
    | 'reject_on' '(' expression_or_dist ')' property_expr
    | 'sync_accept_on' '(' expression_or_dist ')' property_expr
    | 'sync_reject_on' '(' expression_or_dist ')' property_expr
    | property_instance
    | clocking_event property_expr
;

property_case_item :
      expression_or_dist (',' expression_or_dist)* ':' property_expr ';'
    | 'default' ':'? property_expr ';'
;

sequence_declaration :
      'sequence' sequence_identifier ('(' sequence_port_list? ')')? ';' assertion_variable_declaration* sequence_expr ';'? 'endsequence' (':' sequence_identifier)?
;

sequence_port_list :
      sequence_port_item (',' sequence_port_item)*
;

sequence_port_item :
      attribute_instance* ('local' sequence_lvar_port_direction?)? sequence_formal_type formal_port_identifier variable_dimension* ('=' sequence_actual_arg)?
;

sequence_lvar_port_direction :
      'input'
    | 'inout'
    | 'output'
;

sequence_formal_type :
      data_type_or_implicit
    | 'sequence'
    | 'untyped'
;

sequence_expr :
      cycle_delay_range sequence_expr (cycle_delay_range sequence_expr)*
    | sequence_expr cycle_delay_range sequence_expr (cycle_delay_range sequence_expr)*
    | expression_or_dist boolean_abbrev?
    | sequence_instance sequence_abbrev?
    | '(' sequence_expr (',' sequence_match_item)* ')' sequence_abbrev?
    | sequence_expr 'and' sequence_expr
    | sequence_expr 'intersect' sequence_expr
    | sequence_expr 'or' sequence_expr
    | 'first_match' '(' sequence_expr (',' sequence_match_item)* ')'
    | expression_or_dist 'throughout' sequence_expr
    | sequence_expr 'within' sequence_expr
    | clocking_event sequence_expr
;

cycle_delay_range :
      '##' constant_primary
    | '##' '[' cycle_delay_const_range_expression ']'
    | '##' '[' '*' ']'
    | '##' '[' '+' ']'
;

sequence_method_call :
      sequence_instance '.' method_identifier
;

sequence_match_item :
      operator_assignment
    | inc_or_dec_expression
    | subroutine_call
;

sequence_instance :
      ps_or_hierarchical_sequence_identifier ('(' sequence_list_of_arguments ')')?
;

sequence_list_of_arguments :
      sequence_actual_arg? (',' sequence_actual_arg?)* (',' '.' IDENTIFIER '(' sequence_actual_arg? ')')*
    | '.' IDENTIFIER '(' sequence_actual_arg? ')' (',' '.' IDENTIFIER '(' sequence_actual_arg? ')')*
;

sequence_actual_arg :
      event_expression
    | sequence_expr
;

boolean_abbrev :
      consecutive_repetition
    | non_consecutive_repetition
    | goto_repetition
;

sequence_abbrev :
      consecutive_repetition
;

consecutive_repetition :
      '[' '*' const_or_range_expression ']'
    | '[' '*' ']'
    | '[' '+' ']'
;

non_consecutive_repetition :
      '[' '=' const_or_range_expression ']'
;

goto_repetition :
      '[' '->' const_or_range_expression ']'
;

const_or_range_expression :
      constant_expression
    | cycle_delay_const_range_expression
;

cycle_delay_const_range_expression :
      constant_expression ':' constant_expression
    | constant_expression ':' '$'
;

expression_or_dist :
      expression ('dist' '{' dist_list '}')?
;

assertion_variable_declaration :
      var_data_type list_of_variable_decl_assignments ';'
;


// A.2.11 Covergroup declarations

covergroup_declaration :
      'covergroup' covergroup_identifier ('(' tf_port_list ')')? coverage_event? ';' coverage_spec_or_option* 'endgroup' (':' covergroup_identifier)?
;

coverage_spec_or_option :
      attribute_instance* coverage_spec
    | attribute_instance* coverage_option ';'
;

coverage_option :
      'option.' member_identifier '=' expression
    | 'type_option.' member_identifier '=' constant_expression
;

coverage_spec :
      cover_point
    | cover_cross
;


// TODO check @@

coverage_event :
      clocking_event
    | 'with' 'function' 'sample' '(' tf_port_list ')'
    | '@@' '(' block_event_expression ')'
;

block_event_expression :
      block_event_expression 'or' block_event_expression
    | 'begin' hierarchical_btf_identifier
    | 'end' hierarchical_btf_identifier
;

hierarchical_btf_identifier :
      hierarchical_tf_identifier
    | hierarchical_block_identifier
    | (hierarchical_identifier '.' | class_scope)? method_identifier
;

cover_point :
      (data_type_or_implicit cover_point_identifier ':')? 'coverpoint' expression ('iff' '(' expression ')')? bins_or_empty
;

bins_or_empty :
      '{' attribute_instance* (bins_or_options ';')* '}'
    | ';'
;

bins_or_options :
      coverage_option
    | 'wildcard'? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '=' '{' covergroup_range_list '}' ('with' '(' with_covergroup_expression ')')? ('iff' '(' expression ')')?
    | 'wildcard'? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '=' cover_point_identifier 'with' '(' with_covergroup_expression ')' ('iff' '(' expression ')')?
    | 'wildcard'? bins_keyword bin_identifier ('[' covergroup_expression? ']')? '=' set_covergroup_expression ('iff' '(' expression ')')?
    | 'wildcard'? bins_keyword bin_identifier ('[' ']')? '=' trans_list ('iff' '(' expression ')')?
    | bins_keyword bin_identifier ('[' covergroup_expression? ']')? '=' 'default' ('iff' '(' expression ')')?
    | bins_keyword bin_identifier '=' 'default' 'sequence' ('iff' '(' expression ')')?
;

bins_keyword :
      'bins'
    | 'illegal_bins'
    | 'ignore_bins'
;

trans_list :
      '(' trans_set ')' (',' '(' trans_set ')')*
;

trans_set :
      trans_range_list ('=>' trans_range_list)*
;


// TODO check

trans_range_list :
      trans_item
    | trans_item '[' '*' repeat_range ']'
    | trans_item '[' '->' repeat_range ']'
    | trans_item '[' '=' repeat_range ']'
;

trans_item :
      covergroup_range_list
;

repeat_range :
      covergroup_expression
    | covergroup_expression ':' covergroup_expression
;

cover_cross :
      (cross_identifier ':')? 'cross' list_of_cross_items ('iff' '(' expression ')')? cross_body
;

list_of_cross_items :
      cross_item ',' cross_item (',' cross_item)*
;

cross_item :
      cover_point_identifier
    | variable_identifier
;

cross_body :
      '{' (cross_body_item ';')* '}'
    | ';'
;

cross_body_item :
      function_declaration
    | bins_selection_or_option ';'
;

bins_selection_or_option :
      attribute_instance* coverage_option
    | attribute_instance* bins_selection
;

bins_selection :
      bins_keyword bin_identifier '=' select_expression ('iff' '(' expression ')')?
;

select_expression :
      select_condition
    | '!' select_condition
    | select_expression '&&' select_expression
    | select_expression '||' select_expression
    | '(' select_expression ')'
    | select_expression 'with' '(' with_covergroup_expression ')' ('matches' integer_covergroup_expression)?
    | cross_identifier
    | cross_set_expression ('matches' integer_covergroup_expression)?
;

select_condition :
      'binsof' '(' bins_expression ')' ('intersect' '{' covergroup_range_list '}')?
;

bins_expression :
      variable_identifier
    | cover_point_identifier ('.' bin_identifier)?
;

covergroup_range_list :
      covergroup_value_range (',' covergroup_value_range)*
;

covergroup_value_range :
      covergroup_expression
    | '[' covergroup_expression ':' covergroup_expression ']'
;

with_covergroup_expression :
      covergroup_expression
;

set_covergroup_expression :
      covergroup_expression
;

integer_covergroup_expression :
      covergroup_expression
;

cross_set_expression :
      covergroup_expression
;

covergroup_expression :
      expression
;


// A.2.12 Let declarations

let_declaration :
      'let' let_identifier ('(' let_port_list? ')')? '=' expression ';'
;

let_identifier :
      IDENTIFIER
;

let_port_list :
      let_port_item (',' let_port_item)*
;

let_port_item :
      attribute_instance* let_formal_type formal_port_identifier variable_dimension* ('=' expression)?
;

let_formal_type :
      data_type_or_implicit
    | 'untyped'
;

let_expression :
      package_scope? let_identifier ('(' let_list_of_arguments ')')?
;

let_list_of_arguments :
      let_actual_arg? (',' let_actual_arg?)* (',' '.' IDENTIFIER '(' let_actual_arg? ')')*
    | '.' IDENTIFIER '(' let_actual_arg? ')' (',' '.' IDENTIFIER '(' let_actual_arg? ')')*
;

let_actual_arg :
      expression
;


// A.3 Primitive instances
// A.3.1 Primitive instantiation and instances

gate_instantiation :
      cmos_switchtype delay3? cmos_switch_instance (',' cmos_switch_instance)* ';'
    | enable_gatetype drive_strength? delay3? enable_gate_instance (',' enable_gate_instance)* ';'
    | mos_switchtype delay3? mos_switch_instance (',' mos_switch_instance)* ';'
    | n_input_gatetype drive_strength? delay2? n_input_gate_instance (',' n_input_gate_instance)* ';'
    | n_output_gatetype drive_strength? delay2? n_output_gate_instance (',' n_output_gate_instance)* ';'
    | pass_en_switchtype delay2? pass_enable_switch_instance (',' pass_enable_switch_instance)* ';'
    | pass_switchtype pass_switch_instance (',' pass_switch_instance)* ';'
    | 'pulldown' pulldown_strength? pull_gate_instance (',' pull_gate_instance)* ';'
    | 'pullup' pullup_strength? pull_gate_instance (',' pull_gate_instance)* ';'
;

cmos_switch_instance :
      name_of_instance? '(' output_terminal ',' input_terminal ',' ncontrol_terminal ',' pcontrol_terminal ')'
;

enable_gate_instance :
      name_of_instance? '(' output_terminal ',' input_terminal ',' enable_terminal ')'
;

mos_switch_instance :
      name_of_instance? '(' output_terminal ',' input_terminal ',' enable_terminal ')'
;

n_input_gate_instance :
      name_of_instance? '(' output_terminal ',' input_terminal (',' input_terminal)* ')'
;

n_output_gate_instance :
      name_of_instance? '(' output_terminal (',' output_terminal)* ',' input_terminal ')'
;

pass_switch_instance :
      name_of_instance? '(' inout_terminal ',' inout_terminal ')'
;

pass_enable_switch_instance :
      name_of_instance? '(' inout_terminal ',' inout_terminal ',' enable_terminal ')'
;

pull_gate_instance :
      name_of_instance? '(' output_terminal ')'
;


// A.3.2 Primitive strengths

pulldown_strength :
      '(' strength0 ',' strength1 ')'
    | '(' strength1 ',' strength0 ')'
    | '(' strength0 ')'
;

pullup_strength :
      '(' strength0 ',' strength1 ')'
    | '(' strength1 ',' strength0 ')'
    | '(' strength1 ')'
;


// A.3.3 Primitive terminals

enable_terminal :
      expression
;

inout_terminal :
      net_lvalue
;

input_terminal :
      expression
;

ncontrol_terminal :
      expression
;

output_terminal :
      net_lvalue
;

pcontrol_terminal :
      expression
;


// A.3.4 Primitive gate and switch types

cmos_switchtype :
      'cmos'
    | 'rcmos'
;

enable_gatetype :
      'bufif0'
    | 'bufif1'
    | 'notif0'
    | 'notif1'
;

mos_switchtype :
      'nmos'
    | 'pmos'
    | 'rnmos'
    | 'rpmos'
;

n_input_gatetype :
      'and'
    | 'nand'
    | 'or'
    | 'nor'
    | 'xor'
    | 'xnor'
;

n_output_gatetype :
      'buf'
    | 'not'
;

pass_en_switchtype :
      'tranif0'
    | 'tranif1'
    | 'rtranif1'
    | 'rtranif0'
;

pass_switchtype :
      'tran'
    | 'rtran'
;


// A.4
// A.4.1
// A.4.1.1 Module

module_instantiation :
      module_identifier parameter_value_assignment? hierarchical_instance (',' hierarchical_instance)* ';'
;

parameter_value_assignment :
      '#' '(' list_of_parameter_assignments? ')'
;

list_of_parameter_assignments :
      ordered_parameter_assignment (',' ordered_parameter_assignment)*
    | named_parameter_assignment (',' named_parameter_assignment)*
;

ordered_parameter_assignment :
      param_expression
;

named_parameter_assignment :
      '.' parameter_identifier '(' param_expression? ')'
;

hierarchical_instance :
      name_of_instance '(' list_of_port_connections ')'
;

name_of_instance :
      instance_identifier unpacked_dimension*
;

list_of_port_connections :
      ordered_port_connection (',' ordered_port_connection)*
    | named_port_connection (',' named_port_connection)*
;

ordered_port_connection :
      attribute_instance* expression?
;

named_port_connection :
      attribute_instance* '.' port_identifier ('(' expression? ')')?
    | attribute_instance* '.*'
;


// A.4.1.2 Interface instantiation

interface_instantiation :
      interface_identifier parameter_value_assignment? hierarchical_instance (',' hierarchical_instance)* ';'
;


// A.4.1.3 Program instantiation

program_instantiation :
      program_identifier parameter_value_assignment? hierarchical_instance (',' hierarchical_instance)* ';'
;


// A.4.1.4 Checker instantiation

checker_instantiation :
      ps_checker_identifier name_of_instance '(' list_of_checker_port_connections ')' ';'
;

list_of_checker_port_connections :
      ordered_checker_port_connection (',' ordered_checker_port_connection)*
    | named_checker_port_connection (',' named_checker_port_connection)*
;

ordered_checker_port_connection :
      attribute_instance* property_actual_arg?
;

named_checker_port_connection :
      attribute_instance* '.' formal_port_identifier ('(' property_actual_arg? ')')?
    | attribute_instance* '.*'
;


// A.4.2 Generated instantiation

generate_region :
      'generate' generate_item* 'endgenerate'
;

loop_generate_construct :
      'for' '(' genvar_initialization ';' genvar_expression ';' genvar_iteration ')' generate_block
;

genvar_initialization :
      'genvar'? genvar_identifier '=' constant_expression
;

genvar_iteration :
      genvar_identifier assignment_operator genvar_expression
    | inc_or_dec_operator=('++' | '--') genvar_identifier
    | genvar_identifier inc_or_dec_operator2=('++' | '--')
;

conditional_generate_construct :
      if_generate_construct
    | case_generate_construct
;

if_generate_construct :
      'if' '(' constant_expression ')' generate_block ('else' generate_block)?
;

case_generate_construct :
      'case' '(' constant_expression ')' case_generate_item case_generate_item* 'endcase'
;

case_generate_item :
      constant_expression (',' constant_expression)* ':' generate_block
    | 'default' ':'? generate_block
;

generate_block :
      generate_item
    | (generate_block_identifier ':')? 'begin' (':' generate_block_identifier)? generate_item* 'end' (':' generate_block_identifier)?
;

generate_item :
      module_or_generate_item
    | interface_or_generate_item
    | checker_or_generate_item
;


// A.5 UDP declaration and instantiation
// A.5.1 UDP declaration

udp_nonansi_declaration :
      attribute_instance* 'primitive' udp_identifier '(' udp_port_list ')' ';'
;

udp_ansi_declaration :
      attribute_instance* 'primitive' udp_identifier '(' udp_declaration_port_list ')' ';'
;

udp_declaration :
      udp_nonansi_declaration udp_port_declaration udp_port_declaration* udp_body 'endprimitive' (':' udp_identifier)?
    | udp_ansi_declaration udp_body 'endprimitive' (':' udp_identifier)?
    | 'extern' udp_nonansi_declaration
    | 'extern' udp_ansi_declaration
    | attribute_instance* 'primitive' udp_identifier '(' '.*' ')' ';' udp_port_declaration* udp_body 'endprimitive' (':' udp_identifier)?
;


// A.5.2 UDP ports

udp_port_list :
      output_port_identifier ',' input_port_identifier (',' input_port_identifier)*
;

udp_declaration_port_list :
      udp_output_declaration ',' udp_input_declaration (',' udp_input_declaration)*
;

udp_port_declaration :
      udp_output_declaration ';'
    | udp_input_declaration ';'
    | udp_reg_declaration ';'
;

udp_output_declaration :
      attribute_instance* 'output' port_identifier
    | attribute_instance* 'output' 'reg' port_identifier ('=' constant_expression)?
;

udp_input_declaration :
      attribute_instance* 'input' list_of_udp_port_identifiers
;

udp_reg_declaration :
      attribute_instance* 'reg' variable_identifier
;


// A.5.3 UDP body

udp_body :
      combinational_body
    | sequential_body
;

combinational_body :
      'table' COMBINATIONAL_ENTRY COMBINATIONAL_ENTRY* 'endtable'
;

sequential_body :
      udp_initial_statement? 'table' SEQUENTIAL_ENTRY SEQUENTIAL_ENTRY* 'endtable'
;

udp_initial_statement :
      'initial' output_port_identifier '=' INIT_VAL ';'
;


// A.5.4 UDP instantiation

udp_instantiation :
      udp_identifier drive_strength? delay2? udp_instance (',' udp_instance)* ';'
;

udp_instance :
      name_of_instance? '(' output_terminal ',' input_terminal (',' input_terminal)* ')'
;


// A.6 Behavioral statements
// A.6.1 Continuous assignment and net alias statements

continuous_assign :
      'assign' drive_strength? delay3? list_of_net_assignments ';'
    | 'assign' delay_control? list_of_variable_assignments ';'
;

list_of_net_assignments :
      net_assignment (',' net_assignment)*
;

list_of_variable_assignments :
      variable_assignment (',' variable_assignment)*
;

net_alias :
      'alias' net_lvalue '=' net_lvalue ('=' net_lvalue)* ';'
;

net_assignment :
      net_lvalue '=' expression
;


// A.6.2 Procedural blocks and assignments

initial_construct :
      'initial' statement_or_null
;

always_construct :
      always_keyword statement
;

always_keyword :
      'always'
    | 'always_comb'
    | 'always_latch'
    | 'always_ff'
;

final_construct :
      'final' function_statement
;

blocking_assignment :
      variable_lvalue '=' delay_or_event_control expression
    | nonrange_variable_lvalue '=' dynamic_array_new
    | (implicit_class_handle '.' | class_scope | package_scope)? hierarchical_variable_identifier select '=' class_new
    | operator_assignment
;

operator_assignment :
      variable_lvalue assignment_operator expression
;

assignment_operator :
      '='
    | '+='
    | '-='
    | '*='
    | '/='
    | '%='
    | '&='
    | '|='
    | '^='
    | '<<='
    | '>>='
    | '<<<='
    | '>>>='
;

nonblocking_assignment :
      variable_lvalue '<=' delay_or_event_control? expression
;

procedural_continuous_assignment :
      'assign' variable_assignment
    | 'deassign' variable_lvalue
    | 'force' variable_assignment
    | 'force' net_assignment
    | 'release' variable_lvalue
    | 'release' net_lvalue
;

variable_assignment :
      variable_lvalue '=' expression
;


// A.6.3 Parallel and sequential blocks

action_block :
      statement_or_null
    | statement? 'else' statement_or_null
;

seq_block :
      'begin' (':' block_identifier)? block_item_declaration* statement_or_null* 'end' (':' block_identifier)?
;

par_block :
      'fork' (':' block_identifier)? block_item_declaration* statement_or_null* join_keyword (':' block_identifier)?
;

join_keyword :
      'join'
    | 'join_any'
    | 'join_none'
;


// A.6.4 Statements

statement_or_null :
      statement
    | attribute_instance* ';'
;

statement :
      (block_identifier ':')? attribute_instance* statement_item
;

statement_item :
      blocking_assignment ';'
    | nonblocking_assignment ';'
    | procedural_continuous_assignment ';'
    | case_statement
    | conditional_statement
    | inc_or_dec_expression ';'
    | subroutine_call_statement
    | disable_statement
    | event_trigger
    | loop_statement
    | jump_statement
    | par_block
    | procedural_timing_control_statement
    | seq_block
    | wait_statement
    | procedural_assertion_statement
    | clocking_drive ';'
    | randsequence_statement
    | randcase_statement
    | expect_property_statement
;

function_statement :
      statement
;

function_statement_or_null :
      function_statement
    | attribute_instance* ';'
;

variable_identifier_list :
      variable_identifier (',' variable_identifier)*
;


// A.6.5 Timing control statements

procedural_timing_control_statement :
      procedural_timing_control statement_or_null
;

delay_or_event_control :
      delay_control
    | event_control
    | 'repeat' '(' expression ')' event_control
;

delay_control :
      '#' delay_value
    | '#' '(' mintypmax_expression ')'
;


// TODO check

event_control :
      '@' hierarchical_event_identifier
    | '@' '(' event_expression ')'
    | '@*'
    | '@' '(' '*' ')'
    | '@' ps_or_hierarchical_sequence_identifier
;

event_expression :
      edge_identifier? expression ('iff' expression)?
    | sequence_instance ('iff' expression)?
    | event_expression 'or' event_expression
    | event_expression ',' event_expression
    | '(' event_expression ')'
;

procedural_timing_control :
      delay_control
    | event_control
    | cycle_delay
;

jump_statement :
      'return' expression? ';'
    | 'break' ';'
    | 'continue' ';'
;

wait_statement :
      'wait' '(' expression ')' statement_or_null
    | 'wait' 'fork' ';'
    | 'wait_order' '(' hierarchical_identifier (',' hierarchical_identifier)* ')' action_block
;

event_trigger :
      '->' hierarchical_event_identifier ';'
    | '->>' delay_or_event_control? hierarchical_event_identifier ';'
;

disable_statement :
      'disable' hierarchical_task_identifier ';'
    | 'disable' hierarchical_block_identifier ';'
    | 'disable' 'fork' ';'
;


// A.6.6 Conditional statements

conditional_statement :
      unique_priority? 'if' '(' cond_predicate ')' statement_or_null ('else' 'if' '(' cond_predicate ')' statement_or_null)* ('else' statement_or_null)?
;

unique_priority :
      'unique'
    | 'unique0'
    | 'priority'
;

cond_predicate :
      expression_or_cond_pattern ('&&&' expression_or_cond_pattern)*
;

expression_or_cond_pattern :
      expression
    | cond_pattern
;

cond_pattern :
      expression 'matches' pattern
;


// A.6.7 Case statements

case_statement :
      unique_priority? case_keyword '(' case_expression ')' case_item case_item* 'endcase'
    | unique_priority? case_keyword '(' case_expression ')' 'matches' case_pattern_item case_pattern_item* 'endcase'
    | unique_priority? 'case' '(' case_expression ')' 'inside' case_inside_item case_inside_item* 'endcase'
;

case_keyword :
      'case'
    | 'casez'
    | 'casex'
;

case_expression :
      expression
;

case_item :
      case_item_expression (',' case_item_expression)* ':' statement_or_null
    | 'default' ':'? statement_or_null
;

case_pattern_item :
      pattern ('&&&' expression)? ':' statement_or_null
    | 'default' ':'? statement_or_null
;

case_inside_item :
      open_range_list ':' statement_or_null
    | 'default' ':'? statement_or_null
;

case_item_expression :
      expression
;

randcase_statement :
      'randcase' randcase_item randcase_item* 'endcase'
;

randcase_item :
      expression ':' statement_or_null
;

open_range_list :
      open_value_range (',' open_value_range)*
;

open_value_range :
      value_range
;


// A.6.7.1 Patterns

pattern :
      '.' variable_identifier
    | '.*'
    | constant_expression
    | 'tagged' member_identifier pattern?
    | SINGLE_QUOTE '{' pattern (',' pattern)* '}'
    | SINGLE_QUOTE '{' member_identifier ':' pattern (',' member_identifier ':' pattern)* '}'
;

assignment_pattern :
      SINGLE_QUOTE '{' expression (',' expression)* '}'
    | SINGLE_QUOTE '{' structure_pattern_key ':' expression (',' structure_pattern_key ':' expression)* '}'
    | SINGLE_QUOTE '{' array_pattern_key ':' expression (',' array_pattern_key ':' expression)* '}'
    | SINGLE_QUOTE '{' constant_expression '{' expression (',' expression)* '}' '}'
;

structure_pattern_key :
      member_identifier
    | assignment_pattern_key
;

array_pattern_key :
      constant_expression
    | assignment_pattern_key
;

assignment_pattern_key :
      simple_type
    | 'default'
;

assignment_pattern_expression :
      assignment_pattern_expression_type? assignment_pattern
;

assignment_pattern_expression_type :
      ps_type_identifier
    | ps_parameter_identifier
    | integer_atom_type
    | type_reference
;

constant_assignment_pattern_expression :
      assignment_pattern_expression
;

assignment_pattern_net_lvalue :
      SINGLE_QUOTE '{' net_lvalue (',' net_lvalue)* '}'
;

assignment_pattern_variable_lvalue :
      SINGLE_QUOTE '{' variable_lvalue (',' variable_lvalue)* '}'
;


// A.6.8 Looping statements

loop_statement :
      'forever' statement_or_null
    | 'repeat' '(' expression ')' statement_or_null
    | 'while' '(' expression ')' statement_or_null
    | 'for' '(' for_initialization? ';' expression? ';' for_step? ')' statement_or_null
    | 'do' statement_or_null 'while' '(' expression ')' ';'
    | 'foreach' '(' ps_or_hierarchical_array_identifier '[' loop_variables ']' ')' statement
;

for_initialization :
      list_of_variable_assignments
    | for_variable_declaration (',' for_variable_declaration)*
;

for_variable_declaration :
      'var'? data_type variable_identifier '=' expression (',' variable_identifier '=' expression)*
;

for_step :
      for_step_assignment (',' for_step_assignment)*
;

for_step_assignment :
      operator_assignment
    | inc_or_dec_expression
    | subroutine_call
;

loop_variables :
      index_variable_identifier? (',' index_variable_identifier?)*
;


// A.6.9 Subroutine call statements

subroutine_call_statement :
      subroutine_call ';'
    | 'void' '(' subroutine_call ')' ';'
;


// A.6.10 Assertion statements

assertion_item :
      concurrent_assertion_item
    | deferred_immediate_assertion_item
;

deferred_immediate_assertion_item :
      (block_identifier ':')? deferred_immediate_assertion_statement
;

procedural_assertion_statement :
      concurrent_assertion_statement
    | immediate_assertion_statement
    | checker_instantiation
;

immediate_assertion_statement :
      simple_immediate_assertion_statement
    | deferred_immediate_assertion_statement
;

simple_immediate_assertion_statement :
      simple_immediate_assert_statement
    | simple_immediate_assume_statement
    | simple_immediate_cover_statement
;

simple_immediate_assert_statement :
      'assert' '(' expression ')' action_block
;

simple_immediate_assume_statement :
      'assume' '(' expression ')' action_block
;

simple_immediate_cover_statement :
      'cover' '(' expression ')' statement_or_null
;

deferred_immediate_assertion_statement :
      deferred_immediate_assert_statement
    | deferred_immediate_assume_statement
    | deferred_immediate_cover_statement
;

deferred_immediate_assert_statement :
      'assert' '#0' '(' expression ')' action_block
    | 'assert' 'final' '(' expression ')' action_block
;

deferred_immediate_assume_statement :
      'assume' '#0' '(' expression ')' action_block
    | 'assume' 'final' '(' expression ')' action_block
;

deferred_immediate_cover_statement :
      'cover' '#0' '(' expression ')' statement_or_null
    | 'cover' 'final' '(' expression ')' statement_or_null
;


// A.6.11 Clocking block

clocking_declaration :
      'default'? 'clocking' clocking_identifier? clocking_event ';' clocking_item* 'endclocking' (':' clocking_identifier)?
    | 'global' 'clocking' clocking_identifier? clocking_event ';' 'endclocking' (':' clocking_identifier)?
;

clocking_event :
      '@' IDENTIFIER
    | '@' '(' event_expression ')'
;

clocking_item :
      'default' default_skew ';'
    | clocking_direction list_of_clocking_decl_assign ';'
    | attribute_instance* assertion_item_declaration
;

default_skew :
      'input' clocking_skew
    | 'output' clocking_skew
    | 'input' clocking_skew 'output' clocking_skew
;

clocking_direction :
      'input' clocking_skew?
    | 'output' clocking_skew?
    | 'input' clocking_skew? 'output' clocking_skew?
    | 'inout'
;

list_of_clocking_decl_assign :
      clocking_decl_assign (',' clocking_decl_assign)*
;

clocking_decl_assign :
      signal_identifier ('=' expression)?
;

clocking_skew :
      edge_identifier delay_control?
    | delay_control
;

clocking_drive :
      clockvar_expression '<=' cycle_delay? expression
;

cycle_delay :
      '##' integral_number
    | '##' IDENTIFIER
    | '##' '(' expression ')'
;

clockvar :
      hierarchical_identifier
;

clockvar_expression :
      clockvar select
;


// A.6.12 Randsequence

randsequence_statement :
      'randsequence' '(' production_identifier? ')' production production* 'endsequence'
;

production :
      data_type_or_void? production_identifier ('(' tf_port_list ')')? ':' rs_rule ('|' rs_rule)* ';'
;

rs_rule :
      rs_production_list (':=' weight_specification rs_code_block?)?
;

rs_production_list :
      rs_prod rs_prod*
    | 'rand' 'join' ('(' expression ')')? production_item production_item production_item*
;

weight_specification :
      integral_number
    | ps_identifier
    | '(' expression ')'
;

rs_code_block :
      '{' data_declaration* statement_or_null* '}'
;

rs_prod :
      production_item
    | rs_code_block
    | rs_if_else
    | rs_repeat
    | rs_case
;

production_item :
      production_identifier ('(' list_of_arguments ')')?
;

rs_if_else :
      'if' '(' expression ')' production_item ('else' production_item)?
;

rs_repeat :
      'repeat' '(' expression ')' production_item
;

rs_case :
      'case' '(' case_expression ')' rs_case_item rs_case_item* 'endcase'
;

rs_case_item :
      case_item_expression (',' case_item_expression)* ':' production_item ';'
    | 'default' ':'? production_item ';'
;


// A.7 Specify section
// A.7.1 Specify block declaration

specify_block :
      'specify' specify_item* 'endspecify'
;

specify_item :
      specparam_declaration
    | pulsestyle_declaration
    | showcancelled_declaration
    | path_declaration
    | system_timing_check
;

pulsestyle_declaration :
      'pulsestyle_onevent' list_of_path_outputs ';'
    | 'pulsestyle_ondetect' list_of_path_outputs ';'
;

showcancelled_declaration :
      'showcancelled' list_of_path_outputs ';'
    | 'noshowcancelled' list_of_path_outputs ';'
;


// A.7.2 Specify path declarations

path_declaration :
      simple_path_declaration ';'
    | edge_sensitive_path_declaration ';'
    | state_dependent_path_declaration ';'
;

simple_path_declaration :
      parallel_path_description '=' path_delay_value
    | full_path_description '=' path_delay_value
;

parallel_path_description :
      '(' specify_input_terminal_descriptor polarity_operator? '=>' specify_output_terminal_descriptor ')'
;

full_path_description :
      '(' list_of_path_inputs polarity_operator? '*>' list_of_path_outputs ')'
;

list_of_path_inputs :
      specify_input_terminal_descriptor (',' specify_input_terminal_descriptor)*
;

list_of_path_outputs :
      specify_output_terminal_descriptor (',' specify_output_terminal_descriptor)*
;


// A.7.3 Specify block terminals

specify_input_terminal_descriptor :
      input_identifier ('[' constant_range_expression ']')?
;

specify_output_terminal_descriptor :
      output_identifier ('[' constant_range_expression ']')?
;

input_identifier :
      input_port_identifier
    | inout_port_identifier
    | interface_identifier '.' port_identifier
;

output_identifier :
      output_port_identifier
    | inout_port_identifier
    | interface_identifier '.' port_identifier
;


// A.7.4 Specify path delays

path_delay_value :
      list_of_path_delay_expressions
    | '(' list_of_path_delay_expressions ')'
;

list_of_path_delay_expressions :
      t_path_delay_expression
    | trise_path_delay_expression ',' tfall_path_delay_expression
    | trise_path_delay_expression ',' tfall_path_delay_expression ',' tz_path_delay_expression
    | t01_path_delay_expression ',' t10_path_delay_expression ',' t0z_path_delay_expression ',' tz1_path_delay_expression ',' t1z_path_delay_expression ',' tz0_path_delay_expression
    | t01_path_delay_expression ',' t10_path_delay_expression ',' t0z_path_delay_expression ',' tz1_path_delay_expression ',' t1z_path_delay_expression ',' tz0_path_delay_expression ',' t0x_path_delay_expression ',' tx1_path_delay_expression ',' t1x_path_delay_expression ',' tx0_path_delay_expression ',' txz_path_delay_expression ',' tzx_path_delay_expression
;

t_path_delay_expression :
      path_delay_expression
;

trise_path_delay_expression :
      path_delay_expression
;

tfall_path_delay_expression :
      path_delay_expression
;

tz_path_delay_expression :
      path_delay_expression
;

t01_path_delay_expression :
      path_delay_expression
;

t10_path_delay_expression :
      path_delay_expression
;

t0z_path_delay_expression :
      path_delay_expression
;

tz1_path_delay_expression :
      path_delay_expression
;

t1z_path_delay_expression :
      path_delay_expression
;

tz0_path_delay_expression :
      path_delay_expression
;

t0x_path_delay_expression :
      path_delay_expression
;

tx1_path_delay_expression :
      path_delay_expression
;

t1x_path_delay_expression :
      path_delay_expression
;

tx0_path_delay_expression :
      path_delay_expression
;

txz_path_delay_expression :
      path_delay_expression
;

tzx_path_delay_expression :
      path_delay_expression
;

path_delay_expression :
      constant_mintypmax_expression
;

edge_sensitive_path_declaration :
      parallel_edge_sensitive_path_description '=' path_delay_value
    | full_edge_sensitive_path_description '=' path_delay_value
;

parallel_edge_sensitive_path_description :
      '(' edge_identifier? specify_input_terminal_descriptor polarity_operator? '=>' '(' specify_output_terminal_descriptor polarity_operator? ':' data_source_expression ')' ')'
;

full_edge_sensitive_path_description :
      '(' edge_identifier? list_of_path_inputs polarity_operator? '*>' '(' list_of_path_outputs polarity_operator? ':' data_source_expression ')' ')'
;

data_source_expression :
      expression
;

edge_identifier :
      'posedge'
    | 'negedge'
    | 'edge'
;

state_dependent_path_declaration :
      'if' '(' module_path_expression ')' simple_path_declaration
    | 'if' '(' module_path_expression ')' edge_sensitive_path_declaration
    | 'ifnone' simple_path_declaration
;

polarity_operator :
      '+'
    | '-'
;


// A.7.5 System timing checks
// A.7.5.1 System timing check commands

system_timing_check :
      dollar_setup_timing_check
    | dollar_hold_timing_check
    | dollar_setuphold_timing_check
    | dollar_recovery_timing_check
    | dollar_removal_timing_check
    | dollar_recrem_timing_check
    | dollar_skew_timing_check
    | dollar_timeskew_timing_check
    | dollar_fullskew_timing_check
    | dollar_period_timing_check
    | dollar_width_timing_check
    | dollar_nochange_timing_check
;

dollar_setup_timing_check :
      '$setup' '(' data_event ',' reference_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_hold_timing_check :
      '$hold' '(' reference_event ',' data_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_setuphold_timing_check :
      '$setuphold' '(' reference_event ',' data_event ',' timing_check_limit ',' timing_check_limit (',' notifier? (',' timestamp_condition? (',' timecheck_condition? (',' delayed_reference? (',' delayed_data?)?)?)?)?)? ')' ';'
;

dollar_recovery_timing_check :
      '$recovery' '(' reference_event ',' data_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_removal_timing_check :
      '$removal' '(' reference_event ',' data_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_recrem_timing_check :
      '$recrem' '(' reference_event ',' data_event ',' timing_check_limit ',' timing_check_limit (',' notifier? (',' timestamp_condition? (',' timecheck_condition? (',' delayed_reference? (',' delayed_data?)?)?)?)?)? ')' ';'
;

dollar_skew_timing_check :
      '$skew' '(' reference_event ',' data_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_timeskew_timing_check :
      '$timeskew' '(' reference_event ',' data_event ',' timing_check_limit (',' notifier? (',' event_based_flag? (',' remain_active_flag?)?)?)? ')' ';'
;

dollar_fullskew_timing_check :
      '$fullskew' '(' reference_event ',' data_event ',' timing_check_limit ',' timing_check_limit (',' notifier? (',' event_based_flag? (',' remain_active_flag?)?)?)? ')' ';'
;

dollar_period_timing_check :
      '$period' '(' controlled_reference_event ',' timing_check_limit (',' notifier?)? ')' ';'
;

dollar_width_timing_check :
      '$width' '(' controlled_reference_event ',' timing_check_limit ',' threshold (',' notifier?)? ')' ';'
;

dollar_nochange_timing_check :
      '$nochange' '(' reference_event ',' data_event ',' start_edge_offset ',' end_edge_offset (',' notifier?)? ')' ';'
;


// A.7.5.2 System timing check command arguments

timecheck_condition :
      mintypmax_expression
;

controlled_reference_event :
      controlled_timing_check_event
;

data_event :
      timing_check_event
;

delayed_data :
      terminal_identifier
    | terminal_identifier '[' constant_mintypmax_expression ']'
;

delayed_reference :
      terminal_identifier
    | terminal_identifier '[' constant_mintypmax_expression ']'
;

end_edge_offset :
      mintypmax_expression
;

event_based_flag :
      constant_expression
;

notifier :
      variable_identifier
;

reference_event :
      timing_check_event
;

remain_active_flag :
      constant_mintypmax_expression
;

timestamp_condition :
      mintypmax_expression
;

start_edge_offset :
      mintypmax_expression
;

threshold :
      constant_expression
;

timing_check_limit :
      expression
;


// A.7.5.3 System timing check event definitions

timing_check_event :
      timing_check_event_control? specify_terminal_descriptor ('&&&' timing_check_condition)?
;

controlled_timing_check_event :
      timing_check_event_control specify_terminal_descriptor ('&&&' timing_check_condition)?
;

timing_check_event_control :
      'posedge'
    | 'negedge'
    | 'edge'
    | edge_control_specifier
;

specify_terminal_descriptor :
      specify_input_terminal_descriptor
    | specify_output_terminal_descriptor
;

edge_control_specifier :
      'edge' EDGE_LIST
;

timing_check_condition :
      scalar_timing_check_condition
    | '(' scalar_timing_check_condition ')'
;

scalar_timing_check_condition :
      expression
    | '~' expression
    | expression '==' SCALAR_CONSTANT
    | expression '===' SCALAR_CONSTANT
    | expression '!=' SCALAR_CONSTANT
    | expression '!==' SCALAR_CONSTANT
;


// A.8 Expressions
// A.8.1 Concatenations

concatenation :
      '{' expression (',' expression)* '}'
;

constant_concatenation :
      '{' constant_expression (',' constant_expression)* '}'
;

constant_multiple_concatenation :
      '{' constant_expression constant_concatenation '}'
;

module_path_concatenation :
      '{' module_path_expression (',' module_path_expression)* '}'
;

module_path_multiple_concatenation :
      '{' constant_expression module_path_concatenation '}'
;

multiple_concatenation :
      '{' expression concatenation '}'
;

streaming_concatenation :
      '{' stream_operator slice_size? stream_concatenation '}'
;

stream_operator :
      '>>'
    | '<<'
;

slice_size :
      simple_type
    | constant_expression
;

stream_concatenation :
      '{' stream_expression (',' stream_expression)* '}'
;

stream_expression :
      expression ('with' '[' array_range_expression ']')?
;

array_range_expression :
      expression
    | expression ':' expression
    | expression '+:' expression
    | expression '-:' expression
;

empty_unpacked_array_concatenation :
      '{' '}'
;


// A.8.2 Subroutine calls
// constant_function_call replaced inline
//    function_subroutine_call

tf_call :
      ps_or_hierarchical_tf_identifier attribute_instance* ('(' list_of_arguments ')')?
;

system_tf_call :
      SYSTEM_TF_IDENTIFIER ('(' list_of_arguments ')')?
    | SYSTEM_TF_IDENTIFIER '(' data_type (',' expression)? ')'
    | SYSTEM_TF_IDENTIFIER '(' expression (',' expression?)* (',' clocking_event?)? ')'
;


//replaced inline    | method_call_root '.' method_call_body

subroutine_call :
      tf_call
    | system_tf_call
    | primary '.' method_call_body
    | implicit_class_handle '.' method_call_body
    | ('std' '::')? randomize_call
;


// replaced inline function_subroutine_call 
//    subroutine_call

list_of_arguments :
      expression? (',' expression?)* (',' '.' IDENTIFIER '(' expression? ')')*
    | '.' IDENTIFIER '(' expression? ')' (',' '.' IDENTIFIER '(' expression? ')')*
;


// replaced inline method_call :
//     method_call_root '.' method_call_body

method_call_body :
      method_identifier attribute_instance* ('(' list_of_arguments ')')?
    | built_in_method_call
;

built_in_method_call :
      array_manipulation_call
    | randomize_call
;

array_manipulation_call :
      array_method_name attribute_instance* ('(' list_of_arguments ')')? ('with' '(' expression ')')?
;

randomize_call :
      'randomize' attribute_instance* ('(' (variable_identifier_list | 'null')? ')')? ('with' ('(' identifier_list? ')')? constraint_block)?
;


// replaced inline method_call_root :
//      primary 
//    | implicit_class_handle

array_method_name :
      method_identifier
    | 'unique'
    | 'and'
    | 'or'
    | 'xor'
;


// A.8.3 Expressions

inc_or_dec_expression :
      inc_or_dec_operator=('++' | '--') attribute_instance* variable_lvalue
    | variable_lvalue attribute_instance* inc_or_dec_operator2=('++' | '--')
;


// conditional_expression expanded inline

constant_expression :
      constant_primary
    | unary_operator=('+' | '-' | '!' | '~' | '&' | '~&' | '|' | '~|' | '^' | '~^' | '^~') attribute_instance* constant_primary
    | constant_expression ('**') attribute_instance* constant_expression
    | constant_expression binary_operator2=('*' | '/' | '%') attribute_instance* constant_expression
    | constant_expression binary_operator3=('+' | '-') attribute_instance* constant_expression
    | constant_expression binary_operator4=('>>' | '<<' | '>>>' | '<<<') attribute_instance* constant_expression
    | constant_expression binary_operator5=('<' | '<=' | '>' | '>=') attribute_instance* constant_expression
    | constant_expression binary_operator6=('==' | '!=' | '===' | '!==' | '==?' | '!=?') attribute_instance* constant_expression
    | constant_expression ('&') attribute_instance* constant_expression
    | constant_expression binary_operator8=('^' | '^~' | '~^') attribute_instance* constant_expression
    | constant_expression ('|') attribute_instance* constant_expression
    | constant_expression ('&&') attribute_instance* constant_expression
    | constant_expression ('||') attribute_instance* constant_expression
    | constant_expression '?' attribute_instance* constant_expression ':' constant_expression
    | <assoc=right> constant_expression binary_operator12=('->' | '<->') attribute_instance* constant_expression
;

constant_mintypmax_expression :
      constant_expression
    | constant_expression ':' constant_expression ':' constant_expression
;

constant_param_expression :
      constant_mintypmax_expression
    | data_type
    | '$'
;

param_expression :
      mintypmax_expression
    | data_type
    | '$'
;

constant_range_expression :
      constant_expression
    | constant_part_select_range
;

constant_part_select_range :
      constant_range
    | constant_indexed_range
;

constant_range :
      constant_expression ':' constant_expression
;

constant_indexed_range :
      constant_expression '+:' constant_expression
    | constant_expression '-:' constant_expression
;


// expanded inline bellow
//    | cond_predicate '?' { attribute_instance } expression ':' expression

expression :
      primary
    | unary_operator=('+' | '-' | '!' | '~' | '&' | '~&' | '|' | '~|' | '^' | '~^' | '^~') attribute_instance* primary
    | inc_or_dec_expression
    | expression ('**') attribute_instance* expression
    | expression binary_operator2=('*' | '/' | '%') attribute_instance* expression
    | expression binary_operator3=('+' | '-') attribute_instance* expression
    | expression binary_operator4=('>>' | '<<' | '>>>' | '<<<') attribute_instance* expression
    | expression binary_operator5=('<' | '<=' | '>' | '>=') attribute_instance* expression
    | expression 'inside' '{' open_range_list '}'
    | expression binary_operator6=('==' | '!=' | '===' | '!==' | '==?' | '!=?') attribute_instance* expression
    | expression ('&') attribute_instance* expression
    | expression binary_operator8=('^' | '^~' | '~^') attribute_instance* expression
    | expression ('|') attribute_instance* expression
    | expression ('&&') attribute_instance* expression
    | expression ('||') attribute_instance* expression
    | expression ('matches' pattern)? ('&&&' expression ('matches' pattern)?)* '?' attribute_instance* expression ':' expression
    | <assoc=right> expression binary_operator12=('->' | '<->') attribute_instance* expression
    | '(' operator_assignment ')'
    | tagged_union_expression
;

tagged_union_expression :
      'tagged' member_identifier expression?
;


// inside_expression replaced inline

value_range :
      expression
    | '[' expression ':' expression ']'
;

mintypmax_expression :
      expression
    | expression ':' expression ':' expression
;

module_path_expression :
      module_path_primary
    | unary_module_path_operator=('!' | '~' | '&' | '~&' | '|' | '~|' | '^' | '~^' | '^~') attribute_instance* module_path_primary
    | module_path_expression binary_module_path_operator=('==' | '!=' | '&&' | '||' | '&' | '|' | '^' | '^~' | '~^') attribute_instance* module_path_expression
    | module_path_expression '?' attribute_instance* module_path_expression ':' module_path_expression
;

module_path_mintypmax_expression :
      module_path_expression
    | module_path_expression ':' module_path_expression ':' module_path_expression
;

part_select_range :
      constant_range
    | indexed_range
;

indexed_range :
      expression '+:' constant_expression
    | expression '-:' constant_expression
;

genvar_expression :
      constant_expression
;


// A.8.4 Primaries
// replaced inline    | constant_cast
// replaced inline    | casting_type SINGLE_QUOTE '(' constant_expression ')' 
// replaced inline    | constant_function_call
// replaced inline    | function_subroutine_call
// replaced inline    | subroutine_call

constant_primary :
      primary_literal
    | ps_parameter_identifier constant_select
    | specparam_identifier ('[' constant_range_expression ']')?
    | genvar_identifier
    | formal_port_identifier constant_select
    | (package_scope | class_scope)? enum_identifier
    | constant_concatenation ('[' constant_range_expression ']')?
    | constant_multiple_concatenation ('[' constant_range_expression ']')?
    | tf_call
    | system_tf_call
    | primary '.' method_call_body
    | implicit_class_handle '.' method_call_body
    | ('std' '::')? randomize_call
    | (let_expression)
    | '(' constant_mintypmax_expression ')'
    | simple_type SINGLE_QUOTE '(' constant_expression ')'
    | constant_primary SINGLE_QUOTE '(' constant_expression ')'
    | (signing | 'string' | 'const') SINGLE_QUOTE '(' constant_expression ')'
    | constant_assignment_pattern_expression
    | type_reference
    | 'null'
;


// TODO added as constant_primary minus | primary  '.' method_call_body

restricted_constant_primary :
      primary_literal
    | ps_parameter_identifier constant_select
    | specparam_identifier ('[' constant_range_expression ']')?
    | genvar_identifier
    | formal_port_identifier constant_select
    | (package_scope | class_scope)? enum_identifier
    | constant_concatenation ('[' constant_range_expression ']')?
    | constant_multiple_concatenation ('[' constant_range_expression ']')?
    | tf_call
    | system_tf_call
    | implicit_class_handle '.' method_call_body
    | ('std' '::')? randomize_call
    | (let_expression)
    | '(' constant_mintypmax_expression ')'
    | simple_type SINGLE_QUOTE '(' constant_expression ')'
    | restricted_constant_primary SINGLE_QUOTE '(' constant_expression ')'
    | (signing | 'string' | 'const') SINGLE_QUOTE '(' constant_expression ')'
    | constant_assignment_pattern_expression
    | type_reference
    | 'null'
;

module_path_primary :
      number
    | IDENTIFIER
    | module_path_concatenation
    | module_path_multiple_concatenation
    | subroutine_call
    | '(' module_path_mintypmax_expression ')'
;


// replaced inline   | subroutine_call
// replaced inline   | cast
// replaced inline   | casting_type SINGLE_QUOTE '(' expression ')'

primary :
      primary_literal
    | class_qualifier hierarchical_identifier select
    | package_scope hierarchical_identifier select
    | empty_unpacked_array_concatenation
    | concatenation ('[' range_expression ']')?
    | multiple_concatenation ('[' range_expression ']')?
    | tf_call
    | system_tf_call
    | primary '.' method_call_body
    | implicit_class_handle '.' method_call_body
    | ('std' '::')? randomize_call
    | let_expression
    | '(' mintypmax_expression ')'
    | simple_type SINGLE_QUOTE '(' expression ')'
    | restricted_constant_primary SINGLE_QUOTE '(' expression ')'
    | (signing | 'string' | 'const') SINGLE_QUOTE '(' expression ')'
    | assignment_pattern_expression
    | streaming_concatenation
    | sequence_method_call
    | 'this'
    | '$'
    | 'null'
;

class_qualifier :
      ('local' '::')? (implicit_class_handle '.' | class_scope)?
;

range_expression :
      expression
    | part_select_range
;

primary_literal :
      number
    | time_literal
    | UNBASED_UNSIZED_LITERAL
    | STRING_LITERAL
;


// TODO restrict DECIMAL_NUMBER to UNSIGNED_NUMBER

time_literal :
      DECIMAL_NUMBER time_unit=('s' | 'ms' | 'us' | 'ns' | 'ps' | 'fs')
    | FIXED_POINT_NUMBER time_unit2=('s' | 'ms' | 'us' | 'ns' | 'ps' | 'fs')
;

implicit_class_handle :
      'this'
    | 'super'
    | 'this' '.' 'super'
;

select :
      (('.' member_identifier (('[' expression ']')*))* '.' member_identifier)? (('[' expression ']')*) ('[' part_select_range ']')?
;

nonrange_select :
      (('.' member_identifier (('[' expression ']')*))* '.' member_identifier)? (('[' expression ']')*)
;

constant_select :
      (('.' member_identifier (('[' constant_expression ']')*))* '.' member_identifier)? (('[' constant_expression ']')*) ('[' constant_part_select_range ']')?
;


// TODO check if SINGLE_QUOTE ( must be toegheter
// REMOVE
// constant_cast :
//    casting_type SINGLE_QUOTE '(' constant_expression ')' 
//;

// TODO check if SINGLE_QUOTE ( must be toegheter
// replaced inline cast :
//    casting_type SINGLE_QUOTE '(' expression ')'
// A.8.5 Expression left-side values

net_lvalue :
      ps_or_hierarchical_net_identifier constant_select
    | '{' net_lvalue (',' net_lvalue)* '}'
    | assignment_pattern_expression_type? assignment_pattern_net_lvalue
;

variable_lvalue :
      (implicit_class_handle '.' | package_scope)? hierarchical_variable_identifier select
    | '{' variable_lvalue (',' variable_lvalue)* '}'
    | assignment_pattern_expression_type? assignment_pattern_variable_lvalue
    | streaming_concatenation
;

nonrange_variable_lvalue :
      (implicit_class_handle '.' | package_scope)? hierarchical_variable_identifier nonrange_select
;


// A.8.6 Operators

// A.8.7 Numbers

number :
      integral_number
    | real_number
;

integral_number :
      DECIMAL_NUMBER
    | OCTAL_NUMBER
    | BINARY_NUMBER
    | HEX_NUMBER
;

real_number :
      FIXED_POINT_NUMBER
    | ACTUAL_REAL_NUMBER
;


// A.8.8 Strings
// TODO
// A.9 General  // A.9.1 Attributes
// TODO check (* contiguous

attribute_instance :
      '(*' attr_spec (',' attr_spec)* '*)'
;

attr_spec :
      (IDENTIFIER) ('=' constant_expression)?
;


// A.9.2 Comments
// TODO UNUSED comment taken care at lexer level
// A.9.3 Identifiers
// TODO UNUSED array_identifier

block_identifier :
      IDENTIFIER
;

bin_identifier :
      IDENTIFIER
;

cell_identifier :
      IDENTIFIER
;

checker_identifier :
      IDENTIFIER
;

class_identifier :
      IDENTIFIER
;

class_variable_identifier :
      variable_identifier
;

clocking_identifier :
      IDENTIFIER
;

config_identifier :
      IDENTIFIER
;

const_identifier :
      IDENTIFIER
;

constraint_identifier :
      IDENTIFIER
;

covergroup_identifier :
      IDENTIFIER
;


// TODO UNUSED covergroup_variable_identifier

cover_point_identifier :
      IDENTIFIER
;

cross_identifier :
      IDENTIFIER
;

dynamic_array_variable_identifier :
      variable_identifier
;

enum_identifier :
      IDENTIFIER
;


// TODO UNUSED formal_identifier

formal_port_identifier :
      IDENTIFIER
;

function_identifier :
      IDENTIFIER
;

generate_block_identifier :
      IDENTIFIER
;

genvar_identifier :
      IDENTIFIER
;

hierarchical_array_identifier :
      hierarchical_identifier
;

hierarchical_block_identifier :
      hierarchical_identifier
;

hierarchical_event_identifier :
      hierarchical_identifier
;

hierarchical_identifier :
      ('$root' '.')? (IDENTIFIER (('[' constant_expression ']')*) '.')* IDENTIFIER
;

hierarchical_net_identifier :
      hierarchical_identifier
;

hierarchical_parameter_identifier :
      hierarchical_identifier
;

hierarchical_property_identifier :
      hierarchical_identifier
;

hierarchical_sequence_identifier :
      hierarchical_identifier
;

hierarchical_task_identifier :
      hierarchical_identifier
;

hierarchical_tf_identifier :
      hierarchical_identifier
;

hierarchical_variable_identifier :
      hierarchical_identifier
;


// TODO identifier replaced directly

index_variable_identifier :
      IDENTIFIER
;

interface_identifier :
      IDENTIFIER
;

interface_instance_identifier :
      IDENTIFIER
;

inout_port_identifier :
      IDENTIFIER
;

input_port_identifier :
      IDENTIFIER
;

instance_identifier :
      IDENTIFIER
;

library_identifier :
      IDENTIFIER
;

member_identifier :
      IDENTIFIER
;

method_identifier :
      IDENTIFIER
;

modport_identifier :
      IDENTIFIER
;

module_identifier :
      IDENTIFIER
;

net_identifier :
      IDENTIFIER
;

net_type_identifier :
      IDENTIFIER
;

output_port_identifier :
      IDENTIFIER
;

package_identifier :
      IDENTIFIER
;

package_scope :
      package_identifier '::'
    | '$unit' '::'
;

parameter_identifier :
      IDENTIFIER
;

port_identifier :
      IDENTIFIER
;

production_identifier :
      IDENTIFIER
;

program_identifier :
      IDENTIFIER
;

property_identifier :
      IDENTIFIER
;

ps_class_identifier :
      package_scope? class_identifier
;

ps_covergroup_identifier :
      package_scope? covergroup_identifier
;

ps_checker_identifier :
      package_scope? checker_identifier
;

ps_identifier :
      package_scope? IDENTIFIER
;

ps_or_hierarchical_array_identifier :
      (implicit_class_handle '.' | class_scope | package_scope)? hierarchical_array_identifier
;

ps_or_hierarchical_net_identifier :
      package_scope? net_identifier
    | hierarchical_net_identifier
;

ps_or_hierarchical_property_identifier :
      package_scope? property_identifier
    | hierarchical_property_identifier
;

ps_or_hierarchical_sequence_identifier :
      package_scope? sequence_identifier
    | hierarchical_sequence_identifier
;

ps_or_hierarchical_tf_identifier :
      package_scope? tf_identifier
    | hierarchical_tf_identifier
;

ps_parameter_identifier :
      (package_scope | class_scope)? parameter_identifier
    | (generate_block_identifier ('[' constant_expression ']')? '.')* parameter_identifier
;

ps_type_identifier :
      ('local' '::' | package_scope | class_scope)? type_identifier
;

sequence_identifier :
      IDENTIFIER
;

signal_identifier :
      IDENTIFIER
;

specparam_identifier :
      IDENTIFIER
;

task_identifier :
      IDENTIFIER
;

tf_identifier :
      IDENTIFIER
;

terminal_identifier :
      IDENTIFIER
;

topmodule_identifier :
      IDENTIFIER
;

type_identifier :
      IDENTIFIER
;

udp_identifier :
      IDENTIFIER
;

variable_identifier :
      IDENTIFIER
;


// A.9.4 White space
// A.10 Footnotes (normative)
// ----------- Rules converted to Lexer rules ---------------
 ONE_LINE_COMMENT : '//' .*? '\n' -> channel (HIDDEN);
 BLOCK_COMMENT : '/*' .*? '*/' -> channel (HIDDEN);
 WHITE_SPACE : (' ' | '\t' | '\r'? '\n') -> channel (HIDDEN);
 UNBASED_UNSIZED_LITERAL : ['] ('0'|'1'|Z_OR_X) ;
 EDGE_LIST : '[' EDGE_DESCRIPTOR (',' EDGE_DESCRIPTOR)* ']' ;
 HEX_NUMBER :    NON_ZERO_UNSIGNED_NUMBER ? HEX_BASE    HEX_VALUE ;
 OCTAL_NUMBER  : NON_ZERO_UNSIGNED_NUMBER ? OCTAL_BASE  OCTAL_VALUE ;
 BINARY_NUMBER : NON_ZERO_UNSIGNED_NUMBER ? BINARY_BASE BINARY_VALUE ;
 DECIMAL_NUMBER :
       NON_ZERO_UNSIGNED_NUMBER ? DECIMAL_BASE ? DEC_VALUE
     | NON_ZERO_UNSIGNED_NUMBER ? DECIMAL_BASE   X_DIGIT '_'*
     | NON_ZERO_UNSIGNED_NUMBER ? DECIMAL_BASE   Z_DIGIT '_'* ;
 FIXED_POINT_NUMBER : DEC_VALUE  '.' DEC_VALUE ;
 ACTUAL_REAL_NUMBER : DEC_VALUE ('.' DEC_VALUE)? ('e'|'E') ('+'|'-')? DEC_VALUE ;
 UNSIGNED_NUMBER    : DEC_VALUE ;
 INIT_VAL : '1' ['] [bB] [01xX] | '1' | '0' ;
 COMBINATIONAL_ENTRY : LEVEL_INPUT_LIST ':' WS OUTPUT_SYMBOL ';' ;
 SEQUENTIAL_ENTRY : (LEVEL_INPUT_LIST | EDGE_INPUT_LIST) ':' WS LEVEL_SYMBOL ':' WS (OUTPUT_SYMBOL | '-' WS) ';' ;
 SCALAR_CONSTANT : '1'? (['] [bB])? [01] ;
 SINGLE_QUOTE : ['] ;
 STRING_LITERAL : '"' .*? '"' ;
 IDENTIFIER : SIMPLE_IDENTIFIER | ESCAPED_IDENTIFIER ;
 C_IDENTIFIER : [a-zA-Z_] [a-zA-Z0-9_]* ;
 SYSTEM_TF_IDENTIFIER : '$' [a-zA-Z0-9_$] [a-zA-Z0-9_$]* ;
 ERROR_CHAR: . ;
// ----------- Aux fragments ---------------
 fragment WS : (' ' | '\t' | '\r'? '\n')+ ;
 fragment EDGE_DESCRIPTOR : '01' | '10' | Z_OR_X ZERO_OR_ONE | ZERO_OR_ONE Z_OR_X ;
 fragment LEVEL_INPUT_LIST : LEVEL_SYMBOL + ;
 fragment EDGE_INPUT_LIST  : LEVEL_SYMBOL * EDGE_INDICATOR LEVEL_SYMBOL* ;
 fragment OUTPUT_SYMBOL : ('0' | '1' | 'x' | 'X') WS ;
 fragment EDGE_INDICATOR : ('(' WS LEVEL_SYMBOL LEVEL_SYMBOL ')') WS | EDGE_SYMBOL ;
 fragment LEVEL_SYMBOL : ('0' | '1' | 'x' | 'X' | '?' | 'b' | 'B') WS ;
 fragment EDGE_SYMBOL  : ('r' | 'R' | 'f' | 'F' | 'p' | 'P' | 'n' | 'N' | '*') WS ;
 fragment NON_ZERO_UNSIGNED_NUMBER : NON_ZERO_DECIMAL_DIGIT ('_' | DECIMAL_DIGIT)* ;
 fragment Z_OR_X      : [xXzZ] ;
 fragment ZERO_OR_ONE : [01] ;
 fragment HEX_VALUE    : HEX_DIGIT     ('_' | HEX_DIGIT)* ;
 fragment DEC_VALUE    : DECIMAL_DIGIT ('_' | DECIMAL_DIGIT)* ;
 fragment OCTAL_VALUE  : OCTAL_DIGIT   ('_' | OCTAL_DIGIT)* ;
 fragment BINARY_VALUE : BINARY_DIGIT  ('_' | BINARY_DIGIT)* ;
 fragment HEX_BASE     : ['] [sS]? [hH] ;
 fragment DECIMAL_BASE : ['] [sS]? [dD] ;
 fragment OCTAL_BASE   : ['] [sS]? [oO] ;
 fragment BINARY_BASE  : ['] [sS]? [bB] ;
 fragment X_DIGIT : [xX] ;
 fragment Z_DIGIT : [zZ?] ;
 fragment HEX_DIGIT :    X_DIGIT|Z_DIGIT|[0-9a-fA-F] ;
 fragment DECIMAL_DIGIT :                [0-9] ;
 fragment OCTAL_DIGIT  : X_DIGIT|Z_DIGIT|[0-7] ;
 fragment BINARY_DIGIT : X_DIGIT|Z_DIGIT|[0-1] ;
 fragment SIMPLE_IDENTIFIER : [a-zA-Z_] [a-zA-Z0-9_$]* ;
 fragment ESCAPED_IDENTIFIER : '\\' [^ \t\n\r] ;
 fragment NON_ZERO_DECIMAL_DIGIT :       [1-9] ;