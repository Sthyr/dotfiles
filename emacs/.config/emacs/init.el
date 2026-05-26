(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
(setq package-install-upgrade-built-in t)

(setenv "PATH" (concat "/usr/local/texlive/2026/bin/x86_64-linux/:"
                       (getenv "PATH")))
(add-to-list 'exec-path "/usr/local/texlive/2026/bin/x86_64-linux/")

(set-face-attribute 'default nil :font "Iosevka Slab" :height 200)
(set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")
(set-face-attribute 'variable-pitch nil :font "Iosevka Etoile" :weight 'medium)

(scroll-bar-mode -1)
(column-number-mode -1) ;; Show the number in the modeline 
(global-display-line-numbers-mode) ;; Show line number in buffer, prefix with global- to show numbers on evert buffer

;; Writing config

(add-hook 'text-mode-hook 'visual-line-mode)
(delete-selection-mode t)
(setq-default scroll-error-top-bottom t)
(setq save-interprogram-paste-before-kill t)

;; Packages
(require 'package)
(setq package-install-upgrade-built-in t)
(use-package package
  :config
  (add-to-list 'package-archives
	       '("melpa" . "https://melpa.org/packages/"))
  (package-initialize))

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
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 3)
  (company-dabbrev-minimum-length 8)
  (company-selection-wrap-around t)
  )

;; Improve keyboard shortcut discoverability
(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-right))

;;; Minibuffer completion

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode))

(use-package ef-themes
  :init (ef-themes-take-over-modus-themes-mode 1)
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-night)
  )

;; Buffer completion on any order
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Add info of the commands in the completion buffer
(use-package marginalia
  :init
  (marginalia-mode))

(use-package org
  :custom (org-pretty-entities t))

(use-package org-modern
  :ensure t
  :hook ((org-mode . org-modern-mode)
	 (org-agenda-finalize . org-modern-agenda))
  :custom
  (set-face-attribute 'org-modern-symbol nil :family "Iosevka")
  )

(use-package org-roam
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


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(auctex company ef-themes jinx lsp-latex lsp-mode magic magit
	    marginalia orderless org-modern org-roam vertico xenops)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; Latex config

;; AucTeX settings - almost no changes
(use-package latex
  :ensure auctex)

(use-package xenops
  :ensure t
  :hook ((latex-mode . xenops-mode)
	 (LaTex-mode . xenops-mode)
	 (org-mode . xenops-mode))
  )


;;; Programing config

(use-package magit
  :ensure t)

(use-package lsp-mode
  :ensure t
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (prog-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; Latex support

(use-package lsp-latex
  :ensure t
  :after lsp-mode
  ;; Uncomment and set path if texlab is not in exec-path:
  :custom (lsp-latex-texlab-executable "/usr/bin/texlab")
  :hook ((tex-mode    . lsp)
         (latex-mode  . lsp)
         (yatex-mode  . lsp)
         (bibtex-mode . lsp)))
