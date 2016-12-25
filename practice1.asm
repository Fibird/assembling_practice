		.model tiny
		count0_add equ 388h	;计时器0的地址
		count1_add equ 389h
		con8253_add equ 38bh
		io8259_0	equ	38eh	;8259奇地址
		io8259_1	equ	38fh	;8259偶地址
		pa_add equ 384h		;8255A口地址
		pb_add equ 385h		;8255B口地址
		con8255_add equ 387h
		.data
		
		.stack
		
		.code
		
		.startup
		;-----8253初始化设置------;
		;初始化计数器0
		mov dx,con8253_add
		mov al,36h
		out dx,al
		mov al,56h
		out dx,al
		;设置计数初值
		mov dx,count0_add
		mov ax,1000
		out dx,al
		mov al,ah
		out dx,al
		mov dx,count1_add
		mov al,200
		out dx,al
		;-----8255初始化设置------;
		mov dx,con8255_add
		mov al,82h
		out dx,al
		xor al,al
		mov dx,pa_add
		out dx,al
		
		call	init8259
		call	wriintvect
		sti
s:		nop
		jmp s
		
		
init8259	proc near
			mov	dx,io8259_0				
			mov	al,13h					;设置ICW1的控制字
			out	dx,al
			mov	dx,io8259_1
			mov	al,08h					;设置ICW2的控制字
			out	dx,al
			mov	al,09h					;设置ICW4的控制字
			out	dx,al
			mov	al,0feh					;设置OCW1的控制字
			out	dx,al
			ret
init8259	endp
		
wriintvect	proc near
			push ds
			mov ax,seg int_proc0
			mov ds,ax
			lea dx,int_proc0
			mov al,28h
			mov ah,25h
			int 21h
			pop ds
			ret
wriintvect	endp

int_proc0	proc near
			mov dx,pb_add
			in al,dx
			not al
			mov dx,pa_add
			out dx,al
			mov al,20h	;发出EOI指令表示中断结束
			out 20h,al
			iret
int_proc0	endp

			end