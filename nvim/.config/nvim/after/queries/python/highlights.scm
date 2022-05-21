;; Decorators

; @cache
(decorator
  (identifier) @annotation)

; @functools.cache
((decorator
   (attribute) @annotation)
 (#set! "priority" 105))

; @lru_cache(maxsize=128)
(decorator
  (call function: (identifier) @annotation))

; @functools.lru_cache(maxsize=128)
((decorator
   (call function: (attribute) @annotation))
 (#set! "priority" 105))


;; Classes

(class_definition name: (identifier) @function)
