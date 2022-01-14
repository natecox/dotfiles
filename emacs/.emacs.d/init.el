(defun reload-config ()
  "Reloads my literate config file."
  (org-babel-load-file "~/.emacs.d/nathancox.org")
  (if (file-readable-p "~/.emacs.d/local-config.org") (org-babel-load-file "~/.emacs.d/local-config.org")))

(setq vc-follow-symlinks nil)
(reload-config)
