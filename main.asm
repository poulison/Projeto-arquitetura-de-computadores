
;Paulo Andre de Oliveira Hirata RA:24.123.086-1
;Victor Merker Binda RA:24.123.086-0


; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2 ;Enable ligado em P1.2


org 0000h
	LJMP START

org 0030h
START:
	CLR A
	MOV R0, A
	MOV R1, A
	MOV R2, A
	MOV R3, A
	mov 60h, a
	MOV r5, A
	CLR F0
	
 	MOV 41H, #0
	MOV 43H, #9
	MOV 44H, #8
	MOV 45H, #7
	MOV 46H, #6
	MOV 47H, #5
	MOV 48H, #4
	MOV 49H, #3
	MOV 4AH, #2
	MOV 4BH, #1

	MOV 30H,#1;MONTANDO O VETRO QUE VAI SERVIR PARA MEMORIA
	MOV 31h,#2
	MOV 32h,#3
	MOV 33h,#4
	MOV 34h,#5
	MOV 35h,#6
	MOV 36h,#7
	MOV R1, #30H

  

	acall lcd_init
	mov A,#0000h
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	MOV A, #'M'
	ACALL sendCharacter
	MOV A, #'E'
	ACALL sendCharacter	
	MOV A, #'M'
	ACALL sendCharacter
	MOV A, #'O'
	ACALL sendCharacter
	MOV A, #'R'
	ACALL sendCharacter
	MOV A, #'I'
	ACALL sendCharacter
	MOV A, #'Z'
	ACALL sendCharacter
	MOV A, #'E'
	ACALL sendCharacter	
	CALL delay
	ACALL clearDisplay
	

	
	acall lcd_init
	clr a
	mov A,#0000h
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	MOV A, #'A'
	ACALL sendCharacter	
	MOV A, #' '
	ACALL sendCharacter
	MOV A, #'S'
	ACALL sendCharacter
	MOV A, #'E'
	ACALL sendCharacter
	MOV A, #'Q'
	ACALL sendCharacter
	MOV A, #'U'
	ACALL sendCharacter
	MOV A, #'E'
	ACALL sendCharacter	
	MOV A, #'N'
	ACALL sendCharacter
	MOV A, #'C'
	ACALL sendCharacter	
	MOV A, #'I'
	ACALL sendCharacter
	MOV A, #'A'
	ACALL sendCharacter		
	CALL delay
	ACALL clearDisplay

	ACALL aparecerNumero
	ACALL UM_NUMERO
	inc 60h	;incrementa pra proxima vez que ele passar
	INC R1;NESTE MOMENTO R1=31

	ACALL aparecerNumero
	MOV A, 30h

	ACALL UM_NUMERO
	inc 60h
	INC R1
	
	JMP $
	
UM_NUMERO:

	ACALL leituraTeclado
	JNB F0, UM_NUMERO
	CALL delay

	MOV A,#40H
	ADD A,R0
	MOV R0,A
	MOV A,@R0
	MOV R0,A

	MOV A, 30h
	CJNE A,00H,derrota;VOU ADICIONAR UM CONTADOR PARA RECICLAR A FUNCAO 
	MOV R0, #00H
	mov r6,#3
	MOV A, 60h
	CLR F0
	CJNE A,#0,DOIS_NUMEROS
	RET

DOIS_NUMEROS:
	ACALL leituraTeclado
	JNB F0, DOIS_NUMEROS
	CALL delay
	MOV A,#40H

	ADD A,R0
	MOV R0,A
	MOV A,@R0
	MOV R0,A

	MOV A,31H
	CJNE A,00H,derrota
	MOV R0, #00H
	CLR F0
	MOV A, 60h
	CJNE A,#1,TRES_NUMEROS
	RET

TRES_NUMEROS:
NOP
QUSTRO_NUMEROS:
NOP
CINCO_NUMEROS:
NOP
SEIS_NUMEROS:
NOP
SETE_NUMEROS:
NOP

derrota:
	ACALL clearDisplay
	mov a, #0000h
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor
	acall lcd_init
	MOV A, #'E'
	ACALL sendCharacter
	MOV A, #'R'
	ACALL sendCharacter	
	MOV A, #'R'
	ACALL sendCharacter
	MOV A, #'O'
	ACALL sendCharacter
	MOV A, #'U'
	ACALL sendCharacter	; manda data no A para o modulo LCD
	ACALL clearDisplay
	LJMP START
aparecerNumero:
	MOV A, #0H
	ACALL posicionaCursor
	ACALL posicionaCursor
	ACALL posicionaCursor       ; Carrega o endereço 30H em R0
	acall lcd_init        ; Carrega o valor armazenado no endereço 30H no acumulador
	mov A,#06H
	ACALL posicionaCursor
	MOV A,@r1
	MOV B, #10
	div AB
	ADD A,#30H
	acall sendCharacter
	MOV A,B
	ADD A,#30H
	ACALL sendCharacter
	ACALL clearDisplay
	ret

leituraTeclado:
	MOV R0, #0			; clear R0 - the first key is key0

	; scan row0
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row1
	SETB P0.0			; set row0
	CLR P0.1			; clear row1
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row2
	SETB P0.1			; set row1
	CLR P0.2			; clear row2
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	; scan row3
	SETB P0.2			; set row2
	CLR P0.3			; clear row3
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
finish:
	RET

; column-scan subroutine
colScan:
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0				; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0				; otherwise move to next key
	RET					; return from subroutine - key not found
gotKey:
	SETB F0				; key found - set F0
	RET					; and return from subroutine




; initialise the display
; see instruction set for details
lcd_init:

	CLR RS		; clear RS - indicates that instructions are being sent to the module

; function set	
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear	
					; function set sent for first time - tells module to go into 4-bit mode
; Why is function set high nibble sent twice? See 4-bit operation on pages 39 and 42 of HD44780.pdf.

	SETB EN		; |
	CLR EN		; | negative edge on E
					; same function set high nibble sent a second time

	SETB P1.7		; low nibble set (only P1.7 needed to be changed)

	SETB EN		; |
	CLR EN		; | negative edge on E
				; function set low nibble sent
	CALL delay		; wait for BF to clear


; entry mode set
; set to increment with no shift
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear


; display on/off control
; the display is turned on, the cursor is turned on and blinking is turned on
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


sendCharacter:
	SETB RS  		; setb RS - indicates that data is being sent to module
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endere o da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | negative edge on E

	CALL delay			; wait for BF to clear
	CALL delay			; wait for BF to clear
	RET


;Retorna o cursor para primeira posi  o sem limpar o display
retornaCursor:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


;Limpa o display
clearDisplay:
	CLR RS	
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | negative edge on E

	CALL delay		; wait for BF to clear
	RET


delay:
	MOV R7, #50
	DJNZ R7, $
	RET





venceu:	
	acall lcd_init
	MOV A, #'A'
	ACALL sendCharacter
	MOV A, #'C'
	ACALL sendCharacter	
	MOV A, #'R'
	ACALL sendCharacter
	MOV A, #'T'
	ACALL sendCharacter
	MOV A, #'O'
	ACALL sendCharacter
	MOV A, #'U'
	ACALL sendCharacter
	ACALL clearDisplay
	LJMP START

	

	
