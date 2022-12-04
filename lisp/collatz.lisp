#! /usr/bin/sbcl --script 
; Ervin Pangilinan
; CSC 330: Organization of Programming Languages - Fall 2022
; Project 3: The Collatz Conjecture
; Iterative Implementation in Lisp

; Iterative Solution
(defun extendSequence (num)
    "PRE: Collatz number is passed in.
     POST: Changes the argument based on parity and iteratively calculates Collatz length."

    (let ((n num) (len 0))
        (loop
            (if (= (mod n 2) 0)
                (progn
                    (setf n (/ n 2))
                    (incf len)
                )
                (progn
                    (setf n (+ (* 3 n) 1))
                    (incf len)
                ))
            (when (= n 1) (return len))
        )
    )
)

(defun searchDuplicates (arr seqLen)
    "PRE: Array of sequence lengths and a Collatz sequence length is passed in.
     POST: Returns index of integer in array that is the same as the passed sequence length."

    (let ((index -1) (size (array-total-size arr)) (n 0))
        (loop 
            (if (= seqLen (aref arr n))
                (setf index n)
            (incf n))
            (when (or (= n 10) (/= index -1)) (return index))
        )
    )  
)

(defun bubbleSort (keys vals)
    "PRE: Parallel arrays passed in are completely filled. 
     POST: Sort key array by values in descending order."

    (let ((needsSwap 1) (size (array-total-size vals))) 
        (loop 
            (setf needsSwap 0)
            (dotimes (i (- size 1))
                (if (< (aref vals i) (aref vals (+ i 1)))
                    (progn 
                        (rotatef (aref vals i) (aref vals (+ i 1)))
                        (rotatef (aref keys i) (aref keys (+ i 1)))
                        (setf needsSwap 1)
                    )
                )
            )
            (when (= needsSwap 0) (return vals))
        )
    )
)

; Main Program
; PRE: Command line arguments are passed to determine bounds.
; POST: Outputs Collatz numbers by sequence length and integer size. 
(prog
    (
        (lower (parse-integer (nth 1 sb-ext:*posix-argv*)))
        (upper (parse-integer (nth 2 sb-ext:*posix-argv*)))
        (numbers 0)
        (lengths 0) 
        (counter 0)                     ; Keeps track of index in parallel arrays. 
        (current 0)                     ; Keeps track of current Collatz number. 
        (seqLen 0)                      ; Holds Collatz length of an integer.
        (temp 0)                        ; Keeps track of index that holds duplicate Collatz length. 
        (n 0)
        (i 0)
    )

    (if (> lower upper)
        ; Swap values, if needed.
        (rotatef lower upper)
    )

    (setf numbers (make-array '(10)))
    (setf lengths (make-array '(10)))

    ; Set everything in parallel arrays to 0.
    (setf i 0)
    (dotimes (i 10) 
        (setf (aref numbers i) 0)
        (setf (aref lengths i) 0)
    )

    (setf current lower)
    (setf counter 0)
    (loop 
        (setf n current)
        (setf seqLen (extendSequence n))                    ; Iterative approach
        (setf temp (searchDuplicates lengths seqLen))       ; Keeps track of index that holds duplicate Collatz length. 

        (if (< counter 10)
            (progn 
            ; Handle the first 10 elements to be added to the parallel arrays.
                (if (= temp -1)
                    (prog1 
                        (setf (aref numbers counter) current)
                        (setf (aref lengths counter) seqLen)
                        (incf counter)
                    )
                    (prog1
                    ; Handle duplicates.
                        (if (< current (aref numbers temp))
                            (setf (aref numbers temp) (- current 1))
                        )
                    ) 
                )
            )
        (progn 
            ; Every case afterwards.  
            (if (/= temp -1)
                ; Handle duplicates. 
                (prog1 
                    (if (< current (aref numbers temp))
                        (setf (aref numbers temp) current)
                    )
                )
            (prog1  
                ; Push out the pair the smallest Collatz length. 
                (if (> seqLen (aref lengths 9))
                    (prog2 
                        (setf (aref lengths 9) seqLen)
                        (setf (aref numbers 9) current)
                        (incf counter)
                    )
                )
            ))
        ))

        (incf current)
        (bubbleSort numbers lengths)
        (when (> current upper) (return current))
    )

    ; Sort based on sequence length.
    (bubbleSort numbers lengths)
    (princ "Sorted based on sequence length")
    (terpri)
    (setf i 0)
    (dotimes (i 10)
        (if (and (/= (aref numbers i) 0) (/= (aref lengths i) 0))
            (progn 
                (write-char #\Tab)
                (princ (aref numbers i))
                (write-char #\Tab)
                (princ (aref lengths i))
                (terpri)
            )
        )
    )
    (terpri)

    ; Sort based on integer size.
    (bubbleSort lengths numbers)
    (princ "Sorted based on sequence length")
    (terpri)
    (setf i 0)
    (dotimes (i 10)
        (if (and (/= (aref numbers i) 0) (/= (aref lengths i) 0))
            (progn 
                (write-char #\Tab)
                (princ (aref numbers i))
                (write-char #\Tab)
                (princ (aref lengths i))
                (terpri)
            )
        )
    )
    (terpri)

)
