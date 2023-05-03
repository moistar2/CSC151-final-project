(import music)
(import js)
(import canvas)

; these are vectors used for testing
(define piano-vec (make-vector 88 0))

(define piano2-vec (make-vector 88 0))

;;; (vec-lookup-table x) -> vec?
;;; x : integer?
;;; returns the associated instument vec that the given index is associated with
(define vec-lookup-table
    (lambda (x)
        (match x
            [13 piano-vec]
            [2 piano2-vec])))

;;; (vec-set-on inst-vec vec-index) -> void?
;;; inst-vec : integer?
;;; vec-index ; integer?
;;; sets the inst-vec's associated vec-index to "on" (1) 
(define vec-set-on
    (lambda (inst-vec vec-index)
        (vector-set! (vec-lookup-table inst-vec) 
                        (match inst-vec
                            [13 (- vec-index 21)]
                            [2 (- vec-index 21)])
                        1)))

;;; (vec-set-off inst-vec vec-index) -> void?
;;; inst-vec : integer?
;;; vec-index ; integer?
;;; sets the inst-vec's associated vec-index to "off" (0) 
(define vec-set-off
    (lambda (inst-vec vec-index)
        (vector-set! (vec-lookup-table inst-vec) 
                        (match inst-vec
                            [13 (- vec-index 21)]
                            [2 (- vec-index 21)])
                            0)))

;;; (instrument-note midi-val dur-val inst-vec) -> comp?
;;; midi-val : integer? valid midi number
;;; dur-val : dur?
;;; inst-vec : integer?
;;; returns the note played on the specificied instrument with the specific note value and duration
(define instrument-note
    (lambda (midi-val dur-val inst-vec)
        (if (= midi-val 0)
            (rest dur-val)
            (mod (instrument inst-vec) (note midi-val dur-val)))))

; this is piano specific as of right now. In the future I would like a function to be able to look up a vecotr from a "table" of them where they are keyed convieniently
;;; (music-machine-helper info-list) -> composition?
;;; info-list : list? of the form (list (midi note value) (duration value) (valid indicator of a instrument))
;;; creates a sequence of trigger-on -> note -> trigger off compositions of the note with the valid instrument triggers
(define music-machine-note
    (lambda (info-list)
        (let* ([midi-val (list-ref info-list 0)]
               [dur-val (list-ref info-list 1)]
               [instrument-vec (list-ref info-list 2)]
               [set-on (lambda () (vec-set-on instrument-vec midi-val))]
               [set-off (lambda () (vec-set-off instrument-vec midi-val))])
             (seq (trigger set-on)
                  (instrument-note midi-val dur-val instrument-vec)
                  (trigger set-off)))))

;;; (music-machine-voice note-list) -> composition?
;;; note-list : list? entries are all valid info-lists from (music-machine-helper)
;;; creates a whole voice from the given note list, with all notes plays in sequential order 
; think back to the horizontal beat machine voices
(define music-machine-voice
    (lambda (note-list)
        (apply seq (map music-machine-note note-list))))

; this might be turned into a recursive function that can be handed a list of note lists for specific voices which then calls the two previous functions
;;; (music-machine-comp voice-list) -> composition?
;;; voice-list : list? list of compositions
;;; plays all the given voice compositions in parallel
(define music-machine-comp
    (lambda (voice-list)
        (apply par (map music-machine-voice voice-list))))


(map music-machine-note (list (list 21 qn 1) (list 22 qn 1) (list 23 qn 1) (list 24 qn 1) (list 25 qn 1) (list 26 qn 1) (list 27 qn 1) (list 28 qn 1)))
(music-machine-comp (list (list (list 81 qn 13) (list 82 qn 13) (list 83 qn 13) (list 84 qn 13) (list 85 qn 13) (list 86 qn 13) (list 87 qn 13) (list 88 qn 13))))

piano-vec

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