(setq custom-file "~/.config/emacs/emacs.custom.el") ; Settings defined with the menu are saved here, not in my init.el
(load custom-file)

;; Change font
(add-to-list 'default-frame-alist `(font . "Iosevka Slab-18"))

(column-number-mode -1) ;; Show the number in the modeline 
(global-display-line-numbers-mode) ;; Show line number in buffer, prefix with global- to show numbers on evert buffer
