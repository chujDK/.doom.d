;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "chuj"
      user-mail-address "1768485949@qq.com")

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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one
      doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 24
                           :weight 'normal)
      doom-variable-pitch-font (font-spec :family "DejaVu Sans" :size 26))

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

(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; 80 ruler
(setq display-fill-column-indicator-column 80)
;; we don't want a ruler in shell right? ..
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

;; don't use tab
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)

;; google c style
(add-hook 'c-mode-common-hook 'google-set-c-style)

;; i want to see if there is a tab or whitespace
(global-whitespace-mode 1)
;; disable whitespace in org mode
(add-hook 'org-mode (lambda () (whitespace-mode nil)))

;; better and better syntax highlighting! more color, more fun!
;; auto start it by setting tree-sitter-after-in-hook
(global-tree-sitter-mode)
(setq-default tree-sitter-after-on-hook (lambda () (tree-sitter-hl-mode t)))

;; always enable wakatime
(global-wakatime-mode t)

;; use a better chinese input
(setq default-input-method "rime")
(setq rime-show-candidate 'posframe)
(setq rime-user-data-dir "~/.local/share/fcitx5/rime")

;; org paste image from windows host
(setq org-startup-with-inline-images t)
(defun org-paste-image-from-windows ()
  "Paste an image into a time stamped unique-named file in the ~/.org/picture
and insert a link to this file"
  (interactive)
  (let* ((target-file
          (concat
           (make-temp-name
            (concat
             "~/.org/picture/"
             (format-time-string "%Y%m%d_%H%M%S_")))
           "\.png"))
         (windows-path
          (wsl-to-windows-path target-file))
         (ps-script
          (concat "(Get-Clipboard -Format image).Save('" windows-path "')")))
         (powershell ps-script)

         (if (file-exists-p target-file)
             (progn (insert (concat "[[" target-file "]]"))
                    (org-display-inline-images)
                    (message (concat "saving to " ps-script "..."))
                    )
           (user-error
            "Pasting the image failed.."))
         ))

(defun wsl-to-windows-path (path)
  "Conver a wsl unix path to its windows path"
  (substring
   (shell-command-to-string (concat "wslpath -w " path)) 0 -1))

(defun powershell (script)
  "Execute the given script within a powershell and return its return value.
Note: pwsh should be a valid command that can start a powershell, for example,
make a symblic link to powershell.exe to ~/.local/bin/powershell"
  (call-process "powershell" nil nil nil
                "-noprofile"
                "-Command" (concat "& {" script "}")))

(keyfreq-mode 1)
(keyfreq-autosave-mode 1)
(setq keyfreq-excluded-commands
      '(self-insert-command
        forward-char
        backward-char
        previous-line
        next-line
        evil-previous-line
        evil-next-line
        evil-backward-char
        evil-forward-char
        evil-force-normal-state
        evil-insert
        term-send-raw))
