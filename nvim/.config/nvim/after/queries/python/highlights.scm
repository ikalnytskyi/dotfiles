; extends

;; Decorators

; @cache
(decorator
  (identifier) @preproc)

; @functools.cache
((decorator
   (attribute) @preproc)
 (#set! "priority" 105))

; @lru_cache(maxsize=128)
(decorator
  (call function: (identifier) @preproc))

; @functools.lru_cache(maxsize=128)
((decorator
   (call function: (attribute) @preproc))
 (#set! "priority" 105))


;; Classes

(class_definition name: (identifier) @function)
