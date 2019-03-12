;; my-emacs-init.el --- My personal Emacs configuration.

;;; Code:

;;
;; -- Use Package Addons --
;;

(use-package delight
  :ensure t)

(use-package bind-key
  :ensure t)

;;
;; -- General Stuff --
;;

;; set emacs exec path
(setq exec-path (cons "~/.pyenv/shims" exec-path))

;; themes
(use-package github-theme :ensure t)
(add-to-list 'custom-theme-load-path "~/.emacs.d/vendor/atom-one-dark-theme/")

;; set theme depending on your mood
(load-theme 'github t)
(load-theme 'atom-one-dark t)

;; turn off the bell
(setq ring-bell-function 'ignore)

;; Set the number to the number of columns to use.
(setq-default fill-column 79)

;; Add Autofill mode to mode hooks.
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Enable syntax highlighting. This will also highlight lines that
;; form a region.
(global-font-lock-mode 1)

;; Always load newest byte code
(setq load-prefer-newer t)

;; Warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; Reduce the frequency of garbage collection by making it happen on
;; each 25MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 25000000)

;; only type 'y' or 'n' instead of 'yes' or 'no'
(fset 'yes-or-no-p 'y-or-n-p)

;; no splash screen
(setq inhibit-splash-screen t)

;; no message on startup
(setq initial-scratch-message nil)

;; no menu bar
(menu-bar-mode -1)

;; no toolbar
(when (functionp 'tool-bar-mode)
  (tool-bar-mode -1))

;; disable scroll bars
(if window-system
    (progn
      (scroll-bar-mode -1)))

;; set default cursor type
(setq-default cursor-type 'bar)

;; nice fonts in OS X
(setq mac-allow-anti-aliasing t)

;; highlight current line
(global-hl-line-mode +1)

;; show file size
(size-indication-mode t)

;; show extra whitespace
(setq show-trailing-whitespace t)

;; ensure last line is a return
(setq require-final-newline t)

;; set encoding
(prefer-coding-system 'utf-8)

;; and tell emacs to play nice with encoding
(define-coding-system-alias 'UTF-8 'utf-8)
(define-coding-system-alias 'utf8 'utf-8)

;;keep cursor at same position when scrolling
(setq scroll-preserve-screen-position t)

;; scroll one line at a time
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
(setq scroll-step 1) ;; keyboard scroll one line at a time
(setq scroll-conservatively 10000)
(setq scroll-margin 3)

;; instantly display current key sequence in mini buffer
(setq echo-keystrokes 0.02)

;; improve filename completion
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
(mapc (lambda (x)
	(add-to-list 'completion-ignored-extensions x))
      '(".gz" ".pyc" ".elc" ".exe"))

;; delete selection, insert text
(delete-selection-mode t)

;; make M-Tab obsolete
;; (setq tab-always-indent ‘complete)

;; write temp files to directory to not clutter the filesystem
(defvar user-temporary-file-directory
  (concat temporary-file-directory user-login-name "/"))
(make-directory user-temporary-file-directory t)
(setq backup-by-copying t)
(setq backup-directory-alist
      `(("." . ,user-temporary-file-directory)
	(,tramp-file-name-regexp nil)))
(setq auto-save-list-file-prefix
      (concat user-temporary-file-directory ".auto-saves-"))
(setq auto-save-file-name-transforms
      `((".*" ,user-temporary-file-directory t)))

;; start server in window mode
;; (when (display-graphic-p)
;;   (unless (and (fboundp 'server-running-p)
;;              (server-running-p))
;;     (server-start)))

;; use desktop files to save sessions and buffers, but
;; handle stale desktop lock files correctly
;; https://emacs.stackexchange.com/a/31622
(require 'desktop)
(defun my-remove-stale-lock-file (dir)
  (let ((pid (desktop-owner dir)))
    (when pid
      (let ((infile nil)
            (destination nil)
            (display nil))
        (unless (= (call-process "ps" infile destination display "-p"
                                 (number-to-string pid)) 0)
          (let ((lock-fn (desktop-full-lock-name dir)))
            (delete-file lock-fn)))))))

(let ((dir "/home/sven/.emacs.d/"))
  (my-remove-stale-lock-file dir)
  (setq desktop-path (list dir))
  (desktop-save-mode 1))

(add-hook 'prog-mode-hook 'linum-mode)	       ; show line numbers
(setq linum-format "%4d \u2502 ")	       ; add space between numbers and code
(add-hook 'prog-mode-hook 'column-number-mode) ; show column numbers

(use-package autorevert
  :delight auto-revert-mode)

;;
;; -- Minor Modes --
;;

;; package manager
(use-package paradox
  :ensure t
  :config
  (setq paradox-execute-asynchronously t))

;; improve emacs bottom line
(use-package airline-themes
  :ensure t
  :config
  (load-theme 'airline-papercolor))

;; Parenthesis Highlighting
(use-package paren
  :config
    (show-paren-mode t))

;; support cross-editor code formatting using .editorconfig files
(use-package editorconfig
  :ensure t
  :delight
  :config
  (editorconfig-mode 1))

;; fringe
(use-package fringe-helper
  :ensure t)

(setq-default fringes-outside-margins t
              highlight-nonselected-windows nil)

;; git highlights
(use-package git-gutter-fringe
  :ensure t)

(use-package git-gutter
  :ensure t
  :delight
  :config
  (require 'git-gutter-fringe)
  (global-git-gutter-mode +1)
  (add-hook 'focus-in-hook 'git-gutter:update-all-windows))

;; ido stuff
(use-package flx-ido
  :ensure t)

(use-package ido
  :config
  (progn
    (ido-mode t)
    (ido-everywhere t)
    (flx-ido-mode t)
    (setq ido-enable-flex-matching t)
    (setq ido-use-faces nil)))

(use-package ido-vertical-mode
  :ensure t
  :config
  (progn
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys #'C-n-and-C-p-only)))

(use-package ido-completing-read+
  :ensure t
  :config
  (ido-ubiquitous-mode 1))

(use-package smex
  :ensure t
  :init
  (smex-initialize))

(use-package disable-mouse
  :ensure t
  :delight global-disable-mouse-mode
  :init
  (global-disable-mouse-mode))

;; move regions or lines up/ down
(use-package move-text
  :ensure t
  :bind (("<C-S-up>" . move-text-up)
          ("<C-S-down>" . move-text-down)))

;; syntax checking and linting
(use-package flycheck
  :ensure t
  :delight
  :init
  (progn
    (setq flycheck-indication-mode 'left-fringe)
    ;; disable the annoying doc checker
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
  :config
  (global-flycheck-mode 1))

;; -- Python --

(use-package pyenv-mode
  :ensure t
  :init
  (pyenv-mode))

;; load the local setup.cfg for flake8 python checking
(use-package flycheck-local-flake8
  :load-path "vendor/flycheck-local-flake8"
  :init
  (require 'flycheck-local-flake8)
  (add-hook 'flycheck-before-syntax-check-hook
	    #'flycheck-local-flake8/flycheck-virtualenv-set-python-executables 'local))

;; -- Lisp --

;; aggressive-indent
;; Keeps code correctly indented during editing.
(use-package aggressive-indent
  :ensure t
  :commands aggressive-indent-mode
  :init
  (progn
    (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
    (add-hook 'lisp-mode-hook #'aggressive-indent-mode)))

;; slime for lisp debugging etc
(use-package slime
  :ensure t
  :init
  (progn
    (setq inferior-lisp-program "/home/linuxbrew/.linuxbrew/bin/sbcl")
    (setq slime-contribs '(slime-fancy))))

;; smartparens and never forget parentheses again :)

;;
;; -- Major Modes --
;;

;; edit Dockerfiles
(use-package dockerfile-mode
  :ensure t
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

;; Markdown files with Github flavor
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
	 ("\\.md\\'" . markdown-mode)
	 ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; YAML files
(use-package yaml-mode
  :ensure t
  :mode (("\\.yml\\'" . yaml-mode)
	 ("\\.yaml\\'" . yaml-mode)))

;; Python major mode
(use-package python-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook
            '(lambda ()
               (setq fill-column 79)))
  (add-to-list 'auto-mode-alist '("\\.py" . python-mode)))

;; emacs python ide
(use-package elpy
  :ensure t
  :defer 2
  :config
  (progn
    ;; Use Flycheck instead of Flymake
    (when (require 'flycheck nil t)
      (remove-hook 'elpy-modules 'elpy-module-flymake)
      (remove-hook 'elpy-modules 'elpy-module-yasnippet)
      (remove-hook 'elpy-mode-hook 'elpy-module-highlight-indentation)
      (add-hook 'elpy-mode-hook 'flycheck-mode))
    (elpy-enable)
    ;; jedi is great
    (setq elpy-rpc-backend "jedi")))

;; Git with emacs
(use-package magit
  :ensure t
  :config
  (progn
    (setq magit-push-always-verify nil)
    (setq magit-completing-read-function #'ivy-completing-read)
    (setq magit-last-seen-setup-instructions "1.4.0")
    (setq magit-diff-refine-hunk t))
  :bind
  ("C-x C-g" . magit-status)
  ("C-c C-a" . magit-commit-amend))

;;
;; -- Function --
;;

;; duplicate the current line function
(defun duplicate-line ()
  "Duplicate the current line."
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (forward-line 1)
  (yank))

;; Kill the current buffer
(defun kill-current-buffer ()
  "Kills the current buffer"
  (interactive)
  (kill-buffer (buffer-name)))

;;
;; -- Key Bindings --
;;

;; duplicate the current line
(global-set-key (kbd "C-c d") #'duplicate-line)

;; kill the current buffer
(global-set-key (kbd "C-x C-k") #'kill-current-buffer)

;; windmove
(global-set-key (kbd "<M-s-left>") 'windmove-left)
(global-set-key (kbd "<M-s-right>") 'windmove-right)
(global-set-key (kbd "<M-s-up>") 'windmove-up)
(global-set-key (kbd "<M-s-down>") 'windmove-down)

;; sorting
(global-set-key (kbd "M-s") #'sort-lines)

;;; my-emacs-init.el ends here
