.model tiny

;8255地址设置
pa_add equ 0f000h  ;输出口，数码管显示内容控制端口地址
control8255_add equ 0f003h ;控制端口

;计数器地址设置
count0_add equ 0e000h
control8253_add equ 0e003h

.data
    seg7 db 3fh,06h,5bh,4fh,66h,6dh,7dh,07h,7fh,67h,77h,7ch,39h,5eh,79h,71h;查找表
.stack

.code

.startup
	mov dx,control8255_add;初始化8255
	mov al,80h
	out dx,al
	
    mov dx,control8253_add;计数器0初始化
	mov al,10h       ;写控制字
	out dx,al
	
	mov al,10h        ;设置计数初值
	mov dx,count0_add
	out dx,al
	
  s:mov al,0h        ;设置锁存控制字
	mov dx,control8253_add
	out dx,al        ;锁存数据

	mov al,10h       ;设置读取锁存器低8位控制字
	mov dx,count0_add
	in al,dx         ;读取count0的当前计数值
	
	lea bx,seg7
	mov ah,0
	mov si,ax
	mov al,[bx+si]
	
	mov dx,pa_add
	out dx,al
	jmp s
	
end