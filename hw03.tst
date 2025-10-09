(deftemplate permutation
   (multislot values)
   (multislot rest)
)

(deffacts initial
   (total 0)
)

(defrule read-base-fact
   (declare (salience 100))
   =>
   (printout t "Please input a base fact for the permutation..." crlf)
   (bind ?input (explode$ (readline)))
   (assert (permutation (values) (rest ?input)))
)

(defrule generate-permutation
   (permutation (values $?perm) (rest $?pre ?select $?suf))
   =>
   (assert (permutation (values $?perm ?select) (rest $?pre $?suf)))
)

(defrule print-permutation
   ?f1 <- (permutation (values $?perm) (rest)) ;(rest) 代表此欄位必須為空
   ?f2 <- (total ?old-total)
   =>
   (retract ?f1 ?f2)
   (assert (total (+ ?old-total 1)))
   (printout t $?perm crlf)
)

(defrule print-total
   (declare (salience -100)) ;最後執行
   (total ?totals)
   =>
   (printout t ?totals crlf)
)
