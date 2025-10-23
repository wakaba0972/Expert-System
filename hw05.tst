(deftemplate data (multislot numbers))

(defrule read-data
   (declare (salience 100))
   =>
   (printout t "Data sorting: ")
   (bind ?input (explode$ (readline)))
   (assert (data (numbers ?input)))
   (open "sort.txt" out "w")
)

(defrule bbsort
   ?f <- (data (numbers $?pre ?a ?b $?suf))
   (test (> ?a ?b))
   =>
   (retract ?f)
   (assert (data (numbers $?pre ?b ?a $?suf)))
)

(defrule done
   (declare (salience -100))
   (data (numbers $?nums))
   =>
   (printout out "The result is: " $?nums crlf)
   (close out)
)