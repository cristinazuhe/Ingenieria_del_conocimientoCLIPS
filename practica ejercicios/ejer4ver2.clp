(deftemplate Persona  (slot nombre)  (slot edad))
(deftemplate Hijo (slot nombre) (slot padre))
(deftemplate NumeroHechos  (slot hecho)  (slot n_veces))

(deffacts VariosHechos
	(Persona (nombre Cris)(edad 22))
  (Persona (nombre Eva)(edad 25))
  (ContarHechos Persona)
  (Hijo (nombre Paco)(padre Luis))
  (ContarHechos Hijo)
)

(defrule Cuenta
   (ContarHechos  ?AContar)
   =>
   (assert (NumeroHechos (hecho ?AContar)(n_veces (length (find-all-facts ((?f ?AContar)) TRUE)))))
)
