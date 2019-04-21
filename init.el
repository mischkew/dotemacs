;; init.el --- My personal Emacs configuration.
;;
;; Copyright (c) 2015, 2016
;;
;; Author: Jonathan Chu <me@jonathanchu.is>
;; URL: https://github.com/jonathanchu/dotemacs
;; Version: 1.0

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This is the whole #!

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:
(setq user-full-name "Sven Mischkewitz"
      user-mail-address "sven.mkw@gmail.com")

(add-to-list 'exec-path "/usr/local/bin")
(add-to-list 'exec-path "/usr/local/sbin")

(defvar current-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

(message "Your Emacs is powering up... Be patient, Master %s!" current-user)

;;----------------------------------------------------------------------------
;; Packages
;;----------------------------------------------------------------------------

(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; use-package
(eval-when-compile
  (require 'use-package))
(setq use-package-verbose t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
  '(custom-safe-themes
     (quote
       ("a8636379e484d77d0001e1b2153e23543e07f16758b2a822f98245aee561992e" "1f85df8aab246edb1013b879c8c109046710d5cb19000a6e40df8a6bfc62b7b5" "538717718df6d23d129d928a6c5e003cd086b1670113e83280000f4c5cdb0705" "8cde151de43e9677e5bba110aa6e368bcc3479ee4849e4a7e352a3cb8a036a43" "4931a04d28467edb8aef9027709279d6c914560025fa30810b82b6d69e6b7103" "9b1c580339183a8661a84f5864a6c363260c80136bd20ac9f00d7e1d662e936a" "a94f1a015878c5f00afab321e4fef124b2fc3b823c8ddd89d360d710fc2bddfc" "b59d7adea7873d58160d368d42828e7ac670340f11f36f67fa8071dbf957236a" default)))
  '(package-selected-packages
     (quote
       (multiple-cursors smartparens slime delight pyenv-mode-auto pyenv-mode yaml-mode disable-mouse flycheck move-text magit elpy python-mode markdown-mode dockerfile-mode smex ido-ubiquitous ido-vertical-mode flx-ido git-gutter-fringe fringe-helper aggressive-indent editorconfig airline-themes paradox github-theme use-package)))
  '(tetris-x-colors
     [[229 192 123]
       [97 175 239]
       [209 154 102]
       [224 108 117]
       [152 195 121]
       [198 120 221]
       [86 182 194]]))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(org-level-1 ((t (:foreground "#56B6C2"))))
  '(org-level-4 ((t (:foreground "#0086b3"))))
  '(org-link ((t (:foreground "#D19A66" :underline t))))
  '(slime-repl-output-face ((t (:foreground "#98C379")))))

;;----------------------------------------------------------------------------
;; Literate Config Test
;;----------------------------------------------------------------------------

(defvar my-init-file (expand-file-name "my-emacs-init.el" user-emacs-directory)
  "Test configurations stored in this file.")

(if (file-exists-p my-init-file)
        (load-file my-init-file))

;;; init.el ends here
