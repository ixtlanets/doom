;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

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
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; Font settings
(setq
 doom-font (font-spec :family "Hack Nerd Font" :size 20)
 doom-big-font (font-spec :family "Hack Nerd Font" :size 32)
 doom-variable-pitch-font (font-spec :family "Cantarell" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org

  (setq org-directory "~/org/")
  (setq org-todo-keywords '((sequence "TODO(t)" "IDEA(i)" "WAIT(w)" "HOLD(h)" "|" "DONE(d)" "CANC(c)")
                            (sequence "[ ](T)" "[-](S)" "[?](W)" "|" "[X](D)")
                            (sequence "|" "OKAY(o)" "YES(y)" "NO(n)")))
  (setq
   org-agenda-skip-scheduled-if-done t
   org-ellipsis " ▾ "
   org-bullets-bullet-list '("·")
   org-tags-column -80
   org-log-done 'time
   )
  (set-face-attribute 'org-link nil
                      :weight 'normal
                      :background nil)
  (set-face-attribute 'org-code nil
                      :foreground "#a9a1e1"
                      :background nil)
  (set-face-attribute 'org-date nil
                      :foreground "#5B6268"
                      :background nil)
  (set-face-attribute 'org-level-1 nil
                      :foreground "steelblue2"
                      :background nil
                      :height 1.8
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :foreground "slategray2"
                      :background nil
                      :height 1.5
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.3
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :foreground "DodgerBlue2"
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-level-5 nil
                      :weight 'normal)
  (set-face-attribute 'org-level-6 nil
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :foreground "SlateGray1"
                      :background nil
                      :height 1.75
                      :weight 'bold)
  )


;; Editor config
                                        ; Set tab width to 2 for all buffers
(setq-default tab-width 2)

                                        ; Use 2 spaces instead of a tab.
(setq-default tab-width 2 indent-tabs-mode nil)

                                        ; Indentation cannot insert tabs.
(setq-default indent-tabs-mode nil)

(setq
 dart-format-on-save t
 js-indent-level 2
 coffee-tab-width 2
 python-indent 2
 css-indent-offset 2
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-css-indent-offset 2
 typescript-indent-level 2
 json-reformat:indent-width 2
 prettier-js-args '("--single-quote")
 projectile-project-search-path '("~/pro/")
 dired-dwim-target t
 )

(add-hook! reason-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))

(add-hook!
 js2-mode 'prettier-js-mode
 (add-hook 'before-save-hook #'refmt-before-save nil t))

;; Increment / Decrement numbers

(global-set-key (kbd "C-=") 'evil-numbers/inc-at-pt)
(global-set-key (kbd "C--") 'evil-numbers/dec-at-pt)
(define-key evil-normal-state-map (kbd "C-=") 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map (kbd "C--") 'evil-numbers/dec-at-pt)

;; Email configuration
(set-email-account! "gmail"
                    '(
                      (mu4e-sent-folder       . "/gmail/[Gmail]/Sent Mail")
                      (mu4e-drafts-folder     . "/gmail/[Gmail]/Drafts")
                      (mu4e-trash-folder      . "/gmail/[Gmail]/Trash")
                      (mu4e-refile-folder     . "/gmail/[Gmail]/All Mail")
                      (smtpmail-smtp-user     . "snikulin@gmail.com")
                      (user-full-name         . "Sergey Nikulin")
                      (user-mail-address      . "snikulin@gmail.com")    ;; only needed for mu < 1.4
                      (mu4e-compose-signature . "---\nBest Wishes,\nSergey Nikulin"))
                    t)

(set-email-account! "zencar"
                    '(
                      (mu4e-sent-folder       . "/zencar/Sent")
                      (mu4e-drafts-folder     . "/zencar/Drafts")
                      (mu4e-trash-folder      . "/zencar/Trash")
                      (mu4e-refile-folder     . "/zencar/Archive")
                      (smtpmail-smtp-user     . "sn@zencar.tech")
                      (user-full-name         . "Sergey Nikulin")
                      (user-mail-address      . "sn@zencar.tech")    ;; only needed for mu < 1.4
                      (mu4e-compose-signature . "---\nBest Wishes,\nSergey Nikulin"))
                    t)
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
