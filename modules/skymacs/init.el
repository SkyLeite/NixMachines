(setq package-user-dir (getenv "XDG_CONFIG_HOME"))

;; Set the font. Note: height = px * 100
(set-face-attribute 'default nil :font "Ubuntu Mono" :height 120)

;; Performance tweaks for modern machines
(setq gc-cons-threshold 100000000) ; 100 mb
(setq read-process-output-max (* 1024 1024)) ; 1mb

;; Keep track of open files
(recentf-mode t)

;; Keep files up-to-date when they change outside Emacs
(global-auto-revert-mode t)

;; Visualize matching parens
(show-paren-mode 1)

;; Automatically save your place in files
(save-place-mode t)

;; Remove extra UI clutter by hiding the scrollbar, menubar, and toolbar.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Evil mode
(require 'evil)
(evil-mode 1)
