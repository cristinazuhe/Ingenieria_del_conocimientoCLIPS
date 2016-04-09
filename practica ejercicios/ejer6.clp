(deftemplate TTT
  (slot nombreslot1)
  (slot nombreslot2)
  (multislot nombreslot3))

(defrule SolicitoTTT	=>
        (printout t "Escriba la secuencia de palabras: " crlf )
      	(bind ?Palabras (explode$ (readline)) )
        (assert (TTT(nombreslot1  (nth$ 1 ?Palabras))
                    (nombreslot2  (nth$ 2 ?Palabras))
                    (nombreslot3  (subseq$ ?Palabras 3 (length$ ?Palabras)))))
)
