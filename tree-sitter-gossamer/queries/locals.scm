; Scopes
(source_file) @local.scope
(block) @local.scope
(function_item) @local.scope
(closure_expression) @local.scope
(match_arm) @local.scope

; Definitions
(let_declaration pattern: (identifier) @local.definition)
(parameter pattern: (identifier) @local.definition)
(function_item name: (identifier) @local.definition)
(struct_item name: (type_identifier) @local.definition)
(enum_item name: (type_identifier) @local.definition)

; References
(identifier) @local.reference
