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
	(hombre "Juan Jose Aguilera Gonzalez")
	(mujer "Josefa Luque Ca�adas")
	(mujer "Aurora Reyes Zuheros")
	(hombre "Jose Reyes Peralvarez")
	(hombre "Santiago Gonzalez Torres")
	)
(deffacts hijs
	(hij_de "Alonso Zuheros Calvo" "Cristina Zuheros Montes")
	(hij_de "Maria del Carmen Montes Roldan" "Cristina Zuheros Montes")
	(hij_de "Alonso Zuheros Calvo" "Eva Maria Zuheros Montes")
	(hij_de "Maria del Carmen Montes Roldan" "Eva Maria Zuheros Montes")
	(hij_de "Alonso Zuheros Calvo" "Jose David Zuheros Montes")
	(hij_de "Maria del Carmen Montes Roldan" "Jose David Zuheros Montes")

	(hij_de "Maria del Rosario Montes Roldan" "Sonia Aguilera Montes")

	(hij_de "Jose Montes Roldan" "Lorena Montes Luque")
	(hij_de "Jose Montes Roldan" "Sergio Montes Luque")

	(hij_de "Manuel Montes Roldan" "Aurora Montes Reyes")

	(hij_de "Victoria Zuheros Calvo" "Mari Carmen Reyes Zuheros")
	(hij_de "Victoria Zuheros Calvo" "Francisco Cornelio Reyes Zuheros")

	(hij_de "Josefa Zuheros Calvo" "Rocio Gonzalez Zuheros")
	(hij_de "Josefa Zuheros Calvo" "Santiago Gonzalez Zuheros")
	(hij_de "Josefa Zuheros Calvo" "Antonia Gonzalez Zuheros")

	(hij_de "Manuel Montes Sanchez" "Maria del Rosario Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Jose Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Manuel Montes Roldan")
	(hij_de "Manuel Montes Sanchez" "Maria del Carmen Montes Roldan")
	(hij_de "Aurora Roldan Rodriguez" "Maria del Rosario Montes Roldan")
	(hij_de "Aurora Roldan Rodriguez" "Jose Montes Roldan")
	(hij_de "Aurora Roldan Rodriguez" "Manuel Montes Roldan")
	(hij_de "Aurora Roldan Rodriguez" "Maria del Carmen Montes Roldan")

	(hij_de "Pedro Zuheros Sanchez" "Alonso Zuheros Calvo")
	(hij_de "Pedro Zuheros Sanchez" "Victoria Zuheros Calvo")
	(hij_de "Pedro Zuheros Sanchez" "Josefa Zuheros Calvo")
	(hij_de "Antonia Calvo Gonzalez" "Alonso Zuheros Calvo")
	(hij_de "Antonia Calvo Gonzalez" "Victoria Zuheros Calvo")
	(hij_de "Antonia Calvo Gonzalez" "Josefa Zuheros Calvo")
	)
(deffacts matrimonios
	(casado "Maria del Rosario Montes Roldan" "Juan Jose Aguilera Gonzalez")
	(casado "Jose Montes Roldan" "Josefa Luque Caniadas")
	(casado "Manuel Montes Roldan" "Aurora Reyes Zuheros")
	(casado "Victoria Zuheros Calvo" "Jose Reyes Peralvarez")
	(casado "Josefa Zuheros Calvo" "Santiago Gonzalez Torres")
	)

(defrule son_hermans
	(hij_de ?padremadre ?hijo1)
	(hij_de ?padremadre ?hijo2)
	(test (neq ?hijo1 ?hijo2))	=>
	(assert (herman_de ?hijo1 ?hijo2))
	)
#Ya tendria mi arbol
#Ahora procedemos a buscar informacion en el

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

(defrule esHombre
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hombre ?nombre1)
	=>
	(printout t crlf ?nombre1 " es hombre")
)

(defrule esMujer
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(mujer ?nombre)
	=>
	(printout t crlf ?nombre " es mujer")
)

(defrule buscandoHermano
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(herman_de ?nombre ?nombre2)
	=>
	(printout t crlf "Su Hermano es: " ?nombre2)
	)

(defrule buscandoPadre
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	=>
	(printout t crlf "Su padre es : " ?nombre2)
	)

(defrule buscandoMadre
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	=>
	(printout t crlf "Su madre es : " ?nombre3)
	)

(defrule hijs
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre ?nombre2)
	=>
	(printout t crlf "Su hijo es : " ?nombre2)
	)

(defrule buscandoAbueloP
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(hij_de ?nombre3 ?nombre2)
	(casado ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su abuelo paterno es : " ?nombre3)
	(printout t crlf "Su abuela paterna es : " ?nombre4)
	)

(defrule buscandoAbueloM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	(hij_de ?nombre4 ?nombre3)
	(casado ?nombre4 ?nombre5)
	=>
	(printout t crlf "Su abuelo materno es : " ?nombre4)
	(printout t crlf "Su abuela materna es : " ?nombre5)
	)

(defrule buscandoTios
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(herman_de ?nombre2 ?nombre3)
	=>
	(printout t crlf "Su tio/a es : " ?nombre3)
	)

(defrule buscandoTiosM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	(herman_de ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su tio/a es : " ?nombre4)
	)

(defrule buscandoMatrimoniosTios
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(herman_de ?nombre2 ?nombre3)
	(casado ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su tio/a es : " ?nombre4)
	)

(defrule buscandoMatrimoniosTiosM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	(herman_de ?nombre3 ?nombre4)
	(casado ?nombre4 ?nombre5)
	=>
	(printout t crlf "Su tio/a es : " ?nombre5)
	)

(defrule buscandoMatrimoniosTias
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(herman_de ?nombre2 ?nombre3)
	(casado ?nombre4 ?nombre3)
	=>
	(printout t crlf "Su tio/a es : " ?nombre4)
	)

(defrule buscandoMatrimoniosTiasM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	(herman_de ?nombre3 ?nombre4)
	(casado ?nombre5 ?nombre4)
	=>
	(printout t crlf "Su tio/a es : " ?nombre5)
	)

(defrule buscandoPrimos
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(herman_de ?nombre2 ?nombre3)
	(hij_de ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su primo/a es : " ?nombre4)
	)

(defrule buscandoPrimosM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre)
	(casado ?nombre2 ?nombre3)
	(herman_de ?nombre3 ?nombre4)
	(hij_de ?nombre4 ?nombre5)
	=>
	(printout t crlf "Su primo/a es : " ?nombre5)
	)

(defrule buscandoSobrino
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(herman_de ?nombre ?nombre2)
	(hij_de ?nombre2 ?nombre3)
	=>
	(printout t crlf "Su sobrino/a es : " ?nombre3)
)

(defrule buscandoCunados
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(herman_de ?nombre ?nombre2)
	(casado ?nombre2 ?nombre3)
	=>
	(printout t crlf "Su cuñado/a es : " ?nombre3)
)

(defrule buscandoCunadas
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(herman_de ?nombre ?nombre2)
	(casado ?nombre3 ?nombre2)
	=>
	(printout t crlf "Su cuñado/a es : " ?nombre3)
)

(defrule buscandoSuegros
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(casado ?nombre ?nombre2)
	(hij_de ?nombre3 ?nombre2)
	(casado ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su suegros/as son : " ?nombre3 " y " ?nombre4 crlf)
)

(defrule buscandoSuegrosM
	(buscorelacioncon1 ?nombre)
	(buscorelacioncon2 ?nombre2)
	(casado ?nombre2 ?nombre)
	(hij_de ?nombre3 ?nombre2)
	(casado ?nombre3 ?nombre4)
	=>
	(printout t crlf "Su suegros/as son : " ?nombre3 " y " ?nombre4 crlf)
)
