(deftemplate person
    (slot name)
    (slot sex)
)

(deftemplate parent-children
    (multislot parent)
    (multislot children)
)

(deftemplate pair
    (slot husband)
    (slot wife)
)

(deftemplate query
    (slot name)
    (slot subject)
)

(deftemplate flag(slot id))

(deffacts initial
    (person (name John) (sex male))
    (person (name Peter) (sex male))
    (person (name David) (sex male))
    (person (name Joe) (sex male))
    (person (name Kevin) (sex male))
    (person (name Mary) (sex female))
    (person (name Sue) (sex female))
    (person (name Linda) (sex female))
    (person (name Sherry) (sex female))
    (pair (husband John) (wife Sue))
    (pair (husband David) (wife Linda))
    (pair (husband Peter) (wife Sherry))
    (parent-children (parent John Sue) (children Mary Kevin))
    (parent-children (parent Peter Sherry) (children John Linda))
    (parent-children (parent David Linda) (children Joe))
    (query (name Mary) (subject Kevin))
    (query (name Sue) (subject Kevin))
    (query (name Peter) (subject Kevin))
    (query (name David) (subject Kevin))
    (query (name Linda) (subject Kevin))
    (query (name Joe) (subject Kevin))
)

(defrule define-brother
    (query (name ?p1) (subject ?p2))
    (or (parent-children (parent $?)
                         (children $? ?p1 $? ?p2 $?))
        (parent-children (parent $?)
                         (children $? ?p2 $? ?p1 $?)))
    (person (name ?p1) (sex male))
    =>
    (printout t ?p1 " is " ?p2 "'s brother." crlf)
)

(defrule define-sister
    (query (name ?p1) (subject ?p2))
    (or (parent-children (parent $?)
                         (children $? ?p1 $? ?p2 $?))
        (parent-children (parent $?)
                         (children $? ?p2 $? ?p1 $?)))
    (person (name ?p1) (sex female))
    =>
    (printout t ?p1 " is " ?p2 "'s sister." crlf)
)

(defrule define-father
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p1 $?) (children $? ?p2 $?))
    (person (name ?p1) (sex male))
    =>
    (printout t ?p1 " is " ?p2 "'s father." crlf)
)

(defrule define-mother
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p1 $?) (children $? ?p2 $?))
    (person (name ?p1) (sex female))
    =>
    (printout t ?p1 " is " ?p2 "'s mother." crlf)
)

(defrule define-grandfather
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p1 $?) (children $? ?p3 $?))
    (parent-children (parent $? ?p3 $?) (children $? ?p2 $?))
    (person (name ?p1) (sex male))
    =>
    (printout t ?p1 " is " ?p2 "'s grandfather." crlf)
)

(defrule define-grandmother
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p1 $?) (children $? ?p3 $?))
    (parent-children (parent $? ?p3 $?) (children $? ?p2 $?))
    (person (name ?p1) (sex female))
    =>
    (printout t ?p1 " is " ?p2 "'s grandfather." crlf)
)

(defrule define-uncle
    (not(flag(id 0))) ;若沒有flag則執行
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p3 $?) (children $? ?p2 $?))
    (or (parent-children (parent $? ?p4 $?) (children $? ?p5 $? ?p3 $?))
    	(parent-children (parent $? ?p4 $?) (children $? ?p3 $? ?p5 $?)))
    (pair (husband ?p1) (wife ?p5))
    (person (name ?p1) (sex male))
    =>
    (printout t ?p1 " is " ?p2 "'s uncle." crlf)
    (assert(flag(id 0 ))) ;添加flag
)

(defrule define-aunt
    (not(flag(id 1))) ;若沒有flag則執行
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p3 $?) (children $? ?p2 $?))
    (or (parent-children (parent $? ?p4 $?) (children $? ?p1 $? ?p3 $?))
    	(parent-children (parent $? ?p4 $?) (children $? ?p3 $? ?p1 $?)))
    (person (name ?p1) (sex female))
    =>
    (printout t ?p1 " is " ?p2 "'s aunt." crlf)
    (assert(flag(id 1 ))) ;添加flag
)

(defrule define-cousin
    (not(flag(id 2))) ;若沒有flag則執行
    (query (name ?p1) (subject ?p2))
    (parent-children (parent $? ?p3 $?) (children $? ?p2 $?))
    (or (parent-children (parent $? ?p4 $?) (children $? ?p5 $? ?p3 $?))
    	(parent-children (parent $? ?p4 $?) (children $? ?p3 $? ?p5 $?)))
    (parent-children (parent $? ?p5 $?) (children ?p1))
    =>
    (printout t ?p1 " is " ?p2 "'s cousin." crlf)
    (assert(flag(id 2 ))) ;添加flag
)

