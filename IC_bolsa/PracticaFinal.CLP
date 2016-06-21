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
)

;;;;;;;;;;;;;;;;;;;;
;;VALORES INESTABLES
;;;;;;;;;;;;;;;;;;;;
(defrule valorInestable1
   (declare(salience 19))
   (Empresas
      (Nombre ?nombre)
      (Sector Construccion))
   =>
   (assert (ValorInestable ?nombre))
   (printout t ?nombre " es un valor inestable por pertenecer a Construiccion." crlf )
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
       (printout t "La economia esta bajando y "?nombre " es un valor inestable por pertenecer a Servicios." crlf )
   )
)



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 3;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA BUENA SOBRE LA EMPRESA, SERÁ ESTABLE.
;(defrule valorInestable4
;   (declare(salience 13))
;   ?f <- (ValorInestable ?nombre)
;   (Noticia
;     (Nombre ?nombre)
;     (Tipo Buena))
;   (Empresas
;         (Nombre ?nombre))
;   =>
;   (retract ?f)
;   (printout t ?nombre " ahora es un valor ESTABLE . Regla 3." crlf )
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 4;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE LA EMPRESA, SERÁ INESTABLE.
(defrule valorInestable5
   (declare(salience 14))
   (Noticia
     (Nombre ?nombre)
     (Tipo Mala))
   (Empresas
      (Nombre ?nombre))
   (not(ValorInestable ?nombre))
   =>
   (assert (ValorInestable ?nombre))
   (printout t ?nombre " es un valor INESTABLE . Regla 4." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 3;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA BUENA SOBRE EL SECTOR, SERÁ ESTABLE.
;(defrule valorInestable3
;    (declare(salience 15))
;    ?f1 <- (SeguirLeyendo)
;    ?f <- (ValorInestable ?nombre)
;    (Noticia
;      (Nombre ?nombreSector)
;      (Tipo Buena))
;    (Empresas
;          (Nombre ?nombre)
;          (Sector ?nombreSector))
;    =>
;    (retract ?f1)
;    (retract ?f)
;    (printout t ?nombre " ahora es un valor ESTABLE . Regla 3." crlf )
;    (assert (SeguirLeyendo2))
;)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 5;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE UN SECTOR, LAS DE ESE SECTOR SERÁN INESTABLES.
(defrule valorInestable6
   (declare(salience 16))
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
   (printout t ?nombre " es un valor INESTABLE . Regla 5." crlf )
  ; (assert (Seguir))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;punto 6;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;SI HAY UNA NOTICIA MALA SOBRE LA ECONOMIA, TODAS SERÁN INESTABLES.
(defrule valorInestable7
   (declare(salience 17))
   (Noticia
     (Nombre IBEX)
     (Tipo Mala))
   (Empresas
     (Nombre ?nombre))
   (not(ValorInestable ?nombre))
   =>
      (assert (ValorInestable ?nombre))
    ;  (assert (Seguir))
      (printout t ?nombre " es un valor INESTABLE . Regla 6." crlf )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MÓDULO 1: DETECCION DE VALORES PELIGROSOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MÓDULO 2: DETECCION DE VALORES SOBREVALORADOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MÓDULO 3: DETECCION DE VALORES INFRAVALORADOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;Empresa general;;;;;;;;;;;;;;;;
(defrule valorInfravalorados1
  (declare(salience 10))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Bajo)
     (EtiquetaRPD Alto))
  =>
  (assert (ValorInfravalorado ?nombre))
  (printout t ?nombre " es un valor infravalorado. Regla 1." crlf )
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
      (printout t ?nombre " es un valor infravalorado. Regla 3." crlf )
    )
  )
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MÓDULO 4: REALIZACION DE PROPUESTAS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule propuesta1
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
        (assert (PropuestaPeligrosa ?nombre (- 20 ?miRPD)))
        (printout t ?nombre " peligroso. Propuesta peligrosa 1." crlf )
      )
  )
)
