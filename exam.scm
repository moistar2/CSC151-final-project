
(import image)

(define white-key (rectangle 20 100 "outline" "black"))
(define black-key (rectangle 10 40 "solid" "black"))
(define empty-key (rectangle 10 25 "solid" "white"))
(define state (vector "red" "black-key"))

(define white-keyboard
 (lambda (n)
  (match n
    [0 (square 0 "solid" "white")]
    [else (beside white-key (white-keyboard (- n 1)) )])))
(white-keyboard 10)

(define black-keyboard 
  (lambda (i)
    (match i
    [0 (square 0 "solid" "white")]
    [else (beside (if (or (= (modulo i 7) 3) (= (modulo i 7) 0))
                      empty-key
                      black-key)
    
     empty-key (black-keyboard (- i 1)))])))
        
   (overlay/align "middle" "top"
    (black-keyboard 9)(white-keyboard 10))


