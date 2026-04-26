/**
 * tree-sitter-gossamer
 *
 * Grammar for the Gossamer programming language. Surface syntax is
 * Rust-flavoured with two simplifications: no lifetime annotations and
 * optional semicolons at statement boundaries.
 */

const PREC = {
  unary: 12,
  cast: 11,
  multiplicative: 10,
  additive: 9,
  shift: 8,
  bitand: 7,
  bitxor: 6,
  bitor: 5,
  comparative: 4,
  and: 3,
  or: 2,
  pipe: 1,
  assign: 0,
};

const integer_types = [
  "i8", "i16", "i32", "i64", "i128", "isize",
  "u8", "u16", "u32", "u64", "u128", "usize",
];

const float_types = ["f32", "f64"];

const primitive_types = integer_types
  .concat(float_types)
  .concat(["bool", "char", "str"]);

const built_in_types = [
  "Arc", "Array", "BTreeMap", "BTreeSet", "Box",
  "HashMap", "HashSet", "Mutex", "Option", "Receiver",
  "Result", "Sender", "String", "Vec",
];

module.exports = grammar({
  name: "gossamer",

  extras: $ => [
    /\s+/,
    $.line_comment,
    $.block_comment,
  ],

  word: $ => $.identifier,

  rules: {
    source_file: $ => repeat($._item),

    _item: $ => choice(
      $.use_declaration,
      $.const_item,
      $.static_item,
      $.struct_item,
      $.enum_item,
      $.trait_item,
      $.impl_item,
      $.function_item,
      $.attribute_item,
      $.mod_item,
      $.type_item,
      $.extern_item,
    ),

    line_comment: _ => token(seq("//", /[^\n]*/)),
    block_comment: _ => token(seq("/*", /[^*]*\*+([^/*][^*]*\*+)*/, "/")),

    attribute_item: $ => seq(
      choice("#", "#!"),
      "[",
      $._token_tree,
      "]",
    ),

    _token_tree: $ => repeat1(choice(
      /[^\[\]]+/,
      seq("[", $._token_tree, "]"),
    )),

    use_declaration: $ => seq(
      optional("pub"),
      "use",
      $._use_path,
      optional(";"),
    ),

    _use_path: $ => seq(
      $._path,
      optional(seq(
        "::",
        choice(
          "*",
          seq("{", commaSep($._use_path), "}"),
        ),
      )),
      optional(seq("as", $.identifier)),
    ),

    _path: $ => seq(
      $.identifier,
      repeat(seq("::", $.identifier)),
    ),

    mod_item: $ => seq(
      optional("pub"),
      "mod",
      field("name", $.identifier),
      choice(";", $.declaration_block),
    ),

    type_item: $ => seq(
      optional("pub"),
      "type",
      field("name", $.identifier),
      optional($.type_parameters),
      "=",
      $._type,
      optional(";"),
    ),

    extern_item: $ => seq(
      "extern",
      optional($.string_literal),
      $.declaration_block,
    ),

    const_item: $ => seq(
      optional("pub"),
      "const",
      field("name", $.identifier),
      ":",
      field("type", $._type),
      "=",
      field("value", $._expression),
      optional(";"),
    ),

    static_item: $ => seq(
      optional("pub"),
      "static",
      optional("mut"),
      field("name", $.identifier),
      ":",
      field("type", $._type),
      "=",
      field("value", $._expression),
      optional(";"),
    ),

    struct_item: $ => seq(
      optional("pub"),
      "struct",
      field("name", $.type_identifier),
      optional($.type_parameters),
      choice(
        seq("{", commaSep($.field_declaration), "}"),
        seq("(", commaSep($._type), ")", optional(";")),
        ";",
      ),
    ),

    enum_item: $ => seq(
      optional("pub"),
      "enum",
      field("name", $.type_identifier),
      optional($.type_parameters),
      "{",
      commaSep($.enum_variant),
      "}",
    ),

    enum_variant: $ => seq(
      field("name", $.type_identifier),
      optional(choice(
        seq("(", commaSep($._type), ")"),
        seq("{", commaSep($.field_declaration), "}"),
      )),
    ),

    field_declaration: $ => seq(
      optional("pub"),
      field("name", $.identifier),
      ":",
      field("type", $._type),
    ),

    trait_item: $ => seq(
      optional("pub"),
      "trait",
      field("name", $.type_identifier),
      optional($.type_parameters),
      optional(seq(":", commaSep1($._type))),
      $.declaration_block,
    ),

    impl_item: $ => seq(
      "impl",
      optional($.type_parameters),
      field("type", $._type),
      optional(seq("for", field("for_type", $._type))),
      $.declaration_block,
    ),

    declaration_block: $ => seq(
      "{",
      repeat($._item),
      "}",
    ),

    function_item: $ => seq(
      optional("pub"),
      optional("async"),
      optional("unsafe"),
      "fn",
      field("name", $.identifier),
      optional($.type_parameters),
      field("parameters", $.parameters),
      optional(seq("->", field("return_type", $._type))),
      optional(seq("where", commaSep1($.where_clause))),
      choice(
        $.block,
        ";",
      ),
    ),

    where_clause: $ => seq(
      $._type,
      ":",
      commaSep1($._type),
    ),

    type_parameters: $ => seq(
      "<",
      commaSep1(choice(
        $.identifier,
        seq($.identifier, ":", commaSep1($._type)),
        seq($.identifier, "=", $._type),
      )),
      ">",
    ),

    parameters: $ => seq(
      "(",
      commaSep(choice(
        seq(optional("&"), optional("mut"), "self"),
        $.parameter,
      )),
      ")",
    ),

    parameter: $ => seq(
      optional("mut"),
      field("pattern", $._pattern),
      ":",
      field("type", $._type),
    ),

    block: $ => seq(
      "{",
      repeat($._statement),
      optional($._expression),
      "}",
    ),

    _statement: $ => choice(
      seq($._expression, optional(";")),
      $.let_declaration,
      $._item,
      ";",
    ),

    let_declaration: $ => seq(
      "let",
      optional("mut"),
      field("pattern", $._pattern),
      optional(seq(":", field("type", $._type))),
      optional(seq("=", field("value", $._expression))),
      optional(";"),
    ),

    _pattern: $ => choice(
      $.identifier,
      $.literal,
      $.tuple_pattern,
      $.struct_pattern,
      $.tuple_struct_pattern,
      $.reference_pattern,
      $.range_pattern,
      $.or_pattern,
      $.captured_pattern,
      "_",
      $._path,
    ),

    tuple_pattern: $ => seq("(", commaSep($._pattern), ")"),

    tuple_struct_pattern: $ => seq(
      $._path,
      "(",
      commaSep(choice($._pattern, "..")),
      ")",
    ),

    struct_pattern: $ => seq(
      $._path,
      "{",
      commaSep(choice(
        seq($.identifier, optional(seq(":", $._pattern))),
        "..",
      )),
      "}",
    ),

    reference_pattern: $ => prec(1, seq("&", optional("mut"), $._pattern)),

    range_pattern: $ => prec(1, seq($.literal, choice("..", "..="), $.literal)),

    or_pattern: $ => prec.left(seq($._pattern, "|", $._pattern)),

    captured_pattern: $ => prec(2, seq($.identifier, "@", $._pattern)),

    _type: $ => choice(
      $.primitive_type,
      $.generic_type,
      $.reference_type,
      $.tuple_type,
      $.array_type,
      $.function_type,
      $.type_identifier,
      $._path,
      seq("dyn", $._type),
    ),

    primitive_type: _ => choice(...primitive_types),

    type_identifier: _ => /[A-Z][A-Za-z0-9_]*/,

    generic_type: $ => seq(
      choice($.type_identifier, $._path),
      "<",
      commaSep1($._type),
      ">",
    ),

    reference_type: $ => seq("&", optional("mut"), $._type),

    tuple_type: $ => seq("(", commaSep($._type), ")"),

    array_type: $ => seq(
      "[",
      $._type,
      optional(seq(";", $._expression)),
      "]",
    ),

    function_type: $ => seq(
      "fn",
      "(",
      commaSep($._type),
      ")",
      optional(seq("->", $._type)),
    ),

    _expression: $ => choice(
      $.literal,
      $.identifier,
      $._path,
      $.unary_expression,
      $.binary_expression,
      $.pipe_expression,
      $.assignment_expression,
      $.call_expression,
      $.field_expression,
      $.method_call_expression,
      $.index_expression,
      $.reference_expression,
      $.range_expression,
      $.tuple_expression,
      $.array_expression,
      $.struct_expression,
      $.if_expression,
      $.match_expression,
      $.loop_expression,
      $.while_expression,
      $.for_expression,
      $.return_expression,
      $.break_expression,
      $.continue_expression,
      $.go_expression,
      $.defer_expression,
      $.select_expression,
      $.closure_expression,
      $.parenthesized_expression,
      $.block,
    ),

    parenthesized_expression: $ => seq("(", $._expression, ")"),

    literal: $ => choice(
      $.integer_literal,
      $.float_literal,
      $.string_literal,
      $.raw_string_literal,
      $.byte_string_literal,
      $.char_literal,
      $.boolean_literal,
    ),

    integer_literal: _ => token(seq(
      choice(
        /[0-9][0-9_]*/,
        /0x[0-9a-fA-F_]+/,
        /0b[01_]+/,
        /0o[0-7_]+/,
      ),
      optional(choice(...integer_types, ...float_types)),
    )),

    float_literal: _ => token(seq(
      /[0-9][0-9_]*\.[0-9_]+([eE][+-]?[0-9_]+)?/,
      optional(choice(...float_types)),
    )),

    string_literal: $ => seq(
      '"',
      repeat(choice(
        $._string_content,
        $.escape_sequence,
      )),
      '"',
    ),

    raw_string_literal: _ => token(seq(
      optional("b"),
      "r",
      /#*/,
      '"',
      /[^"]*/,
      '"',
      /#*/,
    )),

    byte_string_literal: $ => seq(
      'b"',
      repeat(choice(
        $._string_content,
        $.escape_sequence,
      )),
      '"',
    ),

    _string_content: _ => /[^"\\]+/,

    escape_sequence: _ => token(seq(
      "\\",
      choice(
        /[nrt0\\"']/,
        /x[0-9a-fA-F]{2}/,
        /u\{[0-9a-fA-F]+\}/,
      ),
    )),

    char_literal: _ => token(seq(
      optional("b"),
      "'",
      choice(
        /[^'\\]/,
        seq("\\", choice(/[nrt0\\"']/, /x[0-9a-fA-F]{2}/, /u\{[0-9a-fA-F]+\}/)),
      ),
      "'",
    )),

    boolean_literal: _ => choice("true", "false"),

    identifier: _ => /[a-zA-Z_][a-zA-Z0-9_]*/,

    unary_expression: $ => prec(PREC.unary, choice(
      seq("-", $._expression),
      seq("!", $._expression),
      seq("*", $._expression),
    )),

    reference_expression: $ => prec(PREC.unary, seq(
      "&",
      optional("mut"),
      $._expression,
    )),

    binary_expression: $ => {
      const table = [
        [PREC.multiplicative, choice("*", "/", "%")],
        [PREC.additive, choice("+", "-")],
        [PREC.shift, choice("<<", ">>")],
        [PREC.bitand, "&"],
        [PREC.bitxor, "^"],
        [PREC.bitor, "|"],
        [PREC.comparative, choice("==", "!=", "<", "<=", ">", ">=")],
        [PREC.and, "&&"],
        [PREC.or, "||"],
      ];

      return choice(...table.map(([prec_, op]) =>
        prec.left(prec_, seq($._expression, op, $._expression)),
      ));
    },

    pipe_expression: $ => prec.left(PREC.pipe, seq(
      $._expression,
      "|>",
      $._expression,
    )),

    assignment_expression: $ => prec.right(PREC.assign, seq(
      $._expression,
      choice("=", "+=", "-=", "*=", "/=", "%=", "&=", "|=", "^=", "<<=", ">>="),
      $._expression,
    )),

    range_expression: $ => prec.left(PREC.assign, choice(
      seq($._expression, choice("..", "..="), $._expression),
      seq($._expression, ".."),
      seq("..", $._expression),
      "..",
    )),

    call_expression: $ => prec(13, seq(
      field("function", $._expression),
      field("arguments", seq("(", commaSep($._expression), ")")),
    )),

    field_expression: $ => prec(13, seq(
      $._expression,
      ".",
      choice($.identifier, /[0-9]+/),
    )),

    method_call_expression: $ => prec(13, seq(
      $._expression,
      ".",
      $.identifier,
      optional(seq("::<", commaSep1($._type), ">")),
      "(",
      commaSep($._expression),
      ")",
    )),

    index_expression: $ => prec(13, seq(
      $._expression,
      "[",
      $._expression,
      "]",
    )),

    tuple_expression: $ => seq("(", commaSep($._expression), ")"),

    array_expression: $ => seq(
      "[",
      choice(
        commaSep($._expression),
        seq($._expression, ";", $._expression),
      ),
      "]",
    ),

    struct_expression: $ => seq(
      $._path,
      "{",
      commaSep(choice(
        seq($.identifier, ":", $._expression),
        $.identifier,
        seq("..", $._expression),
      )),
      "}",
    ),

    if_expression: $ => seq(
      "if",
      field("condition", $._expression),
      field("consequence", $.block),
      optional(seq("else", choice($.block, $.if_expression))),
    ),

    match_expression: $ => seq(
      "match",
      field("scrutinee", $._expression),
      "{",
      commaSep($.match_arm),
      "}",
    ),

    match_arm: $ => seq(
      $._pattern,
      optional(seq("if", $._expression)),
      "=>",
      $._expression,
    ),

    loop_expression: $ => seq("loop", $.block),

    while_expression: $ => seq(
      "while",
      field("condition", $._expression),
      $.block,
    ),

    for_expression: $ => seq(
      "for",
      field("pattern", $._pattern),
      "in",
      field("iterable", $._expression),
      $.block,
    ),

    return_expression: $ => prec.right(seq("return", optional($._expression))),

    break_expression: $ => prec.right(seq("break", optional($._expression))),

    continue_expression: _ => "continue",

    go_expression: $ => prec.right(seq("go", $._expression)),

    defer_expression: $ => prec.right(seq("defer", $._expression)),

    select_expression: $ => seq(
      "select",
      "{",
      commaSep($.select_arm),
      "}",
    ),

    select_arm: $ => seq(
      choice(
        seq($._pattern, "=", $._expression),
        $._expression,
      ),
      "=>",
      $._expression,
    ),

    closure_expression: $ => seq(
      optional("move"),
      "fn",
      field("parameters", $.parameters),
      optional(seq("->", field("return_type", $._type))),
      $.block,
    ),
  },
});

function commaSep(rule) {
  return optional(commaSep1(rule));
}

function commaSep1(rule) {
  return seq(rule, repeat(seq(",", rule)), optional(","));
}
