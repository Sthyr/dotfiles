(setq custom-file "~/.config/emacs/emacs.custom.el") ; Settings defined with the menu are saved here, not in my init.el
(load custom-file)

;; Change font
(add-to-list 'default-frame-alist `(font . "Iosevka Slab-18"))

(scroll-bar-mode -1)
(column-number-mode -1) ;; Show the number in the modeline 
(global-display-line-numbers-mode) ;; Show line number in buffer, prefix with global- to show numbers on evert buffer

(fset 'yes-or-no-p 'y-or-n-p) ; Confirmation dialog uses y/n instead of yes/no

;; Theme conf
(require-theme 'modus-themes)

(setq modus-themes-mode-line '(accented borderless padded))

(load-theme 'modus-vivendi-tinted t)

;; Packages

(require 'package)

;; There should be a way to add the repos I need without modifying the entire repo archive
(add-to-list 'package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))
