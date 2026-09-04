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

;; OCaml: better error and backtrace matching
(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))
(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'caml-mode-hook 'set-ocaml-error-regexp)

;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
;; Optional: generate opam-user-setup.el with `opam user-setup install`.
(let ((opam-user-setup-file
       (expand-file-name "opam-user-setup.el" user-emacs-directory)))
  (when (file-exists-p opam-user-setup-file)
    (require 'opam-user-setup opam-user-setup-file)))
;; ## end of OPAM user-setup addition for emacs / base ## keep this line
