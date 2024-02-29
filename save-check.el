;;; save-check.el - Perform syntax checks AFTER saving files



;; The configuration we support
(setq save-check-config
      '(

        (:mode json-mode
         :exec "sysbox validate-json %s"
         :cond (executable-find "sysbox"))

        (:mode nxml-mode
         :exec "sysbox validate-xml %s"
         :cond (executable-find "sysbox"))

        ;; This avoids creating .pyc files, which would happen if we had
        ;; used the more natural/obvious "python3 -m py_compile %s" approach
        (:mode python-mode
         :exec "python3 -c 'import ast; ast.parse(open(\"%s\").read())'"
         :cond (executable-find "python3"))

        (:mode sh-mode
         :exec "shellcheck %s"
         :cond (executable-find "shellcheck"))

        (:mode terraform-mode
         :exec "tflint --no-color --chdir %s"
         :cond (executable-find "tflint")
         :path t)

        (:mode yaml-mode
         :exec "sysbox validate-yaml %s"
         :cond (executable-find "sysbox"))
       ))


(defun save-check-run()
  "Run the save-check if the current buffer has a configured command.

The commands are contained within the list `save-check-config', and those
commands will have '%s' replaced with the path to the saved file."
  (interactive)
  (mapc #'(lambda (entry)
            (let ((exec (plist-get entry :exec))
                  (cnd (plist-get entry :cond))
                  (mode (plist-get entry :mode))
                  (path (plist-get entry :path))
                  (run nil))

              ;; If there is a condition set
              (if cnd
                  (if (eval cnd)
                      (setq run t))   ; we run only if that passed
                (setq run t) ;; otherwise, no condition set, we run
                )

              (if (and run (or (derived-mode-p mode) (eq major-mode  mode)))
                  (save-check-run-command exec path))))
        save-check-config)
  )


(defun save-check-run-command(cmd directory)
  "Execute the specified command, with the name of the buffers file as an argument.

The directory argument, if true, will cause the command to be given the path to the directory containing the buffers' file.

If the command exists with a zero-return code then nothing happens, otherwise the output will be shown."
  (interactive)

  ;; get, and kill, any existing buffer.
  (with-current-buffer (get-buffer-create "*save-check*")
    (kill-buffer))

  ;; setup variables
  (let ((buffer (get-buffer-create "*save-check*"))
        (exec   "")
        (ret nil))

    ;; If the directory arg is true use the directory-name
    ;; otherwise we'll execute with the filename.
    (if directory
        (setq exec (format cmd (file-name-directory buffer-file-name)))
      (setq exec (format cmd buffer-file-name)))

    ;; call the process
    (setq ret (call-process-shell-command exec nil buffer nil))

    ;; if the return code was OK, kill the results.
    ;; otherwise pop to the buffer, and set it to be "special mode"
    ;; which has suitable keybindings.
    (if (= 0 ret)
        (kill-buffer buffer)
      (progn
        (pop-to-buffer buffer)
        (special-mode)
        ))))


;; Add the hook
(add-hook 'after-save-hook 'save-check-run)

;;
;; End
(provide 'save-check)
