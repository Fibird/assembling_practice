.model small

.data 
	seg7	db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h
.stack

.code

.startup
	lea bx,seg7
	mov dx,0f003h
	mov al,81h
	out dx,al	;设置控制字
	mov dx,0f001h	;数码管的位控制地址
	mov al,7fh
	out dx,al	;选择数码管的第1位
	
again:	mov dx,0f002h
	in al,dx
	and al,0fh
	mov ah,0
	mov si,ax
	mov al,[bx+si]
	mov dx,0f000h
	out dx,al
	jmp again

end
