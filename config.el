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

;; Launch Emacs maximized

(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!


(defun nik/ensure-heading-exists (file headline)
  "Ensure that a heading exists in the specified file. If the heading does not exist, it is created."
  (save-excursion
    (with-current-buffer (find-file-noselect file)
      (org-with-wide-buffer
       (goto-char (point-min))
       (unless (search-forward-regexp (format "^*\\s-+News" ) nil t)
         (goto-char (point-max))
         (insert "* News\n"))
       (unless (re-search-forward (format "^**\\s-+%s$" headline) nil t)
         (goto-char (point-max))
         (insert (format "** %s\n" headline)))
       (save-buffer)))))

(defun nik/org-font-setup ()
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.7)
                  (org-level-2 . 1.6)
                  (org-level-3 . 1.5)
                  (org-level-4 . 1.4)
                  (org-level-5 . 1.3)
                  (org-level-6 . 1.2)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch))

(use-package! org
  :bind ("C-c c" . org-capture)
  :config
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)

  (setq org-agenda-files
        '("~/org/inbox.org"
          "~/org/gr.org"
          "~/org/zencar.org"
          "~/org/loktar.org"
          "~/org/projects.org"
          "~/org/home.org"))
  (setq org-archive-location "~/org/archive.org::* From %s")
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
          (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))
  (setq org-refile-targets
        '(("archive.org" :maxlevel . 1)
          ("gr.org" :maxlevel . 1)
          ("zencar.org" :maxlevel . 1)
          ("loktar.org" :maxlevel . 1)
          ("projects.org" :maxlevel . 1)
          ("home.org" :maxlevel . 1)))

  ;; Save Org buffers after refiling!
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
        '(("d" "Dashboard"
           ((agenda "" ((org-deadline-warning-days 7)))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))
            (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

          ("n" "Next Tasks"
           ((todo "NEXT"
                  ((org-agenda-overriding-header "Next Tasks")))))

          ("W" "Work Tasks" tags-todo "+work-email")

          ;; Low-effort next actions
          ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
           ((org-agenda-overriding-header "Low Effort Tasks")
            (org-agenda-max-todos 20)
            (org-agenda-files org-agenda-files)))

          ("w" "Workflow Status"
           ((todo "WAIT"
                  ((org-agenda-overriding-header "Waiting on External")
                   (org-agenda-files org-agenda-files)))
            (todo "REVIEW"
                  ((org-agenda-overriding-header "In Review")
                   (org-agenda-files org-agenda-files)))
            (todo "PLAN"
                  ((org-agenda-overriding-header "In Planning")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "BACKLOG"
                  ((org-agenda-overriding-header "Project Backlog")
                   (org-agenda-todo-list-sublevels nil)
                   (org-agenda-files org-agenda-files)))
            (todo "READY"
                  ((org-agenda-overriding-header "Ready for Work")
                   (org-agenda-files org-agenda-files)))
            (todo "ACTIVE"
                  ((org-agenda-overriding-header "Active Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "COMPLETED"
                  ((org-agenda-overriding-header "Completed Projects")
                   (org-agenda-files org-agenda-files)))
            (todo "CANC"
                  ((org-agenda-overriding-header "Cancelled Projects")
                   (org-agenda-files org-agenda-files)))))))

  (setq org-capture-templates
        `(("t" "Time-sensitive task" entry
           (file+headline "inbox.org" "Tasks with a date")
           ,(concat "* TODO %^{Title} %^g\n"
                    "%^{How time sensitive it is|SCHEDULED|DEADLINE}: %^t\n"
                    ":PROPERTIES:\n"
                    ":CAPTURED: %U\n"
                    ":END:\n\n"
                    "%?")
           :empty-lines-after 1)
          ("n" "News for scouts" plain
           (function
            (lambda ()
              (let ((headline (format-time-string "%Y-%m-%d" (org-read-date nil t "+mon")))
                    (org-file (expand-file-name "gr.org" org-directory)))
                (nik/ensure-heading-exists org-file headline)
                (find-file org-file)
                (goto-char (point-min))
                (re-search-forward (format "^*\\s-+News\\s-*$"))
                (re-search-forward (format "^**\\s-+%s$" headline))
                (org-end-of-subtree t))))
           ,(concat "*** %^{Title}\n"
                    ":PROPERTIES:\n"
                    ":CAPTURED: %U\n"
                    ":END:\n\n"
                    "Link: %^{Link to news source}\n"
                    "%?")
           :empty-lines-after 2)
          ))
  (nik/org-font-setup))

(require 'org-tempo)


(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))


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
(use-package! gptel)


(use-package! password-store
  :bind ("C-c k" . password-store-copy)
  :config
  (setq password-store-time-before-clipboard-restore 30))
