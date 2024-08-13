(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

; theme
(require 'modus-themes)
(load-theme 'modus-vivendi-tinted :no-confirm)

; modeline
(require 'doom-modeline)
(doom-modeline-mode 1)
(setq doom-modeline-icon t)
;(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-buffer-modification-icon t)
(setq doom-modeline-lsp-icon t)
(setq doom-modeline-time-icon t)
(setq doom-modeline-time-live-icon t)
(setq doom-modeline-buffer-name t)
(setq doom-modeline-minor-modes t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-indent-info t)
(setq doom-modeline-total-line-number t)
(setq doom-modeline-vcs-icon t)
(setq doom-modeline-check-icon t)
(setq doom-modeline-workspace-name t)
(setq doom-modeline-persp-name t)
(setq doom-modeline-lsp t)
(setq doom-modeline-modal t)
(setq doom-modeline-modal-icon t)
(setq doom-modeline-modal-modern-icon t)
(setq doom-modeline-gnus t)
(setq doom-modeline-battery t)
(setq doom-modeline-time t)
(setq doom-modeline-display-misc-in-all-mode-lines t)
(setq doom-modeline-env-version t)

(setq display-line-numbers 'relative)

(setq package-selected-packages '(lsp-mode lsp-ui yasnippet lsp-treemacs helm-lsp
					   projectile hydra flycheck company avy which-key helm-xref dap-mode ccls
					   doom-modeline evil flycheck-rust good-scroll lsp-pyright modus-themes))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

; C/C++
(require 'ccls)
(setq ccls-executable "/usr/bin/ccls")
(setq flycheck-gcc-args '("-Wall" "-Wextra"))

; bash
(setq lsp-bash-explainshell-endpoint t)
(setq lsp-bash-glob-pattern t)
(setq lsp-bash-highlight-parsing-errors t)

;python
(require 'lsp-pyright)

;rust
(with-eval-after-load 'rust-mode
		     (add-hook 'flycheck-rust-setup))

(require 'lsp-ui)
(setq lsp-enable-symbol-highlighting t)
(setq lsp-lens-enable nil)
(setq lsp-headerline-breadcrumb-enable t)
(setq lsp-ui-sideline-enable t)
(setq lsp-ui-sideline-show-diagnostics t)
(setq lsp-ui-sideline-show-hover t)
(setq lsp-ui-sideline-show-code-actions t)
(setq lsp-modeline-code-actions-enable t)
(setq lsp-diagnostics-provider :flycheck)
(setq lsp-eldoc-enable-hover t)
(setq lsp-modeline-diagnostics-enable t)
(setq lsp-signature-auto-activate t) ;; you could manually request them via `lsp-signature-activate`
(setq lsp-signature-render-documentation t)
(setq lsp-completion-provider :company-mode)
(setq lsp-completion-show-detail t)
(setq lsp-completion-show-kind t)
(setq lsp-ui-peek-enable t)
(setq lsp-ui-peek-show-directory t)
(setq lsp-ui-doc-enable t)
(setq lsp-ui-doc-show-with-cursor t)
(setq lsp-ui-doc-show-with-mouse t)

(which-key-mode)

;c/c++ hooks
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

;bash hook
(add-hook 'sh-mode-hook 'lsp)

;python hook
(add-hook 'python-mode-hook 'lsp)

;rust hook
(add-hook 'rust-mode-hook 'lsp-deferred)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(good-scroll-mode 1)
(require 'evil)
(evil-mode 1)

(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'absolute)
(dolist (mode '(org-mode-hook
		dired-mode-hook
		eshell-mode-hook
		shell-mode-hook
		term-mode-hook
		vterm-mode-hook))
  (add-hook mode (lambda ()
		   (display-line-numbers-mode 0))))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("8d146df8bd640320d5ca94d2913392bc6f763d5bc2bb47bed8e14975017eea91" "e410458d3e769c33e0865971deb6e8422457fad02bf51f7862fa180ccc42c032" default))
 '(package-selected-packages
   '(flycheck-rust lsp-pyright ghub doom-modeline modus-themes evil good-scroll yasnippet-snippets ccls lsp-mode lsp-ui yasnippet lsp-treemacs helm-lsp projectile hydra flycheck company avy which-key helm-xref dap-mode))
 '(xterm-mouse-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;(defun lsp-booster--advice-json-parse (old-fn &rest args)
;  "Try to parse bytecode instead of json."
;  (or
;   (when (equal (following-char) ?#)
;     (let ((bytecode (read (current-buffer))))
;       (when (byte-code-function-p bytecode)
;         (funcall bytecode))))
;   (apply old-fn args)))
;(advice-add (if (progn (require 'json)
;                       (fboundp 'json-parse-buffer))
;                'json-parse-buffer
;              'json-read)
;            :around
;            #'lsp-booster--advice-json-parse)

;(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
;  "Prepend emacs-lsp-booster command to lsp CMD."
;  (let ((orig-result (funcall old-fn cmd test?)))
;    (if (and (not test?)                             ;; for check lsp-server-present?
;             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
;             lsp-use-plists
;             (not (functionp 'json-rpc-connection))  ;; native json-rpc
;             (executable-find "emacs-lsp-booster"))
;        (progn
;          (message "Using emacs-lsp-booster for %s!" orig-result)
;          (cons "emacs-lsp-booster" orig-result))
;      orig-result)))
;(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)
