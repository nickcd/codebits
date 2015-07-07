(require 2htdp/image)
(require 2htdp/universe)

;; NEWTON'S BALL
;; "A ball in motion stays in motion." - Totally legit quote from Isaac Newton

;; Just run the code (press F5) to start!
;; Controls:
;; - arrow keys control the direction and velocity of the ball
;; - press spacebar to reset the ball
;; Also, the ball changes colors! Woah!

;; =================
;; Constants:

(define WIDTH 640)
(define HEIGHT 480)
(define MTS (empty-scene WIDTH HEIGHT))

(define B-RADIUS 60)
(define B-MODE "solid")

;; =================
;; Data definitions:

(define-struct ball (x y dx dy))
;; Ball is (make-ball Number Number Number Number)
;; interp. a ball at position x and y with direction/velocity of x and direction/velocity of y
;; positive dx is left -> right
;; negative dx is right -> left
;; positive dy is down -> up
;; negative dy is up -> down
;; the higher the dx or dy, the faster the ball moves

(define BALL-1 (make-ball 6 10 3 -5))

#;
(define (fn-for-ball b)
  (... (ball-x  b)     ;Number ;Horiztonal coordinate
       (ball-y  b)     ;Number ;Vertical coordinate
       (ball-dx b)     ;Number ;Horizontal direction and velocity
       (ball-dy b)))   ;Number ;Vertical direction and velocity
;; Template rules used:
;;  - Compound: 4 fields

;; =================
;; Functions:

;; Ball -> Ball
;; start the world with (make-ball 0 0 0 0)
;;        or better yet (make-ball 0 0 9 10)
(define (main b)
  (big-bang b                           ; Ball
            (on-tick   adv-ball)        ; Ball -> Ball
            (to-draw   render-ball)     ; Ball -> Image
            (on-key    handle-key)))    ; Ball KeyEvent -> Ball

;; Ball -> Ball
;; produce the next Ball in movement sequence
(check-expect (adv-ball (make-ball 20 50 6 -4))           (make-ball 26 46 6 -4))
(check-expect (adv-ball (make-ball -1 50 -6 -4))          (make-ball 6 46 6 -4))
(check-expect (adv-ball (make-ball (+ WIDTH 1) 50 6 -4))  (make-ball (- WIDTH 1) 46 -6 -4))
(check-expect (adv-ball (make-ball 20 -1 6 -4))           (make-ball 26 4 6 4))
(check-expect (adv-ball (make-ball 20 (+ HEIGHT 1) 1 -4)) (make-ball 21 (- HEIGHT 1) 1 4))

;(define (adv-ball b) (make-ball 26 -46 6 -4))

(define (adv-ball b)
  (cond [(< (ball-x b) 0)      (make-ball (+ 0 (- (ball-dx b))) (+ (ball-y  b)(ball-dy b)) (- (ball-dx b)) (ball-dy b))]
        [(> (ball-x b) WIDTH)  (make-ball (- WIDTH 1) (+ (ball-y  b)(ball-dy b)) (- (ball-dx b)) (ball-dy b))]
        [(< (ball-y b) 0)      (make-ball (+ (ball-x b) (ball-dx b)) (+ 0 (- (ball-dy b))) (ball-dx b) (- (ball-dy b)))]
        [(> (ball-y b) HEIGHT) (make-ball (+ (ball-x b) (ball-dx b)) (- HEIGHT 1) (ball-dx b) (- (ball-dy b)))]
        [else                  (make-ball (+ (ball-x b) (ball-dx b)) (+ (ball-y  b)(ball-dy b)) (ball-dx b) (ball-dy b))]))

;; Ball -> Image
;; render Ball at correct location with correct color
(check-expect (render-ball (make-ball 20 50  6 -4)) (place-image (circle B-RADIUS B-MODE "Blue")   20 50 MTS))
(check-expect (render-ball (make-ball 20 50 -4  6)) (place-image (circle B-RADIUS B-MODE "Red")    20 50 MTS))
(check-expect (render-ball (make-ball 20 50  0  0)) (place-image (circle B-RADIUS B-MODE "Purple") 20 50 MTS))

;(define (render-ball b) (place-image (circle B-RADIUS B-MODE B-COLOR) 20 50 MTS))

(define (render-ball b)
  (cond [(< (ball-dx b) (ball-dy b)) (place-image (circle B-RADIUS B-MODE "Red")    (ball-x b) (ball-y b) MTS)]
        [(> (ball-dx b) (ball-dy b)) (place-image (circle B-RADIUS B-MODE "Blue")   (ball-x b) (ball-y b) MTS)]
        [else                        (place-image (circle B-RADIUS B-MODE "Purple") (ball-x b) (ball-y b) MTS)]))

;; Ball KeyEvent -> Ball
;; Increase ball velocity in correct direction when corresponding direction key is pressed; reset ball when spacebar is pressed
(check-expect (handle-key (make-ball 32  40  2  1)  "up")    (make-ball 32 40 2 0))
(check-expect (handle-key (make-ball 69  31  5  20) "down")  (make-ball 69  31  5  21))
(check-expect (handle-key (make-ball 102 21  2  1)  "right") (make-ball 102 21  3  1))
(check-expect (handle-key (make-ball 3   222 10 11) "left")  (make-ball 3   222 9 11))
(check-expect (handle-key (make-ball 3   222 10 11) " ")     (make-ball (/ WIDTH 2) (/ HEIGHT 2) 0 0))
(check-expect (handle-key (make-ball 3   222 10 11) "a")     (make-ball 3   222 10 11))

;(define (handle-key b key) (make-ball 32 40 2 0));stub

(define (handle-key b key)
  (cond [(key=? key "up")    (make-ball (ball-x b) (ball-y b) (ball-dx b) (- (ball-dy b) 1))]
        [(key=? key "down")  (make-ball (ball-x b) (ball-y b) (ball-dx b) (+ (ball-dy b) 1))]
        [(key=? key "right") (make-ball (ball-x b) (ball-y b) (+ (ball-dx b) 1) (ball-dy b))]
        [(key=? key "left")  (make-ball (ball-x b) (ball-y b) (- (ball-dx b) 1) (ball-dy b))]
        [(key=? key " ")     (make-ball (/ WIDTH 2) (/ HEIGHT 2) 0 0)]
        [else                (make-ball (ball-x b) (ball-y b) (ball-dx b) (ball-dy b))]))

(main (make-ball (/ WIDTH 2) (/ HEIGHT 2) 0 0))
