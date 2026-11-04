(with-eval-after-load 'package
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

(cua-mode t)

(when (display-graphic-p)
  (context-menu-mode))

;; Automatically reread from disk if the underlying file changes
(setopt auto-revert-avoid-polling t)
;; Some systems don't do file notifications well; see
;; https://todo.sr.ht/~ashton314/emacs-bedrock/11
(setopt auto-revert-interval 5)
(setopt auto-revert-check-vc-info t)
(global-auto-revert-mode)

(tab-bar-mode 1)

(set-face-attribute 'default nil
		    :family "Iosevka"
		    ;; Height = point size * 10
		    :height 180
		    :weight 'Regular)
(set-face-attribute 'fixed-pitch nil
		      :family "Iosevka"
		    :height 180)
(set-face-attribute 'variable-pitch nil
		    :family "Iosevka Etoile"
		    :height 180)

(add-hook 'text-mode-hook #'variable-pitch-mode)

(use-package ef-themes
  :ensure t
  :init (ef-themes-take-over-modus-themes-mode 1)
  :config
  ;; All customisations here.
  (setq modus-themes-mixed-fonts t) ;; This uses the monospace(fixed-pitch) font in things such as tables, etc.
  (setq modus-themes-italic-constructs t)
  (modus-themes-load-theme 'ef-night)
  )

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

(use-package tex
  :ensure auctex
  :hook ((LaTeX-mode . turn-on-reftex)            ; referencias cruzadas
         (LaTeX-mode . TeX-source-correlate-mode) ; sincroniza código <-> PDF
         (LaTeX-mode . visual-line-mode))         ; ajusta líneas largas
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-source-correlate-start-server t)
  (reftex-plug-into-AUCTeX t))

;; Where to store my agenda files
(setq org-agenda-files '("~/org"))

;; Record a timestamp when a TODO is set to a done state
(setq org-log-done 'time)

;; Follow links
(setq org-return-follows-link t)

;; Indent headings
;; * Heading 1
;;  ** Heading 2
;;   *** Heading 3
(add-hook 'org-mode-hook 'org-indent-mode)

;; Wrap lines in org mode. I don't have to scroll horizontally to see the text at the end of each line
(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-capture-templates
        '(
	  ("j" "Journal Entry"
	  entry (file+datetree "~/org/journal.org")
	  "* %?"
:empty-lines 0)
    ))
