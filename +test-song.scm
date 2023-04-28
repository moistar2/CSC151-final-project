(import music)

(define beat-machine (lambda (n cymbal-list snare-list base-list)
                             (repeat n (mod percussion (par (apply seq cymbal-list)
                                                            (apply seq snare-list)
                                                            (apply seq base-list))))))
(define piano-machine
    (lambda (n notelist)
        (repeat n (apply seq notelist))))
(define first10 (piano-machine 1 (map (lambda (n) (note (+ n 21) qn)) (range 11))))
first10


(define song1 (list (list 60 (dur 3 16) 1) (list 60 en 1) (list 62 qn 1) (list 60 qn 1) (list 65 qn 1) (list 64 hn 1)
                    (list 60 (dur 3 16) 1) (list 60 en 1) (list 62 qn 1) (list 60 qn 1) (list 67 qn 1) (list 65 hn 1)
                    (list 60 (dur 3 16) 1) (list 60 en 1) (list 72 qn 1) (list 69 qn 1) (list 65 qn 1) (list 64 qn 1) (list 62 qn 1)
                    (list 70 (dur 3 16) 1) (list 70 en 1) (list 69 qn 1) (list 65 qn 1) (list 67 qn 1) (list 65 hn 1)))

(import music)
(import js)
; these are vectors used for testing
(define piano-vec (make-vector 88 0))

(define vec-set-piano-on
    (lambda (vec-index)
        (vector-set! piano-vec vec-index 1)))

(define vec-set-piano-off
    (lambda (vec-index)
        (vector-set! piano-vec vec-index 0)))

; this is piano specific as of right now. In the future I would like a function to be able to look up a vecotr from a "table" of them where they are keyed convieniently
;;; (music-machine-helper info-list) -> composition?
;;; info-list : list? of the form (list (midi note value) (duration value) (valid indicator of a instrument))
;;; creates a sequence of trigger-on -> note -> trigger off compositions of the note with the valid instrument triggers
(define music-machine-helper
    (lambda (info-list)
        (let* ([midi-val (list-ref info-list 0)]
               [dur-val (list-ref info-list 1)]
               [instrument-vec (list-ref info-list 2)]
               [set-on (lambda () (vec-set-piano-on (- midi-val 21)))]
               [set-off (lambda () (vec-set-piano-off (- midi-val 21)))]
               )
             (seq (trigger set-on)
                  (note midi-val dur-val)
                  (trigger set-off)
                  ))))

;;; (music-machine-voice note-list) -> composition?
;;; note-list : list? entries are all valid info-lists from (music-machine-helper)
;;; creates a whole voice from the given note list, with all notes plays in sequential order 
; think back to the horizontal beat machine voices
(define music-machine-voice
    (lambda (note-list)
        (apply seq (map music-machine-helper note-list))))

; this might be turned into a recursive function that can be handed a list of note lists for specific voices which then calls the two previous functions
;;; (music-machine-comp voice-list) -> composition?
;;; voice-list : list? list of compositions
;;; plays all the given voice compositions in parallel
(define music-machine-comp
    (lambda (voice-list)
        (apply par voice-list)))


(map music-machine-helper (list (list 21 qn 1) (list 22 qn 1) (list 23 qn 1) (list 24 qn 1) (list 25 qn 1) (list 26 qn 1) (list 27 qn 1) (list 28 qn 1)))
(apply seq (map music-machine-helper (list (list 21 qn 1) (list 22 qn 1) (list 23 qn 1) (list 24 qn 1) (list 25 qn 1) (list 26 qn 1) (list 27 qn 1) (list 28 qn 1))))
(music-machine-voice song1)

;;; TESTING ANIMATION
(import canvas)
(define canv (make-canvas 880 100))

(animate-with
  (lambda (time)
    (begin
      (draw-rectangle canv 0 0 880 100 "solid" "white")
      (map
        (lambda (x)
            (if (equal? (vector-ref piano-vec x) 1)
                (draw-rectangle canv (* 10 x) 0 10 100 "solid" "purple")
                (draw-rectangle canv (* 10 x) 0 10 100 "solid" "white")))
        (range 88)))))

canv