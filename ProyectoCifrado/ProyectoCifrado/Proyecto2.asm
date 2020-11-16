.386																							;Definición del modelo del procesador
.MODEL flat, stdcall																			;Convención del uso de parámetros
OPTION casemap:none																				;Convención del mapeo de caracteres 
;Inclusión de librerías utilizadas
INCLUDE \masm32\include\windows.inc
INCLUDE \masm32\include\kernel32.inc
INCLUDE \masm32\include\masm32.inc
INCLUDE \masm32\include\masm32rt.inc
.DATA
MatrizGuia DB "ABCDEFGHIJKLMNOPQRSTUVWXYZ",0
.CODE
Programa:
	INVOKE StdOut, ADDR MatrizGuia
	;Salida del programa
	Salida:
		INVOKE ExitProcess, 0
END Programa