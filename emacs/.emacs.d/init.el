;;;; Initialization

(require 'package)

(setq lexical-binding t)
(setq auto-window-vscroll nil)
(setq max-lisp-eval-depth 2000)

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

(add-hook 'emacs-startup-hook
          (lambda ()
            "Recover GC values after startup."
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

;;; Set up package archives

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/") t)

(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;;; use-package

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package diminish
  ;; https://github.com/myrjola/diminish.el
  :ensure t)

(use-package gnu-elpa-keyring-update
  ;; http://elpa.gnu.org/packages/gnu-elpa-keyring-update.html
  :ensure t)

(use-package exec-path-from-shell
  ;; https://github.com/purcell/exec-path-from-shell
  :ensure t

  :custom
  (exec-path-from-shell-variables '("PATH"))
  (exec-path-from-shell-arguments nil)

  :config
  (exec-path-from-shell-initialize))

;;;; Setting up sane defaults

(use-package emacs
  ;; Configure emacs itself

  :hook ((before-save . delete-trailing-whitespace))

  :bind (("s-SPC" . cycle-spacing))

  :custom
  (completion-styles '(basic substring) "gnu.org/software/emacs/manual/html_node/emacs/Completion-Styles.html")
  (confirm-nonexistent-file-or-buffer nil)
  (cursor-in-non-selected-windows nil)
  (custom-file (concat user-emacs-directory "custom.el"))
  (custom-safe-themes t "mark all themes as safe, since we can't persist now")
  (dired-listing-switches "-al --group-directories-first")
  (enable-local-variables :all "fix =defvar= warnings")
  (font-lock-maximum-decoration nil)
  (font-lock-maximum-size nil)
  (indicate-empty-lines nil)
  (inhibit-startup-echo-area-message t)
  (inhibit-startup-message t)
  (inhibit-startup-screen t)
  (initial-buffer-choice nil)
  (ispell-program-name "aspell")
  (kill-do-not-save-duplicates t)
  (ring-bell-function 'ignore)
  (sentence-end-double-space nil)
  (temp-buffer-max-height 8)
  (use-dialog-box nil)
  (use-file-dialog nil)
  (use-short-answers t)
  (user-full-name "Nathan Cox")
  (user-mail-address "nate@natecox.dev")
  (warning-minimum-level :emergency)
  (window-min-height 1)

  :config
  (set-time-zone-rule "/usr/share/zoneinfo.default/America/Los_Angeles")

  (setq-default fill-column 100)
  (auto-fill-mode nil)
  (setq frame-title-format nil)

  ;; Mouse active in terminal
  (unless (display-graphic-p)
    (xterm-mouse-mode 1)
    (global-set-key (kbd "<mouse-4>") 'scroll-down-line)
    (global-set-key (kbd "<mouse-5>") 'scroll-up-line))

  ;; No scroll bars
  (if (fboundp 'scroll-bar-mode) (set-scroll-bar-mode nil))

  ;; No toolbar
  (if (fboundp 'tool-bar-mode) (tool-bar-mode -1))

  ;; No menu bar
  (if (display-graphic-p) (menu-bar-mode t) (menu-bar-mode -1))

  ;; Navigate windows using shift+direction
  (windmove-default-keybindings)

  (when (featurep 'ns)
    (defun ns-raise-emacs ()
      "Raise Emacs."
      (ns-do-applescript "tell application \"Emacs\" to activate"))
    (defun ns-raise-emacs-with-frame (frame)
      "Raise Emacs and select the provided frame."
      (with-selected-frame frame
        (when (display-graphic-p)
          (ns-raise-emacs))))
    (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)
    (when (display-graphic-p)
      (ns-raise-emacs)))

  (setq mac-command-modifier 'meta
        mac-option-modifier 'super
        ns-function-modifier 'hyper
        ns-use-native-fullscreen t)

  ;; Make sure clipboard works properly in tty mode on OSX
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  (when (and (not (display-graphic-p))
             (eq system-type 'darwin))
    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx))

  ;; Size of temporary buffers
  (temp-buffer-resize-mode)

  ;; Buffer encoding
  (prefer-coding-system       'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-language-environment   'utf-8)

  ;; Default shell in term
  (unless (eq system-type 'windows-nt)
    (setq-default shell-file-name "/bin/zsh")
    (setq explicit-shell-file-name "/bin/zsh"))

  ;; Kill term buffer when exiting
  (defadvice term-sentinel (around my-advice-term-sentinel (proc msg))
    (if (memq (process-status proc) '(signal exit))
        (let ((buffer (process-buffer proc)))
          ad-do-it
          (kill-buffer buffer))
      ad-do-it))
  (ad-activate 'term-sentinel)

  ;; write over selected text on input... like all modern editors do
  (delete-selection-mode t)

  (show-paren-mode)

  ;; stop emacs from littering the file system with backup files
  (setq make-backup-files nil
        auto-save-default nil
        create-lockfiles nil)

  ;; enable winner mode globally for undo/redo window layout changes
  (winner-mode t)

  ;; clean up the mode line
  (display-time-mode -1)
  (setq column-number-mode t))

(use-package tramp
  ;; customize tramp default behavior
  :custom (tramp-default-method "ssh"))

(use-package hl-line-mode
  ;; use the builtin current-line highlighter
  :hook ((prog-mode) (text-mode) (org-agenda-mode)))

(use-package recentf
  ;; keep package files out of recentf
  :config
  (add-to-list 'recentf-exclude "\\elpa")
  (add-to-list 'recentf-exclude "^/private")
  (recentf-mode 1))


;;;; Look and feel

;;; Ligatures
(let ((alist '((33 . ".\\(?:\\(?:==\\|!!\\)\\|[!=]\\)")
               (35 . ".\\(?:###\\|##\\|_(\\|[#(?[_{]\\)")
               (36 . ".\\(?:>\\)")
               (37 . ".\\(?:\\(?:%%\\)\\|%\\)")
               (38 . ".\\(?:\\(?:&&\\)\\|&\\)")
               (42 . ".\\(?:\\(?:\\*\\*/\\)\\|\\(?:\\*[*/]\\)\\|[*/>]\\)")
               (43 . ".\\(?:\\(?:\\+\\+\\)\\|[+>]\\)")
               (45 . ".\\(?:\\(?:-[>-]\\|<<\\|>>\\)\\|[<>}~-]\\)")
               (46 . ".\\(?:\\(?:\\.[.<]\\)\\|[.=-]\\)")
               (47 . ".\\(?:\\(?:\\*\\*\\|//\\|==\\)\\|[*/=>]\\)")
               (48 . ".\\(?:x[a-zA-Z]\\)")
               (58 . ".\\(?:::\\|[:=]\\)")
               (59 . ".\\(?:;;\\|;\\)")
               (60 . ".\\(?:\\(?:!--\\)\\|\\(?:~~\\|->\\|\\$>\\|\\*>\\|\\+>\\|--\\|<[<=-]\\|=[<=>]\\||>\\)\\|[*$+~/<=>|-]\\)")
               (61 . ".\\(?:\\(?:/=\\|:=\\|<<\\|=[=>]\\|>>\\)\\|[<=>~]\\)")
               (62 . ".\\(?:\\(?:=>\\|>[=>-]\\)\\|[=>-]\\)")
               (63 . ".\\(?:\\(\\?\\?\\)\\|[:=?]\\)")
               (91 . ".\\(?:]\\)")
               (92 . ".\\(?:\\(?:\\\\\\\\\\)\\|\\\\\\)")
               (94 . ".\\(?:=\\)")
               (119 . ".\\(?:ww\\)")
               (123 . ".\\(?:-\\)")
               (124 . ".\\(?:\\(?:|[=|]\\)\\|[=>|]\\)")
               (126 . ".\\(?:~>\\|~~\\|[>=@~-]\\)")
               )
             ))
  (dolist (char-regexp alist)
    (set-char-table-range composition-function-table (car char-regexp)
                          `([,(cdr char-regexp) 0 font-shape-gstring]))))

;;; Theme
(use-package modus-themes
  ;; https://protesilaos.com/emacs/modus-themes
  :ensure t

  :custom
  (modus-themes-headings '((1 . (rainbow overline background 1.2))
                           (2 . (rainbow overline background 1.1))
                           (t . (rainbow semibold))))
  (modus-themes-bold-constructs t)
  (modus-themes-italic-constructs t)
  (modus-themes-syntax '(faint))
  (modus-themes-prompts nil)
  (modus-themes-diffs 'desaturated)
  (modus-themes-links '(color))
  (modus-themes-org-blocks 'gray-background)

  :config
  (custom-set-faces
   '(default ((t (:family "Iosevka Comfy" :height 140)))))

  ;; If emacs has been built with system appearance detection
  ;; add a hook to change the theme to match the system
  (if (boundp 'ns-system-appearance-change-functions)
      (add-hook 'ns-system-appearance-change-functions
                (lambda (appearance)
                  (mapc #'disable-theme custom-enabled-themes)
                  (pcase appearance
                    ('light (modus-themes-select 'modus-operandi))
                    ('dark (modus-themes-select 'modus-vivendi)))))
    (modus-themes-select 'modus-operandi)))

;;; Indentation

(use-package emacs
  :custom
  (tab-width 2)
  :config
  (setq-default indent-tabs-mode nil)   ; Always use spaces by default
  (electric-indent-mode +1))

(use-package smart-tabs-mode
  ;; https://www.emacswiki.org/emacs/SmartTabs
  ;; indent with tabs, align with spaces where enabled
  :ensure t
  :config (smart-tabs-insinuate 'ruby))

(use-package highlight-indent-guides
  ;; https://github.com/DarthFennec/highlight-indent-guides
  :ensure t
  :hook ((prog-mode . highlight-indent-guides-mode)
         (taskpaper-mode . highlight-indent-guides-mode))
  :custom
  (highlight-indent-guides-method 'bitmap)
  (highlight-indent-guides-responsive 'stack))


;;; Text manipulation

(use-package vundo
  :ensure t
  :custom (vundo-glyph-alist vundo-unicode-symbols)
  :bind (("s-/" . #'vundo)))

(use-package expand-region
  :ensure t
  :diminish
  :bind (("s-e" . #'er/expand-region)))

(use-package change-inner
  :ensure t
  :diminish
  :after expand-region
  :bind (("s-i" . #'change-inner)
         ("s-o" . #'change-outer)))

;; (use-package drag-stuff
;;   :ensure t
;;   :diminish
;;   :bind (("<M-down>" . drag-stuff-down)
;;          ("<M-up>" . drag-stuff-up)
;;          ("<M-right>" . drag-stuff-right)
;;          ("<M-left>" . drag-stuff-left))
;;   :config (drag-stuff-global-mode 1))

(defun nc/run-region-as-shell-command (start end)
  "Execute region from START to END as a shell command."
  (interactive "r")
  (shell-command  (buffer-substring-no-properties start end)))

(use-package shell-region
  :bind (("s-|" . nc/run-region-as-shell-command)))

;;; Buffer management

(use-package ibuffer
  :commands ibuffer-find-file
  :custom
  (ibuffer-filter-group-name-face '(:inherit (font-lock-string-face bold))))

(use-package ace-window
  :ensure t
  :bind ("M-o" . ace-window))

;;; Tab bar

(use-package tab-bar
  :if (< 26 emacs-major-version)

  :bind
  (("s-{" . tab-bar-switch-to-prev-tab)
   ("s-}" . tab-bar-switch-to-next-tab)
   ("s-w" . tab-bar-close-tab)
   ("s-n" . tab-bar-new-tab))

  :config
  (setq tab-bar-show 1)                      ;; hide bar if <= 1 tabs open
  (setq tab-bar-close-button-show nil)       ;; hide tab close / X button
  (setq tab-bar-new-tab-choice "*dashboard*");; buffer to show in new tabs
  (setq tab-bar-tab-hints t)                 ;; show tab numbers
  (setq tab-bar-format '(tab-bar-format-tabs tab-bar-separator))
  (setq tab-bar-select-tab-modifiers "super"))

;;;; Navigation

;;; Cursor movement

(use-package avy
  ;; https://github.com/abo-abo/avy
  :ensure t
  :bind (("s-t" . 'avy-goto-char-timer)
         ("s-T" . 'avy-goto-line)
         ("C-c C-j" . 'avy-resume))
  :config (avy-setup-default))

;;; Completion

(use-package consult
  :ensure t
  :bind ("C-x b" . consult-buffer))

;; improved UX for searching in a buffer
(use-package ctrlf
  :ensure t
  :config (ctrlf-mode t))

;; https://github.com/minad/corfu
(use-package corfu
  :ensure t

  :custom
  (corfu-cycle t)

  :init
  (global-corfu-mode))

(use-package embark
  :ensure t
  :bind (("C-." . embark-act)
         ("C-;" . embark-dwim)
         ("C-h B" . embark-bindings)))

(use-package embark-consult
  :ensure t
  :after (embark consult)
  :hook (embark-collect-mode . consult-preview-at-point-mode))

;; add annotations to minibuffers
(use-package marginalia
  :ensure t
  :bind (:map minibuffer-local-map ("C-M-a" . marginalia-cycle))
  :custom (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package orderless
  :ensure t

  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t))

;; better interface for selecting items from a list
(use-package vertico
  :ensure t
  :init (vertico-mode))

;;; Improving discoverability
(use-package hydra
  :ensure t)

(use-package major-mode-hydra
  :ensure t
  :demand t
  :after hydra
  :diminish
  :bind ([s-return] . major-mode-hydra))

(use-package pretty-hydra)

(use-package discover
  :ensure t
  :diminish
  :config (global-discover-mode 1))

(use-package which-key
  :ensure t
  :diminish
  :config (which-key-mode))

;;;; Note taking

(use-package denote
  :ensure t

  :after (org pretty-hydra)

  :bind (("C-c n" . denote-hydra/body))

  :custom
  (denote-directory (expand-file-name (concat org-directory "/notes")))
  (denote-dired-directories (list denote-directory))
  (denote-templates
   '((meeting . "* agenda\n\n* minutes\n\n* takeaways\n#+begin: columnview :hlines 1 :id global :format \"%todo(Status) %item(Topic)\" :match \"/!\"\n#+end:")))

  :pretty-hydra
  ((:title "Denote" :color teal :quit-key "q")
   ("New note..."
    (("n" denote-create-note "with defaults")
     ("t" denote-create-note-with-template "from template")
     ("s" denote-subdirectory "in subdirectory")
     ("d" denote-date "for date"))
    "Open..."
    (("oo" denote-open-or-create "note")
     ("od" (dired (expand-file-name (concat org-directory "/notes"))) "directory"))
    "Links"
    (("l" denote-link "Insert link"))))

  :init
  (add-hook 'dired-mode-hook #'denote-dired-mode-in-directories))

;;;; Org modes

;; 1. Install macTEX with `brew install cask mactex`
;; 2. Download and install https://amaxwell.github.io/tlutility/
;; 3. Ensure Lato font is installed

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
  :after (major-mode-hydra)
  :pin gnu
  :bind (("C-c a" . org-agenda)
         ("C-c l" . org-store-link)
         ("C-c c" . org-capture)
         ("C-c r" . org-refile)
         :map org-mode-map
         ("M-<return>" . nc/org-insert-dwim))

  ;; :hook ((after-init . (lambda () (org-agenda nil "n"))))

  :custom
  (org-ascii-links-to-notes nil)
  (org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  (org-agenda-start-with-log-mode t)
  (org-agenda-window-setup 'current-window)
  (org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
  (org-columns-default-format "%50ITEM(Task) %2PRIORITY %10Effort(Effort){:} %10CLOCKSUM")
  (org-confirm-babel-evaluate nil)
  (org-default-notes-file (concat org-directory "/notes.org"))
  (org-directory "~/org")
  (org-display-remote-inline-images 'download)
  (org-export-copy-to-kill-ring nil)
  (org-export-headline-levels 2)
  (org-export-with-author nil)
  (org-export-with-section-numbers nil)
  (org-export-with-sub-superscripts '{})
  (org-export-with-toc nil)
  (org-global-properties
   '(("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
  (org-latex-logfiles-extensions
   (quote ("lof" "lot" "tex" "aux" "idx" "log" "out" "toc" "nav"
           "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc"
           "ps" "spl" "bbl" "xdv")))
  (org-latex-compiler "xelatex")
  (org-latex-pdf-process '("latexmk -xelatex -quiet -shell-escape -f %f"))
  (org-log-into-drawer t)
  (org-outline-path-complete-in-steps nil)
  (org-pretty-entities t)
  (org-refile-targets '((org-agenda-files . (:maxlevel . 6))))
  (org-refile-use-outline-path 'file)
  (org-return-follows-link nil)
  (org-startup-folded 'content)
  (org-startup-indented t)
  (org-tag-alist '((:startgrouptag) ("people") (:grouptags) ("{^@.+}") (:endgrouptag)))
  (org-tags-column 80)

  :mode-hydra
  (org-mode
   (:title "Org Mode Commands")
   ("Timestamps"
    (("ts" org-time-stamp "Insert active")
     ("ti" org-time-stamp-inactive "Insert inactive"))))

  :config
  (add-to-list 'exec-path "/Library/TeX/texbin")
  (setq-default TeX-engine 'xetex)
  (setq-default TeX-PDF-mode t))

(use-package org
  ;; babel config
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((ruby . t)
     (python . t)
     (shell . t))))

(use-package mermaid-mode
  ;; https://github.com/abrochard/mermaid-mode
  :ensure t
  :custom (mermaid-mmdc-location "~/.asdf/shims/mmdc"))

(use-package ob-mermaid
  ;; https://github.com/arnm/ob-mermaid
  :ensure t
  :custom (ob-mermaid-cli-path "~/.asdf/shims/mmdc"))

;;; Exporters

(use-package org-contrib
  :ensure t)

;; add jira format export
(use-package ox-jira
  ;; https://github.com/emacsmirror/ox-jira
  :ensure t
  :after org
  :config (eval-after-load "org" '(progn (require 'ox-jira))))

;; add github flavored markdown export
(use-package ox-gfm
  :ensure t
  :config (eval-after-load "org" '(require 'ox-gfm nil t)))

;; add confluence formatted export
(use-package ox-confluence
  ;; https://github.com/aspiers/orgmode/blob/master/contrib/lisp/ox-confluence.el
  :after org-contrib
  :config (eval-after-load "org" '(require 'ox-contrib nil t)))

(use-package flyspell-mode
  ;; https://www.emacswiki.org/emacs/FlySpell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode)))

(use-package flycheck
  ;; https://www.flycheck.org/en/latest/
  :ensure t
  :diminish
  :config (global-flycheck-mode))

(use-package flycheck-package
  ;; https://github.com/purcell/flycheck-package
  :ensure t
  :after flycheck)

;; match paired brackets with colors
(use-package rainbow-delimiters
  ;; https://github.com/Fanael/rainbow-delimiters
  :ensure t
  :hook (prog-mode . (lambda ()
                       (unless (derived-mode-p 'lisp-mode 'emacs-lisp-mode 'clojure-mode)
                         (rainbow-delimiters-mode)))))

(use-package tree-sitter
  ;; https://emacs-tree-sitter.github.io
  ;; https://github.com/emacs-tree-sitter/elisp-tree-sitter
  :ensure t
  :diminish
  :hook ((ruby-mode . tree-sitter-hl-mode)
         (rustic-mode . tree-sitter-hl-mode)
         (haskell-mode . tree-sitter-hl-mode))
  :config (global-tree-sitter-mode))

(use-package tree-sitter-langs
  ;; https://github.com/emacs-tree-sitter/tree-sitter-langs
  :ensure t
  :after tree-sitter)

(use-package eglot
  ;; https://github.com/joaotavora/eglot
  :ensure t)

(use-package direnv
  :ensure t
  :custom (direnv-always-show-summary nil)
  :config (direnv-mode))

(use-package project
  :bind (:map project-prefix-map
              ("m" . magit-project-status)
              ("v" . vterm))
  :config
  (push '(magit "Magit Status" ?m) project-switch-commands)
  (push '(vterm "vterm" ?v) project-switch-commands))


;; Taskpaper

(use-package taskpaper-mode
  :ensure t)


;;;; Version control

(use-package magit
  ;; https://github.com/magit/magit
  :ensure t
  :bind (("C-c g s" . magit-status))
  :hook ((git-commit-mode . (lambda () (set-fill-column 72))))
  :config
  (setq git-commit-style-convention-checks '(non-empty-second-line overlong-summary-line)
        git-commit-summary-max-length 50))

(use-package forge
  ;; https://github.com/magit/forge
  :ensure t
  :after magit
  :config (push '("git.innova-partners.com" "git.innova-partners.com/api/v3" "git.innova-partners.com" forge-github-repository) forge-alist))

(use-package diff-hl
  ;; https://github.com/dgutov/diff-hl
  :ensure t
  :after magit
  :hook (magit-post-refresh . diff-hl-magit-post-refresh)
  :config (global-diff-hl-mode))

(use-package nix-mode
  :ensure t
  :mode "\\.nix\\'")

(use-package emacs
  :custom (js-indent-level 2))

;; (use-package web-mode
;;   :ensure t

;;   :custom
;;   (web-mode-markup-indent-offset 2)
;;   (web-mode-css-indent-offset 2)
;;   (web-mode-code-indent-offset 2)
;;   (web-mode-enable-css-colorization t)
;;   (web-mode-enable-html-entities-fontification t)
;;   (web-mode-extra-snippets
;;    '(("erb" . (("content_for" . "<% content_for :| do %>\n\n<% end %>")
;;                ("content_for_if" . "<% if content_for?(:|) %>\n<% yield : %>\n<% end %>")
;;                ("var" . "<%= :| %>")))))

;;   :init
;;   (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;;   (add-to-list 'auto-mode-alist '("\\.css\\'" . web-mode)))

(use-package html-mode
  :hook (html-mode . eglot-ensure))

(use-package emmet-mode
  :hook (html-mode . emmet-mode)
  :ensure t)

(use-package paredit
  :ensure t
  :hook ((lisp-mode . enable-paredit-mode)
         (emacs-lisp-mode . enable-paredit-mode)
         (clojure-mode . enable-paredit-mode)))

(use-package rainbow-blocks
  :ensure t
  :hook ((emacs-lisp-mode . rainbow-blocks-mode)
         (clojure-mode . rainbow-blocks-mode)
         (elisp-mode . rainbow-blocks-mode)))

(use-package clojure-mode
  :ensure t
  :defer t
  :hook ((clojure-mode . eglot-ensure)
         (clojurescript-mode . eglot-ensure)
         (clojurec-mode . eglot-ensure)))

(use-package cider
  :ensure t
  :defer t
  :custom (cider-auto-test-mode t))

(use-package ruby-mode
  :hook (ruby-mode . eglot-ensure))

(use-package bundler
  :ensure t)

(use-package yard-mode
  :ensure t
  :after ruby-mode
  :hook ruby-mode)

(use-package inf-ruby
  :ensure t
  :config (setenv "PAGER" (executable-find "cat")))

(use-package rspec-mode
  :ensure t
  :hook ((after-init . inf-ruby-switch-setup)
         (compilation-filter-hook . inf-ruby-auto-enter))
  :custom
  (compilation-scroll-output t)
  (rspec-primary-source-dirs '("app")))

(use-package rubocop
  :ensure t)

;; Rust

(use-package rustic
  :ensure t
  :custom
  (rustic-format-on-save t)
  (rustic-lsp-client 'eglot))

;; Haskell

(use-package haskell-mode
  :ensure t
  :hook (haskell-mode . eglot-ensure))

(use-package dante
  :ensure t)

(use-package elpy
  :ensure t
  :defer t
  :init (advice-add 'python-mode :before 'elpy-enable))

(use-package yaml-mode
  :ensure t
  :hook (yaml-mode . eglot-ensure)
  :config (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))

(use-package org-tree-slide
  :ensure t)

(use-package elfeed
  :ensure t
  :custom
  (elfeed-feeds '(("https://d12frosted.io/atom.xml" blog emacs))))

(if (file-readable-p "~/.emacs.d/local-config.el") (load-file "~/.emacs.d/local-config.el"))
