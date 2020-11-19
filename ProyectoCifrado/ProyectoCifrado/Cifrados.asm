.386																							;Definición del modelo del procesador
.MODEL flat, stdcall																			;Convención del uso de parámetros
OPTION casemap:none																				;Convención del mapeo de caracteres 
;Inclusión de librerías utilizadas
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
;Cadena con el contenido de cada fila en la matriz
MatrizGuia DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
;Menu
Menu DB "Elija una opcion:",13,10,"1-Cifrado estandar",13,10,"2-Cifrado con variante",13,10,"3-Descifrado estandar",13,10,"4-Decifrado con variante",13,10,"5- Calcular porcentaje de ocurrencia",13,10,"6- Salir",13,10,0
SolMensaje DB "Ingrese la cadena para operar: ",0
SolClave DB "Ingrese la clave de cifrado: ",0
Resultado DB "La cadena procesada es: ",0
ResultadoProbabilidades DB "Basado en la cadena ingresada las probabilidades de ocurrencia de cada letra para este idioma son:",13,10,0
Alerta1 DB "Entrada no reconocida, intente nuevamente.",13,10,0
Alerta2 DB "Se ha encontrado una letra minuscula, recuerde que este programa funciona con letras mayusculas.",13,10,0
;Variables para interacción con el usuario
Elegida DB 0,0
Mensaje DB 100 DUP (0),0
ClaveUsuario DB 100 DUP (0),0
;Variables para operaciones internas
ClaveModificada DB 100 DUP (0),0
ContadorLetras DB 30 DUP (0),0
LongitudM DB 0,0
PosInicial DB 0,0
Desplazamiento DB 0,0
IndiceActual DB 0,0
IndiceAux DB 0,0
Caracter DB 0,0
LongitudClave DB 0,0
LongitudMen DB 0,0
.CODE
Programa:
	Inicio:
		INVOKE StdOut, ADDR Menu
		INVOKE StdIn, ADDR Elegida, 10
		CMP Elegida, 31h 
		JE CifradoE
		CMP Elegida, 32h 
		JE CifradoV
		CMP Elegida, 33h 
		JE DescifradoE
		CMP Elegida, 34h 
		JE DescifradoV
		CMP Elegida, 35h 
		JE Porcentaje
		CMP Elegida, 36h 
		JE Salida
		INVOKE StdOut, ADDR Alerta1
		JMP Inicio
		CifradoE:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			CALL LongitudMensaje
			CALL EmpatarClaveE
			INVOKE StdOut, ADDR Resultado
			CALL CifrarMensaje
			JMP Salida
		CifradoV:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			CALL LongitudMensaje
			CALL EmpatarClaveV
			INVOKE StdOut, ADDR Resultado
			CALL CifrarMensaje
			JMP Salida
		DescifradoE:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			CALL LongitudMensaje
			CALL EmpatarClaveE
			INVOKE StdOut, ADDR Resultado
			CALL DescifrarMensajeE
			JMP Salida
		DescifradoV:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			CALL LongitudMensaje
			MOV AL, LongitudM
			MOV LongitudMen,AL
			CALL EmpateParcialV
			INVOKE StdOut, ADDR Resultado
			CALL DescifrarMensajeV
			JMP Salida
		Porcentaje:
			CALL LecturaMensaje
			CALL ValMayus
			INVOKE StdOut, ADDR ResultadoProbabilidades
			CALL LongitudMensaje
			CALL CalcularPorcentajes
			CALL LongitudMensaje
			CALL ImprimirProbabilidades
			JMP Salida
	;Salida del programa
	Salida:
		INVOKE ExitProcess, 0
	;Lectura del mensaje ya sea en claro o cifrado
	LecturaMensaje PROC Near
	INVOKE StdOut, ADDR SolMensaje
	INVOKE StdIn, ADDR Mensaje, 99
	ret
	LecturaMensaje ENDP
	;Lectura de la clave de cifrado
	LecturaClave PROC Near
	INVOKE StdOut, ADDR SolClave
	INVOKE StdIn, ADDR ClaveUsuario, 99
	ret
	LecturaClave ENDP
	;Validar que no haya letras minúsculas en las cadenas ingresadas
	ValMayus PROC Near
		LEA ESI, Mensaje
		LEA EDI, ClaveUsuario
		ValMensaje:
			MOV AL, [ESI]
			CMP AL, 0h
			JE ValClave
			CMP AL, 41h
			JL Advertencia
			CMP AL, 5Ah
			JG Advertencia
			INC ESI
			JMP ValMensaje
		ValClave:
			MOV AL, [EDI]
			CMP AL, 0h
			JE TerminarValMayus
			CMP AL, 41h
			JL Advertencia
			CMP AL, 5Ah
			JG Advertencia
			INC EDI
			JMP ValClave
		Advertencia:
			INVOKE StdOut, ADDR Alerta2
			JMP Inicio
		TerminarValMayus:
	ret
	ValMayus ENDP
	;Calcula la longitud de la cadena con el mensaje
	LongitudMensaje PROC Near
		LEA ESI, Mensaje
		Conteo:
			MOV AL, [ESI]
			CMP AL, 0h
			JE FinConteo
			INC LongitudM
			INC ESI
			JMP Conteo
		FinConteo:
	ret
	LongitudMensaje ENDP
	;Convierte la clave ingresada por el usuario a la misma longitud que la cadena del mensaje
	EmpatarClaveE PROC Near
		XOR CX, CX
		MOV CL, LongitudM
		LEA ESI, ClaveModificada
		BaseClaveU:
			LEA EDI, ClaveUsuario
			CMP CX,0h
			JE FinEmpatadoE
			EmpatadoE:
				MOV AL, [EDI]
				CMP AL, 0h
				JE BaseClaveU
				MOV [ESI],AL
				INC ESI
				INC EDI
				LOOP EmpatadoE
			FinEmpatadoE:
	ret
	EmpatarClaveE ENDP
	;Convierte la clave ingresada por el usuario con la variente del algoritmo para igualar la longitud del mensaje y la clave
	EmpatarClaveV PROC Near
		XOR CX, CX
		MOV CL, LongitudM
		LEA ESI, ClaveModificada
		LEA EDI, ClaveUsuario
		JMP EmpatadoV
		BaseMensaje:
			LEA EDI, Mensaje
		EmpatadoV:
			CMP CX,0h
			JE FinEmpatadoV
			MOV AL, [EDI]
			CMP AL, 0h
			JE BaseMensaje
			MOV [ESI], AL
			INC ESI
			INC EDI
			DEC CX
			JMP EmpatadoV
		FinEmpatadoV:
	ret
	EmpatarClaveV ENDP
	;Convierte la primera parte de la clave para descifrar con la variante del algoritmo
	EmpateParcialV PROC Near
		LEA ESI, ClaveUsuario
		LEA EDI, ClaveModificada
		EmpatadoPV:
			MOV AL, [ESI]
			CMP AL,0h
			JE SalirEmpatePV
			MOV [EDI],AL
			INC ESI
			INC EDI
			INC LongitudClave
			JMP EmpatadoPV
		SalirEmpatePV:
	ret
	EmpateParcialV ENDP
	;Calcula la posición en la que se inicia el recorrido de la cadena MatrizGuia
	CalcularPosInicio PROC Near
		LEA ESI, ClaveModificada
		MOV AL, IndiceActual
		MOV IndiceAux, AL
		PI: 
			MOV AL, IndiceAux
			CMP AL, 0h
			JE SalirPI
			INC ESI
			DEC IndiceAux
			JMP PI
		SalirPI:
		LEA EDI, MatrizGuia
		MOV PosInicial, 0h
		AumentoPI:
			MOV AL, [ESI]
			MOV BL, [EDI]
			CMP AL, BL
			JE FinAumentoPI
			INC PosInicial
			INC EDI
			JMP AumentoPI
		FinAumentoPI:
	ret
	CalcularPosInicio ENDP
	;Calcula la cantidad de posiciones a desplazar en la cadena MatrizGuia
	CalcularDesplazamiento PROC Near
		LEA ESI, Mensaje
		MOV AL, IndiceActual
		MOV IndiceAux, AL
		Desp: 
			MOV AL, IndiceAux
			CMP AL, 0h
			JE SalirDesp
			INC ESI
			DEC IndiceAux
			JMP Desp
		SalirDesp:
		LEA EDI, MatrizGuia
		MOV Desplazamiento, 0h
			AumentoDesp:
				MOV AL, [ESI]
				MOV BL, [EDI]
				CMP AL, BL 
				JE FinAumentoDesp
				INC Desplazamiento
				INC EDI
				JMP AumentoDesp
			FinAumentoDesp:
	ret
	CalcularDesplazamiento ENDP
	;Cifrar caracter según indice actual de la cadena
	CarCifrado PROC Near
		LEA ESI, MatrizGuia
		AlcanzarPI:
			INC ESI
			DEC PosInicial
			MOV BL, PosInicial
			CMP BL, 0h
			JNE AlcanzarPI
		DesplazarCar:
			MOV AL, [ESI]
			CMP AL, 0h
			JE ReiniciarMatrizGuia
			MOV BL, Desplazamiento
			CMP BL, 0h
			JE SalidaCarCifrado
			INC ESI
			DEC Desplazamiento
			JMP DesplazarCar
		ReiniciarMatrizGuia:
			LEA ESI, MatrizGuia
			JMP DesplazarCar
		SalidaCarCifrado:
	ret
	CarCifrado ENDP
	;Ciclo cifrado completo
	CifrarMensaje PROC Near
		CifraIndividual:
			CALL CalcularPosInicio
			CALL CalcularDesplazamiento
			CALL CarCifrado
			MOV Caracter, AL
			INVOKE StdOut, ADDR Caracter
			INC IndiceActual
			DEC LongitudM
			MOV BL, LongitudM
			CMP BL, 0h
			JNE CifraIndividual
			print chr$(10,13)
	ret 
	CifrarMensaje ENDP
	;Descifrar caracter por método estándar
	CarDescifradoE PROC Near
		LEA ESI, MatrizGuia
		AlcanzarDesp:
			MOV BL, Desplazamiento
			CMP BL, 0h
			JE RegresarPosI
			INC ESI
			DEC Desplazamiento
			JMP AlcanzarDesp
		RegresarPosI:
			MOV AL, [ESI]
 			CMP AL, 0h
			JE ColaMatrizGuia
			MOV BL, PosInicial
			CMP BL, 0h
			JE SalirCarDescifrado
			DEC ESI
			DEC PosInicial
			JMP RegresarPosI
		ColaMatrizGuia:
			MOV CL, 19h
			LEA ESI, MatrizGuia
			ColMat:
				INC ESI
				DEC CL
				CMP CL, 0
				JE RegresarPosI
				JMP ColMat
		SalirCarDescifrado:
	ret
	CarDescifradoE ENDP
	;Descifrar por método estándar
	DescifrarMensajeE PROC Near
		DescifrarCarE:
			CALL CalcularPosInicio
			CALL CalcularDesplazamiento
			CALL CarDescifradoE
			MOV Caracter, AL
			INVOKE StdOut, ADDR Caracter
			INC IndiceActual
			DEC LongitudM
			MOV BL, LongitudM
			CMP BL, 0h
			JNE DescifrarCarE
			print chr$(10,13)
	ret
	DescifrarMensajeE ENDP
	;Ingresa el caracter descifrado a la clave
	RegistrarCaracter PROC Near
		MOV AL, LongitudMen
		MOV BL, LongitudClave
		CMP AL,BL
		JE SalirRegistro
		LEA ESI, ClaveModificada
		MOV AL, LongitudClave
		LlegarIndiceClave:
			INC ESI
			DEC AL
			CMP AL, 0h
			JNE LlegarIndiceClave
			MOV [ESI],DL
		SalirRegistro:
		INC LongitudClave
	ret
	RegistrarCaracter ENDP
	;Descifrar por método con variante
	DescifrarMensajeV PROC Near
		DescifrarCarV:
			CALL CalcularPosInicio
			CALL CalcularDesplazamiento
			CALL CarDescifradoE
			MOV DL,AL
			CALL RegistrarCaracter
			CALL CalcularPosInicio
			CALL CalcularDesplazamiento
			CALL CarDescifradoE
			MOV Caracter, AL
			INVOKE StdOut, ADDR Caracter
			INC IndiceActual
			DEC LongitudM
			MOV BL, LongitudM
			CMP BL, 0h
			JNE DescifrarCarV
			print chr$(10,13)
	ret
	DescifrarMensajeV ENDP
	;Contar el porcentaje de probabilidad de ocurrencia para cada letra
	CalcularPorcentajes PROC Near
		ContarLetra:
			MOV AL, LongitudM
			CMP AL, 0h
			JE SalirConteoLetra
			CALL CalcularDesplazamiento
			MOV AL, Desplazamiento
			LEA ESI, ContadorLetras
			AumentarLetra:
				CMP AL, 0h
				JE FinAumentoLetra
				INC ESI
				DEC AL
				JMP AumentarLetra
			FinAumentoLetra:
			MOV AL, [ESI]
			INC AL
			MOV [ESI], AL
			INC IndiceActual
			DEC LongitudM
			JMP ContarLetra
		SalirConteoLetra:
	ret
	CalcularPorcentajes ENDP
	;Imprimir las probabilidades calculadas
	ImprimirProbabilidades PROC Near
		LEA ESI, ContadorLetras
		ImprimirLetra:
			MOV AL, IndiceAux
			CMP AL, 1Ah
			JE TerminarImpresion
			ADD AL, 41h
			MOV Caracter, AL
			INVOKE StdOut, ADDR Caracter
			print chr$(9)
			MOV AL, [ESI]
			print str$(AL)
			print chr$(47)
			MOV AL, LongitudM
			print str$(AL)
			print chr$(10)
			INC ESI
			INC IndiceAux
			JMP ImprimirLetra
			TerminarImpresion:
	ret
	ImprimirProbabilidades ENDP
END Programa