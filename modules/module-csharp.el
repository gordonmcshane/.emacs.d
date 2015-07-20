;;; module-csharp.el

(use-package csharp-mode
  :functions (csharp-log)
  :mode "\\.cs$"
  :init (add-hook! csharp-mode 'flycheck-mode))

(use-package omnisharp
  :after csharp-mode
  :init (add-hook! csharp-mode 'omnisharp-mode)
  :config
  (setq omnisharp-server-executable-path
        "~/Dropbox/projects/lib/Omnisharp/server/OmniSharp/bin/Debug/OmniSharp.exe"
        omnisharp-auto-complete-want-documentation nil)

  (bind! :map omnisharp-mode-map
         :n "gd" 'omnisharp-go-to-definition
         :n "\\u" 'omnisharp-find-usages
         :n "\\i" 'omnisharp-find-implementations)

  (after! company
    (add-company-backend! csharp-mode (omnisharp))
    (add-hook! csharp-mode 'turn-on-eldoc-mode)))

;; unity shaders
(use-package shaderlab-mode :mode "\\.shader$")

(provide 'module-csharp)
;;; module-csharp.el ends here