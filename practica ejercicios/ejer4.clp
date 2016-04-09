(deftemplate Relacion
  (slot tipo)
  (multislot persona1)
  (multislot persona2))

(deffacts personas
	(mujer "Eva Zuheros Montes")
	(mujer "Cristina Zuheros Montes")
	(hombre "Alonso Zuheros Calvo")
	(mujer "MCMR"))

(deffacts hijs
	(hij_de "Alonso Zuheros Calvo" "Cristina Zuheros Montes")
	(hij_de "Alonso Zuheros Calvo" "Eva Zuheros Montes")	)

(deffacts matrimonios
  (casado "Alonso Zuheros Calvo" "MCMR"))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HERMANOS;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule son_hermanas
	(hij_de ?padremadre ?hija1)
	(hij_de ?padremadre ?hija2)
	(test (neq ?hija1 ?hija2))
  (mujer ?hija1)
	=>
	(assert (Relacion (tipo "hermana")(persona1 ?hija1)(persona2 ?hija2)))
	(assert (herman_de ?hija1 ?hija2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defrule pedirPrimerNombre	=>
	(printout t "Escriba el nombre de la primera persona: " crlf )
	(bind ?PrimerNombre (read) )
	(assert (buscorelacioncon1 ?PrimerNombre)))

(defrule pedirSegundoNombre		=>
		(printout t crlf "Escriba el nombre de la segunda persona: " crlf )
		(bind ?SegundoNombre (read) )
		(assert (buscorelacioncon2 ?SegundoNombre)))

(defrule BuscoRelacion
	(buscorelacioncon1 ?nombre1)
	(buscorelacioncon2 ?nombre2)
	(Relacion (tipo ?rel)(persona1 ?nombre1)(persona2 ?nombre2))
	=>
	(printout t crlf ?nombre1 " es "?rel" de " ?nombre2 crlf))
