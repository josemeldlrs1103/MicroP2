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
Alerta1 DB "Entrada no reconocida, intente nuevamente.",13,10,0
Alerta2 DB "Se ha encontrado una letra minuscula, recuerde que este programa funciona con letras mayusculas.",13,10,0
;Variables para interacción con el usuario
Elegida DB 0,0
Mensaje DB 100 DUP (0),0
ClaveUsuario DB 100 DUP (0),0
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
			JMP Inicio
		CifradoV:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			JMP Inicio
		DescifradoE:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			JMP Inicio
		DescifradoV:
			CALL LecturaMensaje
			CALL LecturaClave
			CALL ValMayus
			JMP Inicio
		Porcentaje:
			CALL LecturaMensaje
			CALL ValMayus
			JMP Inicio
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
END Programa