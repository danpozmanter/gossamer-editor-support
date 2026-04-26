; This file mirrors editors/tree-sitter-gossamer/queries/highlights.scm.
; It is placed here so neovim's runtimepath query loader can find it
; when the tree-sitter parser is registered as `gossamer`.

; Comments
(line_comment) @comment
(block_comment) @comment

; Literals
(integer_literal) @number
(float_literal) @number
(boolean_literal) @boolean
(string_literal) @string
(raw_string_literal) @string
(byte_string_literal) @string
(char_literal) @character
(escape_sequence) @string.escape

((identifier) @constant.builtin
  (#match? @constant.builtin "^(Some|None|Ok|Err)$"))

(primitive_type) @type.builtin

((type_identifier) @type.builtin
  (#match? @type.builtin "^(Arc|Array|BTreeMap|BTreeSet|Box|HashMap|HashSet|Mutex|Option|Receiver|Result|Sender|String|Vec)$"))

(type_identifier) @type

(function_item name: (identifier) @function)
(call_expression function: (identifier) @function.call)
(method_call_expression (identifier) @function.method)

(field_declaration name: (identifier) @field)
(parameter pattern: (identifier) @parameter)

(identifier) @variable

"|>" @operator

[
  "as" "async" "await" "const" "crate" "dyn" "enum" "extern" "fn"
  "impl" "let" "mod" "mut" "pub" "ref" "self" "Self" "static" "struct"
  "super" "trait" "type" "unsafe" "use" "where"
] @keyword

[
  "if" "else" "match" "loop" "while" "for" "in" "break" "continue"
  "return" "yield" "defer" "select" "go"
] @keyword

(attribute_item) @attribute
