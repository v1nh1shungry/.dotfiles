;; extends

((comment) @comment
  (#match? @comment "^//")
  (#set! @comment bo.commentstring "// %s"))

((comment) @comment
  (#match? @comment "^/\\*")
  (#set! @comment bo.commentstring "/* %s */"))
