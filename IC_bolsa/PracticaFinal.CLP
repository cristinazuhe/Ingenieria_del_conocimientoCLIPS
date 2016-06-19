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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DE ANALISIS, ANALISIS SECTORES Y LA CARTERA DEL USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfile
  =>
  (printout t "Cargando datos: " crlf )
  (load "LecturaEmpresa.CLP")
  (load "LecturaSectores.CLP")
  (load "LecturaCartera.CLP")
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;MÓDULO 1: DETECCION DE VALORES PELIGROSOS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule valorPeligroso1
  (declare(salience 18))
  (Cartera (Nombre ?nombre))
  (ValorInestable ?nombre)
  (Empresas
     (Nombre ?nombre)
     (Perd3Dias true))
  =>
  (assert (ValorPeligroso ?nombre))
)

(defrule valorPeligroso2
  (declare(salience 18))
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
  (declare(salience 17))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Alto)
     (EtiquetaRPD Bajo))
  =>
  (assert (ValorSobrevalorado ?nombre))
)

;;;;;;;;;;;;;;;;;;;Empresa pequenia;;;;;;;;;;;;;;;
(defrule valorSobrevalorados2
  (declare(salience 17))
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
  (declare(salience 17))
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
  (declare(salience 17))
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
  (declare(salience 16))
  (Empresas
     (Nombre ?nombre)
     (EtiquetaPER Bajo)
     (EtiquetaRPD Alto))
  =>
  (assert (ValorInfravalorado ?nombre))
  (printout t ?nombre " es un valor infravalorado. Regla 1." crlf )
)

(defrule valorInfravalorados2
  (declare(salience 16))
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
  (declare(salience 16))
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
