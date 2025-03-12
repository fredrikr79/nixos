;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

(setq doom-user-dir "~/system_flake/home/doom.d/")


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Fredrik Robertsen"
      user-mail-address "fredrikrobertsen7@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Monocraft" :size 24 :weight 'medium)
      ;; doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13)
      )
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (doom/set-frame-opacity 40)

(set-frame-parameter nil 'alpha-background 80)
(add-to-list 'default-frame-alist '(alpha-background . 80))
;; (add-to-list 'default-frame-alist 'alpha 80)


;; (use-package! websocket)
;; (use-package! typst-preview
;;   ;; :load-path "directory-of-typst-preview.el"
;;   :config
;;   (setq typst-preview-browser "default")
;;   (define-key typst-preview-mode-map (kbd "C-c C-j") 'typst-preview-send-position)
;;   )

;; (use-package! typst-ts-mode
;;   ;; :load-path "directory-of-typst-ts-mode.el"
;;   :custom
;;   (typst-ts-mode-watch-options "--open")
;;   ;; (typst-ts-mode-enable-raw-blocks-highlight t)
;;   ;; :config
;;   ;; make sure to install typst-lsp from
;;   ;; https://github.com/nvarner/typst-lsp/releases
;;   ;; or use tinymist
;;   ;; (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))
;;   ;; (lsp-register-client
;;   ;;  (make-lsp-client
;;   ;;   :new-connection (lsp-stdio-connection "typst-lsp")
;;   ;;   :major-modes '(typst-ts-mode)
;;   ;;   :server-id 'typst-lsp))
;;   )


;; gptttt
;; Ensure lsp-mode is loaded and set up for typst-ts-mode
;; (after! lsp-mode
;;   (add-to-list 'lsp-language-id-configuration '(typst-ts-mode . "typst"))

;;   (lsp-register-client
;;    (make-lsp-client
;;     :new-connection (lsp-stdio-connection '("tinymist" "lsp"))
;;     :major-modes '(typst-ts-mode)
;;     :server-id 'tinymist)))

;; Enable LSP in typst-ts-mode
;; (add-hook 'typst-ts-mode-hook #'lsp)


(require 'elcord)
(elcord-mode)

(map! :leader "pv" #'dirvish)

(map! [f5] #'+make/run-last)


;; accept completion from copilot and fallback to company
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

;; (add-to-list 'copilot-major-mode-alist '("typescript" . "javascript"))


(run-with-idle-timer 120 t #'zone)

