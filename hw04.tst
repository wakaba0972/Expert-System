; 可能有bug

(deftemplate conversion 
   (slot character) 
   (multislot morse-code)
)

(deftemplate translation 
   (multislot string) 
   (multislot code)
)

(defrule get-message
   (declare (salience 1000))
   (not (translation (string $?) (code $?)))
   =>
   (printout t "Enter a message (<Enter> to end): ")
   (bind ?input (explode$ (readline)))
   (assert (translation (string) (code ?input /)))
)

(defrule end
   (translation (string) (code /))
   =>
   (halt)
)


(deffacts conversions
   (conversion (character A) (morse-code * -))
   (conversion (character B) (morse-code - * * *))
   (conversion (character C) (morse-code - * - *))
   (conversion (character D) (morse-code - * *))
   (conversion (character E) (morse-code *))
   (conversion (character F) (morse-code * * - *))
   (conversion (character G) (morse-code - - *))
   (conversion (character H) (morse-code * * * *))
   (conversion (character I) (morse-code * *))
   (conversion (character J) (morse-code * - - -))
   (conversion (character K) (morse-code - * -))
   (conversion (character L) (morse-code * - * *))
   (conversion (character M) (morse-code - -))
   (conversion (character N) (morse-code - *))
   (conversion (character O) (morse-code - - -))
   (conversion (character P) (morse-code * - - *))
   (conversion (character Q) (morse-code - - * -))
   (conversion (character R) (morse-code * - *))
   (conversion (character S) (morse-code * * *))
   (conversion (character T) (morse-code -))
   (conversion (character U) (morse-code * * -))
   (conversion (character V) (morse-code * * * -))
   (conversion (character W) (morse-code * - -))
   (conversion (character X) (morse-code - * * -))
   (conversion (character Y) (morse-code - * - -))
   (conversion (character Z) (morse-code - - * *))
)



(defrule invalid_1
   ?f1 <- (translation (string) (code / $?)) ;string空 且 code第一個是/
   =>
   (retract ?f1)
   (printout t "Can't decode this message" crlf)
)

(defrule invalid_2
   (declare (salience 100)) ;優先檢查
   ?f1 <- (translation (string $?) (code $? / / $?)) ; code存在連續兩個//
   =>
   (retract ?f1)
   (printout t "Can't decode this message" crlf)
)

(defrule invalid_3
   (declare (salience -10)) ;連end都不能執行 代表無法轉換
   ?f1 <- (translation (string $?) (code $?)) ;無法轉換
   =>
   (retract ?f1)
   (printout t "Can't decode this message" crlf)
)

(defrule decode
   (declare (salience 10))
   (conversion (character ?char) (morse-code $?mcode))
   ?f1 <- (translation (string $?str) (code $?mcode / $?left))
   =>
   (retract ?f1)
   (assert (translation (string $?str ?char) (code $?left)))
)

(defrule print
   ?f1 <- (translation (string $?str) (code))
   =>
   (retract ?f1)
   (printout t "The message is" $?str crlf)
)
