; extends

(test
  (header
    (separator) @markup.environment.name))

(test
  (header
    (name) @markup.environment.name))

(test
  (header
    (attributes
      (attribute) @markup.link.label))
 (#set! "priority" 105))

(test
  (separator) @comment)
