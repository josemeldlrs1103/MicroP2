.386																							;Definici�n del modelo del procesador
.MODEL flat, stdcall																			;Convenci�n del uso de par�metros
OPTION casemap:none																				;Convenci�n del mapeo de caracteres 
;Inclusi�n de librer�as utilizadas
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