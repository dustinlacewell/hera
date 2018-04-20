;; (use-package ht)
(require 'ht)

;; (use-package dash)
(require 'dash)

;; the hydra body to run if no major mode specific hydra is set
(defvar hera-default-hydra nil)

;; this is an alist of major mode -> hydra body
(defvar hera--hydras (ht))

;; this is a FIFO list of hydra bodies
(defvar hera--stack nil)

;; return the hydra body for the current major-mode, or hera-entrypoint
(defun hera--first-body ()
  (let ((current-hydra (assoc major-mode hera-hydras)))
    (if current-hydra (second current-hydra)
      hera-default-hydra)))

(defun hera-register (major-mode hydra-body)
  (ht-set! hera--hydras major-mode hydra-body))

(defun hera-push (hydra-body)
  (setq hera--stack (-cons* hydra-body hera--stack))
  (call-interactively hydra-body))

(defun hera-pop ()
  (if (length hera--stack)
      (cl-destructuring-bind (hydra-body rest) (-split-at 1 hera--stack)
        (setq hera--stack rest)
        (when hydra-body
          (call-interactively (car hydra-body))))
    (hydra--body-exit)))

;; execute the hydra body for the current mode, or the default one
(defun hera-run ()
  (interactive)
  (let ((context (hera--first-body)))
    (when context (funcall context))))

;; bind hera-run
(global-set-key (kbd "<f19>") 'hera-run)
(global-set-key (kbd "C-<f19>") 'hera-pop)
