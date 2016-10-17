(require 'evil)
(require 'cl-lib)

(eval-when-compile
  (declare-function evil-iedit-state/quit-iedit-mode "evil-iedit-state.el"))

(defgroup evil-escape nil
  "Key sequence to escape insert state and everything else."
  :prefix "evil-escape-"
  :group 'evil)

(defcustom evil-escape-key-sequence (kbd "fd")
  "Two keys sequence to escape from insert state."
  :type 'key-sequence
  :group 'evil-escape)

(defcustom evil-escape-delay 0.1
  "Max time delay between two key presses."
  :type 'number
  :group 'evil-escape)

(defcustom evil-escape-unordered-key-sequence nil
  "If non-nil then the key sequence can also be entered with the second
key first."
  :type 'boolean
  :group 'evil-escape)

(defcustom evil-escape-excluded-major-modes nil
  "Excluded major modes where escape sequences has no effect."
  :type 'sexp
  :group 'evil-escape)

(defcustom evil-escape-enable-only-for-major-modes nil
  "List of major modes where evil-escape is enabled."
  :type 'sexp
  :group 'evil-escape)

(defcustom evil-escape-inhibit-functions nil
  "List of zero argument predicate functions disabling evil-escape.
 If any of these functions return non nil, evil escape will be inhibited."
  :type 'sexp
  :group 'evil-escape)

(defvar evil-escape-inhibit nil
  "When non nil evil-escape is inhibited.")

;;;###autoload
(define-minor-mode evil-escape-mode
  "Buffer-local minor mode to escape insert state and everything else
with a key sequence."
  :lighter (:eval (concat " " evil-escape-key-sequence))
  :group 'evil
  :global t
  (if evil-escape-mode
      (add-hook 'pre-command-hook 'evil-escape-pre-command-hook t)
    (remove-hook 'pre-command-hook 'evil-escape-pre-command-hook)))

(defun evil-escape ()
  "Escape from everything... well almost everything."
  (interactive)
  (call-interactively (evil-escape-func)))

(defun evil-escape-func ()
  "Return the function to escape from everything."
  (pcase evil-state
    (`normal (evil-escape--escape-normal-state))
    (`motion (evil-escape--escape-motion-state))
    (`insert 'evil-normal-state)
    (`emacs (evil-escape--escape-emacs-state))
    (`hybrid (evil-escape--escape-emacs-state))
    (`evilified (evil-escape--escape-emacs-state))
    (`visual 'evil-exit-visual-state)
    (`replace 'evil-normal-state)
    (`lisp 'evil-lisp-state/quit)
    (`iedit 'evil-iedit-state/quit-iedit-mode)
    (`iedit-insert 'evil-iedit-state/quit-iedit-mode)
    (_ (evil-escape--escape-normal-state))))

(defun evil-escape-pre-command-hook ()
  "evil-escape pre-command hook."
  (with-demoted-errors "evil-escape: Error %S"
      (when (evil-escape-p)
        (let* ((modified (buffer-modified-p))
               (inserted (evil-escape--insert))
               (fkey (elt evil-escape-key-sequence 0))
               (skey (elt evil-escape-key-sequence 1))
               (evt (read-event nil nil evil-escape-delay)))
          (when inserted (evil-escape--delete))
          (set-buffer-modified-p modified)
          (cond
           ((and (integerp evt)
                 (or (and (equal (this-command-keys) (evil-escape--first-key))
                          (char-equal evt skey))
                     (and evil-escape-unordered-key-sequence
                          (equal (this-command-keys) (evil-escape--second-key))
                          (char-equal evt fkey))))
            (evil-repeat-stop)
            (when (evil-escape-func) (setq this-command (evil-escape-func))))
           ((null evt))
           (t (setq unread-command-events
                    (append unread-command-events (list evt)))))))))

(defadvice evil-repeat (around evil-escape-repeat-info activate)
  (let ((evil-escape-inhibit t))
    ad-do-it))

(defun evil-escape-p ()
  "Return non-nil if evil-escape can run."
  (and (not evil-escape-inhibit)
       (or (window-minibuffer-p)
           (bound-and-true-p isearch-mode)
           (eq 'ibuffer-mode major-mode)
           (and (fboundp 'helm-alive-p) (helm-alive-p))
           (or (not (eq 'normal evil-state))
               (not (eq 'evil-force-normal-state
                        (lookup-key evil-normal-state-map [escape])))))
       (not (memq major-mode evil-escape-excluded-major-modes))
       (or (not evil-escape-enable-only-for-major-modes)
           (memq major-mode evil-escape-enable-only-for-major-modes))
       (or (equal (this-command-keys) (evil-escape--first-key))
           (and evil-escape-unordered-key-sequence
                (equal (this-command-keys) (evil-escape--second-key))))
       (not (cl-reduce (lambda (x y) (or x y))
                       (mapcar 'funcall evil-escape-inhibit-functions)
                       :initial-value nil))))

(defun evil-escape--escape-normal-state ()
  "Return the function to escape from normal state."
  (cond
   ((and (fboundp 'helm-alive-p) (helm-alive-p)) 'helm-keyboard-quit)
   ((eq 'ibuffer-mode major-mode) 'ibuffer-quit)
   ((bound-and-true-p isearch-mode) 'isearch-abort)
   ((window-minibuffer-p) 'abort-recursive-edit)
   (t (lookup-key evil-normal-state-map [escape]))))

(defun evil-escape--escape-motion-state ()
  "Return the function to escape from motion state."
  (cond
   ((or (memq major-mode '(apropos-mode
                           help-mode
                           ert-results-mode
                           ert-simple-view-mode
                           compilation-mode))) 'quit-window)
   ((eq 'undo-tree-visualizer-mode major-mode) 'undo-tree-visualizer-quit)
   ((and (fboundp 'helm-ag--edit-abort)
         (string-equal "*helm-ag-edit*" (buffer-name))) 'helm-ag--edit-abort)
   ((eq 'neotree-mode major-mode) 'neotree-hide)
   (t 'evil-normal-state)))

(defun evil-escape--escape-emacs-state ()
  "Return the function to escape from emacs state."
  (cond
   ((bound-and-true-p isearch-mode) 'isearch-abort)
   ((window-minibuffer-p) 'abort-recursive-edit)
   ((string-match "magit" (symbol-name major-mode)) 'evil-escape--escape-with-q)
   ((eq 'ibuffer-mode major-mode) 'ibuffer-quit)
   ((eq 'emoji-cheat-sheet-plus-buffer-mode major-mode) 'kill-this-buffer)
   ((eq 'paradox-menu-mode major-mode) 'evil-escape--escape-with-q)
   ((eq 'gist-list-menu-mode major-mode) 'quit-window)
   (t 'evil-normal-state)))

(defun evil-escape--first-key ()
  "Return the first key string in the key sequence."
  (let* ((first-key (elt evil-escape-key-sequence 0))
         (fkeystr (char-to-string first-key)))
    fkeystr))

(defun evil-escape--second-key ()
  "Return the second key string in the key sequence."
  (let* ((sec-key (elt evil-escape-key-sequence 1))
         (fkeystr (char-to-string sec-key)))
    fkeystr))

(defun evil-escape--insert-func ()
  "Default insert function."
  (when (not buffer-read-only) (self-insert-command 1)))

(defun evil-escape--delete-func ()
  "Delete char in current buffer if not read only."
  (when (not buffer-read-only) (delete-char -1)))

(defun evil-escape--insert ()
  "Insert the first key of the sequence."
  (condition-case err
      (pcase evil-state
        (`insert (evil-escape--insert-2) t)
        (`emacs (evil-escape--insert-2) t)
        (`hybrid (evil-escape--insert-2) t)
        (`normal
         (when (window-minibuffer-p) (evil-escape--insert-func) t))
        (`iedit-insert (evil-escape--insert-func) t))
    ('error nil)))

(defun evil-escape--insert-2 ()
  "Insert character while taking into account mode specificites."
  (pcase major-mode
    (`term-mode (call-interactively 'term-send-raw))
    (_ (cond
        ((bound-and-true-p isearch-mode) (isearch-printing-char))
        (t (evil-escape--insert-func))))))

(defun evil-escape--delete ()
  "Revert the insertion of the first key of the sequence."
  (pcase evil-state
    (`insert (evil-escape--delete-2))
    (`emacs (evil-escape--delete-2))
    (`hybrid (evil-escape--delete-2))
    (`normal
     (when (minibuffer-window-active-p (evil-escape--delete-func))))
    (`iedit-insert (evil-escape--delete-func))))

(defun evil-escape--delete-2 ()
  "Delete character while taking into account mode specifities."
  (pcase major-mode
    (`term-mode (call-interactively 'term-send-backspace))
    (_ (cond
        ((bound-and-true-p isearch-mode) (isearch-delete-char))
        (t (evil-escape--delete-func))))))

(defun evil-escape--escape-with-q ()
  "Send `q' key press event to exit from a buffer."
  (interactive)
  (setq unread-command-events (listify-key-sequence "q")))

(provide 'evil-escape)