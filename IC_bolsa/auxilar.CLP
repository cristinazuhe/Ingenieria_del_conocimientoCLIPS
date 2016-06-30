(defrule propuesta1
  (declare(salience 9))
  (HagoPropuestas)
  (ValorPeligroso ?nombre)
  (Empresas
      (Nombre ?nombre)
      (VarMes ?varMes)
      (Sector ?nombreSector)
      (RPD ?miRPD))
  (Sector
      (Nombre ?nombreSector)
      (VarMes ?varMesSector))
  =>
  (if (< ?varMes 0) then
      (if (< (- ?varMes ?varMesSector) -3) then
        (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Vender")
                           (RE (- 20 ?miRPD)) (Explicacion "La empresa es peligrosa por..........;")) )
        (assert (PropuestasPeores (NombreEmpresa ?nombre)  (RE (- 20 ?miRPD)) ) )
        (printout t ?nombre " peligroso. Propuesta1." crlf )
      )
  )
)

(defrule propuesta2
  (declare(salience 9))
  (HagoPropuestas)
  (ValorInfravalorado ?nombre)
  (Empresas
    (Nombre ?nombre)
    (PER ?miPER)
    (RPD ?miRPD)
    (Sector ?nombreSector))
  (Cartera
    (Nombre DISPONIBLE)
    (Acciones ?cantidadDisponible))
  (Sector
    (Nombre Ibex)
    (PERMedio ?PERIbex))
  =>
   (if (> ?cantidadDisponible 0 ) then
     (if (> ?miPER 0) then
       (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Invertir")
               (RE (+ (/ (* (- ?PERIbex ?miPER) 100) (* 5 ?miPER) ) ?miRPD))
               (Explicacion "Esta empresa esta infravalorada...") ))
       (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE (+ (/ (* (- ?PERIbex ?miPER) 100) (* 5 ?miPER) ) ?miRPD)) ))
     )
     (if (= ?miPER 0) then
     (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Invertir")
             (RE ?miRPD)
             (Explicacion "Esta empresa esta infravalorada...") ))
     (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE ?miRPD)  ))
     )
   )
)



(defrule propuesta4
   (declare(salience 9))
   (HagoPropuestas)
   (Empresas
      (Nombre ?empresa1)
      (RPD ?RPD1))
   (not (ValorSobrevalorado ?empresa1))
   (Empresas
      (Nombre ?empresa2)
      (RPD ?RPD2)
      (PER ?PER2)
      (Sector ?NombreSector2)
      (VarAnual ?var12))
   (not (ValorInfravalorado ?empresa2))
   (Cartera
      (Nombre ?empresa2))
    (Sector
      (Nombre ?NombreSector2)
      (PERMedio ?PERMedioSector2))
   =>
   (if (> ?RPD1 ( + 1 ( + ?RPD2 ?var12))) then
      (assert (Propuesta (NombreEmpresa ?empresa2) (NombreEmpresa2 ?empresa1)(NombreSector ?NombreSector2) (TipoPropuesta "Cambiar")
                         (RE (- ?RPD1 (+ 1 (+ (* ?RPD2 ( / (* 100 (- ?PER2 ?PERMedioSector2)) (* 5 ?PER2)   )) ?var12 ) )))
                         (Explicacion (str-cat ?empresa1 " debe tener una revalorizacion acorde con la evolucion de la bolsa.
Por dividendos se espera un " (* ?RPD2 100) "%, que es mas de lo que te esta dando " ?empresa2 ",
por eso te propongo cambiar los valores por los de esta otra. " )) ))
      (assert (PropuestasPeores (NombreEmpresa ?empresa2) (NombreEmpresa2 ?empresa1)
                                (RE (- ?RPD1 (+ 1 (+ (* ?RPD2 ( / (* 100 (- ?PER2 ?PERMedioSector2)) (* 5 ?PER2)   )) ?var12 ) ))) ))
    )
)
