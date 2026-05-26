(with-eval-after-load 'package
   (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(setenv "PATH" (concat "/usr/local/texlive/2026/bin/x86_64-linux/:"
                       (getenv "PATH")))
(add-to-list 'exec-path "/usr/local/texlive/2026/bin/x86_64-linux/")

(set-face-attribute 'default nil :font "Iosevka Slab" :height 200)
(set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")
(set-face-attribute 'variable-pitch nil :font "Iosevka Etoile" :weight 'medium)


;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

;; Save history of mini buffer
(savehist-mode)

;; Fix archaic defaults
(setopt sentence-end-double-space nil)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Don't litter file system with *~ backup files; put them all inside
;; ~/.emacs.d/backup or wherever
(defun bedrock--backup-file-name (fpath)
  "Return a new file path of a given file path.
If the new path's directories does not exist, create them."
  (let* ((backupRootDir (concat user-emacs-directory "emacs-backup/"))
         (filePath (replace-regexp-in-string "[A-Za-z]:" "" fpath )) ; remove Windows driver letter in path
         (backupFilePath (replace-regexp-in-string "//" "/" (concat backupRootDir filePath "~") )))
    (make-directory (file-name-directory backupFilePath) (file-name-directory backupFilePath))
    backupFilePath))
(setopt make-backup-file-name-function 'bedrock--backup-file-name)

;; Show the help buffer after startup
(add-hook 'after-init-hook 'help-quick)

;; Minibuffer
(setopt enable-recursive-minibuffers t)                ; Use the minibuffer whilst in the minibuffer
(setopt completion-cycle-threshold 1)                  ; TAB cycles candidates
(setopt completions-detailed t)                        ; Show annotations
(setopt tab-always-indent 'complete)                   ; When I hit TAB, try to complete, otherwise, indent
(setopt completion-styles '(basic initials substring)) ; Different styles to match input to candidates

(setopt completion-auto-help 'always)                  ; Open completion always; `lazy' another option
(setopt completions-max-height 20)                     ; This is arbitrary
(setopt completions-format 'one-column)
(setopt completions-group t)
(setopt completion-auto-select 'second-tab)            ; Much more eager
;(setopt completion-auto-select t)                     ; See `C-h v completion-auto-select' for more possible values

(keymap-set minibuffer-mode-map "TAB" 'minibuffer-complete) ; TAB acts more like how it does in the shell

;; Interface
;; Mode line information
(setopt line-number-mode t)                        ; Show current line in modeline
(setopt column-number-mode t)                      ; Show column as well

(setopt x-underline-at-descent-line nil)           ; Prettier underlines
(setopt switch-to-buffer-obey-display-actions t)   ; Make switching buffers more consistent

(setopt show-trailing-whitespace nil)      ; By default, don't underline trailing spaces
(setopt indicate-buffer-boundaries 'left)  ; Show buffer top and bottom in the margin

;; Enable horizontal scrolling
(setopt mouse-wheel-tilt-scroll t)
(setopt mouse-wheel-flip-direction t)

;; Misc. UI tweaks
(blink-cursor-mode -1)                                ; Steady cursor
(pixel-scroll-precision-mode)                         ; Smooth scrolling

;; Display line numbers in programming mode
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setopt display-line-numbers-width 3)           ; Set a minimum width

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Modes to highlight the current line with
(let ((hl-line-hooks '(text-mode-hook prog-mode-hook)))
  (mapc (lambda (hook) (add-hook hook 'hl-line-mode)) hl-line-hooks))

;; Writing config

(add-hook 'text-mode-hook 'visual-line-mode)
(delete-selection-mode t)
(setq-default scroll-error-top-bottom t)
(setq save-interprogram-paste-before-kill t)

;; Spell checking
(use-package jinx
  :ensure t
  :hook (emacs-startup . global-jinx-mode)
  :bind (("C-;" . jinx-correct)
	 ("C-M-;" . jinx-languages))
  :custom
  (jinx-languages "en_US es_CL")
  )

;; Auto Completion
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 3)
  (company-dabbrev-minimum-length 8)
  (company-selection-wrap-around t)
  )

;; Improve keyboard shortcut discoverability
(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;;; Minibuffer completion

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

(use-package ef-themes
  :ensure t
  :init (ef-themes-take-over-modus-themes-mode 1)
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-night)
  )

;; Buffer completion on any order
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

;; Add info of the commands in the completion buffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

(use-package org
  :ensure t
  :custom (org-pretty-entities t))

(use-package org-modern
  :ensure t
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

(setq gc-cons-threshold (or bedrock--initial-gc-threshold 800000))
