

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DEL FICHERO ANALISIS.TXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfileEmpresas
  (declare(salience 30))
  =>
  (open "Analisis.txt" file)
  (assert (SeguirLeyendo))
)

(defrule readDataEmpresas
  (declare(salience 20))
  ?f <- (SeguirLeyendo)
  =>
  (bind ?valor1 (read file))
  (retract ?f)
  (if (neq ?valor1 EOF) then
    (bind ?valor2 (read file))
    (bind ?valor3 (read file))
    (bind ?valor4 (read file))
    (bind ?valor5 (read file))
    (bind ?valor6 (read file))
    (bind ?valor7 (read file))
    (bind ?valor8 (read file))
    (bind ?valor9 (read file))
    (bind ?valor10 (read file))
    (bind ?valor11 (read file))
    (bind ?valor12 (read file))
    (bind ?valor13 (read file))
    (bind ?valor14 (read file))
    (bind ?valor15 (read file))
    (bind ?valor16 (read file))
    (bind ?valor17 (read file))
    (bind ?valor18 (read file))
    (bind ?valor19 (read file))
    (bind ?valor20 (read file))
    (assert (Empresas
      (Nombre ?valor1)
      (Precio ?valor2)
      (VariacionDia ?valor3)
      (Capitalizacion ?valor4)
      (PER ?valor5)
      (RPD ?valor6)
      (Tamanio ?valor7)
      (PorcentIBEX ?valor8)
      (EtiquetaPER ?valor9)
      (EtiquetaRPD ?valor10)
      (Sector ?valor11)
      (Var5Dias ?valor12)
      (Perd3Dias ?valor13)
      (Perd5Dias ?valor14)
      (VarSector5Dias ?valor15)
      (VRS5 ?valor16)
      (VarMes ?valor17)
      (VarTrimestre ?valor18)
      (VarSemestre ?valor19)
      (VarAnual ?valor20)
    ))
    (assert (SeguirLeyendo))
  )
)

(defrule closefileEmpresas
  (declare(salience 1))
  =>
  (close file)
)
