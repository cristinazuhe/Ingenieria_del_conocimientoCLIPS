;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DE ANALISIS, ANALISIS SECTORES Y LA CARTERA DEL USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfile
  ;(declare(salience 30))
  =>
  (printout t "Cargando datos: " crlf )
  (load "LecturaEmpresa.CLP")
  (load "LecturaSectores.CLP")
  (load "LecturaCartera.CLP")
)

;;*******************************
;;MÓDULO DE DETECCION DE VALORES PELIGROSOS**
;;*******************************

;;A continuación se definirán las reglas a tomar con los valores peligrosos.

;;Regla que nos dará los valores peligrosos tras 3 días seguidos bajando. (Deben ser inestables)
;(defrule Peligrosos3Dias

;)


;;Regla que nos dará los valores peligrosos tras estar 5 días seguidos bajando.
;;Hay que comprobar que bajen respecto a su valor, su sector o el valor total del IBEX35.
;(defrule Peligrosos5Dias

;)
