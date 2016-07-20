;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DEL FICHERO ANALISIS_SECTORES.TXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfileSector
  (declare(salience 30))
  =>
  (open "AnalisisSectores.txt" file1)
  (assert (SeguirLeyendo1))
)

(defrule readDataSector
  (declare(salience 20))
  ?f <- (SeguirLeyendo1)
  =>
  (bind ?valor1 (read file1))
  (retract ?f)
  (if (neq ?valor1 EOF) then
  (bind ?valor2 (read file1))
  (bind ?valor3 (read file1))
  (bind ?valor4 (read file1))
  (bind ?valor5 (read file1))
  (bind ?valor6 (read file1))
  (bind ?valor7 (read file1))
  (bind ?valor8 (read file1))
  (bind ?valor9 (read file1))
  (bind ?valor10 (read file1))
  (bind ?valor11 (read file1))
  (bind ?valor12 (read file1))
  (bind ?valor13 (read file1))
  (assert (Sector
    (Nombre ?valor1)
    (VariacionDia ?valor2)
    (Capitalizacion ?valor3)
    (PERMedio ?valor4)
    (RPDMedio ?valor5)
    (PorcentIBEX ?valor6)
    (Var5Dias ?valor7)
    (Perd3Dias ?valor8)
    (Perd5Dias ?valor9)
    (VarMes ?valor10)
    (VarTrimestre ?valor11)
    (VarSemestre ?valor12)
    (VarAnual ?valor13)
    ))
    (assert (SeguirLeyendo1))
  )
)

(defrule closefileSector
  (declare(salience 1))
  =>
  (close file1)
)
