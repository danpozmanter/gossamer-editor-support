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
(method_call_expression (identifier) @function.method)

(field_declaration name: (identifier) @property)
(parameter pattern: (identifier) @variable.parameter)

(identifier) @variable

"|>" @operator

[
  "as" "async" "await" "const" "crate" "dyn" "enum" "extern" "fn"
  "impl" "let" "mod" "mut" "pub" "ref" "self" "Self" "static" "struct"
  "super" "trait" "type" "unsafe" "use" "where"
  "if" "else" "match" "loop" "while" "for" "in" "break" "continue"
  "return" "yield" "defer" "select" "go"
] @keyword

(attribute_item) @attribute
