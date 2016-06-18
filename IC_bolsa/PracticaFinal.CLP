;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;DEFINIMOS LAS ESTRUCTURAS DE TRABAJO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(deftemplate Empresas
  (slot Nombre)
  (slot Precio)
  (slot Variacion)
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
  (slot VRSS)
  (slot VarMes)
  (slot VarTrimestre)
  (slot VarSemestre)
  (slot VarInterAnual)
)
(deftemplate Sector
  (slot Nombre)
  (slot Variacion)
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
  (slot VarInterAnual)
)
(deftemplate Cartera
  (slot Empresa)
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
  (Cartera (Empresa ?nombre))
  (ValorInestable ?nombre)
  (Empresas
     (Nombre ?nombre)
     (Perd3Dias true))
  =>
  (assert (ValorPeligroso ?nombre))
)

(defrule valorPeligroso2
  (declare(salience 18))
  (Cartera (Empresa ?nombre))
  (Empresas
     (Nombre ?nombre)
     (Perd5Dias true)
     (VarSector5Dias ?valsec))
  =>
  (if (< ?valsec -5) then
  (assert (ValorPeligroso ?nombre))
  )
)
