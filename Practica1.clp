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
	(casado "Maria del Rosario Montes Roldan" "Juan Jose Aguilera Garcia")
	(casado "Jose Montes Roldan" "Josefa Luque Caniadas")
	(casado "Manuel Montes Roldan" "Aurora Reyes Zuheros")
	(casado "Victoria Zuheros Calvo" "Jose Reyes Peralvarez")
	(casado "Josefa Zuheros Calvo" "Santiago Gonzalez Torres")
	)

(defrule son_hijs
			(casado ?casado1 ?casado2)
			(hij_de ?casado1 ?hijo)
			=>
			(assert (hij_de ?casado2 ?hijo))
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

##############################################################
##Relaciones de hermanos/hermanas (3posibles combinaciones):##
##############################################################
(defrule sonHermanas
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(herman_de ?nombre1 ?nombre2)
	(mujer ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre1 " y " ?nombre2 " son hermanas. " crlf)
	)

(defrule sonHermanos1
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(herman_de ?nombre1 ?nombre2)
		(hombre ?nombre1)
		=>
		(printout t crlf ?nombre1 " y " ?nombre2 " son hermanos. " crlf)
)

(defrule sonHermanos2
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(herman_de ?nombre1 ?nombre2)
		(hombre ?nombre2)
		=>
		(printout t crlf ?nombre1 " y " ?nombre2 " son hermanos. " crlf)
)

##############################################################
################## Relaciones de padre/hija:##################
##############################################################
#Relacion de padre hija
(defrule esPadreHija1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre1)
	(hombre ?nombre2)
	(mujer ?nombre1)
	=>
	(printout t crlf ?nombre2 " es padre de " ?nombre1)
	(printout t crlf ?nombre1 " es hija de " ?nombre2 crlf)
)

(defrule esPadreHija2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre1 ?nombre2)
	(mujer ?nombre2)
	(hombre ?nombre1)
	=>
	(printout t crlf ?nombre1 " es padre de " ?nombre2)
	(printout t crlf ?nombre2 " es hija de " ?nombre1 crlf)
)


##############################################################
################## Relaciones de padre/hijo:##################
##############################################################
(defrule esPadreHijo1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre1 ?nombre2)
	(hombre ?nombre2)
	(hombre ?nombre1)
	=>
	(printout t crlf ?nombre1 " es padre de " ?nombre2)
	(printout t crlf ?nombre2 " es hijo de " ?nombre1 crlf)
)

(defrule esPadreHijo2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre1)
	(hombre ?nombre2)
	(hombre ?nombre1)
	=>
	(printout t crlf ?nombre2 " es padre de " ?nombre1)
	(printout t crlf ?nombre1 " es hijo de " ?nombre2 crlf)
)
##############################################################
################## Relaciones de madre/hijo:##################
##############################################################
#Relacion de padre hija
(defrule esMadreHijo1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre1)
	(mujer ?nombre2)
	(hombre ?nombre1)
	=>
	(printout t crlf ?nombre2 " es madre de " ?nombre1)
	(printout t crlf ?nombre1 " es hijo de " ?nombre2 crlf)
)

(defrule esMadreHijo2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre1 ?nombre2)
	(hombre ?nombre2)
	(mujer ?nombre1)
	=>
	(printout t crlf ?nombre1 " es madre de " ?nombre2)
	(printout t crlf ?nombre2 " es hijo de " ?nombre1 crlf)
)


##############################################################
################## Relaciones de madre/hija:##################
##############################################################
(defrule esMadreHija1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre1 ?nombre2)
	(mujer ?nombre2)
	(mujer ?nombre1)
	=>
	(printout t crlf ?nombre1 " es madre de " ?nombre2)
	(printout t crlf ?nombre2 " es hija de " ?nombre1 crlf)
)

(defrule esMadreHija2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre2 ?nombre1)
	(mujer ?nombre2)
	(mujer ?nombre1)
	=>
	(printout t crlf ?nombre2 " es madre de " ?nombre1)
	(printout t crlf ?nombre1 " es hija de " ?nombre2 crlf)
)

##############################################################
################# Relaciones de abuelo/nieto:#################
##############################################################
#Primero se pasa el nieto
(defrule esAbueloNieto1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(hij_de ?nombre2 ?nombre3)
	(hombre ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre2 " es abuelo de " ?nombre1)
	(printout t crlf ?nombre1 " es nieto de " ?nombre2 crlf)
)

#Primero se pasa el abuelo
(defrule esAbueloNieto2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre2)
	(hij_de ?nombre1 ?nombre3)
	(hombre ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre1 " es abuelo de " ?nombre2)
	(printout t crlf ?nombre2 " es nieto de " ?nombre1 crlf)
)

##############################################################
################# Relaciones de abuelo/nieta:#################
##############################################################
#Primero se pasa la nieta
(defrule esAbueloNieta1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(hij_de ?nombre2 ?nombre3)
	(mujer ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre2 " es abuelo de " ?nombre1)
	(printout t crlf ?nombre1 " es nieta de " ?nombre2 crlf)
)

#Primero se pasa el abuelo
(defrule esAbueloNieta2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre2)
	(hij_de ?nombre1 ?nombre3)
	(hombre ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre1 " es abuelo de " ?nombre2)
	(printout t crlf ?nombre2 " es nieta de " ?nombre1 crlf)
)

##############################################################
################# Relaciones de abuela/nieto:#################
##############################################################
#Primero se pasa el nieto
(defrule esAbuelaNieto1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(hij_de ?nombre2 ?nombre3)
	(hombre ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre2 " es abuela de " ?nombre1)
	(printout t crlf ?nombre1 " es nieto de " ?nombre2 crlf)
)

#Primero se pasa la abuela
(defrule esAbuelaNieto2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre2)
	(hij_de ?nombre1 ?nombre3)
	(mujer ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre1 " es abuela de " ?nombre2)
	(printout t crlf ?nombre2 " es nieto de " ?nombre1 crlf)
)

##############################################################
################# Relaciones de abuela/nieta:#################
##############################################################
#Primero se pasa la nieta
(defrule esAbuelaNieta1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(hij_de ?nombre2 ?nombre3)
	(mujer ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre2 " es abuela de " ?nombre1)
	(printout t crlf ?nombre1 " es nieta de " ?nombre2 crlf)
)

#Primero se pasa la abuela
(defrule esAbuelaNieta2
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre2)
	(hij_de ?nombre1 ?nombre3)
	(mujer ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre1 " es abuela de " ?nombre2)
	(printout t crlf ?nombre2 " es nieta de " ?nombre1 crlf)
)






##############################################################
################# Relaciones de tia/sobrina:#################
##############################################################
#Primero la sobrina
(defrule esTiaSobrina1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(herman_de ?nombre2 ?nombre3)
	(mujer ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre1 " es sobrina de " ?nombre2)
	(printout t crlf ?nombre2 " es tia de " ?nombre1 crlf)
	)

#Primero la tia
(defrule esTiaSobrina2
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(hij_de ?nombre3 ?nombre2)
		(herman_de ?nombre3 ?nombre1)
		(mujer ?nombre1)
		(mujer ?nombre2)
		=>
		(printout t crlf ?nombre2 " es sobrina de " ?nombre1)
		(printout t crlf ?nombre1 " es tia de " ?nombre2 crlf)
)


##############################################################
################# Relaciones de tia/sobrino:#################
##############################################################
#Primero el sobrino
(defrule esTiaSobrino1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(herman_de ?nombre2 ?nombre3)
	(hombre ?nombre1)
	(mujer ?nombre2)
	=>
	(printout t crlf ?nombre1 " es sobrino de " ?nombre2)
	(printout t crlf ?nombre2 " es tia de " ?nombre1 crlf)
	)

#Primero la tia
(defrule esTiaSobrino2
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(hij_de ?nombre3 ?nombre2)
		(herman_de ?nombre3 ?nombre1)
		(mujer ?nombre1)
		(hombre ?nombre2)
		=>
		(printout t crlf ?nombre2 " es sobrino de " ?nombre1)
		(printout t crlf ?nombre1 " es tia de " ?nombre2 crlf)
)


##############################################################
################# Relaciones de tio/sobrina:#################
##############################################################
#Primero la sobrina
(defrule esTioSobrina1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(herman_de ?nombre2 ?nombre3)
	(mujer ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre1 " es sobrina de " ?nombre2)
	(printout t crlf ?nombre2 " es tio de " ?nombre1 crlf)
	)

#Primero la tio
(defrule esTioSobrina2
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(hij_de ?nombre3 ?nombre2)
		(herman_de ?nombre3 ?nombre1)
		(hombre ?nombre1)
		(mujer ?nombre2)
		=>
		(printout t crlf ?nombre2 " es sobrina de " ?nombre1)
		(printout t crlf ?nombre1 " es tio de " ?nombre2 crlf)
)


##############################################################
################# Relaciones de tio/sobrino:#################
##############################################################
#Primero el sobrino
(defrule esTioSobrino1
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(hij_de ?nombre3 ?nombre1)
	(herman_de ?nombre2 ?nombre3)
	(hombre ?nombre1)
	(hombre ?nombre2)
	=>
	(printout t crlf ?nombre1 " es sobrino de " ?nombre2)
	(printout t crlf ?nombre2 " es tio de " ?nombre1 crlf)
	)

#Primero la tio
(defrule esTioSobrino2
		(buscorelacioncon1 ?nombre1)
		(buscorelacioncon2 ?nombre2)
		(hij_de ?nombre3 ?nombre2)
		(herman_de ?nombre3 ?nombre1)
		(hombre ?nombre1)
		(hombre ?nombre2)
		=>
		(printout t crlf ?nombre2 " es sobrino de " ?nombre1)
		(printout t crlf ?nombre1 " es tio de " ?nombre2 crlf)
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
