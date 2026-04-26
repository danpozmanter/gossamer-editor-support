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

; Built-in literals (Some/None/Ok/Err live as paths/identifiers — match by name)
((identifier) @constant.builtin
  (#match? @constant.builtin "^(Some|None|Ok|Err)$"))

; Primitive and built-in types
(primitive_type) @type.builtin

((type_identifier) @type.builtin
  (#match? @type.builtin "^(Arc|Array|BTreeMap|BTreeSet|Box|HashMap|HashSet|Mutex|Option|Receiver|Result|Sender|String|Vec)$"))

(type_identifier) @type

; Functions
(function_item name: (identifier) @function)
(call_expression function: (identifier) @function)
(method_call_expression (identifier) @function.method)

; Fields
(field_expression (identifier) @variable.field .)
(field_declaration name: (identifier) @variable.field)

; Parameters
(parameter pattern: (identifier) @variable.parameter)

; Identifiers
(identifier) @variable

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
  "~"
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
  "?"
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
  "await"
  "const"
  "crate"
  "dyn"
  "enum"
  "extern"
  "fn"
  "impl"
  "let"
  "mod"
  "mut"
  "pub"
  "ref"
  "self"
  "Self"
  "static"
  "struct"
  "super"
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
  "continue"
  "return"
  "yield"
  "defer"
  "select"
  "go"
] @keyword.control

; Attributes
(attribute_item) @attribute
