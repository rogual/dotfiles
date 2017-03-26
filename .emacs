(setq debug-on-error t)
;; Don't shit files everywhere
(progn
  (setq make-backup-files nil)
  (setq create-lockfiles nil)
  (setq backup-directory-alist `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))))



;;; PACKAGE MANAGER

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(defmacro require-package (name &rest body)
  (declare (indent defun))
  `(use-package ,name
     :ensure t
     :config ,@body))

;; Show help after first of key sequence
(require-package which-key
  (which-key-mode))



;;; EDITING

;; Abbrevs
(progn

  (add-hook 'prog-mode-hook
            (lambda () (abbrev-mode)))

  (add-hook 'org-mode-hook
            (lambda () (abbrev-mode)))

  (kill-all-abbrevs)
  (kill-all-abbrevs)

  (define-global-abbrev "clog" "console.log")
  (define-global-abbrev "rq" "require")
  (define-global-abbrev "im" "import")
  (define-global-abbrev "pa" "function")
  (define-global-abbrev "fnc" "package")
  (define-global-abbrev "ifa" "interface")
  (define-global-abbrev "impl" "implementation")
  (define-global-abbrev "cont" "continue")

  (define-global-abbrev "pub" "public")
  (define-global-abbrev "priv" "private")
  (define-global-abbrev "prot" "protected")

  (define-global-abbrev "ovr" "override")

  (define-global-abbrev "noti" "notification")
  (define-global-abbrev "notis" "notifications")

  (define-global-abbrev "scl" "static class")
  (define-global-abbrev "sfn" "static function")
  (define-global-abbrev "pcl" "public class")
  (define-global-abbrev "pfn" "public function")
  (define-global-abbrev "pscl" "public static class")
  (define-global-abbrev "psfn" "public static function")
  (define-global-abbrev "pifa" "public interface"))


;; Flycheck
(require-package flycheck
  (setq-default flycheck-disabled-checkers
                '(emacs-lisp-checkdoc jshint python-pycompile))
  (global-flycheck-mode))

;; Dired
(add-hook 'dired-mode-hook
          (lambda () (dired-hide-details-mode 1)))
(require 'dired-x)

;; Paredit
(require-package paredit)

;; Editing preferences
(setq-default indent-tabs-mode nil)
(setq column-number-mode 1)

;; Helm
(require-package helm
  (require 'helm)
  (require 'helm-config)

  (use-package evil
    :config
    (define-key evil-normal-state-map (kbd "§k") 'helm-show-kill-ring))

  (global-set-key (kbd "C-c o p") 'helm-buffers-list)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (helm-mode 1))

;; Whitespace
(add-hook 'before-save-hook 'whitespace-cleanup)



;;; WINDOWS

(winner-mode 1)



;;; DOCS

(when (eq system-type 'gnu/linux)
  (require-package zeal-at-point
    (global-set-key (kbd "C-c d") 'zeal-at-point)))



;;; APPEARANCE


;; GUI Annoyances
(progn
  (setq ring-bell-function 'ignore)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode (if (eq system-type 'darwin) 1 0))
  (blink-cursor-mode 0))

(setq frame-title-format (if (eq system-type 'darwin) "%b" "%b - Emacs"))

(require-package page-break-lines
  (global-page-break-lines-mode))

(require-package jbeans-theme)

;; Show Paren
(setq show-paren-delay 0)
(add-hook 'prog-mode-hook
          #'show-paren-mode)
(set-face-background 'show-paren-match "#9999aa")
(set-face-foreground 'show-paren-match "#000000")


;; Fonts
(set-face-attribute
 'default nil
 :height 120
 :family (if (eq system-type 'darwin) "Menlo" "Iosevka"))

(setq face-font-rescale-alist '(("Kailasa" . 1.5)))



;;; STARTUP

;; Default file
(setq initial-buffer-choice "~/notes.org")
(setq default-directory "~")



;;; LANGUAGE SUPPORT

(progn
  (add-to-list 'auto-mode-alist '("\\.pl\\'" . prolog-mode)))

(require-package haxe-mode)

;; Yaml
(require-package yaml-mode)

;; Lisp
(setq inferior-lisp-program (if (eq system-type 'darwin) "ccl64" "sbcl"))

(require-package slime
  (setq inferior-lisp-program "ccl64")
  (setq slime-contribs '(slime-listener-hooks))
  (setq common-lisp-hyperspec-root
        (if (eq system-type 'darwin)
            "/usr/local/share/doc/hyperspec/HyperSpec/"
          "/usr/share/doc/hyperspec/"))
  (setq slime-words-of-encouragement '(""))
  (setq common-lisp-hyperspec-symbol-table
        (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
  (setq common-lisp-hyperspec-issuex-table
        (concat common-lisp-hyperspec-root "Data/Map_IssX.txt")))

;; C++
(defun my-c-lineup-inclass (langelem)
  (let ((inclass (assoc 'inclass c-syntactic-context)))
    (save-excursion
      (goto-char (c-langelem-pos inclass))
      (if (or (looking-at "struct")
              (looking-at "typedef struct"))
          '+
        '++))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook (lambda()
                           (c-set-offset 'inclass 'my-c-lineup-inclass)
                           (c-set-offset 'access-label '-)))

;; ActionScript
(add-to-list 'auto-mode-alist '("\\.as\\'" . javascript-mode))

;; GLSL
(require-package glsl-mode
  (autoload 'glsl-mode "glsl-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode)))

;; Assembly
(add-hook 'asm-mode-hook (lambda()
                           (setq tab-stop-list '(12))))

;; JS
(setq js-indent-level 2)

;; JSx
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . js-jsx-mode))

;; Python
(require-package pydoc-info
  (info-lookup-add-help
   :mode 'python-mode
   :parse-rule 'pydoc-info-python-symbol-at-point
   :doc-spec
   '(("(python)Index" pydoc-info-lookup-transform-entry)
     ("(TARGETNAME)Index" pydoc-info-lookup-transform-entry))))

(require-package pytest
  (setq pytest-cmd-flags "-s"))

(when (not (eq system-type 'darwin))
  (require-package elpy
    (global-set-key (kbd "C-c .") 'elpy-goto-definition)))

(add-to-list 'auto-mode-alist '("SConstruct" . python-mode))

;; Markdown
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

;; Web
(require-package web-mode
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode)))



;; EVIL MODE

(use-package evil
  :ensure t
  :init
  (global-set-key (kbd "C-c C-u") 'universal-argument)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (global-set-key (kbd "s-[") 'evil-prev-buffer)
  (global-set-key (kbd "s-]") 'evil-next-buffer)

  (define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

  (setq-default evil-symbol-word-search 'symbol)

  (define-key evil-normal-state-map (kbd ",1") 'dired-jump)

  (setq evil-motion-state-modes
        (append evil-emacs-state-modes evil-motion-state-modes))
  (setq evil-emacs-state-modes nil)

  (load "~/.emacs.d/evil-little-word.el")
  (require 'evil-little-word)

  (require-package evil-surround
    (global-evil-surround-mode 1))

  (require-package evil-args
    (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
    (define-key evil-outer-text-objects-map "a" 'evil-outer-arg)))



;;; ORG MODE

(require-package org
  (require 'ox-md nil t)

  (require-package org-bullets
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

  (require-package ob-http)

  (setq org-confirm-babel-evaluate nil
        org-html-postamble nil
        org-export-babel-evaluate nil
        org-src-fontify-natively t
        org-export-with-sub-superscripts nil
        org-src-tab-acts-natively t)

  (org-babel-do-load-languages
   'org-babel-load-languages
   '((sh         . t)
     (gnuplot    . t)
     (js         . t)
     (C          . t)
     (http       . t)
     (emacs-lisp . t)
     (sql        . t)
     (perl       . t)
     (scala      . t)
     (ditaa      . t)
     (clojure    . t)
     (python     . t)
     (ruby       . t)
     (dot        . t)
     (css        . t)
     (plantuml   . t)))

  (use-package evil
    :config
    (add-hook 'org-mode-hook (lambda()
                               (setq evil-auto-indent nil)))))



;;; GENERAL CODING

(setq vc-follow-symlinks t)
(setq compilation-scroll-output 'first-error)

;; Projectile
(require-package helm-projectile
  (use-package evil
    :config
    (define-key evil-normal-state-map (kbd "C-l") 'helm-projectile-find-other-file)
    (define-key evil-normal-state-map (kbd "C-p") 'helm-projectile-find-file)
    (define-key evil-normal-state-map (kbd "C-S-p") 'helm-projectile-ag))

  (setq projectile-completion-system 'helm)
  (setq projectile-switch-project-action 'projectile-dired)
  (helm-mode)
  (helm-projectile-on)
  (projectile-global-mode)
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories "ve")
  (add-to-list 'projectile-other-file-alist '("cc" "h"))
  (add-to-list 'projectile-other-file-alist '("h" "cc"))
  (global-set-key (kbd "M-x") 'helm-M-x))

;; Magit
(require-package magit
  (global-set-key (kbd "C-c g s") 'magit-status)
  (use-package evil
    :config
    (evil-set-initial-state 'magit-status-mode 'emacs)))

;; Git-gutter
(require-package git-gutter
  (use-package evil
    :config
    (define-key evil-normal-state-map (kbd "]h") 'git-gutter:next-hunk)
    (define-key evil-normal-state-map (kbd "[h") 'git-gutter:previous-hunk))
  (global-git-gutter-mode 1))


(require-package helm-ag
  (define-key helm-ag-mode-map (kbd "§j") 'helm-ag-mode-jump-other-window)
  (setq helm-ag-use-agignore t)
  (define-key evil-normal-state-map (kbd "C-x p") 'helm-ag))

(require-package rust-mode)



;;; MAPPINGS

;; Menu toggle
(global-set-key (kbd "<f12>") 'menu-bar-mode)

;; Use Esc to quit stuff
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; OSX CUA Keys
(setq mac-option-modifier nil)
(setq mac-command-modifier 'super)
(setq mac-right-command-modifier 'meta)
(global-set-key (kbd "s-s") 'save-buffer)
(global-set-key (kbd "s-x") 'clipboard-kill-region)
(global-set-key (kbd "s-c") 'clipboard-kill-ring-save)
(global-set-key (kbd "s-v") 'clipboard-yank)
(global-set-key (kbd "s-q") 'save-buffers-kill-terminal)
(global-set-key (kbd "s-a") 'mark-whole-buffer)
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s-=") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)
(global-set-key (kbd "s-_") 'text-scale-decrease)

(progn
  (defmacro file-key (key file)
    `(global-set-key (kbd ,key) (lambda() (interactive)(find-file ,file))))

  (file-key "C-c f n" "~/notes.org")
  (file-key "C-c f e" "~/.emacs")
  (file-key "C-c f b" "~/.bash_profile")
  (file-key "C-c f p" "~/Projects"))

(when (eq system-type 'darwin)
  (global-set-key
   (kbd "C-c t")
   (lambda()
     (interactive)
     (projectile-with-default-dir (projectile-project-root)
       (shell-command "open -a terminal .")))))


;; Visible whitespace
(progn
  (require 'whitespace)
  (setq whitespace-global-modes '(prog-mode))
  (setq-default whitespace-style '(tab-mark lines-tail face))
  (setq-default whitespace-line-column 80)
  (global-whitespace-mode t))

;; Trailing whitespace
(add-hook 'prog-mode-hook
          (lambda () (add-to-list
                      'write-file-functions
                      'delete-trailing-whitespace)))

;; 80 chars
(progn
  (when nil
    (require-package adaptive-wrap
      (visual-line-mode)
      (adaptive-wrap-prefix-mode)))

  (require-package multi-line)
  (setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow)))

                                        ; Custom vars in separate file
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)



;;; COLOR SCHEMES

(defun light ()
  (interactive)
  (global-font-lock-mode)

  (setq black "#000000")
  (setq white "#eeeeee")

  (set-face-attribute
   'default nil
   :height 120
   :family "Monaco")

  (set-face-background 'default white)
  (set-face-foreground 'default black)

  (dolist (face (face-list))
    (set-face-bold face nil)
    (set-face-italic face nil)
    (set-face-underline face nil)
    (set-face-background face nil)
    (set-face-foreground face nil))

  ;; Decorators are not type names
  (font-lock-add-keywords
   'python-mode
   `(
     ("@[A-Za-z0-9_]+" . font-lock-keyword-face)))

  ;; Show-parens
  (set-face-bold 'show-paren-match t)

  (dolist (face '(region mode-line isearch lazy-highlight helm-selection
                         trailing-whitespace))
    (set-face-background face black)
    (set-face-foreground face white))

  (set-cursor-color black)

  (setq git-gutter:modified-sign " =")
  (setq git-gutter:added-sign    " +")
  (setq git-gutter:deleted-sign  " -")

  (set-face-bold 'font-lock-type-face t)
  (set-face-bold 'font-lock-function-name-face t)

  (set-face-foreground 'git-gutter:added black)
  (set-face-foreground 'git-gutter:modified black)
  (set-face-foreground 'git-gutter:deleted black))

(defun dark ()
  (interactive)
  (global-font-lock-mode)

  ;; Reset colors prior to applying jbeans
  (dolist (face (face-list))
    (set-face-background face nil)
    (set-face-foreground face nil))

  ;; Most settings come from jbeans
  (load-theme 'jbeans t)

  (dolist (face (face-list))
    (set-face-italic face nil))

  ;; Now for overrides.
  ;; Dim comment delimiters & pagee break lines
  (set-face-foreground 'font-lock-comment-delimiter-face "#555")
  (set-face-foreground 'page-break-lines "#555")

  ;; GUI
  (set-mouse-color "#cccccc")

  ;; Show-parens
  (set-face-background 'show-paren-match "#9999aa")
  (set-face-foreground 'show-paren-match "#000000")

  ;; Highlight
  (require 'hi-lock)
  (set-face-foreground 'hi-yellow "#000000")
  (set-face-background 'hi-yellow "#fad07a")

  (set-face-foreground 'hi-pink "#000000")
  (set-face-background 'hi-pink "#ff73fd")
  (set-face-foreground 'hi-red-b "#ff73fd")

  (set-face-foreground 'hi-blue "#000000")
  (set-face-background 'hi-blue "#8197bf")
  (set-face-foreground 'hi-blue-b "#8197bf")

  (set-face-foreground 'hi-green "#000000")
  (set-face-background 'hi-green "#99ad6a")
  (set-face-foreground 'hi-green-b "#99ad6a")

  ;; Git-gutter
  (progn
    (set-face-foreground 'git-gutter:deleted "#99ad6a")
    (set-face-foreground 'git-gutter:modified "#fad07a")
    (set-face-foreground 'git-gutter:added "#cf6a4c"))

  (progn
    (setq git-gutter:modified-sign " =")
    (setq git-gutter:added-sign    " +")
    (setq git-gutter:deleted-sign  " -"))

  ;; Whitespace
  (set-face-foreground 'whitespace-line "#cf6a4c")
  (set-face-background 'whitespace-trailing "#cf6a4c"))


(dark)



;;; SNIPPETS

(require-package yasnippet
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-global-mode 1))



;;; CUSTOM COMMANDS

(defun copy-file-name-to-clipboard ()
  "Copy the current buffer file name to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied buffer file name '%s' to the clipboard." filename))))



;;; DISABLED COMMANDS

(progn
  (put 'narrow-to-region 'disabled nil)
  (put 'narrow-to-page 'disabled nil))



;;; POSTAMBLE

(load "~/.emacs.d/local.el" 'noerror)
