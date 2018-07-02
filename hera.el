;;; hera.el --- Hera for Gydra
;; Copyright (C) 2018 Dustin Lacewell

;; Author: Dustin Lacewell <dlacewell@gmail.com>
;; Version: 0.1
;; Package-Requires: (hydra ht dash)
;; Keywords: hydra
;; URL: http://github.com/dustinlacewell/hera

;;; Commentary:

;; This package is awesome!

;;; Code:
(require 'hydra)
(require 'ht)
(require 'dash)

;; the hydra body to run if no major mode specific hydra is set
(defvar hera-default-hydra nil)

;; this is an alist of major mode -> hydra body
(defvar hera--hydras (ht))

;; this is a FIFO list of hydra bodies
(defvar hera--stack nil)

;; return the hydra body for the current major-mode, or hera-entrypoint
(defun hera--first-body ()
  (let ((current-hydra (ht-get hera--hydras major-mode)))
    (if current-hydra (call-interactively current-hydra)
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

(provide 'hera)
;;; hera.el ends here
