;ʹ��8255оƬ�����߶��������ʾ
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
	lea bx,seg7	;ȡseg7����ʼƫ�Ƶ�ַ
	mov dx,CON_ADD
	mov al,81h
	out dx,al	;���ÿ�����
	mov dx,0f001h	;����ܵ�λ���Ƶ�ַ
	mov al,7fh
	out dx,al	;ѡ������ܵĵ�1λ
	
again:	mov dx,PC_ADD
	in al,dx	;��C�ڶ�ȡ4λ���ص�ֵ
	and al,0fh	;��������λ
	mov ah,0
	mov si,ax
	mov al,[bx+si]	;ȡ����Ӧ�ı���
	mov dx,PA_ADD
	out dx,al		;�����A��
	jmp again

end
