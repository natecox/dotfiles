(defun reload-config ()
  "Reloads my literate config file."
  (org-babel-load-file "~/.emacs.d/nathancox.org")
  (if (file-readable-p "~/.emacs.d/local-config.org") (org-babel-load-file "~/.emacs.d/local-config.org")))

(setq vc-follow-symlinks nil)
(reload-config)
(put 'set-goal-column 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(exec-path-from-shell diminish use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
