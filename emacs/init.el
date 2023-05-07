;;; Backups ;;;
(setq backup-directory-alist '(("" . "~/.emacs.d/backup/per-save"))
      backup-by-copying t
      make-backup-files t
      version-control t
      delete-old-versions t
      delete-by-moving-to-trash t
      kept-old-versions 6
      kept-new-versions 9
      auto-save-default t
      auto-save-timeout 20
      auto-save-interval 100
      vc-make-backup-files t)

(defun force-backup-of-buffer ()
  (when (not buffer-backed-up)
    (let ((backup-directory-alist '(("" . "~/.emacs.d/backup/per-session")))
          (kept-new-versions 3))
      (backup-buffer)))
  (let ((buffer-backed-up nil))
    (backup-buffer)))

(add-hook 'before-save-hook  'force-backup-of-buffer)

;;; General settings ;;;
;; Disable splash screen
(setq inhibit-startup-message t
      initial-scratch-message nil)

(setq-default vc-follow-symlinks t ;; Follow symlinks
      visible-bell t ;; Disable sound bell
      show-trailing-whitespace t ;; Show trailing whitespaces
      )

;; Normal selection by default
(delete-selection-mode 1)

;; Enable mouse
(xterm-mouse-mode 1)
(global-set-key (kbd "<mouse-4>") 'scroll-down-line)
(global-set-key (kbd "<mouse-5>") 'scroll-up-line)

;; Disable menu-bar
(menu-bar-mode -1)

;; Enable mouse
(xterm-mouse-mode 1)

;; Display line numbers
(add-hook 'prog-mode-hook
	  'display-line-numbers-mode)


;;; Loading packages ;;;
;; MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;; Org
(use-package org
  :ensure
  :mode (("\\.org$" . org-mode))
  :config
  (setq org-hide-emphasis-markers t)
  :hook (org-mode . visual-line-mode))

(use-package org-bullets
  :ensure
  :hook (org-mode . org-bullets-mode))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

;;; Editor ;;;
;; Disable these annoying bars
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Consult
(use-package consult
  :ensure
  :bind
  ("C-x b" . consult-buffer)
  ("C-x C-b" . switch-to-buffer))

;; Distraction-free screen
(use-package olivetti
  :ensure
  :init
  (setq olivetti-body-width .67)
  :config
  (defun distraction-free ()
    "Distraction-free writing environment"
    (interactive)
    (if (equal olivetti-mode nil)
        (progn
          (window-configuration-to-register 1)
          (delete-other-windows)
          (text-scale-increase 2)
          (olivetti-mode t)
	  (display-line-numbers-mode 0))
      (progn
        (jump-to-register 1)
        (olivetti-mode 0)
        (display-line-numbers-mode t)
        (text-scale-decrease 2))))
  :bind
  (("<f9>" . distraction-free)))

;; Save history
(use-package savehist
  :init
  (savehist-mode t))

;; For minibuffer completion
(use-package vertico
  :ensure
  :config
  (vertico-mode t))

;; For rich completion annotations
(use-package marginalia
  :ensure
  :init
  (marginalia-mode t))

;; Display keybindings help
(use-package which-key
  :ensure
  :init
  (which-key-mode t)
  :custom
  (which-key-idle-delay 0.75))

;; Select ([C-RET]) then [M-s l] for multiple cursors
(use-package multiple-cursors
  :ensure
  :bind
  ("M-s l" . mc/edit-lines))

;; For quick motion ; replacement for `vim-sneak'
(use-package avy
  :ensure
  :bind
  ("M-s M-s" . avy-goto-char-2))

;; Git
(use-package magit
  :ensure)

;; `orderless' completion style.
(use-package orderless
  :ensure
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package treemacs
  :ensure
  :bind
  (:map global-map
	("C-t" . treemacs)))

(setq-default cursor-type 'bar)

(set-frame-font (font-spec :family "FiraCode Nerd Font" :size 14))
(setq default-frame-alist '((font . "FiraCode Nerd Font 12")))

(use-package ligature
  :ensure
  :config
  (ligature-set-ligatures 'prog-mode '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
                                       ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
                                       "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
                                       "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
                                       "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
                                       "..." "+++" "/==" "///" "_|_" "www" "&&" "^=" "~~" "~@" "~="
                                       "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
                                       "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
                                       ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
                                       "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
                                       "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
                                       "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "~~" "(*" "*)"
                                       "\\\\" "://"))
  (global-ligature-mode t))

(use-package gruvbox-theme
  :ensure
  :config
  (load-theme 'gruvbox-dark-medium t))

(use-package powerline
  :ensure
  :init
  (powerline-default-theme))

(use-package all-the-icons
  :ensure)

(use-package rainbow-delimiters
  :ensure
  :hook
  (prog-mode . rainbow-delimiters-mode))

;;; Semantic language packages/configurations ;;;
(use-package lsp-mode
  :ensure
  :bind-keymap
  ("C-l" . lsp-command-map)
  :bind
  (:map lsp-command-map
	("C-r" . lsp-rename)
	("C-a" . lsp-execute-code-action)
        ("C-d" . lsp-find-definition)
	("C-s" . lsp-find-references))
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints t))

(use-package lsp-ui
  :ensure)

(use-package company
  :ensure
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package flycheck
  :ensure)

(use-package yasnippet
  :ensure
  :config
  (yas-global-mode))

(use-package yasnippet-snippets
  :ensure)

;; Nix
(use-package nix-mode
  :ensure
  :mode "\\.nix\\'")

;; Coq
(use-package proof-general
  :ensure
  :config
  (setq proof-splash-enable nil
	overlay-arrow-string ""))

(use-package company-coq
  :ensure
  :init
  (add-hook 'coq-mode-hook #'company-coq-mode)
  :config
  (setq company-coq-features/prettify-symbols-in-terminals t))

;; C & co
(use-package ccls
  :ensure)

;; Haskell
(use-package haskell-mode
  :ensure)

;; Rust
(use-package rustic
  :ensure
  :config
  (setq rustic-format-on-save nil))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(consult haskell-mode ccls company-coq proof-general nix-mode yasnippet-snippets yasnippet rainbow-delimiters all-the-icons powerline gruvbox-theme ligature treemacs orderless magit avy multiple-cursors which-key marginalia vertico olivetti org-bullets use-package)))

