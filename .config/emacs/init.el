;;; init.el --- ~/.config/emacs/init.el  -*- lexical-binding: t; -*-
;; Based on the OPAM user-setup template (Louis Gesbert, CC0).

(make-directory "~/.local/share/emacs/backups" t)

(custom-set-variables
 '(indent-tabs-mode nil)
 '(compilation-context-lines 2)
 '(compilation-error-screen-columns nil)
 '(compilation-scroll-output t)
 '(compilation-search-path (quote (nil "src")))
 '(electric-indent-mode nil)
 '(next-line-add-newlines nil)
 '(require-final-newline t)
 '(sentence-end-double-space nil)
 '(show-trailing-whitespace t)
 '(visible-bell t)
 '(show-paren-mode t)
 '(next-error-highlight t)
 '(next-error-highlight-no-select t)
 '(backup-directory-alist '(("." . "~/.local/share/emacs/backups")))
 '(line-move-visual t))

;; ANSI color in compilation buffers (built in since Emacs 28)
(add-hook 'compilation-filter-hook #'ansi-color-compilation-filter)

;; Key bindings
(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
