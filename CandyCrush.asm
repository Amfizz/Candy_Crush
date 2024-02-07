[org 0x0100]
jmp start
Score: dw "Score: 0  "
ScoreVal: dw 0
Msg: dw "Mini Candy Crush"
bombflag: db 0
Msg1: db 'Welcome to Mini Candy Crush' ; 27 chars
Msg2: db 'You will get 9 turns to score the maximum score possible' ;56 chars
Msg3: db 'Make pattern of two numbers to pop them and gain score' ;54 chars
Msg4: db 'Make a pattern of five or more characters to form a bomb X' ;58 chars
Msg5: db 'Swap the bomb with a character to delete all instances of that character' ;72 chars
Msg6: db 'Score 80 to win' ;15 chars
PressAnyKey: db 'Press any key to continue' ;25 chars
winningMessage: db 'You Win';7
CM: db 'Press Any Key To Exit' ;21 chars
ScoreLen: dw 10
Char: db 'ABCDABCD'
Colours: db 0x50,0x60,0x70,0x15,0x50,0x60,0x70,0x15
randomNum: dw 0
randomNumber: 
	push cx
	push dx
	push ax
	rdtsc ;getting a random number in ax dx
	xor dx,dx ;making dx 0
	mov cx, 8
	div cx ;dividing by 8 to get numbers from 0-7
	mov [randomNum], dl 
	pop ax
	pop dx
	pop cx
	ret
; ------------------------------------------------------
printstr: 
	push bp
	mov bp, sp
	push es
	push ax
	push cx
	push si
	push di
	mov ax, 0xb800
	mov es, ax ; point es to video base
	mov al, 80 ; load al with columns per row
	mul byte [bp+10] ; multiply with y position
	add ax, [bp+12] ; add x position
	shl ax, 1 ; turn into byte offset
	mov di,ax ; point di to required location
	mov si, [bp+6] ; point si to string
	mov cx, [bp+4] ; load length of string in cx
	mov ah, [bp+8] ; load attribute in ah
	cld ; auto increment mode
nextchar: 
	lodsb ; load next char in al
	stosw ; print char/attribute pair
	loop nextchar ; repeat for the whole string
	pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret 10
;-------------------------------------------------------

clrscr:

		push bp
		mov bp,sp
		
		push es
		push ax
		push di
		push cx
		
		mov ax, 0xb800
		mov es, ax
		xor di, di
		mov ax, 0x0720
		mov cx, 2000
		
		cld
		rep stosw
		
		pop cx
		pop di
		pop ax
		pop es

		pop bp
		ret
;------------------------------------------------------
printnum: 
		push bp
		mov bp, sp
		push es
		push ax
		push bx
		push cx
		push dx
		push di
		
		mov ax, 0xb800
		mov es, ax ; point es to video base
		mov ax, [bp+4] ; load number in ax
		mov bx, 10 ; use base 10 for division
		mov cx, 0 ; initialize count of digits

nextdigit: 
		mov dx, 0 ; zero upper half of dividend
		div bx ; divide by 10
		add dl, 0x30 ; convert digit into ascii value
		push dx ; save ascii value on stack
		inc cx ; increment count of values
		cmp ax, 0 ; is the quotient zero
		jnz nextdigit ; if no divide it again
		
		mov di, 284 ; point di
		
nextpos:
		pop dx ; remove a digit from the stack
		mov dh,01000000b ; use normal attribute
		mov [es:di], dx ; print char on screen
		add di, 2 ; move to next screen location
		loop nextpos ; repeat for all digits on stack
		
		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp
		ret 2
;---------------------------------------------------
Printboard:
		
		push bp
		mov bp, sp
		push es
		push ax
		push di
		call clrscr
		call top ; print top row strip
		mov ax, 0xb800
		mov es, ax
		mov di, 320 ; leave first row as already covered by top sub routine
		mov al, 0x20 ; space character
		mov ah, 07 ; blue color

nxt:		mov [es:di], ax
		add di, 2
		cmp di, 4000
		jne nxt
		
		pop di
		pop ax
		pop es

		pop bp
		ret
; ------------------------------------------------------
top:

		push bp
		mov bp, sp
		
		push es
		push ax
		push di
		
		mov ax, 0xb800
		mov es, ax
		mov di, 0
		
		mov al, 0x20 ; space character
		mov ah, 01000000b ; red color

		con: mov [es:di], ax
		add di, 2
		cmp di, 320
		jne con
		
		pop di
		pop ax
		pop es

		pop bp
		ret		
; ------------------------------------------------------
Horz:
		push bp
		mov bp, sp
		
		push es
		push ax
		push di
		push cx
		
		mov ax, 0xb800
		mov es, ax
		mov di, 480 ; first two row already left empty and two more rows left as each block will be 2 units wide
		
		mov al, '-'
		mov ah, 07 ; blue color
		mov dl, 12

Horzloop:		
		mov cx, 0
		
nxtHorz: ; print a line of _ character
		
		mov [es:di], ax
		add di, 2
		add cx, 2
		cmp cx, 160
		jne nxtHorz
		
		add di, 160 ; skip a row to make blocks 2 wide
		dec dl
		cmp dl, 0
		jne Horzloop
		
		pop cx
		pop di
		pop ax
		pop es

		pop bp
		ret
; ------------------------------------------------------

Ver:
		push bp
		mov bp, sp
		push es
		push ax
		push di
		push cx
		mov ax, 0xb800
		mov es, ax
		mov di, 320 ; leave fisrt row
		mov al, '|' ; | character
		mov ah, 07 ; blue color
		mov bx, 2 ; used for multiplication
		mov dx, 0
		
Verloop:	mov cl, 0
		add di, 0 ; leave space on left side for proper symmetry and allignment
		
nxtVer: ; run a loop and print | character 13 times
		
		mov [es:di], ax
		add di, 12
		inc cl
		cmp cl, 13
		jbe nxtVer
		push ax ; store value of ax
		; multiplication used to move onto next line of grid 
		mov ax, 160
		mul bx
		mov di, ax
		inc bx
		pop ax ; restore value of ax
		cmp di, 4000
		jbe Verloop
	        pop cx
		pop di
		pop ax
		pop es
		pop bp
		ret
; ------------------------------------------------------
prtdetails:     push bp
		mov bp, sp
		push es
		push ax
		push di
                push si
		push cx
		mov ax, 0xb800
		mov es, ax
		mov cx, [ScoreLen]
		mov di, 270
		mov si, Score
		mov ah, 01000000b

prtscore: 	mov al, [si]
		mov [es:di], ax
		add di, 2
                add si, 1
		loop prtscore

		mov cx, 16
		mov ax, 0xb800
		mov es, ax
		mov di, 172
		mov si, Msg              
		mov ah, 01000000b 

prt:
		mov al, [si]
		mov [es:di], ax
		add di, 2
                add si, 1
		loop prt
        
		pop cx
        pop si
        pop di
        pop ax
        pop es
        pop bp
        ret
;.................................................
RNB: ; generate a random number using the system time
	push cx
	push dx
	push ax
	rdtsc ;getting a random number in ax dx
	xor dx,dx ;making dx 0
	mov cx, 8
	div cx
	mov [randomNum], dl ;moving the random number in variable
	pop ax
	pop dx
	pop cx
	ret
;...................................................
initialise:
	;random number initalisation here
	
	mov al, 13
	xor ah, ah
	mov dl, 0x00
	sub dl, 3
	
l2:
call RNB
	push ax
	
	add dl, 0x06
	
	mov cl, 12
	xor ch, ch

	
l1:
	call RNB
	push cx
	mov ah, 0x13 ; service 13 - print string
	mov al, 0 ; subservice 01 – update cursor
	mov bh, 0 ; output on page 0
	
	mov si, [randomNum]
	call randomNumber
	mov bl, [Colours + si]
	
	;mov dx, 0x0A03 ; row 10 column 3
	
	mov dh, cl
	add dh, cl
	
	
	mov cx, 1 ; length of string
	push cs
	pop es ; segment of string

	mov bp, Char ; offset of string
	add bp, si

	int 0x10
	
	pop cx
	dec cx
	cmp cx, 0
	jne l1
	
	pop ax
	dec ax
	cmp ax, 0
	jne l2
	
	ret
;.............................................

setup:

welcomescreen:
	call clrscr
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x70
	mov dx, 0x0601 
	mov cx, 27 
	push cs
	pop es 
	mov bp, Msg1 
	int 0x10
	mov ah, 0x13
	mov al, 1
	mov bh, 0 
	mov bl, 0x20 
	mov dx, 0x0B01 
	mov cx, 56
	push cs
	pop es 
	mov bp, Msg2 
	int 0x10
	mov ah, 0x13 
	mov al, 1
	mov bh, 0 
	mov bl, 0x20
	mov dx, 0x0D01 
	mov cx, 54 
	push cs
	pop es 
	mov bp, Msg3 
	int 0x10
	mov ah, 0x13 
	mov al, 1
	mov bh, 0 
	mov bl, 0x20 
	mov dx, 0x0F01 
	mov cx, 58
	push cs
	pop es 
	mov bp, Msg4 
	int 0x10
	mov ah, 0x13 
	mov al, 1 
	mov bh, 0 
	mov bl, 0x20 
	mov dx, 0x1101 
	mov cx, 72 
	push cs
	pop es 
	mov bp, Msg5 
	int 0x10
	mov ah, 0x13 
	mov al, 1 
	mov bh, 0 
	mov bl, 0x20
	mov dx, 0x1301 
	mov cx, 15 
	push cs
	pop es
	mov bp, Msg6
	int 0x10
	mov ah, 0x13 
	mov al, 1
	mov bh, 0 
	mov bl, 0x20 
	mov dx, 0x1801 
	mov cx, 25 
	push cs
	pop es 
	mov bp, PressAnyKey
	int 0x10
	mov ah, 0
	int 0x16
	 ClearScreen:
	mov ah, 00
	mov al, 03h
	int 10h
	ret
;......................................................
noMouseClick:
    push bp
	mov bp, sp
	push ax
	push bx
	push cx;
	push di
	push dx
	
	mov ax, 01h ;to show mouse
	int 33h
waitForMouseClick:
	mov ax,0003h
	int 33h
	cmp bx, 0
	je waitForMouseClick
	mov ax, 0002h ;hide mouse after clicking
	int 33h
	shr cx, 3
	shr dx, 3

	mov ax, 0xb800
	mov es, ax
	mov ax, 80
	mov bx, dx
	mul bl
	add ax, cx
	shl ax, 1
    	mov di, ax
	;mov ax, [es:di]
	mov [bp+4], di  ;return coordinate of click
	
	pop dx
	pop di
	pop cx
	pop bx
	pop ax
	pop bp
	ret 
rg:
	push bp
	mov bp,sp
	push ax
	push es
	push si
	push di
	push dx
	push bx

	jmp startfun

	endfun1:
	pop bx
	pop dx
	pop di
	pop si
	pop es
	pop ax
	pop bp
	ret 2

	startfun:
	
	mov ax, 0xb800
	mov es, ax
	mov di, [bp+4]
	jmp mainrg

	looprandom:
	cmp di, 480
	jb endfun1

	sub di, 320
	mov bx, [es:di]

	mov [es:di+320], bx
	cmp di, 480
	ja looprandom

	call randomNumber
	mov si, [randomNum]
	mov ah, [Colours+si]

	mov al, [Char+si]
	mov [es:di], ax
	jmp endfun

mainrg:
	call randomNumber
	mov si, [randomNum]
	mov ah, [Colours+si]

	mov al, [Char+si]
	mov [es:di], ax

	endfun:
	pop bx
	pop dx
	pop di
	pop si
	pop es
	pop ax
	pop bp
	ret 2
;----------------------------------------------------

setflag:
	push bp
	mov bp, sp
	push ax
	push dx
	mov dx, [bp+4]

	cmp dx, 3
	ja resetflag

	mov al, 1
	mov [bombflag], al
	jmp endsetflag

	resetflag:
	mov al, 0
	mov [bombflag], al

	endsetflag:
	pop dx
	pop ax
	pop bp
	ret 2
;-------------------------

updateScore:
	push bp
	mov bp,sp
	push ax
	push dx
	mov dx, [bp+4]
	xor dh, dh
	mov ax, [ScoreVal]
	add ax, dx
	mov [ScoreVal], ax

	xor ah, ah
	push ax
	call printnum
	pop dx
	pop ax
	pop bp
	ret 2
	
bombsub:

	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push si
	push di
	mov si, 0
	
	mov ax, 0xb800
	mov es, ax
	
	mov di, [bp+6]
	mov cx, [es:di]
	
	mov di, [bp+4] ;bomb always here
	mov dx, [es:di]
	
	push di
	call rg
	
	mov di, 320 ; leave first row as already covered by top sub routine

bombnxt:
		
		mov ax, [es:di]
		cmp al, cl
		je remv
		
continue_nxt:		
		
		add di, 2
		cmp di, 4000
		jne bombnxt
		jmp fun_eend
		
remv:
		inc si
remov_:		
		push di
		call rg
		mov ax, [es:di]
		cmp al, cl
		je remov_
		jmp continue_nxt	
	
	fun_eend:
	push si
	call updateScore
	pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4
	
pattern:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push es
	push si
	push di
	
	mov ax, 0xb800
	mov es, ax
	
	mov di, [bp+6]
	mov bx, [es:di]
	
	mov di, [bp+4]
	mov dx, [es:di]
	
	cmp dl, 'X'
	jne bomb1st
	
	cmp bl, 'X'
	je fun_ter
	jmp bomb2nd
	
	fun_ter:
	pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4

	
bomb2nd:	
	
	mov di, [bp+6]
	push di
	mov di, [bp+4]
	push di
	call bombsub
	jmp fun_ter
	
bomb1st: 

	cmp bl, 'X'
	jne topleft
	
	cmp dl, 'X'
	je fun_ter
	
	mov di, [bp+4]
	push di
	mov di, [bp+6]
	push di
	call bombsub
	jmp fun_ter
topleft:
	mov si, 0
	mov di, [bp+4]
	sub di, 320
	sub di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne topright  

	continuetopleft:
	inc si
	push di
	call rg
	sub di, 320
	sub di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continuetopleft

	topright:
	mov di, [bp+4]
	sub di, 320
	add di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne bottomleft

	continuetopright:
	inc si
	push di
	call rg
	sub di, 320
	add di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continuetopright

	bottomleft:
	mov di, [bp+4]
	add di, 320
	sub di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne bottomright  

	continuebottomleft:
	inc si
	push di
	call rg
	add di, 320
	sub di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continuebottomleft

	bottomright:
	mov di, [bp+4]
	add di, 320
	add di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne down

	continuebottomright:
	inc si
	push di
	call rg
	add di, 320
	add di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continuebottomright
		
	down:
	mov di, [bp+4]
	add di, 320
	mov cx, [es:di]
	cmp dx, cx
	jne up  

	continuedown:
	inc si
	push di
	call rg
	add di, 320
	mov cx, [es:di]
	cmp dx,cx
	je continuedown

	up:
	mov di, [bp+4]
	sub di, 320
	mov cx, [es:di]
	cmp dx, cx
	jne right  

	continueup:
	inc si
	push di
	call rg
	sub di, 320
	mov cx, [es:di]
	cmp dx,cx
	je continueup
	
	right:
	mov di, [bp+4]
	add di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne left
	
	continueright:
	inc si
	push di
	call rg
	add di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continueright

	left:
	mov di, [bp+4]
	sub di, 12
	mov cx, [es:di]
	cmp dx, cx
	jne pass
	
	continueleft:
	inc si
	push di
	call rg
	sub di, 12
	mov cx, [es:di]
	cmp dx,cx
	je continueleft

	pass:

	push si
	call setflag
	mov di, [bp+4]


	cmp byte[bombflag], 0
	jne updateoriginal
	mov di, [bp+4]
	inc si
	push si
	call updateScore

	push ax
	push di
	call rg
	mov al, 'X'
	mov ah, 0x05
	mov [es:di], ax
	pop ax
	jmp fun_end

	updateoriginal:
	cmp si, 0
	je fun_end
	push di
	call rg
	inc si
	push si
	call updateScore

	

	fun_end:
	pop di
	pop si
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	
	ret 4
;...........................................
waitForButtonRelease:
	push ax
	push bx
	push cx
	push dx
	waitt:	
	mov ax, 03h
	int 33h
	cmp bx, 1
	je waitt
	pop dx
	pop cx
	pop bx
	pop ax
	ret
;........................................
Coorswap:
	push bp
	mov bp, sp
	push ax
	push bx
	push cx
	push dx
	push di
	push si
	mov si, [bp+4]
	mov ax, [bp+6]

	add ax, 320
	cmp ax, si
	je swap
	
	mov ax, [bp+6]
	sub ax, 320
	cmp ax, si
	je swap
	
	mov ax, [bp+6]
	add ax, 12
	cmp ax, si
	je swap
	
	mov ax, [bp+6]
	sub ax, 12
	cmp ax, si
	je swap
	
	jmp returnfun

swap:
	mov ax, 0xb800
	mov es, ax
	mov ax, [bp+6]
	mov di, ax
	mov dx, [es:di] ; 1st ; bp+6
	mov di, si
	mov si, 0 ; count of pattern
	mov bx, [es:di] ; 2nd ; bp+4
	mov di, [bp+6]
	mov [es:di], bx
	mov di, [bp+4]
	mov [es:di], dx
	p:
	
	mov di, [bp+6]
	push di
	mov di, [bp+4]
	push di
	call pattern

	
	returnfun:
	pop si
	pop di
	pop dx
	pop cx
	pop bx
	pop ax
	pop bp
	ret 4
;........................................................
	winningScreen:
	mov si, 4
	mov dx, 0x0A18
	prtrectangle:
	mov ah, 0x13
	mov al, 1 
	mov bh, 0 
	mov bl, 0x77 
	mov cx, 27
	push cs
	pop es
	mov bp, PressAnyKey 
	int 0x10
	inc dh
	dec si
	cmp si, 0
	jne prtrectangle

	mov ah, 0x13 
	mov al, 1
	mov bh, 0 
	mov bl, 0x70
	mov dx, 0x0B21
	mov cx, 7 
	push cs
	pop es 
	mov bp, winningMessage 
	int 0x10
	mov ah, 0x13 
	mov al, 1 
	mov bh, 0 
	mov bl, 0x70 
	mov dx, 0x0C1B
	mov cx, 21 
	push cs
	pop es 
	mov bp, CM 
	int 0x10
	mov ah, 0
	int 16h
		mov ax, 0xb800
		mov es, ax
		xor di, di
		mov ax, 0x0720
		mov cx, 2000
		cld
		rep stosw
		ret
;...................................................
start:

	call setup
	call Printboard 
	call Horz
	call Ver 
        call prtdetails 
	call initialise
	again:
	sub sp, 2
	call noMouseClick
	pop dx
	call waitForButtonRelease
	;mov ah, 0
        ;int 0x16 ;await input
	;sub al,0x30
        sub sp, 2
        call noMouseClick
        pop di
	call waitForButtonRelease
	push dx
	push di
        call Coorswap
        cmp word[ScoreVal],80
	jb again
terminate:
	call winningScreen
	end: mov ax, 0x4c00
	int 21h

