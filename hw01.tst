(deftemplate conditions (slot type))	;故障類型

(deftemplate flag(slot id))	;flag避免重複觸發同一個rule

(defrule brake-malfunction
	(not(flag(id 0))) ;若沒有flag則執行
	( or 
		(conditions(type "noise-when-braking"))
		(conditions(type "noise-from-tires"))
	)
	=>
	(printout t "check brake fluid and pedal" crlf)
	(assert(flag(id 0))) ;添加flag
)

(defrule raditor-malfunction
	(not(flag(id 1)))
	( or 
		(conditions(type "temperature-gauge-high"))
		(conditions(type "radiator-leaking"))
	)
	=>
	(printout t "repair the car radiator or add water" crlf)
	(assert(flag(id 1))) 
)

(defrule engine-belt-is-loose
	(not(flag(id 2)))
	(conditions(type "noise-from-engine-compartment"))
	=>
	(printout t "replace the engine belt" crlf)
	(assert(flag(id 2))) 
)

(defrule car-battery-is-dead
	(not(flag(id 3)))
	(conditions(type "engine-fails-to-start"))
	=>
	(printout t "replace or rechange the car battery" crlf)
	(assert(flag(id 3))) 
)

(assert (conditions (type "radiator-leaking")))
(assert (conditions (type "temperature-gauge-high")))
(assert (conditions (type "engine-fails-to-start")))

(run)