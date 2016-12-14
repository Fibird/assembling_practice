	.MODEL	TINY
EXTRN	Display8:NEAR
IO8259_0	EQU	0F000H
IO8259_1	EQU	0F001H
	.STACK      100
	.DATA    
BUFFER          DB      8 DUP(?)	;设置缓冲区
Counter		DB	?					;计数值
ReDisplayFlag	DB	0				;显示标志位
	.CODE
START:  	MOV     AX,@DATA
        	MOV     DS,AX
        	MOV	ES,AX
        	NOP
        	CALL	Init8259
        	CALL	WriIntver
		MOV	Counter,0	;中断次数
		MOV	ReDisplayFlag,1	;需要显示
		STI			;开中断
START1:		CMP	ReDisplayFlag,0
		JZ	START1					;检查显示标志位是否为1，即确定是否需要显示
		CALL	LedDisplay
		MOV	ReDisplayFlag,0			
		JMP	START1

Init8259	PROC	NEAR
		MOV	DX,IO8259_0				
		MOV	AL,13H					;设置ICW1的控制字
		OUT	DX,AL
		MOV	DX,IO8259_1
		MOV	AL,08H					;设置ICW2的控制字
		OUT	DX,AL
		MOV	AL,09H					;设置ICW4的控制字
		OUT	DX,AL
		MOV	AL,0FEH					;设置OCW1的控制字
		OUT	DX,AL
		RET
Init8259	ENDP

WriIntver	PROC	NEAR
		PUSH	ES
		MOV	AX,0
		MOV	ES,AX
		MOV	DI,20H
		LEA	AX,INT_0
		STOSW
		MOV	AX,CS
		STOSW
		POP	ES
		RET
WriIntver	ENDP

LedDisplay	PROC	NEAR
		MOV	AL,Counter
		MOV	AH,AL
		AND	AL,0FH
		MOV	Buffer,AL
		AND	AH,0F0H
		ROR	AH,4
		MOV	Buffer + 1,AH
		MOV	Buffer + 2,10H		;高六位不需要显示
		MOV	Buffer + 3,10H
		MOV	Buffer + 4,10H
		MOV	Buffer + 5,10H
		MOV	Buffer + 6,10H
		MOV	Buffer + 7,10H
		LEA	SI,Buffer
		CALL	Display8
		RET
LedDisplay	ENDP

INT_0:		PUSH	DX
		PUSH	AX
		MOV	AL,Counter
		ADD	AL,1
		DAA
		MOV	Counter,AL
		MOV	ReDisplayFlag,1
		MOV	DX,IO8259_0
		MOV	AL,20H
		OUT	DX,AL
		POP	AX
		POP	DX
		IRET
		
		END	START
