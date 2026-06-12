; Mirrors editors/tree-sitter-gossamer/queries/highlights.scm but tuned
; for Zed's highlight name conventions.

(line_comment) @comment
(block_comment) @comment

(integer_literal) @number
(float_literal) @number
(boolean_literal) @boolean
(string_literal) @string
(raw_string_literal) @string
(byte_string_literal) @string
(char_literal) @string.special
(escape_sequence) @string.escape

((identifier) @constant
  (#match? @constant "^(Some|None|Ok|Err)$"))

(primitive_type) @type
(type_identifier) @type

(function_item name: (identifier) @function)
(call_expression function: (identifier) @function)
(generic_function function: (identifier) @function)
(method_call_expression (identifier) @function.method)
(macro_invocation macro: (identifier) @function.special)

(field_declaration name: (identifier) @property)
(parameter pattern: (identifier) @variable.parameter)
(closure_parameter pattern: (identifier) @variable.parameter)

(identifier) @variable

"|>" @operator

; Only tokens the grammar actually defines may appear here; an unknown
; token makes the whole query fail to load.
[
  "as" "async" "const" "dyn" "enum" "extern" "fn"
  "impl" "let" "mod" "mut" "pub" "self" "static" "struct"
  "trait" "type" "unsafe" "use" "where"
  "if" "else" "match" "loop" "while" "for" "in" "break"
  "return" "defer" "select" "go" "arena"
] @keyword

; `continue_expression` is a bare-literal rule; its token is not exposed
; as an anonymous node, so match the named node instead.
(continue_expression) @keyword

(attribute_item) @attribute
