;; (setq vc-follow-symlinks t)
(require 'package)

(setq package-enable-at-startup nil)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("ublt" . "https://elpa.ubolonton.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'org-install)
(require 'ob-tangle)

(defun reload-config ()
	"Reloads my literate config file."
	(org-babel-load-file "~/.emacs.d/nathancox.org"))

(setq max-lisp-eval-depth 2000)

(reload-config)
