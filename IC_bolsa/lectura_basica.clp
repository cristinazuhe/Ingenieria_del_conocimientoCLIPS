(defrule openfile
   (declare (salience 30))
   =>
   (open "Analisis.txt" mydata)
   (assert (SeguirLeyendo))
)

(defrule LeerValoresCierreFromFile
   (declare (salience 20))
   ?f <- (SeguirLeyendo)
   =>
   (bind ?Leido (read mydata))
   (retract ?f)
   (if (neq ?Leido EOF) then
   (assert (ValorCierre ?Leido (read mydata)))
   (assert (SeguirLeyendo)))
)

(defrule closefile
   (declare (salience 40))
   =>
   (close mydata)
)
