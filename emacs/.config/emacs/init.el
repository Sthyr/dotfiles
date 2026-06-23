(with-eval-after-load 'package
 (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;; Nice line wrapping when working with text
(add-hook 'text-mode-hook 'visual-line-mode)

;; Make right-click do something sensible
(when (display-graphic-p)
  (context-menu-mode))

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

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

;; Enable vertico
(use-package vertico
  :ensure t
  :init
  (vertico-mode))

;; Add info of the commands in the completion buffer
(use-package marginalia
  :ensure t
  :init
  (marginalia-mode))

;; Buffer completion on any order
(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-pcm-leading-wildcard t))

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

(use-package ef-themes
  :ensure t
  :init (ef-themes-take-over-modus-themes-mode 1)
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t)
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-night)
  )

(set-face-attribute 'default nil :font "Iosevka Slab" :height 200)
(set-face-attribute 'fixed-pitch nil :font "Iosevka Slab")
(set-face-attribute 'variable-pitch nil :font "Iosevka Etoile" :weight 'medium)

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

(use-package buffer-guardian
  :ensure t
  :custom
  ;; When non-nil, include remote files in the auto-save process
  (buffer-guardian-inhibit-saving-remote-files t)

  ;; When non-nil, buffers visiting nonexistent files are not saved
  (buffer-guardian-inhibit-saving-nonexistent-files nil)

  ;; Save the buffer even if the window change results in the same buffer
  (buffer-guardian-save-on-same-buffer-window-change t)

  ;; Non-nil to enable verbose mode to log when a buffer is automatically saved
  (buffer-guardian-verbose nil)

  ;; Pre-save all package-managed buffers before native save commands run
  ;; Advise `save-some-buffers' to use `buffer-guardian' logic.
  ;; When non-nil and `buffer-guardian-mode' is active, this intercepts
  ;; `save-some-buffers' to silently pre-save package-managed buffers before
  ;; allowing the native command to run normally.
  (buffer-guardian-override-save-some-buffers nil)

  ;; Save all buffers after N seconds of user idle time. (Disabled by default)
  ;; (buffer-guardian-save-all-buffers-idle 30)

  ;; Save all buffers every N seconds. (Disabled by default)
  ;; (setq buffer-guardian-save-all-buffers-interval (* 60 30))

  :hook
  (after-init . buffer-guardian-mode))

;; Spell checking
(use-package jinx
  :ensure t
  :hook (emacs-startup . global-jinx-mode)
  :bind (("C-;" . jinx-correct)
	 ("C-M-;" . jinx-languages))
  :custom
  (jinx-languages "en_US es_CL")
  )

(use-package tempel
  :ensure t
  ;; By default, tempel looks at the file "templates" in
  ;; user-emacs-directory, but you can customize that with the
  ;; tempel-path variable:z
  ;; :custom
  ;; (tempel-path (concat user-emacs-directory "custom_template_file"))
  :bind (("M-´" . tempel-insert)
         ("M-+" . tempel-complete)
         :map tempel-map
         ("C-c RET" . tempel-done)
         ("C-<down>" . tempel-next)
         ("C-<up>" . tempel-previous)
         ("M-<down>" . tempel-next)
         ("M-<up>" . tempel-previous))
  :init
  ;; Make a function that adds the tempel expansion function to the
  ;; list of completion-at-point-functions (capf).
  (defun tempel-setup-capf ()
    (add-hook 'completion-at-point-functions #'tempel-expand -1 'local))
  ;; Put tempel-expand on the list whenever you start programming or
  ;; writing prose.
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

(use-package org
  :ensure t
  :custom (org-pretty-entities t))

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

;; Download images
(use-package org-download
  :ensure t
  :custom (add-hook 'dired-mode-hook . 'org-download-enable)
  )

(use-package org-modern
    :ensure t
    :hook ((org-mode . org-modern-mode)
  	 (org-agenda-finalize . org-modern-agenda))
)
 ;   :custom
 ;   (set-face-attribute 'org-modern-symbol nil :family "Iosevka")
 ;   )
