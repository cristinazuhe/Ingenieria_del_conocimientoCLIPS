;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LAS NOTICIAS
;;;;;;;;;;;;;;;;;;;;;
(defrule openfileNoticias
  (declare(salience 30))
  =>
  (open  "Noticias.txt" file3)
  (assert (SeguirLeyendo3))
)

(defrule readDataNoticias
  (declare(salience 20))
  ?f <- (SeguirLeyendo3)
  =>
  (bind ?valor1 (read file3))
  (retract ?f)
  (if (neq ?valor1 EOF) then
  (bind ?valor2 (read file3))
  (bind ?valor3 (read file3))
  (assert (Cartera
    (Nombre ?valor1)
    (Tipo ?valor2)
    (Antiguedad ?valor3)
    ))
  (assert (SeguirLeyendo3))
  )
)

(defrule closefileNoticias
  (declare(salience 1))
  =>
  (close file3)
)
