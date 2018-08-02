;;; hera.el --- Hera for Hydra
;; Copyright (C) 2018 Dustin Lacewell

;; Author: Dustin Lacewell <dlacewell@gmail.com>
;; Version: 0.1
;; Package-Requires: ((emacs "24") (hydra "0"))
;; Keywords: hydra
;; URL: http://github.com/dustinlacewell/hera

;;; Commentary:

;; This package provides a simple stack feature for Hydra.

;;; Code:
(require 'hydra)

;; this is a FIFO list of hydra bodies
(setq hera--stack nil)

(defun hera-push (hydra-body)
  (when hydra-curr-body-fn
    (push hydra-curr-body-fn hera--stack))
  (call-interactively hydra-body))

(defun hera-pop ()
  (let ((x (pop hera--stack)))
    (when x
      (call-interactively x))))

(provide 'hera)
;;; hera.el ends here
