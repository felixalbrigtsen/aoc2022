(defun string-to-list (s)
  (assert (stringp s) (s) "~s :questa non e una stringa")
  (coerce s 'list))

(defun unique-string (str)
  (concatenate 'string (remove-duplicates (string-to-list str))))

(defun unique-sequence (str n)
  (if (= (length (unique-string (subseq str 0 n))) n)
      (subseq str 0 n)
      (unique-sequence (subseq str 1) n)))

(defun part1 (str)
  (+ 4 (search (unique-sequence str 4) str)))

(let ((in (open "input.txt" :if-does-not-exist nil)))
  (when in
    (print (part1 (read-line in)))
    (close in)))

