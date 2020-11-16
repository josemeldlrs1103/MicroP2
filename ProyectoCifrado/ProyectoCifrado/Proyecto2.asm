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
Alerta1 DB "Entrada no reconocida, intente nuevamente.",13,10,0
;Variables para interacción con el usuario
Elegida DB 0,0
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
			print str$(1),13,10
			JMP Inicio
		CifradoV:
			print str$(2),13,10
			JMP Inicio
		DescifradoE:
			print str$(3),13,10
			JMP Inicio
		DescifradoV:
			print str$(4),13,10
			JMP Inicio
		Porcentaje:
			print str$(5),13,10
			JMP Inicio
	;Salida del programa
	Salida:
		INVOKE ExitProcess, 0
END Programa