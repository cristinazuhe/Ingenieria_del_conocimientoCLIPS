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


;;***************************
;;LEEMOS EL FICHERO PARA ACTUALIZAR LOS DATOS ACTUALES Y LO ACTUALIZAMOS TRAS APLICAR LOS CAMBIOS**
;;***************************

;Importamos los datos del IBEX35 de un excell.
;Formato de lectura de los datos:
;Datos del IBEX35 (economía)
;;;;Nombre Anterior Ultimo %Dif Maximo Minimo Fecha Hora %DifAños2016
;Datos individuales
;;;;Nombre1 Ultimo %Dif Maximo Minimo Volumen Efectivo Fecha Hora
;;;;...
;;;;...
;;;;NombreN Ultimo %Dif Maxiomo Minimo Volumen Efectivo Fecha Hora



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
      (Variacion ?valor3)
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
      (VRSS ?valor16)
      (VarMes ?valor17)
      (VarTrimestre ?valor18)
      (VarSemestre ?valor19)
      (VarInterAnual ?valor20)
    ))
    (assert (SeguirLeyendo))
  )
)

(defrule closefileEmpresas
  (declare(salience 10))
  =>
  (close file)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DEL FICHERO ANALISIS_SECTORES.TXT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defrule openfileSector
  (declare(salience 29))
  =>
  (open "AnalisisSectores.txt" file1)
  (assert (SeguirLeyendo1))
)

(defrule readDataSector
  (declare(salience 19))
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
    (Variacion ?valor2)
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
    (VarInterAnual ?valor13)
    ))
    (assert (SeguirLeyendo1))
  )
)

(defrule closefileSector
  (declare(salience 9))
  =>
  (close file1)
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;LEEMOS LOS DATOS DE LA CARTERA DEL USUARIO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule openfileCartera
  (declare(salience 28))
  =>
  (printout t "Escriba el nombre del archivo .txt que contiene la cartera: " crlf )
  (bind ?NombreArchivo (read) )
  (open ?NombreArchivo file2)
  (assert (SeguirLeyendo2))
)

(defrule readDataCartera
  (declare(salience 18))
  ?f <- (SeguirLeyendo2)
  =>
  (bind ?valor1 (read file2))
  (retract ?f)
  (if (neq ?valor1 EOF) then
  (bind ?valor2 (read file2))
  (bind ?valor3 (read file2))
  (assert (Cartera
    (Empresa ?valor1)
    (Acciones ?valor2)
    (ValorActual ?valor3)
    ))
  (assert (SeguirLeyendo2))
  )
)

(defrule closefileCartera
  (declare(salience 8))
  =>
  (close file2)
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
