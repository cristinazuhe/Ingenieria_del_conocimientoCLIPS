(deftemplate Relacion
  (slot tipo)
  (multislot persona1)
  (multislot persona2))

(deffacts personas
	(mujer "Maria del Rosario Montes Roldan")
	(hombre "Jose Montes Roldan")
	(hombre "Manuel Montes Roldan")
	(mujer "Maria del Carmen Montes Roldan")
	(hombre "Alonso Zuheros Calvo")
	(mujer "Victoria Zuheros Calvo")
	(mujer "Josefa Zuheros Calvo")
	(hombre "Manuel Montes Sanchez")
	(mujer "Aurora Roldan Rodriguez")
	(hombre "Pedro Zuheros Sanchez")
	(mujer "Antonia Calvo Gonzalez")
	(mujer "Sonia Aguilera Montes")
	(mujer "Lorena Montes Luque")
	(hombre "Sergio Montes Luque")
	(mujer "Aurora Montes Reyes")
	(mujer "Mari Carmen Reyes Zuheros")
	(hombre "Francisco Cornelio Reyes Zuheros")
	(mujer "Rocio Gonzalez Zuheros")
	(hombre "Santiago Gonzalez Zuheros")
	(mujer "Antonia Gonzalez Zuheros")
	(hombre "Jose David Zuheros Montes")
	(mujer "Eva Maria Zuheros Montes")
	(mujer "Cristina Zuheros Montes")
	(hombre "Juan Jose Aguilera Garcia")
	(mujer "Josefa Luque Caniadas")
	(mujer "Aurora Reyes Zuheros")
	(hombre "Jose Reyes Peralvarez")
	(hombre "Santiago Gonzalez Torres")
	)

(deffacts hijs
	(hij_de "Alonso Zuheros Calvo" "Cristina Zuheros Montes")
	(hij_de "Alonso Zuheros Calvo" "Eva Maria Zuheros Montes")
	(hij_de "Alonso Zuheros Calvo" "Jose David Zuheros Montes")
	(hij_de "Juan Jose Aguilera Garcia" "Sonia Aguilera Montes")
	(hij_de "Jose Montes Roldan" "Lorena Montes Luque")
	(hij_de "Jose Montes Roldan" "Sergio Montes Luque")
	(hij_de "Manuel Montes Roldan" "Aurora Montes Reyes")
	(hij_de "Jose Reyes Peralvarez" "Mari Carmen Reyes Zuheros")
	(hij_de "Jose Reyes Peralvarez" "Francisco Cornelio Reyes Zuheros")
	(hij_de "Santiago Gonzalez Torres" "Rocio Gonzalez Zuheros")
	(hij_de "Santiago Gonzalez Torres" "Santiago Gonzalez Zuheros")
	(hij_de "Santiago Gonzalez Torres" "Antonia Gonzalez Zuheros")
	(hij_de "Manuel Montes Sanchez" "Maria del Rosario Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Jose Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Manuel Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Maria del Carmen Montes Roldan")
	(hij_de "Pedro Zuheros Sanchez" "Alonso Zuheros Calvo")
	(hij_de "Pedro Zuheros Sanchez" "Victoria Zuheros Calvo")
	(hij_de "Pedro Zuheros Sanchez" "Josefa Zuheros Calvo")
	)

(deffacts matrimonios
	(casado "Jose Montes Roldan" "Josefa Luque Caniadas")
	(casado "Manuel Montes Roldan" "Aurora Reyes Zuheros")
	(casado "Alonso Zuheros Calvo" "Maria del Carmen Montes Roldan")
	(casado "Juan Jose Aguilera Garcia" "Maria del Rosario Montes Roldan")
	(casado "Jose Reyes Peralvarez"  "Victoria Zuheros Calvo")
	(casado "Santiago Gonzalez Torres"  "Josefa Zuheros Calvo" )
  (casado "Pedro Zuheros Sanchez" "Antonia Calvo Gonzalez")
  (casado "Manuel Montes Sanchez" "Aurora Roldan Rodriguez"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MATRIMONIOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule es_matrimonio
		(casado ?casado1 ?casado2)
		=>
		(assert (Relacion (tipo "esposo")(persona1 ?casado1)(persona2 ?casado2))
            (Relacion (tipo "esposa")(persona1 ?casado2)(persona2 ?casado1))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HERMANOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule son_hermanas
	(hij_de ?padremadre ?hija1)
	(hij_de ?padremadre ?hija2)
	(test (neq ?hija1 ?hija2))
  (mujer ?hija1)
	=>
	(assert (Relacion (tipo "hermana")(persona1 ?hija1)(persona2 ?hija2)))
	(assert (herman_de ?hija1 ?hija2)))

(defrule son_hermanos
	(hij_de ?padremadre ?hijo1)
	(hij_de ?padremadre ?hijo2)
	(test (neq ?hijo1 ?hijo2))
  (hombre ?hijo1)
	=>
	(assert (Relacion (tipo "hermano")(persona1 ?hijo1)(persona2 ?hijo2)))
	(assert (herman_de ?hijo1 ?hijo2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HIJOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule es_hijo
			(casado ?casado1 ?casado2)
	    (hij_de ?casado1 ?hijo)
			(hombre ?hijo)
			=>
			(assert (Relacion (tipo "hijo")(persona1 ?hijo)(persona2 ?casado1))
		        	(Relacion (tipo "hijo")(persona1 ?hijo)(persona2 ?casado2))
							(Relacion (tipo "padre")(persona1 ?casado1)(persona2 ?hijo))
							(Relacion (tipo "madre")(persona1 ?casado2)(persona2 ?hijo)))
      (assert (hij_de ?casado2 ?hijo)))

(defrule es_hija
			(casado ?casado1 ?casado2)
	    (hij_de ?casado1 ?hija)
			(mujer ?hija)
			=>
			(assert (Relacion (tipo "hija")(persona1 ?hija)(persona2 ?casado1))
		        	(Relacion (tipo "hija")(persona1 ?hija)(persona2 ?casado2))
							(Relacion (tipo "padre")(persona1 ?casado1)(persona2 ?hija))
							(Relacion (tipo "madre")(persona1 ?casado2)(persona2 ?hija)))
      (assert (hij_de ?casado2 ?hija)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;PRIMOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule son_primas
    (Relacion (tipo "hija")(persona1 ?prima1)(persona2 ?herman1))
    (herman_de ?herman1 ?herman2)
    (hij_de ?herman2 ?prima2)
    =>
    (assert (Relacion (tipo "prima")(persona1 ?prima1)(persona2 ?prima2))))

(defrule son_primos
    (Relacion (tipo "hijo")(persona1 ?primo1)(persona2 ?herman1))
    (herman_de ?herman1 ?herman2)
    (hij_de ?herman2 ?primo2)
    =>
    (assert (Relacion (tipo "primo")(persona1 ?primo1)(persona2 ?primo2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;TIOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule es_sobrina_tia
  (mujer ?sobrina)
	(hij_de ?herman1 ?sobrina)
  (herman_de ?herman2 ?herman1)
  (mujer ?herman2)
  (casado ?casado1 ?herman2)
  =>
  (assert (Relacion (tipo "sobrina")(persona1 ?sobrina)(persona2 ?herman2))
          (Relacion (tipo "sobrina")(persona1 ?sobrina)(persona2 ?casado1))
          (Relacion (tipo "tia")(persona1 ?herman2)(persona2 ?sobrina))
          (Relacion (tipo "tio")(persona1 ?casado1)(persona2 ?sobrina))))

(defrule es_sobrina_tio
    (mujer ?sobrina)
    (hij_de ?herman1 ?sobrina)
    (herman_de ?herman2 ?herman1)
    (hombre ?herman2)
    (casado ?herman2 ?casado1)
    =>
    (assert (Relacion (tipo "sobrina")(persona1 ?sobrina)(persona2 ?herman2))
            (Relacion (tipo "sobrina")(persona1 ?sobrina)(persona2 ?casado1))
            (Relacion (tipo "tio")(persona1 ?herman2)(persona2 ?sobrina))
            (Relacion (tipo "tia")(persona1 ?casado1)(persona2 ?sobrina))))

(defrule es_sobrino_tia
  (hombre ?sobrino)
        	(hij_de ?herman1 ?sobrino)
          (herman_de ?herman2 ?herman1)
          (mujer ?herman2)
          (casado ?casado1 ?herman2)
          =>
          (assert (Relacion (tipo "sobrino")(persona1 ?sobrino)(persona2 ?herman2))
                  (Relacion (tipo "sobrino")(persona1 ?sobrino)(persona2 ?casado1))
                  (Relacion (tipo "tia")(persona1 ?herman2)(persona2 ?sobrino))
                  (Relacion (tipo "tio")(persona1 ?casado1)(persona2 ?sobrino))))

(defrule es_sobrino_tio
        (hombre ?sobrino)
        (hij_de ?herman1 ?sobrino)
        (herman_de ?herman2 ?herman1)
        (hombre ?herman2)
        (casado ?herman2 ?casado1)
        =>
        (assert (Relacion (tipo "sobrino")(persona1 ?sobrino)(persona2 ?herman2))
                (Relacion (tipo "sobrino")(persona1 ?sobrino)(persona2 ?casado1))
                (Relacion (tipo "tio")(persona1 ?herman2)(persona2 ?sobrino))
                (Relacion (tipo "tia")(persona1 ?casado1)(persona2 ?sobrino))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;ABUELOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule es_abuelo_nieto
    (hij_de ?nombre3 ?nombre1)
    (hij_de ?nombre2 ?nombre3)
    (hombre ?nombre2)  (hombre ?nombre1)
    =>
    (assert (Relacion (tipo "abuelo")(persona1 ?nombre2)(persona2 ?nombre1))
            (Relacion (tipo "nieto")(persona1 ?nombre1)(persona2 ?nombre2))))

(defrule es_abuela_nieto
    (hij_de ?nombre3 ?nombre1)
    (hij_de ?nombre2 ?nombre3)
    (mujer ?nombre2)  (hombre ?nombre1)
    =>
    (assert (Relacion (tipo "abuela")(persona1 ?nombre2)(persona2 ?nombre1))
            (Relacion (tipo "nieto")(persona1 ?nombre1)(persona2 ?nombre2))))

(defrule es_abuelo_nieta
    (hij_de ?nombre3 ?nombre1)
    (hij_de ?nombre2 ?nombre3)
    (hombre ?nombre2)  (mujer ?nombre1)
    =>
    (assert (Relacion (tipo "abuelo")(persona1 ?nombre2)(persona2 ?nombre1))
            (Relacion (tipo "nieta")(persona1 ?nombre1)(persona2 ?nombre2))))

(defrule es_abuela_nieta
    (hij_de ?nombre3 ?nombre1)
    (hij_de ?nombre2 ?nombre3)
    (mujer ?nombre2)  (mujer ?nombre1)
    =>
    (assert (Relacion (tipo "abuela")(persona1 ?nombre2)(persona2 ?nombre1))
            (Relacion (tipo "nieta")(persona1 ?nombre1)(persona2 ?nombre2))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;SUEGROS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule es_yerno_suegra
	(casado ?nombre1 ?nombre3)
	(hij_de ?nombre2 ?nombre3)
  (mujer ?nombre2)
	=>
  (assert (Relacion (tipo "yerno")(persona1 ?nombre1)(persona2 ?nombre2))
          (Relacion (tipo "suegra")(persona1 ?nombre2)(persona2 ?nombre1))))

(defrule es_yerno_suegro
	(casado ?nombre1 ?nombre3)
	(hij_de ?nombre2 ?nombre3)
  (hombre ?nombre2)
	=>
  (assert (Relacion (tipo "yerno")(persona1 ?nombre1)(persona2 ?nombre2))
          (Relacion (tipo "suegro")(persona1 ?nombre2)(persona2 ?nombre1))))

(defrule es_nuera_suegro
	(casado ?nombre1 ?nombre3)
	(hij_de ?nombre2 ?nombre1)
  (hombre ?nombre2)
	=>
  (assert (Relacion (tipo "nuera")(persona1 ?nombre3)(persona2 ?nombre2))
          (Relacion (tipo "suegro")(persona1 ?nombre2)(persona2 ?nombre3))))

(defrule es_nuera_suegra
	(casado ?nombre1 ?nombre3)
	(hij_de ?nombre2 ?nombre1)
  (mujer ?nombre2)
	=>
  (assert (Relacion (tipo "nuera")(persona1 ?nombre3)(persona2 ?nombre2))
          (Relacion (tipo "suegra")(persona1 ?nombre2)(persona2 ?nombre3))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule pedirPrimerNombre	=>
	(printout t "Escriba el nombre de la primera persona: " crlf )
	(bind ?PrimerNombre (read) )
	(assert (buscorelacioncon1 ?PrimerNombre))
)

(defrule pedirSegundoNombre		=>
		(printout t crlf "Escriba el nombre de la segunda persona: " crlf )
		(bind ?SegundoNombre (read) )
		(assert (buscorelacioncon2 ?SegundoNombre))
)

(defrule BuscoRelacion
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(Relacion (tipo ?rel)(persona1 ?nombre1)(persona2 ?nombre2))
	=>
	(printout t crlf ?nombre1 " es "?rel" de " ?nombre2 crlf)
)
