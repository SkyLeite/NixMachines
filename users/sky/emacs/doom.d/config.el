;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
      doom-variable-pitch-font (font-spec :family "Comic Sans MS" :size 13)) ;; haha funny
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-homage-white)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

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

;; (setq org-capture-templates
;;       (quote
;;        (("j" "Journal" entry (file+datetree "~/org/journal.org")
;;          "* %?\n%U\n"))))

(use-package! ts)

(defvar flymake-allowed-file-name-masks nil)

(after! org
  (add-to-list 'org-capture-templates
               '("i" "Idea" entry (file+headline +org-capture-todo-file "Idea") "* TODO %? %(org-set-tags \"idea\")"))

  (add-to-list 'org-capture-templates
               '("d" "Daily Standup note" entry (file+olp+datetree "~/org/standup.org") "* TODO %U %? %(org-set-tags \"standup\")\n%i\n%a" :prepend t))

  (let* ((now (ts-now))
         (today-after-standup (ts-apply :hour 14 :minute 0 :second 0 now))
         (yesterday-after-standup (ts-adjust 'day -1 today-after-standup)))
    (setq org-agenda-custom-commands
          `(("cd" "Custom: Daily Standup notes"
             ((org-ql-block '(and (ts :from ,yesterday-after-standup) (tags "standup"))
                            ((org-ql-block-header "Daily Standup notes")))
              (agenda)))

            ("i" "Custom: Ideas"
             ((org-ql-block '(and (tags "idea") (todo))
                            ((org-ql-block-header "Ideas")))
              (agenda)))
            )))
  )

(after! emms
  (setq emms-player-mpd-server-name "localhost")
  (setq emms-player-mpd-server-port "6600")
  (setq emms-player-mpd-music-directory "/mnt/hdd/music")
  )

(after! magit
  (setq auth-sources '("~/.authinfo")))

(after! dap-mode
  (require 'dap-dlv-go))

(after! eglot
  (require 'eglot-fsharp)
  (set-eglot-client! 'haskell-mode '("/nix/store/l4vfmlm894xpa17plhfwacycalqajcys-haskell-language-server-1.7.0.0/bin/haskell-language-server-9.0.2" "--lsp")))

(after! lsp-mode
  (setq lsp-fsharp-use-dotnet-tool-for-fsac t)
  (setq lsp-clients-lua-language-server-bin "/etc/profiles/per-user/sky/bin/lua-language-server")
  (add-hook 'csharp-tree-sitter-mode-hook #'lsp-deferred)
  (add-hook 'csharp-mode-hook #'lsp-deferred))

(after! lsp-ui
  (setq lsp-ui-doc-max-height 40)
  (setq lsp-ui-doc-include-signature t))

;; (defun lsp-ui-doc-glance-or-focus ())

(unbind-key "K" evil-normal-state-map)
(map! :after lsp-mode
      :map evil-normal-state-map
      "K" #'lsp-ui-doc-glance)

(after! apheleia
  (setf (alist-get 'csharpie apheleia-formatters)
        '("dotnet" "csharpie" "--skip-write" "--write-stdout" filepath)))


;; (after! format-all-mode
;;   (advice-add 'format-all-buffer :around #'envrc-propagate-environment)
;;   (advice-add 'format-all-buffer--from-hook :around #'envrc-propagate-environment))
