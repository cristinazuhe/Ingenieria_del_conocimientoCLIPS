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
	(casado "Santiago Gonzalez Torres"  "Josefa Zuheros Calvo" ))

#################################################################################

(defrule es_matrimonio
		(casado ?casado1 ?casado2)
    (mujer ?casado2)
		=>
		(assert (Relacion (tipo "esposo")(persona1 ?casado1)(persona2 ?casado2))
            (Relacion (tipo "esposa")(persona1 ?casado2)(persona2 ?casado1))))

(defrule son_hermanas
	(hij_de ?padremadre ?hija1)
	(hij_de ?padremadre ?hija2)
	(test (neq ?hija1 ?hija2))
  (mujer ?hija1)
	=>
	(assert (Relacion (tipo "hermana")(persona1 ?hija1)(persona2 ?hija2))))

(defrule son_hermanos
	(hij_de ?padremadre ?hijo1)
	(hij_de ?padremadre ?hijo2)
	(test (neq ?hijo1 ?hijo2))
  (hombre ?hijo1)
	=>
	(assert (Relacion (tipo "hermano")(persona1 ?hijo1)(persona2 ?hijo2))))

(defrule es_hijo
			(casado ?casado1 ?casado2)
	    (hij_de ?casado1 ?hijo)
			(hombre ?hijo)
			=>
			(assert (Relacion (tipo "hijo")(persona1 ?hijo)(persona2 ?casado1))
		        	(Relacion (tipo "hijo")(persona1 ?hijo)(persona2 ?casado2))
							(Relacion (tipo "padre")(persona1 ?casado1)(persona2 ?hijo))
							(Relacion (tipo "madre")(persona1 ?casado2)(persona2 ?hijo))))

(defrule es_hija
			(casado ?casado1 ?casado2)
	    (hij_de ?casado1 ?hija)
			(mujer ?hija)
			=>
			(assert (Relacion (tipo "hija")(persona1 ?hija)(persona2 ?casado1))
		        	(Relacion (tipo "hija")(persona1 ?hija)(persona2 ?casado2))
							(Relacion (tipo "padre")(persona1 ?casado1)(persona2 ?hija))
							(Relacion (tipo "madre")(persona1 ?casado2)(persona2 ?hija))))

#################################################################################

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


##############################################################
################### Relacion:###################
##############################################################
(defrule BuscoRelacion
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(Relacion (tipo ?rel)(persona1 ?nombre1)(persona2 ?nombre2))
	=>
	(printout t crlf ?nombre1 " es "?rel" de " ?nombre2 crlf)
)
