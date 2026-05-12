(setq custom-file "~/.config/emacs/emacs.custom.el") ; Settings defined with the menu are saved here, not in my init.el
(load custom-file)



;; Change fonts
(set-face-attribute 'default nil :font "Iosevka Slab" :height 200)
(set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")
(set-face-attribute 'variable-pitch nil :font "Iosevka Etoile" :weight 'medium)

(scroll-bar-mode -1)
(column-number-mode -1) ;; Show the number in the modeline 
(global-display-line-numbers-mode) ;; Show line number in buffer, prefix with global- to show numbers on evert buffer

(fset 'yes-or-no-p 'y-or-n-p) ; Confirmation dialog uses y/n instead of yes/no

;; Writing config

(add-hook 'text-mode-hook 'visual-line-mode)
(delete-selection-mode t)
(setq-default scroll-error-top-bottom t)
(setq save-interprogram-paste-before-kill t)

;; Packages
(setq package-install-upgrade-built-in t)
(use-package package
  :config
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/"))
  (package-initialize)
  )


(use-package use-package
  :custom
  (use-package-always-ensure t)
  (package-native-compile t)
  (warning-minimum-level :error))

;; Theme
(use-package ef-themes
  :ensure t
  :init
  ;; This makes the Modus commands listed below consider only the Ef
  ;; themes.  For an alternative that includes Modus and all
  ;; derivative themes (like Ef), enable the
  ;; `modus-themes-include-derivatives-mode' instead.  The manual of
  ;; the Ef themes has a section that explains all the possibilities:
  ;;
  ;; - Evaluate `(info "(ef-themes) Working with other Modus themes or taking over Modus")'
  ;; - Visit <https://protesilaos.com/emacs/ef-themes#h:6585235a-5219-4f78-9dd5-6a64d87d1b6e>
  (ef-themes-take-over-modus-themes-mode 1)
  :bind
  (("<f5>" . modus-themes-rotate)
   ("C-<f5>" . modus-themes-select)
   ("M-<f5>" . modus-themes-load-random))
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)

  ;; Finally, load your theme of choice (or a random one with
  ;; `modus-themes-load-random', `modus-themes-load-random-dark',
  ;; `modus-themes-load-random-light').
  (modus-themes-load-theme 'ef-night))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
)

(use-package magit
  :after (magit))

;; Spell checking
(use-package jinx
  :hook (emacs-startup . global-jinx-mode)
  :bind (("C-;" . jinx-correct)
	 ("C-M-;" . jinx-languages))
  :custom
  (jinx-languages "en_US es_CL")
  )

;; Auto Completion
(use-package company
  :custom
  (company-minimum-prefix-length 4)
  (company-dabbrev-minimum-length 8)
  (company-selection-wrap-around t)
  :init (global-company-mode)
  )

;;; Minibuffer completion

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-sort-function 'vertico-sort-history-alpha))


;; Persistent history over restart
;(use-package savehist
;  :init
;  (save-hist-mode))

;; Buffer completion on any order
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Add info of the commands in the completion buffer
(use-package marginalia
  :init
  (marginalia-mode))

;; Improve keyboard shortcut discoverability
(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right))

;; Set default, fixed and variable pitch fonts
(use-package mixed-pitch
  :hook
  (text-mode . mixed-pitch-mode))

;; Org mode config

(variable-pitch-mode 1)

(use-package org-modern
  :hook ((org-mode . org-modern-mode)
	 (org-agenda-finalize . org-modern-agenda))
  :custom
  (set-face-attribute 'org-modern-symbol nil :family "Iosevka")
  )



(use-package org-roam
  :ensure t
  :custom
  (org-roam-directory (file-truename "~/Documents/RoamNotes/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))
