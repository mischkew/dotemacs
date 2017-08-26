;; my-emacs-init.el --- My personal Emacs configuration.

;;; Code:

;;
;; -- General Stuff --
;;

;; github theme (light)
(use-package github-theme
  :ensure t)

;; doom theme (dark)
;; TODO

;; set theme depending on your mood
(load-theme 'github t)

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

;; save sessions and buffers
(desktop-save-mode 1)
(setq desktop-restore-eager 5)

(add-hook 'prog-mode-hook 'linum-mode)	       ; show line numbers
(setq linum-format "%4d \u2502 ")	       ; add space between numbers and code
(add-hook 'prog-mode-hook 'column-number-mode) ; show column numbers


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
  :diminish editorconfig-mode
  :config
  (editorconfig-mode 1))

;; emacs python ide
(use-package elpy
  :ensure t
  :config
  (elpy-enable))

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
  :diminish git-gutter-mode
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

(use-package ido-ubiquitous
  :ensure t
  :config
  (ido-ubiquitous-mode 1))

(use-package smex
  :ensure t
  :init
  (smex-initialize))

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

;; Python major mode
(use-package python-mode
  :ensure t
  :config
  (add-hook 'python-mode-hook
            '(lambda ()
               (setq fill-column 79)))
  (add-to-list 'auto-mode-alist '("\\.py" . python-mode)))

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
