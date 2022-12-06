
; Split to list, remove duplicates, recombine
(defun unique-string (str)
  (concatenate 'string (remove-duplicates (coerce str 'list))))

; Returns the index of the first occurrence of a sequence of "len" different characters in "str"
(defun unique-sequence (str len &optional (offset 0))
  (if (= len
         (length (unique-string (subseq str offset (+ len offset)))))
      offset
      (unique-sequence str len (+ offset 1))))

; unique-sequence gives the index-of, but we want the index-after
(defun part1 (str)
  (+ 4 (unique-sequence str 4)))

(defun part2 (str)
  (+ 14 (unique-sequence str 14)))

(let ((in (open "input.txt" :if-does-not-exist nil)))
  (when in
    (let ((str (read-line in nil nil)))
      (format t "Part 1: ~a~%" (part1 str))
      (format t "Part 2: ~a~%" (part2 str)))
    (close in)))

