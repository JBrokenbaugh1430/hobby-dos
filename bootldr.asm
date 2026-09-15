bits 16

org 0x7C3D

; glb uint8_t : unsigned char
; glb uint16_t : unsigned
; glb DiskAddressPacket : struct <something>
; glb kernel_name : * char
section .data
	align 2
	global	_kernel_name
_kernel_name:
; =

section .rodata
L1:
	db	"KERNEL BIN"
	times	1 db 0

section .data
; RPN'ized expression: "L1 "
; Expanded expression: "L1 "
	dw	L1

; glb boot : () void
section .text
	global	_boot
_boot:
	push	bp
	mov	bp, sp
	;sub	sp,          0
mov ax, 0xB800
mov es, ax
mov di, 0
mov cx, 1000
mov ax, 0x0720
rep stosw
mov bh, 0
mov dx, 0
mov ah, 0x02
int 0x10


section .rodata
L4:
	db	"B"
	times	1 db 0

section .text
; RPN'ized expression: "( L4 puts ) "
; Expanded expression: " L4  puts ()2 "
; Fused expression:    "( L4 , puts )2 "
	push	L4
	call	_puts
	sub	sp, -2
; RPN'ized expression: "( load_kernel ) "
; Expanded expression: " load_kernel ()0 "
; Fused expression:    "( load_kernel )0 "
	call	_load_kernel
read_failed:


section .rodata
L5:
	db	13,10,"E"
	times	1 db 0

section .text
; RPN'ized expression: "( L5 puts ) "
; Expanded expression: " L5  puts ()2 "
; Fused expression:    "( L5 , puts )2 "
	push	L5
	call	_puts
	sub	sp, -2
check_key:mov ah, 0x01
int 0x16
jz check_key
mov ah, 0x0E
mov al, 'k'
int 0x10
mov dx, 0x64
mov al, 0xFE
out dx, al

L2:
	leave
	ret

; glb load_kernel : () void
section .text
	global	_load_kernel
_load_kernel:
	push	bp
	mov	bp, sp
	 sub	sp,          2
; RPN'ized expression: "( 1792 , 0 , 1 , 164 lba_read ) "
; Expanded expression: " 1792  0  1  164  lba_read ()8 "
; Fused expression:    "( 1792 , 0 , 1 , 164 , lba_read )8 "
	push	1792
	push	0
	push	1
	push	164
	call	_lba_read
	sub	sp, -8
; loc     result : (@-2) : unsigned char

section .rodata
L8:
	db	"KERNEL BIN"
	times	1 db 0

section .text
; RPN'ized expression: "result ( L8 find_file ) = "
; Expanded expression: "(@-2)  L8  find_file ()2 =(1) "
; Fused expression:    "( L8 , find_file )2 =(170) *(@-2) ax "
	push	L8
	call	_find_file
	sub	sp, -2
	mov	[bp-2], ax
jmp $

; return
L6:
	leave
	ret

; glb lba_read : (
; prm     sector : unsigned
; prm     count : unsigned
; prm     segment : unsigned
; prm     offset : unsigned
;     ) void
section .text
	global	_lba_read
_lba_read:
	push	bp
	mov	bp, sp
	 sub	sp,         16
; loc     sector : (@4) : unsigned
; loc     count : (@6) : unsigned
; loc     segment : (@8) : unsigned
; loc     offset : (@10) : unsigned
mov ah, 0x41
mov bx, 0x55AA
mov dl, 0x80
int 0x13

; loc     DAP : (@-16) : struct <something>
; RPN'ized expression: "DAP &u size -> *u 16 = "
; Expanded expression: "(@-16) 16 =(1) "
; Fused expression:    "=(154) *(@-16) 16 "
	mov	ax, 16
	mov	[bp-16], al
	mov	ah, 0
; RPN'ized expression: "DAP &u reserved -> *u 0 = "
; Expanded expression: "(@-15) 0 =(1) "
; Fused expression:    "=(154) *(@-15) 0 "
	mov	ax, 0
	mov	[bp-15], al
	mov	ah, 0
; RPN'ized expression: "DAP &u sector_count -> *u count = "
; Expanded expression: "(@-14) (@6) *(2) =(2) "
; Fused expression:    "=(170) *(@-14) *(@6) "
	mov	ax, [bp+6]
	mov	[bp-14], ax
; RPN'ized expression: "DAP &u buffer_offset -> *u offset = "
; Expanded expression: "(@-12) (@10) *(2) =(2) "
; Fused expression:    "=(170) *(@-12) *(@10) "
	mov	ax, [bp+10]
	mov	[bp-12], ax
; RPN'ized expression: "DAP &u buffer_segment -> *u segment = "
; Expanded expression: "(@-10) (@8) *(2) =(2) "
; Fused expression:    "=(170) *(@-10) *(@8) "
	mov	ax, [bp+8]
	mov	[bp-10], ax
; RPN'ized expression: "DAP &u sector_high_1 -> *u 0 = "
; Expanded expression: "(@-6) 0 =(2) "
; Fused expression:    "=(170) *(@-6) 0 "
	mov	ax, 0
	mov	[bp-6], ax
; RPN'ized expression: "DAP &u sector_low_1 -> *u sector = "
; Expanded expression: "(@-8) (@4) *(2) =(2) "
; Fused expression:    "=(170) *(@-8) *(@4) "
	mov	ax, [bp+4]
	mov	[bp-8], ax
; RPN'ized expression: "DAP &u sector_high_2 -> *u 0 = "
; Expanded expression: "(@-2) 0 =(2) "
; Fused expression:    "=(170) *(@-2) 0 "
	mov	ax, 0
	mov	[bp-2], ax
; RPN'ized expression: "DAP &u sector_low_2 -> *u 0 = "
; Expanded expression: "(@-4) 0 =(2) "
; Fused expression:    "=(170) *(@-4) 0 "
	mov	ax, 0
	mov	[bp-4], ax
lea si, [bp-16]
mov ah, 0x42
mov dl, 0x80
int 0x13
jc read_failed

; return
L9:
	leave
	ret

; glb find_file : (
; prm     name : * char
;     ) unsigned char
section .text
	global	_find_file
_find_file:
	push	bp
	mov	bp, sp
	 sub	sp,         12
; loc     name : (@4) : * char
; loc     reserved_sectors : (@-2) : unsigned
; loc     bytes_per_sector : (@-4) : unsigned
; loc     sectors_per_fat : (@-6) : unsigned
; loc     fat_count : (@-8) : unsigned
; loc     fat_start : (@-10) : unsigned
; loc     root_dir_start : (@-12) : unsigned
mov word ax, [0x7C0E]
mov word [bp-2], ax
mov word ax, [0x7C0B]
mov word [bp-4], ax
mov word ax, [0x7C16]
mov word [bp-6], ax
mov word ax, [0x7C10]
mov word [bp-8], ax

; RPN'ized expression: "fat_start reserved_sectors = "
; Expanded expression: "(@-10) (@-2) *(2) =(2) "
; Fused expression:    "=(170) *(@-10) *(@-2) "
	mov	ax, [bp-2]
	mov	[bp-10], ax
; RPN'ized expression: "root_dir_start fat_start fat_count sectors_per_fat * + = "
; Expanded expression: "(@-12) (@-10) *(2) (@-8) *(2) (@-6) *(2) * + =(2) "
; Fused expression:    "* *(@-8) *(@-6) + *(@-10) ax =(170) *(@-12) ax "
	mov	ax, [bp-8]
	mul	word [bp-6]
	mov	cx, ax
	mov	ax, [bp-10]
	add	ax, cx
	mov	[bp-12], ax
jmp $

L11:
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
L13:
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
L15:
	leave
	ret



; Syntax/declaration table/stack:
; Bytes used: 465/15360


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
; Ident uint8_t
; Ident uint16_t
; Ident <something>
; Ident size
; Ident reserved
; Ident sector_count
; Ident buffer_offset
; Ident buffer_segment
; Ident sector_low_1
; Ident sector_high_1
; Ident sector_low_2
; Ident sector_high_2
; Ident DiskAddressPacket
; Ident kernel_name
; Ident boot
; Ident load_kernel
; Ident lba_read
; Ident sector
; Ident count
; Ident segment
; Ident offset
; Ident find_file
; Ident name
; Ident putc
; Ident c
; Ident puts
; Ident string
; Bytes used: 407/5632

; Next label number: 17
; Compilation succeeded.
