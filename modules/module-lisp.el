;;; module-lisp --- all things lisp
;; see lib/elisp-defuns.el

(define-repl! emacs-lisp-mode ielm)
(add-hook! emacs-lisp-mode 'turn-on-eldoc-mode)

;; [pedantry intensifies]
(defadvice emacs-lisp-mode (after emacs-lisp-mode-rename-modeline activate)
  (setq mode-name "Elisp"))

(defun narf-elisp-auto-compile ()
  (when (narf/is-recompilable-p)
    (narf:compile-el)))

(add-hook! emacs-lisp-mode
  (add-hook 'before-save-hook 'delete-trailing-whitespace nil t)
  (add-hook 'after-save-hook 'narf-elisp-auto-compile nil t)

  (let ((header-face 'font-lock-constant-face))
    (add-to-list 'imenu-generic-expression
                 `("Package" "\\(^\\s-*(use-package +\\)\\(\\_<.+\\_>\\)" 2))
    (add-to-list 'imenu-generic-expression
                 `("Spaceline Segment" "\\(^\\s-*(spaceline-define-segment +\\)\\(\\_<.+\\_>\\)" 2))))

;; Add new colors to helm-imenu
(after! helm-imenu
  (defun helm-imenu-transformer (candidates)
    (cl-loop for (k . v) in candidates
             for types = (or (helm-imenu--get-prop k)
                             (list "Function" k))
             for bufname = (buffer-name (marker-buffer v))
             for disp1 = (mapconcat
                          (lambda (x)
                            (propertize
                             x 'face (cond ((string= x "Variables")
                                            'font-lock-variable-name-face)
                                           ((string= x "Function")
                                            'font-lock-function-name-face)
                                           ((string= x "Types")
                                            'font-lock-type-face)
                                           ((string= x "Package")
                                            'font-lock-negation-char-face)
                                           ((string= x "Spaceline Segment")
                                            'font-lock-string-face))))
                          types helm-imenu-delimiter)
             for disp = (propertize disp1 'help-echo bufname)
             collect
             (cons disp (cons k v)))))

(font-lock-add-keywords
 'emacs-lisp-mode `(("\\(lambda\\)" (0 (narf/show-as ?λ)))))

;; Real go-to-definition for elisp
(map! :map emacs-lisp-mode-map
      :m "gd" 'narf/elisp-find-function-at-pt
      :m "gD" 'narf/elisp-find-function-at-pt-other-window)

(use-package slime :defer t
  :config
  (setq inferior-lisp-program "clisp"))

(provide 'module-lisp)
;;; module-elisp.el ends here