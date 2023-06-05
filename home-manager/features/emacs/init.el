(setq custom-file (concat user-emacs-directory "custom.el"))

(setq config-file (concat user-emacs-directory "config.org"))
(org-babel-load-file config-file)

(when (file-exists-p custom-file)
  (load custom-file))
