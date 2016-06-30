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
  (slot NombreEmpresa2)
  (slot TipoPropuesta)
  (slot RE)
  (slot NombreSector)
  (slot Explicacion)
)
(deftemplate PropuestasPeores
  (slot NombreEmpresa)
  (slot NombreEmpresa2)
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
  (assert (HagoPropuestas))
  (assert (PropuestasMejores nil nil 0))
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
  (Cartera
      (Nombre ?nombre)
      (Acciones ?acciones))
  =>
  (if (> ?acciones 0) then
  (if (< ?varMes 0) then
      (if (< (- ?varMes ?varMesSector) -3) then
        (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Vender")
                           (RE (- 20 ?miRPD)) (Explicacion (str-cat ?nombre " es peligrosa.
Ademas esta entrando en tendencia bajista con respecto a su sector.
Segun mi estimacion existe una probabilidad no despreciable de que pueda caer
al cabo del anio un 20%.
Aunque produzca un " (* 100 ?miRPD) "% por dividendos, perderiamos un " (- 20 ?miRPD)"%."))) )
        (assert (PropuestasPeores (NombreEmpresa ?nombre)  (RE (- 20 ?miRPD)) ) )
      )
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
               (Explicacion (str-cat ?nombre " esta infravalorada y seguramente el PER (" ?miPER ")
tienda al PERMedio (" ?PERIbex ") en 5 anios, con lo que se deberia revalorizar un
" (/ (* (- ?PERIbex ?miPER) 100) (* 5 ?miPER) )  " anual, a lo que habria que sumar un " (* ?miRPD 100) "% de beneficios por dividendos. " )) ))
       (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE (+ (/ (* (- ?PERIbex ?miPER) 100) (* 5 ?miPER) ) ?miRPD)) ))
     )
     (if (= ?miPER 0) then
     (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Invertir")
             (RE ?miRPD)
             (Explicacion (str-cat ?nombre " esta infravalorada y seguramente el PER (" ?miPER ")
tienda al PERMedio (" ?PERIbex ") en 5 anios." )) ))
     (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE ?miRPD)  ))
     )
   )
)


(defrule propuesta3
    (declare(salience 9))
    (HagoPropuestas)
    (Cartera
      (Nombre ?nombre)
      (Acciones ?acciones))
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
    (if (> ?acciones 0) then
    (if (< ( / (* 100 (- ?miPER ?PERMedioSector)) (* 5 ?miPER)   ) (+ 5 ?precio) ) then
       (assert (Propuesta (NombreEmpresa ?nombre) (NombreSector ?nombreSector) (TipoPropuesta "Vender")
            (RE (+ (- 0 ?miRPD) (/ (* (- ?miPER ?PERMedioSector ) 100) (* 5 ?miPER )) ) )
            (Explicacion (str-cat ?nombre " esta sobrevalorada, es mejor amortizar lo invertido,
ya que seguramente el PER tan alto (" ?miPER ") debera bajar al PER medio del sector (" ?PERMedioSector ").
Por tanto, se deberia devaluar un " (/ (* (- ?miPER ?PERMedioSector ) 100) (* 5 ?miPER )) " anual, asi que aunque se pierda el " (* 100 ?miRPD) "
de beneficios por dividendos saldria rentable." ) ) ))
       (assert (PropuestasPeores (NombreEmpresa ?nombre) (RE (+ ?miRPD (/ (* (- ?miPER ?PERMedioSector ) 100) (* 5 ?miPER )) ) )  ))
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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MÓDULO 4.2 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Me quedo con las 5 mejores propuestas;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defglobal ?*contador_max* = 0)
(defrule FinPropuestas
   (declare(salience 8))
   ?p <- (HagoPropuestas)
   =>
   (retract ?p)
)

(defrule Busco5MejoresPropuestas
  (declare(salience 8))
  ?f <- (BuscoMejoresPropuestas)
  (PropuestasPeores (RE ?x))
  (forall (PropuestasPeores (RE ?y)) (test (>= ?x ?y)))
  ?a <- (PropuestasPeores (NombreEmpresa ?nombre) (NombreEmpresa2 ?nombre2) (RE ?x))
  =>
  (if (< ?*contador_max* 5) then
     (retract ?f)
     (retract ?a)
     (bind ?*contador_max* (+ ?*contador_max* 1))
     (assert (BuscoMejoresPropuestas))
     (assert (PropuestasMejores ?nombre ?nombre2 ?*contador_max*))
     (assert (PropuestasMejores nil nil 0))
  )
  (if (> ?*contador_max* 4) then   ;Si ya tengo las 5 mejores, elimino las PropuestasPeores (las sigo teniendo en Propuestas)
     (retract ?a)
  )
)

(defrule PropongoAUsuario
   (declare(salience 7))
   (PropuestasMejores ?nombre ?nombre2 ?numero)
   (Propuesta
      (NombreEmpresa ?nombre)
      (NombreEmpresa2 ?nombre2)
      (TipoPropuesta ?tipoPropuesta)
      (RE ?miRE)
      (NombreSector ?nombreSector)
      (Explicacion ?explicacion)
   )
   =>
   (printout t "*****************************************************************************" crlf)
   (printout t "********************************* PROPUESTA " ?numero "********************************" crlf)
   (printout t "Para la empresa " ?nombre "  del sector " ?nombreSector " tenemos una propuesta de tipo " ?tipoPropuesta " ." crlf)
   (printout t "
Explicacion:
" ?explicacion crlf)
   (printout t "
El rendimiento esperado es de " ?miRE crlf)
   (printout t crlf)
   (assert (PropuestasHechas))
)

(defrule EligeOpcionUsuario
   (declare(salience 6))
   ?f <- (PropuestasHechas)
   =>
   (printout t "*****************************************************************************" crlf)
   (printout t "********************************* PROPUESTA 0 ********************************" crlf)
   (printout t "No realizar ninguna accion." crlf)
   (printout t crlf)
   (printout t "Eliga una de las propuestas indicadas (0, 1, 2, 3, 4 o 5): " crlf)
   (bind ?Respuesta (explode$ (readline)))
   (assert (OpcionElegida ?Respuesta))
   (retract ?f)
)

(defrule RealizarEleccionUsuario
    ?f <- (OpcionElegida ?Respuesta)
    (PropuestasMejores ?nombreEmpresa ?nombreEmpresa2 ?Respuesta)
    (Propuesta
         (NombreEmpresa ?nombreEmpresa)
         (NombreEmpresa2 ?nombreEmpresa2)
         (TipoPropuesta ?tipo)
         (RE ?miRE)
         (NombreSector ?nombreSector)
         (Explicacion ?explicacion))
    (Cartera
        (Nombre ?nombreCartera)
        (Acciones ?accionesCartera))
    =>
    (if (eq ?tipo "Invertir") then
        (printout t " ¿Cuantas acciones quieres comprar de " ?nombreEmpresa "?." crlf)
        (bind ?Respuesta (explode$ (readline)))
        (assert (ComprarAcciones ?nombreEmpresa ?Respuesta))
    )

    (if (eq ?tipo "Vender") then
        (printout t " ¿Cuantas acciones quieres vender de " ?nombreEmpresa "?." crlf)
        (bind ?Respuesta (explode$ (readline)))
        (assert (VenderAccionesCartera ?nombreEmpresa ?Respuesta))
    )
    (if (eq ?tipo "Cambiar") then
        (printout t " ¿Cuantas acciones quieres cambiar de " ?nombreEmpresa " a " ?nombreEmpresa2 "?." crlf)
        (bind ?Respuesta (explode$ (readline)))
        (assert (CambiarAccionesEmpresa ?nombreEmpresa ?nombreEmpresa2 ?Respuesta))
    )
    (retract ?f)
)


(defrule RealizarVenta
      ?f <- (VenderAccionesCartera ?nombreEmpresa ?Respuesta)
      ?C1 <- (Cartera
                 (Nombre ?nombreEmpresa)
                 (Acciones ?acciones)
                 (ValorActual ?valorantiguo))

      ?C2 <- (Cartera
                  (Nombre DISPONIBLE)
                  (Acciones ?dinero))
      =>
      (assert (Reiniciar))
      (if (<= ?Respuesta ?acciones) then
        (retract ?f)
        (modify ?C1 (Acciones (- ?acciones ?Respuesta)) (ValorActual (- ?valorantiguo (* ?Respuesta (/ ?valorantiguo ?acciones)))))
        (modify ?C2 (Acciones (+ ?dinero (* ?Respuesta (/ ?valorantiguo ?acciones))))
                    (ValorActual ( + ?dinero (* ?Respuesta (/ ?valorantiguo ?acciones)))))

        (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
        (printout t "Ha vendido " ?Respuesta " acciones de " ?nombreEmpresa ", ahora le quedan " (- ?acciones ?Respuesta) "."  crlf )
        (printout t "Le queda " ( + ?dinero (* ?Respuesta (/ ?valorantiguo ?acciones))) " dinero disponible en la cartera." crlf)
        (printout t "*********************************************************************" crlf)
      )
      (if (> ?Respuesta ?acciones) then
        (retract ?f)
        (printout t "No tienes tantas acciones para vender. " crlf)
      )
)

(defrule RealizarInversionYaEnCartera
    ?f <- (ComprarAcciones ?nombreEmpresa ?Respuesta)
    ?C1 <- (Cartera
               (Nombre ?nombreEmpresa)
               (Acciones ?acciones)
               (ValorActual ?valorantiguo))

    ?C2 <- (Cartera
                (Nombre DISPONIBLE)
                (Acciones ?dinero))
   (Empresas
      (Nombre ?nombreEmpresa)
      (Precio ?precio))
   =>
   (assert (Reiniciar))
   (if (> (- ?dinero (* ?Respuesta ?precio)) 0) then
       (retract ?f)
       (modify ?C1 (Acciones (+ ?acciones ?Respuesta)) (ValorActual (+ ?valorantiguo (* ?Respuesta ?precio))))
       (modify ?C2 (Acciones (- ?dinero (* ?Respuesta ?precio)))
                   (ValorActual ( - ?dinero (* ?Respuesta ?precio))))

       (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
       (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa ", ahora tiene " (+ ?acciones ?Respuesta) "."  crlf )
       (printout t "Le queda " ( - ?dinero (* ?Respuesta ?precio)) " dinero disponible en la cartera." crlf)
       (printout t "*********************************************************************" crlf)
   )
   (if (<= (- ?dinero (* ?Respuesta ?precio)) 0) then
      (retract ?f)
      (printout t "No tiene dinero disponible para comprar tantas acciones." crlf)
   )
)

(defrule RealizarInversionNoEnCartera
    ?f <- (ComprarAcciones ?nombreEmpresa ?Respuesta)
    ?C2 <- (Cartera
              (Nombre DISPONIBLE)
              (Acciones ?dinero))
   (Empresas
            (Nombre ?nombreEmpresa)
            (Precio ?precio))
    =>
    (assert (Reiniciar))
    (if (> (- ?dinero (* ?Respuesta ?precio)) 0) then
        (retract ?f)
        (assert (Cartera (Nombre ?nombreEmpresa) (Acciones ?Respuesta) (ValorActual (* ?Respuesta ?precio))))
        (modify ?C2 (Acciones (- ?dinero (* ?Respuesta ?precio)))
                    (ValorActual ( - ?dinero (* ?Respuesta ?precio))))

        (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
        (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa ", ahora tiene "  ?Respuesta "."  crlf )
        (printout t "Le queda " ( - ?dinero (* ?Respuesta ?precio)) " dinero disponible en la cartera." crlf)
        (printout t "*********************************************************************" crlf)
    )
    (if (<= (- ?dinero (* ?Respuesta ?precio)) 0) then
       (retract ?f)
       (printout t "No tiene dinero disponible para comprar tantas acciones." crlf)
    )
)

(defrule RealizarCambioAccionesYaEnCartera
    ?f <- (CambiarAccionesEmpresa ?nombreEmpresa1 ?nombreEmpresa2 ?Respuesta)
    ?C1 <- (Cartera
               (Nombre ?nombreEmpresa1)
               (Acciones ?acciones1)
               (ValorActual ?valor1))
    ?C2 <- (Cartera
               (Nombre ?nombreEmpresa2)
               (Acciones ?acciones2)
               (ValorActual ?valor2))
    ?C3 <- (Cartera
                (Nombre DISPONIBLE)
                (Acciones ?dinero))
    =>
  (retract ?f)
  (assert (Reiniciar))
  (if (<= ?Respuesta ?acciones1) then                                                 ;si tengo tantas acciones para cambiar...
         (if (>= (/ ?valor1 ?acciones1) (/ ?valor2 ?acciones2) ) then                ;la primera empresa tiene un coste de acciones mayor...ganaré dinero disponible
              (modify ?C1 (Acciones (- ?acciones1 ?Respuesta)) (ValorActual (- ?valor1 (* ?Respuesta (/ ?valor1 ?acciones1)))))
              (modify ?C2 (Acciones (+ ?acciones2 ?Respuesta)) (ValorActual (+ ?valor2 (* ?Respuesta (/ ?valor2 ?acciones2)))))
              (modify ?C3 (Acciones (+ ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta (/ ?valor2 ?acciones2)) )))
                          (ValorActual ( + ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta (/ ?valor2 ?acciones2)) ) )))

              (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
              (printout t "Ha vendido " ?Respuesta " acciones de " ?nombreEmpresa1 ", ahora tiene " (- ?acciones1 ?Respuesta) "."  crlf )
              (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa2 ", ahora tiene " (+ ?acciones2 ?Respuesta) "."  crlf )
              (printout t "Ahora tiene " (+ ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta (/ ?valor2 ?acciones2)) ))
                                       " dinero disponible en la cartera." crlf)
              (printout t "*********************************************************************" crlf)
          )
          (if (< (/ ?valor1 ?acciones1) (/ ?valor2 ?acciones2) ) then                 ;la primera empresa tiene un coste de acciones menor...tendré que invertir dinero
              (if (<= (- (* ?Respuesta (/ ?valor2 ?acciones2)) (* ?Respuesta (/ ?valor1 ?acciones1)) ) ?dinero ) then
                    (modify ?C1 (Acciones (- ?acciones1 ?Respuesta)) (ValorActual (- ?valor1 (* ?Respuesta (/ ?valor1 ?acciones1)))))
                    (modify ?C2 (Acciones (+ ?acciones2 ?Respuesta)) (ValorActual (+ ?valor2 (* ?Respuesta (/ ?valor2 ?acciones2)))))
                    (modify ?C3 (Acciones (- ?dinero (- (* ?Respuesta (/ ?valor2 ?acciones2)) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) ) )
                                (ValorActual (- ?dinero (- (* ?Respuesta (/ ?valor2 ?acciones2)) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) )))

                    (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
                    (printout t "Ha vendido " ?Respuesta " acciones de " ?nombreEmpresa1 ", ahora tiene " (- ?acciones1 ?Respuesta) "."  crlf )
                    (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa2 ", ahora tiene " (+ ?acciones2 ?Respuesta) "."  crlf )
                    (printout t "Le queda " (- ?dinero (- (* ?Respuesta (/ ?valor2 ?acciones2)) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) )
                                             " dinero disponible en la cartera." crlf)
                    (printout t "*********************************************************************" crlf)
              )
              (if (> (- (* ?Respuesta (/ ?valor2 ?acciones2)) (* ?Respuesta (/ ?valor1 ?acciones1)) ) ?dinero ) then
                   (printout t "No tiene dinero suficiente para hacer dicho cambio de acciones." crlf)
              )
          )
  )
  (if (> ?Respuesta ?acciones1) then
    (retract ?f)
    (printout t "No tienes tantas acciones para vender. " crlf)
  )
)

(defrule RealizarCambioAccionesNoEnCartera
    ?f <- (CambiarAccionesEmpresa ?nombreEmpresa1 ?nombreEmpresa2 ?Respuesta)
    ?C1 <- (Cartera
               (Nombre ?nombreEmpresa1)
               (Acciones ?acciones1)
               (ValorActual ?valor1))
    (Empresas
         (Nombre ?nombreEmpresa2)
         (Precio ?valor2))
    ?C3 <- (Cartera
                (Nombre DISPONIBLE)
                (Acciones ?dinero))
      =>
    (retract ?f)
    (assert (Reiniciar))
    (if (<= ?Respuesta ?acciones1) then                                                 ;si tengo tantas acciones para cambiar...
           (if (>= (/ ?valor1 ?acciones1) ?valor2 ) then                ;la primera empresa tiene un coste de acciones mayor...ganaré dinero disponible
                (modify ?C1 (Acciones (- ?acciones1 ?Respuesta)) (ValorActual (- ?valor1 (* ?Respuesta (/ ?valor1 ?acciones1)))))
                (assert (Cartera (Nombre ?nombreEmpresa2) (Acciones ?Respuesta) (ValorActual (* ?Respuesta ?valor2))))
                (modify ?C3 (Acciones (+ ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta ?valor2 ) )))
                            (ValorActual ( + ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta ?valor2 ) ) )))
                (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
                (printout t "Ha vendido " ?Respuesta " acciones de " ?nombreEmpresa1 ", ahora tiene " (- ?acciones1 ?Respuesta) "."  crlf )
                (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa2 ", ahora tiene " ?Respuesta "."  crlf )
                (printout t "Ahora tiene " (+ ?dinero (- (* ?Respuesta (/ ?valor1 ?acciones1)) (* ?Respuesta ?valor2 ) ))
                                         " dinero disponible en la cartera." crlf)
                (printout t "*********************************************************************" crlf)
            )
            (if (< (/ ?valor1 ?acciones1) ?valor2 ) then                 ;la primera empresa tiene un coste de acciones menor...tendré que invertir dinero
                (if (<= (- (* ?Respuesta ?valor2) (* ?Respuesta (/ ?valor1 ?acciones1)) ) ?dinero ) then
                      (modify ?C1 (Acciones (- ?acciones1 ?Respuesta)) (ValorActual (- ?valor1 (* ?Respuesta (/ ?valor1 ?acciones1)))))
                      (assert (Cartera (Nombre ?nombreEmpresa2) (Acciones ?Respuesta) (ValorActual (* ?Respuesta ?valor2))))
                      (modify ?C3 (Acciones (- ?dinero (- (* ?Respuesta ?valor2 ) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) ) )
                                  (ValorActual (- ?dinero (- (* ?Respuesta ?valor2 ) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) )))
                      (printout t "********************CONSECUENCIAS DE SU SELECCION********************" crlf)
                      (printout t "Ha vendido " ?Respuesta " acciones de " ?nombreEmpresa1 ", ahora tiene " (- ?acciones1 ?Respuesta) "."  crlf )
                      (printout t "Ha comprado " ?Respuesta " acciones de " ?nombreEmpresa2 ", ahora tiene "  ?Respuesta "."  crlf )
                      (printout t "Le queda " (- ?dinero (- (* ?Respuesta ?valor2 ) (* ?Respuesta (/ ?valor1 ?acciones1) ) ) )
                                               " dinero disponible en la cartera." crlf)
                      (printout t "*********************************************************************" crlf)
                )
                (if (> (- (* ?Respuesta ?valor2 ) (* ?Respuesta (/ ?valor1 ?acciones1)) ) ?dinero ) then
                         (printout t "No tiene dinero suficiente para hacer dicho cambio de acciones." crlf)
                )
            )
      )
      (if (> ?Respuesta ?acciones1) then
          (retract ?f)
          (printout t "No tienes tantas acciones para vender. " crlf)
      )
)

(defrule BorrarPropuestas
    (declare(salience 3))
    (Reiniciar)
    ?f <- (Propuesta)
    =>
    (retract ?f)
    (assert (BorrarMejores))
)

(defrule BorrarPropuestasMejores
    (declare(salience 2))
    (BorrarMejores)
    ?f <- (PropuestasMejores ?nombre1 ?nombre2 ?numero)
    =>
    (retract ?f)
    (assert (HacerNuevasPropuestas))
)

(defrule ReiniciarPropuestas
    ?f <- (HacerNuevasPropuestas)
    ?r <- (Reiniciar)
    ?b <- (BorrarMejores)
    =>
    (retract ?f)
    (retract ?r)
    (retract ?b)
    (bind ?*contador_max* 0)
    (printout t "Pulse cualquier tecla para ver mas propuestas... " crlf)
    (bind ?Sigamos (explode$ (readline)))
    (assert (PropuestasMejores nil nil 0))
    (assert (HagoPropuestas))
    (assert (BuscoMejoresPropuestas))
)
