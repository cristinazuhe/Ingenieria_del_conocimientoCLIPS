;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DEFINIMOS LAS ESTRUCTURAS DE TRABAJO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftemplate Empresas
  (slot Nombre)
  (slot Precio)
  (slot VariacionDia)
  (slot Capitalizacion)
  (slot PER)
  (slot RPD)
  (slot Tamanio)
  (slot PorcentIBEX)
  (slot EtiquetaPER)
  (slot EtiquetaRPD)
  (slot Sector)
  (slot Var5Dias)
  (slot Perd3Dias)
  (slot Perd5Dias)
  (slot VarSector5Dias)
  (slot VRS5)
  (slot VarMes)
  (slot VarTrimestre)
  (slot VarSemestre)
  (slot VarAnual)
)
(deftemplate Sector
  (slot Nombre)
  (slot VariacionDia)
  (slot Capitalizacion)
  (slot PERMedio)
  (slot RPDMedio)
  (slot PorcentIBEX)
  (slot Var5Dias)
  (slot Perd3Dias)
  (slot Perd5Dias)
  (slot VarMes)
  (slot VarTrimestre)
  (slot VarSemestre)
  (slot VarAnual)
)
(deftemplate Cartera
  (slot Nombre)
  (slot Acciones)
  (slot ValorActual)
)
(deftemplate Noticia
  (slot Nombre)
  (slot Tipo)
  (slot Antiguedad)
)

(deftemplate Propuesta
  (slot NombreEmpresa)
  (slot TipoPropuesta)
  (slot RE)
  (slot NombreSector)
  (multislot Explicacion)
)
(deftemplate PropuestasPeores
  (slot NombreEmpresa)
  (slot RE))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DE ANALISIS, ANALISIS SECTORES Y LA CARTERA DEL USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfile
  =>
  (printout t "Cargando datos: " crlf )
  (load "LecturaEmpresa.CLP")
  (load "LecturaSectores.CLP")
  (load "LecturaCartera.CLP")
  (load "LecturaNoticias.CLP")
  (assert (BuscoMejoresPropuestas))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;VALORES INESTABLES;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule valorInestable1
   (declare(salience 19))
   (Empresas
      (Nombre ?nombre)
      (Sector Construccion))
   =>
   (assert (ValorInestable ?nombre))
   (printout t ?nombre " -------- valor INESTABLE. Regla 1." crlf )
)

(defrule valorInestable2
   (declare(salience 19))
   (Sector
      (Nombre Ibex)
      (Var5Dias ?cantidad))
   (Empresas
      (Nombre ?nombre)
      (Sector Servicios))
   =>
   (if (< ?cantidad 0) then
       (assert (ValorInestable ?nombre))
       (printout t ?nombre " --------valor INESTABLE. Regla 2" crlf )
   )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 6. Ibex;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE LA ECONOMIA, TODAS SERÁN INESTABLES.
(defrule valorInestable3
   (declare(salience 17))
   (not (Etapas paso1Fin))
   (Noticia
     (Nombre Ibex)
     (Tipo Mala))
   (Empresas
     (Nombre ?nombre))
   (not(ValorInestable ?nombre))
   =>
      (assert (ValorInestable ?nombre))
      (printout t ?nombre " -------- valor INESTABLE . Regla 6." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 5. M_S;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE UN SECTOR, LAS DE ESE SECTOR SERÁN INESTABLES.
(defrule valorInestable4
   (declare(salience 16))
   (not (Etapas paso1Fin))
   (Noticia
     (Nombre ?nombreSector)
     (Tipo Mala))
   (Sector
      (Nombre ?nombreSector))
   (Empresas
     (Nombre ?nombre)
     (Sector ?nombreSector))
   (not(ValorInestable ?nombre))
   =>
   (assert (ValorInestable ?nombre))
   (printout t ?nombre " -------- valor INESTABLE . Regla 5." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 3. B_Sectores;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA BUENA SOBRE EL SECTOR, SERÁ ESTABLE.
(defrule valorInestable5
    (declare(salience 15))
    (not (Etapas paso2Fin))
    ?f <- (ValorInestable ?nombre)
    (Noticia
      (Nombre ?nombreSector)
      (Tipo Buena))
    (Empresas
          (Nombre ?nombre)
          (Sector ?nombreSector))
    =>
    (assert (Etapas paso1Fin))
    (retract ?f)
    (printout t ?nombre " -------- valor ESTABLE . Regla 3 Sector." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 4 M_E;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE LA EMPRESA, SERÁ INESTABLE.
(defrule valorInestable6
   (declare(salience 14))
   (not (Etapas paso3Fin))
   (Noticia
     (Nombre ?nombre)
     (Tipo Mala))
   (Empresas
      (Nombre ?nombre))
   (not(ValorInestable ?nombre))
   =>
   (assert (Etapas paso2Fin))
   (assert (ValorInestable ?nombre))
   (printout t ?nombre " -------- valor INESTABLE . Regla 4." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 3. B_Empresa;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA BUENA SOBRE LA EMPRESA, SERÁ ESTABLE.
(defrule valorInestable7
   (declare(salience 13))
   ?f <- (ValorInestable ?nombre)
   (Noticia
     (Nombre ?nombre)
     (Tipo Buena))
   (Empresas
         (Nombre ?nombre))
   =>
   (assert (Etapas paso3Fin))
   (retract ?f)
   (printout t ?nombre " -------- valor ESTABLE . Regla 3." crlf )
)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 1: DETECCION DE VALORES PELIGROSOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule valorPeligroso1
  (declare(salience 12))
  (Cartera (Nombre ?nombre))
  (ValorInestable ?nombre)
  (Empresas
     (Nombre ?nombre)
     (Perd3Dias true))
  =>
  (assert (ValorPeligroso ?nombre))
)

(defrule valorPeligroso2
  (declare(salience 12))
  (Cartera (Nombre ?nombre))
  (Empresas
     (Nombre ?nombre)
     (Perd5Dias true)
     (VarSector5Dias ?valsec))
  =>
  (if (< ?valsec -5) then
  (assert (ValorPeligroso ?nombre))
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 2: DETECCION DE VALORES SOBREVALORADOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;Empresa general;;;;;;;;;;;;;;;;
(defrule valorSobrevalorados1
  (declare(salience 11))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Alto)
     (EtiquetaRPD Bajo))
  =>
  (assert (ValorSobrevalorado ?nombre))
)

;;;;;;;;;;;;;;;;;;;Empresa pequenia;;;;;;;;;;;;;;;
(defrule valorSobrevalorados2
  (declare(salience 11))
  (or (Empresas
        (Nombre ?nombre)
        (Tamanio PEQUENIA)
        (EtiquetaPER Alto))
      (Empresas
        (Nombre ?nombre)
        (Tamanio PEQUENIA)
        (EtiquetaPER Medio)
        (EtiquetaRPD Bajo))
  )
  =>
  (assert (ValorSobrevalorado ?nombre))
)

;;;;;;;;;;;;;;;;;;Empresa grande;;;;;;;;;;;;;;;;;;;
(defrule valorSobrevalorados3
  (declare(salience 11))
  (Empresas
     (Nombre ?nombre)
     (Tamanio GRANDE)
     (EtiquetaRPD Bajo)
     (EtiquetaPER ?miPER))
  =>
  (if (= (str-compare ?miPER "Medio") 0) then
          (assert (ValorSobrevalorado ?nombre))
  )
  (if (= (str-compare ?miPER "Alto") 0) then
          (assert (ValorSobrevalorado ?nombre))
  )
)

(defrule valorSobrevalorados4
  (declare(salience 11))
  (Empresas
     (Nombre ?nombre)
     (Tamanio GRANDE)
     (EtiquetaRPD Medio)
     (EtiquetaPER Alto))
  =>
     (assert (ValorSobrevalorado ?nombre))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 3: DETECCION DE VALORES INFRAVALORADOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;Empresa general;;;;;;;;;;;;;;;;
(defrule valorInfravalorados1
  (declare(salience 10))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Bajo)
     (EtiquetaRPD Alto))
  =>
  (assert (ValorInfravalorado ?nombre))
)

(defrule valorInfravalorados2
  (declare(salience 10))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Bajo)
     (VarMes ?varciacionMes)
     (VarTrimestre ?var3)
     (VarSemestre ?var6)
     (VarAnual ?var12))
  =>
  (if (> ?varciacionMes 0) then
    (if (< ?var3 -30) then
     (assert (ValorInfravalorado ?nombre))
     (printout t ?nombre " es un valor infravalorado. Regla 2. Condicion Trimestre" crlf )
    )
    (if (< ?var6 -30) then
     (assert (ValorInfravalorado ?nombre))
     (printout t ?nombre " es un valor infravalorado. Regla 2. Condicion Semestre" crlf )
    )
    (if (< ?var12 -30) then
     (assert (ValorInfravalorado ?nombre))
     (printout t ?nombre " es un valor infravalorado. Regla 2. Condicion Anual" crlf )
    )
  )
)

(defrule valorInfravalorados3
  (declare(salience 10))
  (Empresas
     (Nombre ?nombre)
     (Tamanio GRANDE)
     (EtiquetaRPD Alto)
     (EtiquetaPER Medio)
     (VarMes ?varMes)      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;¿ESTA VARIABLE O VAR5??
     (VarSector5Dias ?varSector))
  =>
  (if (> ?varSector 0) then
    (if (> ?varMes 0) then
      (assert (ValorInfravalorado ?nombre))
    )
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 4.1 REALIZACION DE PROPUESTAS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule propuesta1
  (declare(salience 9))
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


(defrule propuesta3
    (declare(salience 9))
    (Cartera
      (Nombre ?nombre))
    (ValorSobrevalorado ?nombre)
    (Empresas
      (Nombre ?nombre)
      (Precio ?precio)
      (PER ?miPER)
      (RPD ?miRPD)
      (Sector ?nombreSector))
    (Sector
      (Nombre ?nombreSector)
      (PERMedio ?PERMedioSector))
    =>
    (if (< ( / (* 100 (- ?miPER ?PERMedioSector)) (* 5 ?miPER)   ) (+ 5 ?precio) ) then
       (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Vender")
            (RE (+ (- 0 ?miRPD) (/ (- ?miPER ?PERMedioSector ) (* 5 ?miPER )) ) )
            (Explicacion "Esta empresa esta sobrevalorada...") ))
       (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE (- ?miRPD (/ (- ?miPER ?PERMedioSector ) (* 5 ?miPER )) ) )  ))
    )
)

(defrule propuesta4
    (declare(salience 9))
   (Empresas
      (Nombre ?empresa1)
      (RPD ?RPD1))
   (not (ValorSobrevalorado ?empresa1))
   (Empresas
      (Nombre ?empresa2)
      (RPD ?RPD2)
      (PER ?PER2)
      (Sector ?NombreSector2))
   (not (ValorInfravalorado ?empresa2))
   (Cartera
      (Nombre ?empresa2))
    (Sector
      (Nombre ?NombreSector2)
      (PERMedio ?PERMedioSector2))
   =>
   (if (> ?RPD1 (+ ?RPD2 1) ) then ;;;;;;;;;;;;;;;;;;;;;;ME FALTA LA REVALORIZACION POR AÑO ESPERADO
      (assert (Propuesta (NombreEmpresa ?empresa1) (NombreSector ?empresa2) (TipoPropuesta "Cambiar")
                         (RE (- ?RPD1 (+ 1 (+ ?RPD2 ( / (* 100 (- ?PER2 ?PERMedioSector2)) (* 5 ?PER2)) ) )))
                         (Explicacion ?empresa1 " debe tener una revalorizacion...") ))
     (assert (PropuestasPeores (NombreEmpresa ?empresa1)
                               (RE (- ?RPD1 (+ 1 (+ ?RPD2 ( / (* 100 (- ?PER2 ?PERMedioSector2)) (* 5 ?PER2)) ) )) )  ))
    )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 4.2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Me quedo con las 5 mejores propuestas;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defglobal ?*contador_max* = 0)
(defrule Busco5MejoresPropuestas
  (declare(salience 8))
  ?f <- (BuscoMejoresPropuestas)
  (PropuestasPeores (RE ?x))
  (forall (PropuestasPeores (RE ?y)) (test (>= ?x ?y)))
  ?a <- (PropuestasPeores (NombreEmpresa ?nombre) (RE ?x))
  =>
  (if (< ?*contador_max* 5) then
     (retract ?f)
     (retract ?a)
     (bind ?*contador_max* (+ ?*contador_max* 1))
     (assert (BuscoMejoresPropuestas))
     (assert (PropuestasMejores ?nombre ?*contador_max*))
  )
  (if (> ?*contador_max* 4) then   ;Si ya tengo las 5 mejores, elimino las PropuestasPeores (las sigo teniendo en Propuestas)
     (retract ?a)
  )
)

(defrule PropongoAUsuario
   (declare(salience 7))
   (PropuestasMejores ?nombre ?numero)
   (Propuesta
      (NombreEmpresa ?nombre)
      (TipoPropuesta ?tipoPropuesta)
      (RE ?miRE)
      (NombreSector ?nombreSector)
      (Explicacion ?explicacion)
   )
   =>
   (printout t "********************************* PROPUESTA " ?numero "********************************" crlf)
   (printout t "Para la empresa " ?nombre " del sector " ?nombreSector " tenemos una propuesta de " ?tipoPropuesta " ." crlf)
   (printout t "Explicacion: " ?explicacion crlf)
   (printout t "El rendimiento esperado es de " ?miRE crlf)
   (printout t crlf)
   (assert (PropuestasHechas))
)

(defrule EligeOpcionUsuario
   (declare(salience 6))
   ?f <- (PropuestasHechas)
   =>
   (printout t "********************************* PROPUESTA 0 ********************************" crlf)
   (printout t "No realizar ninguna accion." crlf)
   (printout t crlf)
   (printout t "Eliga una de las propuestas indicadas (0, 1, 2, 3, 4 o 5): " crlf)
   (bind ?Respuesta (explode$ (readline)))
   (assert (OpcionElegida ?Respuesta))
)

(defrule RealizarEleccionUsuario
    (declare(salience 5))
    ?f <- (OpcionElegida ?Respuesta)
    (PropuestasMejores ?nombreEmpresa ?Respuesta)
    (Propuesta
         (NombreEmpresa ?nombreEmpresa)
         (TipoPropuesta ?tipo)
         (RE ?miRE)
         (NombreSector ?nombreSector)
         (Explicacion ?explicacion))
    (Cartera (Nombre ?nombreEmpresaCartera) (Acciones ?cantidadActual))
    =>
    (if (and (eq ?tipo "Invertir")(eq ?nombreEmpresaCartera DISPONIBLE)) then
        (printout t " ¿Cuanto dinero quieres invertir? Tienes " ?cantidadActual " euros."  crlf)
        (bind ?Respuesta (explode$ (readline)))
        (assert (InvertirDineroCartera ?nombreEmpresa ?Respuesta))
    )

    (if (and (eq ?tipo "Vender")(eq ?nombreEmpresaCartera ?nombreEmpresa)) then
        (printout t " ¿Cuantas acciones quieres vender de " ?nombreEmpresa "?. Tienes " ?cantidadActual " acciones." crlf )
        (bind ?Respuesta (explode$ (readline)))
        (assert (VenderAccionesCartera ?nombreEmpresa ?Respuesta))
    )
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;FALTA CAMBIAR!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

)
