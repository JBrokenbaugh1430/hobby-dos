bits 16

org 0x0700

mov sp, 0xF000
; glb main : () void
section .text
	global	_main
_main:
	push	bp
	mov	bp, sp
	;sub	sp,          0

section .rodata
L3:
	db	13,10,"Welcome!",13,10
	times	1 db 0

section .text
; RPN'ized expression: "( L3 puts ) "
; Expanded expression: " L3  puts ()2 "
; Fused expression:    "( L3 , puts )2 "
	push	L3
	call	_puts
	sub	sp, -2
jmp $

; Fused expression:    "0  "
	mov	ax, 0
L1:
	leave
	ret

; glb putc : (
; prm     c : char
;     ) void
section .text
	global	_putc
_putc:
	push	bp
	mov	bp, sp
	 sub	sp,          2
; loc     c : (@4) : char
; loc     var : (@-2) : char
; RPN'ized expression: "var 102 = "
; Expanded expression: "(@-2) 102 =(-1) "
; Fused expression:    "=(170) *(@-2) 102 "
	mov	ax, 102
	mov	[bp-2], ax
mov ah, 0x0E
mov byte al, [bp-2]
int 0x10

mov ah, 0x0E
mov byte al, [bp+4]
int 0x10

; return
L4:
	leave
	ret

; glb puts : (
; prm     string : * char
;     ) void
section .text
	global	_puts
_puts:
	push	bp
	mov	bp, sp
	;sub	sp,          0
; loc     string : (@4) : * char
push si
mov si, [bp+4]
load_char:
lodsb
cmp al, 0
jz exit
mov ah, 0x0E
int 0x10
jmp load_char
exit:
pop si

; return
L6:
	leave
	ret



; Syntax/declaration table/stack:
; Bytes used: 140/15360


; Macro table:
; Macro __SMALLER_C__ = `0x0100`
; Macro __SMALLER_C_16__ = ``
; Macro __SMALLER_C_SCHAR__ = ``
; Macro __SMALLER_C_UWCHAR__ = ``
; Macro __SMALLER_C_WCHAR16__ = ``
; Bytes used: 110/5120


; Identifier table:
; Ident 
; Ident __floatsisf
; Ident __floatunsisf
; Ident __fixsfsi
; Ident __fixunssfsi
; Ident __addsf3
; Ident __subsf3
; Ident __negsf2
; Ident __mulsf3
; Ident __divsf3
; Ident __lesf2
; Ident __gesf2
; Ident main
; Ident putc
; Ident c
; Ident puts
; Ident string
; Bytes used: 152/5632

; Next label number: 8
; Compilation succeeded.
