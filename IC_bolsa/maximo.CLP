(deftemplate maximo
  (slot Nombre)
  (slot val)
)
(deftemplate auxiliar
  (slot Nombre)
  (slot val)
)
(defglobal ?*contador_max* = 0)

(defrule init "Inicializa el calculo del maximo"
  =>
  (assert (maximo (Nombre A) (val 22)))
  (assert (maximo (Nombre B) (val 13)))
  (assert (maximo (Nombre C) (val 45)))
  (assert (maximo (Nombre D) (val 15)))
  (assert (maximo (Nombre E) (val 3)))
  (assert (maximo (Nombre F) (val 44)))
  (assert (auxiliar (Nombre A) (val 22)))
  (assert (auxiliar (Nombre B) (val 13)))
  (assert (auxiliar (Nombre C) (val 45)))
  (assert (auxiliar (Nombre D) (val 15)))
  (assert (auxiliar (Nombre E) (val 3)))
  (assert (auxiliar (Nombre F) (val 44)))
  (assert (SigueLeyendo))
)

(defrule calculamax
  ?f <- (SigueLeyendo)
  (auxiliar (val ?x))
  (forall (auxiliar (val ?y)) (test (>= ?x ?y)))
  ?a <- (auxiliar (Nombre ?nombre) (val ?x))
  =>
  (if (< ?*contador_max* 5) then
     (retract ?f)
     (retract ?a)
     (printout t ?x crlf)
     (bind ?*contador_max* (+ ?*contador_max* 1))
     (assert (SigueLeyendo))
     (assert (Mejores ?nombre))
  )
)
