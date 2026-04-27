; Helix tree-sitter highlight queries: later patterns override earlier ones.
; Catch-alls go first; more specific overrides come last.

; Comments
(line_comment) @comment
(block_comment) @comment

; Literals
(integer_literal) @number
(float_literal) @number
(boolean_literal) @constant.builtin.boolean
(string_literal) @string
(raw_string_literal) @string
(byte_string_literal) @string
(char_literal) @string
(escape_sequence) @string.escape

; Catch-all identifiers (specific cases override these below)
(identifier) @variable
(type_identifier) @type
(primitive_type) @type.builtin

; Built-in generic/container types
((type_identifier) @type.builtin
  (#match? @type.builtin "^(Arc|Array|BTreeMap|BTreeSet|Box|HashMap|HashSet|Mutex|Option|Receiver|Result|Sender|String|Vec)$"))

; Built-in constructors (Some/None/Ok/Err live as paths/identifiers — match by name)
((identifier) @constant.builtin
  (#match? @constant.builtin "^(Some|None|Ok|Err)$"))

; Functions
(function_item name: (identifier) @function)
(call_expression function: (identifier) @function)
(method_call_expression (identifier) @function.method)

; Fields
(field_expression (identifier) @variable.field .)
(field_declaration name: (identifier) @variable.field)

; Parameters
(parameter pattern: (identifier) @variable.parameter)

; Operators
[
  "+"
  "-"
  "*"
  "/"
  "%"
  "&"
  "|"
  "^"
  "!"
  "<"
  ">"
  "="
  "=="
  "!="
  "<="
  ">="
  "&&"
  "||"
  "<<"
  ">>"
  "->"
  "=>"
  "+="
  "-="
  "*="
  "/="
  "%="
  "&="
  "|="
  "^="
  "<<="
  ">>="
  ".."
  "..="
  "::"
  "@"
] @operator

"|>" @operator.special

; Punctuation
[ "(" ")" "[" "]" "{" "}" ] @punctuation.bracket
[ "," ";" ":" "." ] @punctuation.delimiter

; Keywords
[
  "as"
  "async"
  "const"
  "dyn"
  "enum"
  "extern"
  "fn"
  "impl"
  "let"
  "mod"
  "mut"
  "pub"
  "self"
  "static"
  "struct"
  "trait"
  "type"
  "unsafe"
  "use"
  "where"
] @keyword

[
  "if"
  "else"
  "match"
  "loop"
  "while"
  "for"
  "in"
  "break"
  "return"
  "defer"
  "select"
  "go"
] @keyword.control

; `continue_expression` is a bare-literal rule, so the "continue" token isn't
; exposed as an anonymous node — match the named node instead.
(continue_expression) @keyword.control

; Attributes
(attribute_item) @attribute
