(setq lexical-binding t)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq gc-cons-threshold 100000000)
(setq auto-window-vscroll nil)

(straight-use-package 'use-package)

(use-package diminish :straight t)

(use-package exec-path-from-shell
  :straight t
  :config
  (setenv "SHELL" "/usr/local/bin/zsh")
  (setq exec-path-from-shell-variables '("PATH"))
  (exec-path-from-shell-initialize))

(defun nc/apply-nano-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (nano-light))
    ('dark (nano-dark))))

(straight-use-package
 '(nano-emacs :type git :host github :repo "rougier/nano-emacs"))

(use-package nano-base-colors)
(use-package nano-faces)
(use-package nano-bindings)
(use-package nano-session)
;; (use-package nano-layout)
(use-package nano-writer)

(use-package nano-defaults
  :config
  (if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1)))

;; (use-package nano-modeline
;;   :straight '(nano-modeline :type git :host github :repo "rougier/nano-modeline")
;;   :config (nano-modeline-mode))

(use-package nano-theme
  :straight '(nano-theme :type git :host github :repo "rougier/nano-theme" :fork "natecox/nano-theme")

  :config

  (custom-set-faces '(default ((t (:font "JetBrains Mono 13")))))

  ;; If emacs has been built with system appearance detection
  ;; add a hook to change the theme to match the system
  (if (boundp 'ns-system-appearance-change-functions)
      (add-hook 'ns-system-appearance-change-functions #'nc/apply-nano-theme)
    (nano-light)))

(use-package nano-agenda
  :straight '(nano-agenda :type git :host github :repo "rougier/nano-agenda"))

(use-package emacs
  :hook ((before-save . delete-trailing-whitespace))
  :bind (("s-SPC" . cycle-spacing))
  :custom ((ispell-program-name "aspell"))
  :config

  (setq user-full-name "Nathan Cox"
        user-mail-address "ncox@covermymeds.com")

  ;; write over selected text on input... like all modern editors do
  (delete-selection-mode t)

  ;; use a reasonable line length
  (setq-default fill-column 120)

  ;; Don't persist a custom file, this bites me more than it helps
  (setq custom-file null-device)         ; use a temp file as a placeholder
  (setq custom-safe-themes t)            ; mark all themes as safe, since we can't persist now
  (setq enable-local-variables :all)     ; fix =defvar= warnings

  ;; stop emacs from littering the file system with backup files
  (setq make-backup-files nil
        auto-save-default nil
        create-lockfiles nil)

  ;; enable winner mode globally for undo/redo window layout changes
  (winner-mode t)

  ;; clean up the mode line
  (display-time-mode -1)
  (setq column-number-mode t)

  ;; Mac specific
  (when (eq system-type 'darwin)
    (setq mac-option-modifier 'super))

  (setq insert-directory-program "gls" dired-use-ls-dired t)
  (setq dired-listing-switches "-al --group-directories-first")
  (setq ring-bell-function 'ignore))

;; customize tramp default behaviour
(use-package tramp
  :custom (tramp-default-method "ssh"))

;; use the builtin current-line highlighter
(use-package hl-line-mode
  :hook ((prog-mode) (text-mode)))

;; keep package files out of recentf
(use-package recentf
  :config
  (add-to-list 'recentf-exclude "\\elpa")
  (add-to-list 'recentf-exclude "^/private"))

(use-package emacs
  :config
  ;; use common convention for indentation by default
  (setq-default indent-tabs-mode nil)   ; Always use spaces.

  ;; let emacs handle indentation
  (electric-indent-mode +1))

;; indent with tabs, align with spaces where enabled
(use-package smart-tabs-mode
  :straight t
  :config (smart-tabs-insinuate 'ruby))

;; add a visual intent guide
(use-package highlight-indent-guides
  :straight t
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  (highlight-indent-guides-character ?|)
  (highlight-indent-guides-responsive 'stack))

(use-package undo-tree
  :straight t
  :bind (:map undo-tree-map ("C-x r" . nil)) ; resolves map conflict w/ discover.el
  :config (global-undo-tree-mode))

(use-package expand-region
  :straight t
  :diminish
  :bind (("s-e" . #'er/expand-region)))

(use-package change-inner
  :straight t
  :diminish
  :after expand-region
  :bind (("s-i" . #'change-inner)
         ("s-o" . #'change-outer)))

(use-package drag-stuff
  :straight t
  :diminish
  :bind (("<M-down>" . drag-stuff-down)
         ("<M-up>" . drag-stuff-up)
         ("<M-right>" . drag-stuff-right)
         ("<M-left>" . drag-stuff-left))
  :config (drag-stuff-global-mode 1))

(defun nc/run-region-as-shell-command (start end)
  "Execute region from START to END as a shell command."
  (interactive "r")
  (shell-command  (buffer-substring-no-properties start end)))

(use-package shell-region
  :bind (("s-|" . nc/run-region-as-shell-command)))

(use-package zoom
  :straight t
  :diminish
  :bind ("C-x +" . zoom)
  :config (zoom-mode t))

(use-package ibuffer
  :commands ibuffer-find-file
  :bind ("C-x C-b" . ibuffer)
  :custom
  (ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))

(use-package ibuffer-vc
  :straight t
  :hook (ibuffer . (lambda ()
                     (ibuffer-vc-set-filter-groups-by-vc-root)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic))))
  :custom
  (ibuffer-formats '((mark modified read-only " "
                           (name 18 18 :left :elide) " "
                           (size 9 -1 :right) " "
                           (mode 16 16 :left :elide) " "
                           (vc-status 16 16 :left) " "
                           (vc-relative-file)))))

(use-package ace-window
  :straight t
  :bind ("M-o" . ace-window))

;; jump to character on screen
(use-package avy
  :straight t
  :bind (("s-t" . 'avy-goto-char)
         ("s-T" . 'avy-goto-line)
         ("C-c C-j" . 'avy-resume))
  :config (avy-setup-default))

;; better predictions based on common usage
(use-package prescient
  :straight t
  :config (prescient-persist-mode t))

;; better interface for selecting items from a list
(use-package selectrum
  :straight t
  :custom (selectrum-extend-current-candidate-highlight t)
  :config (selectrum-mode t))

(use-package selectrum-prescient
  :straight t
  :config (selectrum-prescient-mode t))

;; improved UX for searching in a buffer
(use-package ctrlf
  :straight t
  :config (ctrlf-mode t))

;; add annotations to minibuffers
(use-package marginalia
  :straight t
  :bind (:map minibuffer-local-map ("C-M-a" . marginalia-cycle))
  :custom (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode)
  (advice-add #'marginalia-cycle :after
              (lambda () (when (bound-and-true-p selectrum-mode) (selectrum-exhibit)))))

(use-package consult
  :straight t)

(use-package hydra
  :straight t)

(use-package major-mode-hydra
  :straight t
  :after hydra
  :diminish
  :bind ([s-return] . major-mode-hydra))

(use-package pretty-hydra)

(use-package discover
  :straight t
  :diminish
  :config (global-discover-mode 1))

(use-package which-key
  :straight t
  :diminish
  :config (which-key-mode))

(defun nc/org-insert-dwim (&optional arg)
  "Insert an appropriate org item. ARG optional."
  (interactive "P")
  (when (eq major-mode 'org-mode)
    (let ((org-special-cprl-a/e t)
          (below? (unless (equal arg '(4)) '(4))))
      (cond ((org-at-item-p)
             (let ((org-M-RET-may-split-line nil)
                   (org-enable-sort-checkbox nil))
               (when below? (org-end-of-line))
               (org-insert-item (org-at-item-checkbox-p))))
            ((org-before-first-heading-p)
             (org-insert-heading))
            (t
             (org-back-to-heading)
             (if (org-get-todo-state)
                 (org-insert-todo-heading t below?)
                 (org-insert-heading below?)))))))

(use-package org
  :straight (:type built-in)
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c r" . org-refile)
         :map org-mode-map
         ("M-<return>" . nc/org-insert-dwim))
  :hook ((after-init . (lambda () (org-agenda nil "n"))))
  :custom
  (org-directory "~/org")
  (org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-refile-targets '((org-agenda-files . (:maxlevel . 6))))
  (org-startup-indented t)
  (org-startup-folded 'content)
  (org-blank-before-new-entry '((heading . t) (plain-list-item . nil)))
  (org-agenda-window-setup 'current-window)
  (org-confirm-babel-evaluate nil)
  (org-tags-column 80)
  (org-export-copy-to-kill-ring 'if-interactive)
  (org-export-with-sub-superscripts '{})
  (org-export-with-toc nil)
  (org-export-with-section-numbers nil)
  (org-export-with-author nil)
  (org-latex-logfiles-extensions
   (quote ("lof" "lot" "tex" "aux" "idx" "log" "out" "toc" "nav"
           "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc"
           "ps" "spl" "bbl" "xdv")))
  (org-latex-compiler "xelatex")
  (org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
  :config
  (add-to-list 'exec-path "/Library/TeX/texbin")
  (setq-default TeX-engine 'xetex)
  (setq-default TeX-PDF-mode t))

(use-package doct :straight t)

(use-package org
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ruby . t)
     (python . t)
     (shell . t))))

;; enable mermaid diagram blocks
(use-package mermaid-mode
  :straight t
  :custom (mermaid-mmdc-location "~/.asdf/shims/mmdc"))

(use-package ob-mermaid
  :straight t
  :custom (ob-mermaid-cli-path "~/.asdf/shims/mmdc"))

(use-package org-contrib
  :straight t)

;; add jira format export
(use-package ox-jira
  :straight t
  :after org
  :config (eval-after-load "org" '(progn (require 'ox-jira))))

;; add github flavored markdown export
(use-package ox-gfm
  :straight t
  :config (eval-after-load "org" '(require 'ox-gfm nil t)))

;; add confluence formatted export
(use-package ox-confluence
  :after org-contrib
  :config (eval-after-load "org" '(require 'ox-contrib nil t)))

(use-package vterm
  :straight t)

(use-package flyspell-mode
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)))

(use-package company
  :straight t
  :diminish
  :config (global-company-mode))

(use-package company-prescient
  :straight t
  :after prescient
  :config (company-prescient-mode))

(use-package flycheck
  :straight t
  :diminish
  :config (global-flycheck-mode))

(use-package flycheck-package
  :straight t
  :after flycheck)

(use-package yasnippet
  :straight t
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :straight t
  :after yasnippet)

(use-package emacs
  :config (show-paren-mode))

;; add ansi support for compilation buffers
(use-package xterm-color
  :straight t
  :custom (compilation-environment '("TERM=xterm-256color"))
  :config
  (defun nc/advise-compilation-filter (f proc string)
    (funcall f proc (xterm-color-filter string)))
  (advice-add 'compilation-filter :around #'nc/advise-compilation-filter))

;; match paired brackets with colors
(use-package rainbow-delimiters
  :straight t
  :hook (prog-mode . rainbow-delimiters-mode))

;; more consistant syntax highlighting
(use-package tree-sitter
  :straight t
  :diminish
  :hook ((ruby-mode . tree-sitter-hl-mode)
         (rustic-mode . tree-sitter-hl-mode))
  :config (global-tree-sitter-mode))

(use-package tree-sitter-langs
  :straight t
  :after tree-sitter)

(use-package lsp-mode
  :straight t
  :hook (lsp-enable-which-key-integration)
  :commands lsp
  :custom (lsp-keymap-prefix "C-c M-k")
  :config (add-to-list 'exec-path "~/src/elixir-lsp/elixir-ls/release"))

(use-package lsp-ui
  :straight t
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :commands lsp-ui-mode)

(use-package magit
  :straight t
  :bind (("C-c g s" . magit-status))
  :hook ((git-commit-mode . (lambda () (set-fill-column 72))))
  :config
  (setq git-commit-style-convention-checks '(non-empty-second-line overlong-summary-line)
        git-commit-summary-max-length 50))

(use-package forge
  :straight t
  :after magit
  :config (push '("git.innova-partners.com" "git.innova-partners.com/api/v3" "git.innova-partners.com" forge-github-repository) forge-alist))

(use-package diff-hl
  :straight t
  :after magit
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)
  :config (global-diff-hl-mode))

(use-package projectile
  :diminish
  :straight t
  :bind-keymap ("s-p" . projectile-command-map)
  :custom
  (projectile-project-search-path (cddr (directory-files "~/src" t)))
  (projectile-completion-system 'default)
  :config
  (defadvice projectile-project-root (around ignore-remote first activate)
    (unless (file-remote-p default-directory) ad-do-it))
  (projectile-mode t))

(use-package perspective
  :straight t :config (persp-mode))

(use-package persp-projectile
  :straight t
  :after perspective)

(use-package emacs
  :custom (js-indent-level 2))

(use-package web-mode
  :straight `(web-mode :type git :host github :repo "fxbois/web-mode" :commit "3ff506aae50a47b277f2b95ff7b7a7c596664e6a")

  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-enable-css-colorization t)
  (web-mode-skip-fontification t)
  (web-mode-extra-snippets
   '(("erb" . (("content_for" . "<% content_for :| do %>\n\n<% end %>")
               ("content_for_if" . "<% if content_for?(:|) %>\n<% yield : %>\n<% end %>")
               ("var" . "<%= :| %>")))))

  :init
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode)))

(use-package html-mode
  :hook (html-mode . lsp))

(use-package emmet-mode
  :hook (html-mode . emmet-mode)
  :straight t)

(use-package clojure-mode
  :straight t
  :hook ((clojure-mode . lsp)
         (clojurescript-mode . lsp)
         (clojurec-mode . lsp)))

(use-package cider
  :straight t)

(use-package ruby-mode
  :hook (ruby-mode . lsp))

(use-package bundler
  :straight t)

(use-package yard-mode
  :straight t
  :after ruby-mode
  :hook ruby-mode)

(use-package inf-ruby
  :straight t
  :config (setenv "PAGER" (executable-find "cat")))

(use-package rspec-mode
  :straight t
  :hook ((after-init . inf-ruby-switch-setup)
         (compilation-filter-hook . inf-ruby-auto-enter))
  :custom
  (compilation-scroll-output t)
  (rspec-primary-source-dirs '("app")))

(use-package rubocop
  :straight t)

(use-package elpy
  :straight t
  :defer t
  :init (advice-add 'python-mode :before 'elpy-enable))

(use-package yaml-mode
  :straight t
  :hook (yaml-mode . lsp)
  :config (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package paredit
  :straight t
  :hook ((lisp-mode . enable-paredit-mode)
         (emacs-lisp-mode . enable-paredit-mode)
         (clojure-mode . enable-paredit-mode)))

(use-package org-tree-slide
  :straight t)

(use-package covermyemacs
  :bind ("C-c i" . covermyemacs)
  :custom
  (covermyemacs-username "ncox")
  (covermyemacs-pdev-directory "~/src/platform/dev/")
  :load-path "~/src/natecox/covermyemacs/lisp/")
