; --- Mapeamento de Hardware (8051) ---
    RS      equ     P1.3    ;Reg Select ligado em P1.3
    EN      equ     P1.2    ;Enable ligado em P1.2


org 0000h
	LJMP START

org 0030h
START:
	acall lcd_init
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
	ACALL sendCharacter	; manda data no A para o modulo LCD
	ACALL clearDisplay
	LJMP vetor
	
	JMP $
vetor:
	MOV 30h,#01h
	MOV 31h,#02h
	MOV 32h,#03h
	MOV 33h,#04h
	MOV 34h,#05h
	MOV 35h,#06h
	MOV 36h,#07h
	RET


leituraTeclado:
	MOV R0, #0			; Clear no R0 - a primeira Key e a Key0

	; scan row0
	MOV P0, #0FFh	
	CLR P0.0			; clear row0
	CALL colScan		; chama a subrotina colScan
	JB F0, finish		; | se F0 esta setado, pula para o final do programa
						; | (porque a chave pressionada foi encontrada e o numero esta em R0)
	; scan row1
	SETB P0.0			; seta a row0
	CLR P0.1			; clear row1
	CALL colScan		; chama a subrotina colScan
	JB F0, finish		; | se F0 esta setado, pula para o final do programa
						; | (porque a chave pressionada foi encontrada e o numero esta em R0)
	; scan row2
	SETB P0.1			; set row1
	CLR P0.2			; clear row2
	CALL colScan		; chama a subrotina colScan
	JB F0, finish		; | se F0 esta setado, pula para o final do programa
						; | (porque a chave pressionada foi encontrada e o numero esta em R0)
	; scan row3
	SETB P0.2			; set row2
	CLR P0.3			; clear row3
	CALL colScan		; chama a subrotina colScan
	JB F0, finish		; | se F0 esta setado, pula para o final do programa
						; | (porque a chave pressionada foi encontrada e o numero esta em R0)
finish:
	RET

; subrotina colScan
colScan:
	JNB P0.4, gotKey	; se col0 esta clear - key encontrada 
	INC R0				; se nao va para a proxia key
	JNB P0.5, gotKey	; se col1 esta clear - key encontrada
	INC R0				; se nao va para a proxia key
	JNB P0.6, gotKey	; se col2 esta clear - key encontrada
	INC R0				; se nao va para a proxia key
	RET					; retorna da subrotina - key nao encontrada
gotKey:
	SETB F0				; key encontrada - set F0
	RET					; retorna da subrotina




; inicializa o display
; olha a intrucao para detalhes
lcd_init:

	CLR RS		; clear no RS - indica que as instrucoes estao sendo mandadas para o mudulo Clear no RS

; function set	
	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CALL delay		; Espera o clear do BF
					; funcao set enviada pela primeira vez - faz o modulo ir para o modo 4-bit


	SETB EN		; |
	CLR EN		; | edge negativa no E
					;  set high nibble uma segunda vez

	SETB P1.7		; low nibble set 

	SETB EN		; |
	CLR EN		; | edge negativa no E
				; funcao set low nibble 
	CALL delay		; espera o clear do BF


; set de modo de entrada
; set para incrementar sem mudança
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | set nibble high 

	SETB EN		; |
	CLR EN		; | edge negativa no E

	SETB P1.6		; |
	SETB P1.5		; |low nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CALL delay		; espera o clear do BF


; controle de ligar e desligar o display
; o display esta ligado o cursor esta ligado e piscando
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble 

	SETB EN		; |
	CLR EN		; | edge negativa no E

	SETB P1.7		; |
	SETB P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble 

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CALL delay		; espera o clear do BF
	RET


sendCharacter:
	SETB RS  		; setb RS - indica que os dados estao sendo mandados para o modulo
	MOV C, ACC.7		; |
	MOV P1.7, C			; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | edge negativa no E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | edge negativa no E

	CALL delay			; espera o clear do BF
	RET

;Posiciona o cursor na linha e coluna desejada.
;Escreva no Acumulador o valor de endereço da linha e coluna.
;|--------------------------------------------------------------------------------------|
;|linha 1 | 00 | 01 | 02 | 03 | 04 |05 | 06 | 07 | 08 | 09 |0A | 0B | 0C | 0D | 0E | 0F |
;|linha 2 | 40 | 41 | 42 | 43 | 44 |45 | 46 | 47 | 48 | 49 |4A | 4B | 4C | 4D | 4E | 4F |
;|--------------------------------------------------------------------------------------|
posicionaCursor:
	CLR RS	         ; clear RS - indica que as instrucoes estao sendo mandadas para o modulo
	SETB P1.7		    ; |
	MOV C, ACC.6		; |
	MOV P1.6, C			; |
	MOV C, ACC.5		; |
	MOV P1.5, C			; |
	MOV C, ACC.4		; |
	MOV P1.4, C			; | high nibble set

	SETB EN			; |
	CLR EN			; | edge negativa no E

	MOV C, ACC.3		; |
	MOV P1.7, C			; |
	MOV C, ACC.2		; |
	MOV P1.6, C			; |
	MOV C, ACC.1		; |
	MOV P1.5, C			; |
	MOV C, ACC.0		; |
	MOV P1.4, C			; | low nibble set

	SETB EN			; |
	CLR EN			; | edge negativa no E

	CALL delay			; espera o clear do BF
	RET


;Retorna o cursor para primeira posição sem limpar o display
retornaCursor:
	CLR RS	      ; clear RS - indica que as instrucoes estao sendo mandadas para o modulo
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CLR P1.7		; |
	CLR P1.6		; |
	SETB P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CALL delay		; espera o clear do BF
	RET


;Limpa o display
clearDisplay:
	CLR RS	      ; clear RS - indica que as instrucoes estao sendo mandadas para o modulo
	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	CLR P1.4		; | high nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CLR P1.7		; |
	CLR P1.6		; |
	CLR P1.5		; |
	SETB P1.4		; | low nibble set

	SETB EN		; |
	CLR EN		; | edge negativa no E

	CALL delay		; espera o clear do BF
	RET


delay:
	MOV R0, #50
	DJNZ R0, $
	RET
