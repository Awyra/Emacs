
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/lisp")
;(add-to-list 'load-path "~/.emacs.d/")
; (require 'monokai-theme)
(require 'molokai)
(require 'psvn)

(setq rainbow-mode t)

(set-frame-parameter (selected-frame) 'alpha '(95))

;  ОБЩИЕ НАСТРОЙКИ
; Для нормальной линии внизу просто кликни на нее
; ident-region -- для выравнивания выделенного текста
; C-c C-c -- коммментирование выделенного
; GDB -- дебагер для плюсов  как "графический дебагер"


;; прокручивание текста на одну строку, а не на пол экрана, как по умолчанию
(setq scroll-step 1)
;; разрешить отвечать y или n вместо yes или no
(fset 'yes-or-no-p 'y-or-n-p)


;auto-complete - предназначение ясно из названия. Через него работают многие другие пакеты, например, jedi.
;autopair - автоматически закрывает скобки
;company - ещё одно средство для автокомплита, через него работают некоторые пакеты, которые не работают с auto-complete
;emmet-mode - незаменимое средство для верстальщиков. Рекомендую ставить из MELPA, т.к. в STABLE очень старая версия, которая работает хуже и многого ;не умеет.
;ergoemacs-mode - пакет, устанавливающий комбинации клавиш, удобные для использования людьми, а не Ричардом Столлманом. Подробное описание клавиш здесь.
;flycheck - модуль проверки чего угодно на лету. На самом деле по-тихому вызывает имеющиеся в системе средства проверки и статического анализа кода. ;Имеет возможность конфигурирования того, какие средства и с какими параметрами следует использовать. Является более новым и прогрессивным в сравнении ;с загнивающим flymake.


(setq inhibit-startup-message t)
(require 'vim)
(require 'evil-escape)
(add-to-list 'load-path "~/.emacs.d/lisp/emacs-powerline/")
(require 'powerline)
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))

;Смещение только одной строки
(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

; Шаблон для кольцевых макросов
(defun make-my-macros()
  "Make macros."
  (interactive)
  (add-to-list 'kmacro-ring '([32 32 32 49 50 51 32 32 32 return return return 47 47 47 backspace] 0 "%d"))
  (add-to-list 'kmacro-ring '("456" 0 "%d")))

(make-my-macros)


; Визуализация уровней кода
(require 'indent-guide)
(indent-guide-global-mode)
(setq indent-guide-recursive t)

(require 'litable)
(require-package 'coffee-mode)
(require-package 'json-mode)
(require-package 'js2-mode)
(require-package 'ac-js2)
(require-package 'tern)
(require-package 'tern-auto-complete)
(require-package 'ruby-mode)
(require-package 'ruby-hash-syntax)
(require 'projectile)
(add-to-list 'load-path "~/.emacs.d/lisp/company-mode/")
(require 'company)
(global-company-mode)
(projectile-global-mode)

(defun jdown ()
  (interactive)
  (dotimes (i 5)
    (forward-line)))
(evilem-default-keybindings "SPC")
;(evilem-define (kbd "SPC w") 'evil-forward-word-begin)

(defun jup ()
  (interactive)
  (dotimes (i 5)
    (forward-line -1)))

(global-set-key (kbd "C-j") 'jdown)
(global-set-key (kbd "C-k") 'jup)

(define-key global-map "\C-cl" 'org-store-link)
; (setq org-togo-keywords '((sequence "TODO" "CHANGE" "|" "DONE")))
;;Временная метка при закрытии задания
;(setq org-log-done t)
(global-font-lock-mode 1)

; (require 'highlight-chars)
; (global-set-key (kbd "<f4>")
                      ; 'hc-toggle-highlight-trailing-whitespace)

; (global-set-key (kbd "C-,") 'previous-buffer)
; (global-set-key (kbd "M-,") 'next-buffer)
(global-evil-tabs-mode t)
; (require 'eproject)
; (add-to-list 'load-path "~/.emacs.d/lang")
; (require 'eproject-ruby)
(global-set-key (kbd "M-s M-s") 'project-explorer-toggle)
(require 'org)
(global-set-key (kbd "C-c h") 'hs-minor-mode)
; (hs-minor-mode 1)
(require 'fold-dwim)
(global-set-key (kbd "C-c a") 'fold-dwim-hide-all)
(global-set-key (kbd "C-c d") 'fold-dwim-toggle)
(global-set-key (kbd "C-c s") 'fold-dwim-show-all)

(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)
;(kbd "?\C-<TAB>")
(global-set-key (kbd "M-q") 'evil-next-buffer)
(global-set-key (kbd "M-w") 'evil-prev-buffer)
;(global-set-key (kbd "M-c M-k") 'elscreen-kill)

(global-set-key [\C-tab] 'elscreen-next)
(global-set-key (kbd "C-<") 'elscreen-previous)
(global-set-key (kbd "<backtab>") 'elscreen-create)
(global-set-key (kbd "C-c C-k") 'elscreen-kill)

(require 'project-explorer)
; "s"        Change directory
; "j"        Next line
; "k"        Previous line
; "g"        Refresh
; "+"        Create file or directory (if the name ends with a slash)
; "-" & "d"  Delete file or directory
; "c"        Copy file or directory
; "r"        Rename file or directory
; "q"        Hide sidebar
; "u"        Go to parent directory
; "["        Previous sibling
; "]"        Next sibling
; "TAB"      Toggle folding. Unfold descendants with C-U
; "S-TAB"    Fold all. Unfold with C-U
; "RET"      Toggle folding of visit file. Specify window with C-U
; "f"        Visit file or directory. Specify window with C-U
; "w"        Show the path of file at point, and copy it to clipboard
; "M-k"      Launch ack-and-a-half, from the closest directory
; "M-l"      Filter using a regular expression. Call with C-u to disable
; "M-o"      Toggle omission of hidden and temporary files
; "s" Изменить каталог
; "J" Следующая строка
; "к" Предыдущая строка
; "г" Обновить
; "+" Создать файл или каталог (если имя заканчивается с косой черты)
; "-" и "d" Удалить файл или каталог
; "C" Копировать файл или каталог
; "г" Переименовать файл или каталог
; "Q" Скрыть боковую панель
; "и" Перейти в родительский каталог
; "[" Предыдущий родственный
; "]" Next родственный
; "TAB" Переключить складной. Открываются потомков с CU
; "S-TAB" Fold все. Открываются с CU
; "РЭТ" Переключить складывания визита файла. Укажите окно с CU
; "F" Визит файла или каталога. Укажите окно с CU
; "ж" Показать путь файла в точке, а затем скопировать его в буфер обмена
; "МК" Запуск Ack-и с половиной, от ближайшего каталога
; Filter "Ml" , используя регулярное выражение. Вызов с Си , чтобы отключить
; "Мо" Переключить пропуск скрытых и временных файлов

; (require 'escreen)
; (escreen-install)
; (require 'workspaces)
; (define-key global-map (kbd "C-<tab>") 'workspace-controller)
; (global-set-key [C-q] 'workspace-goto)

(desktop-save-mode t)
(global-set-key (kbd "<f1>") 'visit-tags-table)
(windmove-default-keybindings 'ctrl)
; (require 'sr-speedbar)
; (global-set-key (kbd "M-s M-s") 'sr-speedbar-toggle)
; (setq sr-speedbar-right-side nil)


(unless (package-installed-p 'inf-ruby)
  (package-install 'inf-ruby))

(autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
(add-hook 'ruby-mode-hook  'inf-ruby-minor-mode)


(add-hook 'js2-mode-hook 'ac-js2-mode)

(add-hook 'js-mode-hook (lambda () (tern-mode t)))
(eval-after-load 'tern
   '(progn
      (require 'tern-auto-complete)
      (tern-ac-setup)))


(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))


(require 'yasnippet)
(yas-global-mode 1)


(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'html-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)

(global-set-key (kbd "M-d") 'evil-escape)

(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

(setq indent-tabs-mode t) ; отступ делается табами
   ; устанавливаем ширину таба в 2 символа
(setq tab-width 2)
(setq c-basic-offset 2)

;;mode-compile
    (autoload 'mode-compile "mode-compile"
      "Command to compile current buffer file based on the major mode" t)
    (global-set-key "\C-cc" 'mode-compile)
    (autoload 'mode-compile-kill "mode-compile"
      "Command to kill a compilation launched by `mode-compile'" t)
    (global-set-key "\C-ck" 'mode-compile-kill)

 ; Map Modifier-CyrillicLetter to the underlying Modifier-LatinLetter, so that
 ; control sequences can be used when keyboard mapping is changed outside of
 ; Emacs.
 ;
 ; For this to work correctly, .emacs must be encoded in the default coding
 ; system.
 ;
 (mapcar*
  (lambda (r e) ; R and E are matching Russian and English keysyms
    ; iterate over modifiers
    (mapc (lambda (mod)
     (define-key input-decode-map
       (vector (list mod r)) (vector (list mod e))))
   '(control meta super hyper))
    ; finally, if Russian key maps nowhere, remap it to the English key without
    ; any modifiers
    (define-key local-function-key-map (vector r) (vector e)))
    "йцукенгшщзхъфывапролджэячсмитьбюЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ"
    "qwertyuiop[]asdfghjkl;'zxcvbnm,.QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,.")




;;run the current perl program
(defun run-perl ()
  (interactive "*")
  (setq perl-buffer-name buffer-file-name)
  (shell)
  (setq perl-run-command "perl ")
  (insert perl-run-command)
  (insert perl-buffer-name)
)

(global-set-key [f9] 'run-perl)

(defalias 'perl-mode 'cperl-mode)
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))



(add-hook 'ruby-mode-hook 'robe-mode)
(require 'robe)

(setq file-name-coding-system 'utf-8)

(global-set-key [f2] 'kmacro-call-macro)
(global-set-key [f3] 'kmacro-start-macro-or-insert-counter)
(global-set-key [f4] 'kmacro-end-or-call-macro)

(global-set-key [C-f11] 'compile)
(global-set-key [f5] 'bookmark-set)
(global-set-key [f6] 'bookmark-jump)
(global-set-key [f7] 'bookmark-bmenu-list)


(setq show-paren-style 'expression)
(show-paren-mode 2)

;; Linum plugin
(require 'linum) ;; вызвать Linum
(line-number-mode   t) ;; показать номер строки в mode-line
(global-linum-mode  t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк

(tooltip-mode  -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(blink-cursor-mode -1) ;; курсор не мигает
(setq use-dialog-box     nil) ;; никаких графических диалогов и окон - все через минибуфер
(setq redisplay-dont-pause t)  ;; лучшая отрисовка буфера
(setq ring-bell-function 'ignore) ;; отключить звуковой сигнал

(setq make-backup-files         nil) ; Don't want any backup files
(setq auto-save-list-file-name  nil) ; Don't want any .saves files
(setq auto-save-default         nil) ; Don't want any auto saving


;; Line wrapping
(setq word-wrap          t) ;; переносить по словам
(global-visual-line-mode t)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; Start window size
; (when (window-system)
    ; (set-frame-size (selected-frame) 100 50))

(setq default-frame-alist (append (list
'(width . 80) ; Width set to 81 characters
'(height . 50)) ; Height set to 60 lines
default-frame-alist))

(setq frame-title-format "emacs - %f")

;; Display file size/time in mode-line
(setq display-time-24hr-format t) ;; 24-часовой временной формат в mode-line
(display-time-mode             t) ;; показывать часы в mode-line
(size-indication-mode          t) ;; размер файла в %-ах

;; IDO plugin
(require 'ido) ; Автоматический поиск и открытие файлов
(ido-mode                      t)
(icomplete-mode                t)
(ido-everywhere                t)
(setq ido-vitrual-buffers      t)
(setq ido-enable-flex-matching t)

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer) ;; отдельный список буферов при нажатии C-x C-b
(global-set-key (kbd "<f1>") 'bs-show) ;; запуск buffer selection кнопкой F2

;; Syntax highlighting
(require 'font-lock)
(global-font-lock-mode             t) ;; включено с версии Emacs-22. На всякий...
(setq font-lock-maximum-decoration t)

;; Indent settings
(setq-default indent-tabs-mode nil) ;; отключить возможность ставить отступы TAB'ом
(setq-default tab-width          2) ;; ширина табуляции - 4 пробельных символа
(setq-default c-basic-offset     2)
(setq-default standart-indent    2) ;; стандартная ширина отступа - 4 пробельных символа
(setq-default lisp-body-indent   2) ;; сдвигать Lisp-выражения на 4 пробельных символа
(global-set-key (kbd "RET") 'newline-and-indent) ;; при нажатии Enter перевести каретку и сделать отступ
(setq lisp-indent-function  'common-lisp-indent-function)


;; Clipboard settings
(setq x-select-enable-clipboard t)


;; Highlight search resaults
(setq search-highlight        t)
(setq query-replace-highlight t)

;; End of file newlines
(setq require-final-newline    t) ;; добавить новую пустую строку в конец файла при сохранении
(setq next-line-add-newlines nil) ;; не добавлять новую строку в конец при смещении
                        ;; курсора  стрелками

;; CEDET settings
(require 'cedet) ;; использую "вшитую" версию CEDET. Мне хватает...
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
(semantic-mode   t)
(global-ede-mode t)
(require 'ede/generic)
(require 'semantic/ia)
(ede-enable-generic-projects)






;; built-in
(require 'bs)
(setq bs-configurations
      '(("files" "^\\*scratch\\*" nil nil bs-visits-non-file bs-sort-buffer-interns-are-last)))

(global-set-key (kbd "<f2>") 'bs-show)

; Изменение размеров окна

(defun win-resize-top-or-bot ()
"Figure out if the current window is on top, bottom or in the
middle"
(let* ((win-edges (window-edges))
(this-window-y-min (nth 1 win-edges))
(this-window-y-max (nth 3 win-edges))
(fr-height (frame-height)))
(cond
((eq 0 this-window-y-min) "top")
((eq (- fr-height 1) this-window-y-max) "bot")
(t "mid"))))

(defun win-resize-left-or-right ()
"Figure out if the current window is to the left, right or in the
middle"
(let* ((win-edges (window-edges))
(this-window-x-min (nth 0 win-edges))
(this-window-x-max (nth 2 win-edges))
(fr-width (frame-width)))
(cond
((eq 0 this-window-x-min) "left")
((eq (+ fr-width 4) this-window-x-max) "right")
(t "mid"))))

(defun win-resize-enlarge-horiz ()
(interactive)
(cond
((equal "top" (win-resize-top-or-bot)) (enlarge-window -1))
((equal "bot" (win-resize-top-or-bot)) (enlarge-window 1))
((equal "mid" (win-resize-top-or-bot)) (enlarge-window -1))
(t (message "nil"))))

(defun win-resize-minimize-horiz ()
(interactive)
(cond
((equal "top" (win-resize-top-or-bot)) (enlarge-window 1))
((equal "bot" (win-resize-top-or-bot)) (enlarge-window -1))
((equal "mid" (win-resize-top-or-bot)) (enlarge-window 1))
(t (message "nil"))))

(defun win-resize-enlarge-vert ()
(interactive)
(cond
((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally -1))))

(defun win-resize-minimize-vert ()
(interactive)
(cond
((equal "left" (win-resize-left-or-right)) (enlarge-window-horizontally 1))
((equal "right" (win-resize-left-or-right)) (enlarge-window-horizontally -1))
((equal "mid" (win-resize-left-or-right)) (enlarge-window-horizontally 1))))

(global-set-key [M-down] 'win-resize-mi2nimize-vert)
(global-set-key [M-up] 'win-resize-enlarge-vert)
(global-set-key [M-left] 'win-resize-minimize-horiz)
(global-set-key [M-right] 'win-resize-enlarge-horiz)
(global-set-key [M-up] 'win-resize-enlarge-horiz)
(global-set-key [M-down] 'win-resize-minimize-horiz)
(global-set-key [M-left] 'win-resize-enlarge-vert)
(global-set-key [M-right] 'win-resize-minimize-vert)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (molokai)))
 '(custom-safe-themes
   (quote
    ("b571f92c9bfaf4a28cb64ae4b4cdbda95241cd62cf07d942be44dc8f46c491f4" "f0c7847d60ea08c2b0eaa098c37349e44b515260ca40fe1e8a9937f0d352e703" default)))
 '(minimap-sync-overlay-properties (quote (face invisible)))
 '(minimap-tag-only t)
 '(minimap-window-location (quote right))
 '(package-selected-packages
   (quote
    (yasnippet w3m tern-auto-complete sr-speedbar speed-type ruby-hash-syntax robe rainbow-mode psvn project-explorer powerline pkg-info moz monokai-theme molokai-theme json-mode highlight-chars fold-dwim eww-lnum evil-tabs evil-easymotion escreen emmet-mode eide ecb direx dash coffee-mode cmake-ide buffer-flip ac-js2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:background "#293739" :foreground "#f8f8f0" :box nil :height 1.0)))))
(put 'dired-find-alternate-file 'disabled nil)
