;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DE LA CARTERA DEL USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfileCartera
  (declare(salience 30))
  =>
  (printout t "Escriba el nombre del archivo .txt que contiene la cartera: " crlf )
  (bind ?NombreArchivo (read) )
  (open ?NombreArchivo file2)
  (assert (SeguirLeyendo2))
)

(defrule readDataCartera
  (declare(salience 20))
  ?f <- (SeguirLeyendo2)
  =>
  (bind ?valor1 (read file2))
  (retract ?f)
  (if (neq ?valor1 EOF) then
  (bind ?valor2 (read file2))
  (bind ?valor3 (read file2))
  (assert (Cartera
    (Nombre ?valor1)
    (Acciones ?valor2)
    (ValorActual ?valor3)
    ))
  (assert (SeguirLeyendo2))
  )
)

(defrule closefileCartera
  (declare(salience 10))
  =>
  (close file2)
)
