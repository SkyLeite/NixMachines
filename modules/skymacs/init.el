;; Melpa
(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Util functions
(defun add-list-to-list-var (list-var new-elements &optional append compare-fn)
  "Like `add-to-list', but add multiple elements NEW-ELEMENTS, in order."
  (interactive)
  (setq new-elements  (if append new-elements (reverse new-elements)))
  (let* ((val  (symbol-value list-var))
         (lst  (if append (reverse val) val)))
    (dolist (elt new-elements)
      (cl-pushnew elt lst :test compare-fn))
    (set list-var (if append (nreverse lst) lst)))
  (symbol-value list-var))

(setq package-user-dir (getenv "XDG_CONFIG_HOME"))

;; Set the font. Note: height = px * 100
(set-face-attribute 'default nil :font "BQN386 Unicode" :height 140)

;; Performance tweaks for modern machines
(setq gc-cons-threshold 200000000) ; 200 mb
(setq read-process-output-max (* 1024 1024)) ; 1mb

;; Keep track of open files
(recentf-mode t)

;; Disable the annoying beeping
(setq visible-bell 1)

;; Use spaces for indentation
(setq indent-tabs-mode nil)

;; Keep files up-to-date when they change outside Emacs
(global-auto-revert-mode t)

;; Visualize matching parens
(show-paren-mode 1)

;; Remove extra UI clutter by hiding the scrollbar, menubar, and toolbar.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Theme
(require 'modus-themes)
(load-theme 'modus-operandi :no-confirm)

;; Evil mode
(setq evil-want-C-u-scroll t
      evil-want-keybinding nil) ;; For evil-collection
(require 'evil)
(evil-mode 1)
(evil-set-undo-system 'undo-redo)
(evil-collection-init)

(require 'evil-org)
(evil-org-set-key-theme '(textobjects insert navigation additional shift todo heading))

(require 'evil-org-agenda)
(evil-org-agenda-set-keys)

(add-hook 'org-mode-hook #'evil-org-mode)

(require 'evil-snipe)
(evil-snipe-mode +1)
(evil-snipe-override-mode +1)

;; Which-key
(require 'which-key)

(setq which-key-idle-delay 0.8)
(setq which-key-idle-secondary-delay 0.05)
(setq which-key-popup-type 'side-window)
(which-key-mode)

;; Projectile
(require 'projectile)
(projectile-mode +1)

;; Formatting
(require 'format-all)
(format-all-mode +1)

;; Helm
(require 'helm)
(require 'helm-autoloads)
(helm-mode +1)
(setq helm-move-to-line-cycle-in-source nil
      helm-apropos-fuzzy-match t)

;; Company
(company-mode +1)
(company-quickhelp-mode)
(with-eval-after-load 'company-quickhelp
  (if (not window-system)
      (company-quickhelp-terminal-mode 1)))

(add-hook 'prog-mode-hook 'global-company-mode)

(setq company-quickhelp-use-propertized-text t)
(setq company-quickhelp-color-background t)
(setq company-tooltip-align-annotations t)
(setq company-tooltip-flip-when-above t)
(setq company-show-quick-access 'left)
(setq company-quick-access-modifier 'super)
(setq company-search-regexp-function 'company-search-flex-regexp)
(setq company-frontends '(company-pseudo-tooltip-unless-just-one-frontend
			  company-preview-if-just-one-frontend))

(setq company-quickhelp-color-background (face-attribute 'company-tooltip :background))


;; Org mode
(require 'org)
(setq find-file-visit-truename t
      org-startup-indented t)
(add-to-list 'org-agenda-files "~/Documents/Obsidian/Test" t)
(add-to-list 'org-modules 'org-habit t)

(setq org-habit-graph-column 70)

;;;; Org templates
(setq org-capture-templates
      '(
	("t" "Todo" entry (file+headline "~/Documents/Obsidian/Test/Personal.org" "Inbox") "** TODO %?")
	))

;;;; Looks
(with-eval-after-load 'org (global-org-modern-mode))

;;;; Roam
(setq org-roam-directory (file-truename "~/Documents/org-roam"))
(org-roam-db-autosync-mode)

;; Language maps
(add-list-to-list-var
 'auto-mode-alist
 '(
   ("\\.nix\\'" . nix-ts-mode)
   ("\\.rs\\'" . rust-ts-mode)
   )
 )

;; Eglot
(add-hook 'rust-ts-mode-hook 'eglot-ensure)
(add-hook 'nix-ts-mode-hook 'eglot-ensure)

;; My commands
(defun describe-symbol-at-point ()
  (interactive)
  (describe-symbol (symbol-at-point)))

;; NeoTree can be opened (toggled) at projectile project root
;; https://gist.github.com/idcrook/28fd6059894cc4f03e74fc48b44da719
(defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))


;; Neotree
(setq neo-smart-open t)

;; Popwin
(require 'popwin)
(popwin-mode 1)

;; Keymaps
(defvar-keymap sky-open-map
               :doc "Open"
               "p" #'neotree-project-dir
	       "r" #'projectile-run-shell
	       "a" #'org-agenda) 

(defvar-keymap sky-projectile-run-map
               :doc "Project:: Run"
               "r" #'projectile-run-shell-command-in-root
               "a" #'projectile-run-async-shell-command-in-root)

(defvar-keymap sky-projectile-map
	       :doc "Projectile-related functions"
	       "a" #'projectile-add-known-project
	       "p" #'projectile-switch-project
	       "d" #'projectile-remove-known-project
	       "c" #'projectile-compile-project
	       "r" sky-projectile-run-map)

(defvar-keymap sky-eval-map
	       :doc "Eval-related functions"
	       "b" #'eval-buffer
	       "d" #'eval-defun)

(defvar-keymap sky-help-map
	       :doc "Help commands"
	       "v" #'describe-variable
	       "p" #'describe-package
	       "b" #'describe-bindings
	       "k" #'describe-key)

(defvar-keymap sky-buffers-map
	       :doc "Buffers"
	       "b" #'projectile-switch-to-buffer
	       "o" #'projectile-switch-to-buffer-other-window)

(defvar-keymap sky-git-map
	       :doc "Git"
	       "g" #'magit)

(defvar-keymap sky-find-map
	       :doc "Find"
	       "w" #'projectile-ripgrep)

(defvar-keymap sky-base-map
               :doc "Base map"
	       "w" #'save-buffer
	       ":" #'helm-M-x
	       "SPC" #'projectile-find-file-dwim
               "f" sky-find-map
	       "o" sky-open-map
	       "p" sky-projectile-map
	       "e" sky-eval-map
	       "h" sky-help-map
	       "g" sky-git-map
	       "b" sky-buffers-map)

;; Close things with ESC instead of C-g
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

(keymap-set evil-normal-state-map "SPC" sky-base-map)
(keymap-set evil-normal-state-map "C-h" #'evil-window-left)
(keymap-set evil-normal-state-map "C-l" #'evil-window-right)
(keymap-set evil-normal-state-map "C-j" #'evil-window-down)
(keymap-set evil-normal-state-map "C-k" #'evil-window-up)
(keymap-set evil-insert-state-map "C-<return>" #'company-complete)
(keymap-set evil-normal-state-map "K" #'describe-symbol-at-point)

(envrc-global-mode)




































































































































































































































































































































































































































































































































