; extends

(lambda_expression
  body:  (compound_statement)) @function.outer

(lambda_expression
  body: (compound_statement . "{" . (_) @_start @_end (_)? @_end . "}"
 (#make-range! "function.inner" @_start @_end)))
