;使用8255芯片控制七段数码管显示
.model tiny
CON_ADD		EQU		0f003h
PA_ADD		EQU		0f000h
PB_ADD		EQU		0f001h
PC_ADD		EQU		0f002h
.data 
	seg7	db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h
.stack

.code

.startup
	lea bx,seg7	;取seg7的起始偏移地址
	mov dx,CON_ADD
	mov al,81h
	out dx,al	;设置控制字
	mov dx,0f001h	;数码管的位控制地址
	mov al,7fh
	out dx,al	;选择数码管的第1位
	
again:	mov dx,PC_ADD
	in al,dx	;从C口读取4位开关的值
	and al,0fh	;保留低四位
	mov ah,0
	mov si,ax
	mov al,[bx+si]	;取出对应的编码
	mov dx,PA_ADD
	out dx,al		;输出到A口
	jmp again

end
