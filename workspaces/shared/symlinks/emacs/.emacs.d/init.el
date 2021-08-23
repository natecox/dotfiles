(defun reload-config ()
	"Reloads my literate config file."
	(org-babel-load-file "~/.emacs.d/nathancox.org"))

(setq vc-follow-symlinks nil)
(reload-config)
