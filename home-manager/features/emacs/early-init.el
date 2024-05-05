;;; early-init.el ---  -*- lexical-binding: t; no-byte-compile: t; mode: emacs-lisp; coding:utf-8; fill-column: 80 -*-

(add-hook
 'emacs-startup-hook
 (lambda ()
   (message "Emacs ready in %s with %d packages, with %d garbage collections."
            (format "%.2f seconds"
                    (float-time
                     (time-subtract after-init-time before-init-time)))
            (length load-path) gcs-done)))

(setq package-enable-at-startup nil
      inhibit-startup-message t
      frame-resize-pixelwise t
      package-native-compile t)

;; Disable garbage collection during init.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 1.0)
(add-hook 'emacs-startup-hook (lambda ()
                                (setq gc-cons-threshold (* 64 1024 1024)
                                      gc-cons-percentage 0.6)))

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(blink-cursor-mode -1)
(set-fringe-mode 5)

;; Disable file-name-handler-alist until emacs has done startup.
(defvar oposs/file-name-handler-alist-old file-name-handler-alist)
(setq file-name-handler-alist nil)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq file-name-handler-alist oposs/file-name-handler-alist-old)))

;; Silence nativecomp and bytecompile warnings.
(customize-set-variable 'native-comp-async-report-warnings-errors nil)
(customize-set-variable
 'byte-compile-warnings
 '(not free-vars unresolved noruntime lexical make-local obsolete))
