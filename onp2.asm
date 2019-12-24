        org     100h
start:  
	call	Menu	
	call	GetInput
        call    Newline
        call    Converse
        call    Display
        call    Newline
        call    Compute
        call    DisplayResult
        call	Clean
        jmp     start
Menu:
	call	Newline
	mov	ah,9
	mov	dx,label1
	int	21h
	mov	ah,1
	int	21h
	cmp	al,'q'
	je	koniec
	cmp	al,'1'
	jne	Menu
ret
GetInput:
	call	Newline
	mov	ah,9
	mov	dx,label2
	int	21h
	call	Newline
	mov	ah,10
	mov	dx,input
	int	21h	
ret
Converse:
        pop     word    [adres]
        mov     ax,0
        push    ax      ;bp przechowuje adres sp, dla ktorego stos jest pusty z moich zmiennych!
        xor     di,di
        add     byte    [input+1],1
        mov     si,2
petla1:
        ;if the token is a number, then:
        xor     ax,ax
        mov     al,[input+si]
        cmp     al,'0'
        jl      ifOperator
        cmp     ah,'9'
        jg      wrongSignException
        mov     byte    [output+di],al
        inc     di
        ;mov     byte    [output+di],' '
        ;inc     di
        ;while there are tokens to be read do petla1
        inc     si
        xor     ax,ax
        mov     al,[input+1]
        cmp     si,ax
        jg      endOfTokens
        jmp     petla1
ifOperator:
        ;ifOperator -> if the token is an operator
        ;              {
        ;               naStos -> while ((there is an operator at the top of the operator stack with greater precedence)
        ;                       or (the operator at the top of the operator stack has equal precedence))
        ;                       and (the operator at the top of the operator stack is not a left parenthesis)
        ;                       {
        ;                       pop operators from the operator stack onto the output queue
        ;                       }
        ;               dodajDoStosu -> push it onto the operator stack
        ;               }
        ;lewyNawias -> if the token is a left paren "("
        ;       {
        ;       push it onto the operator stack
        ;       }
        ;prawyNawias ->if the token is a right paren ")" 
        ;while (the operator at the top of the operator stack is not a left paren)
        ;       {
        ;       pop the operator from the operator stack onto the output queue
        ;       }
        ;if the stack runs out without finding a left paren, then there are mismatched parentheses
        ;       if there is a left paren at the top of the operator stack
        ;       {
        ;       pop the operator from the operator stack and discard it
        ;       }
        cmp     al,'('
        je      addToStack

        cmp     byte    [output+di-1],36
        je      znak
        mov     byte    [output+di],' '
        inc     di
znak:
        cmp     al,'+'
        je      naStos2
        cmp     al,'-'
        je      naStos2
        cmp     al,'*'
        je      naStos3       
        cmp     al,'/'
        je      naStos3
        cmp     al,')'
        je      rightParen
        jne     wrongSignException
naStos2:
        ;naStos -> while ((there is an operator at the top of the operator stack with greater precedence)
        ;                       or (the operator at the top of the operator stack has equal precedence))
        ;                       and (the operator at the top of the operator stack is not a left parenthesis)
        ;                       {
        ;                       pop operators from the operator stack onto the output queue
        ;                       }
        ;          addToStack -> push it onto the operator stack

        pop     ax
        push    ax
        cmp     al,0            ;nie ma operatora na szczycie stosu
        je      addToStack
        cmp     al,'('
        je      addToStack
        ;pop operators from the operator stack onto the output queue
        pop     ax
        mov     byte    [output+di],al
        inc     di
        mov     byte    [output+di],' '
        inc     di
        jmp     naStos2
addToStack:
        xor     ax,ax
        mov     al,[input+si]
        push    ax
        inc     si
        xor     ax,ax
        mov     al,[input+1]
        cmp     si,ax
        jg      lastSignIsOperatorException
        jmp     petla1

naStos3:
        ;naStos -> while ((there is an operator at the top of the operator stack with greater precedence)
        ;                       or (the operator at the top of the operator stack has equal precedence))
        ;                       and (the operator at the top of the operator stack is not a left parenthesis)
        ;                       {
        ;                       pop operators from the operator stack onto the output queue
        ;                       }
        ;          addToStack -> push it onto the operator stack
        pop     ax
        push    ax
        cmp     al,0            ;nie ma operatora na szczycie stosu
        je      addToStack
        cmp     al,'('
        je      addToStack
        cmp     al,'-'
        je      addToStack
        cmp     al,'+'
        je      addToStack
        ;pop operators from the operator stack onto the output queue
        pop     ax
        mov     byte    [output+di],al
        inc     di
        mov     byte    [output+di],' '
        inc     di
        jmp     naStos3

rightParen:
        ;prawyNawias ->if the token is a right paren ")" 
        ;while (the operator at the top of the operator stack is not a left paren)
        ;       {
        ;       pop the operator from the operator stack onto the output queue
        ;       }
        ;if the stack runs out without finding a left paren, then there are mismatched parentheses
        ;       if there is a left paren at the top of the operator stack
        ;       {
        ;       pop the operator from the operator stack and discard it
        ;       }
        pop     ax
        cmp     al,0            ;nie ma operatora na szczycie stosu
        je      mismatchedParenException
        cmp     al,'('
        je      endOfParen
        mov     byte    [output+di],al
        inc     di
        ;mov     byte    [output+di],' '
        ;inc     di
        jmp     rightParen
endOfParen:
        inc     si
        xor     ax,ax
        mov     al,[input+1]
        cmp     si,ax
        jg      endOfTokens
        jmp     petla1

endOfTokens:
        ;After while loop, if operator stack not null, pop everything to output queue
        ;if there are no more tokens to read
        ;       {
        ;               while there are still operator tokens on the stack
        ;               /* if the operator token on the top of the stack is a paren, then there are mismatched parentheses. */
        ;                pop the operator from the operator stack onto the output queue.
        ;       }
        ;exit
        mov     byte    [output+di],' '
        inc     di
        pop     ax
        cmp     al,0           ;nie ma operatora na szczycie stosu
        je      stackIsNull
        cmp     al,'('
        je      mismatchedParenException
        cmp     al,')'
        je      mismatchedParenException
        mov     byte    [output+di],al
        inc     di
        ;mov     byte    [output+di],' '
        ;inc     di
        jmp     endOfTokens
stackIsNull:
        dec     di
        mov     byte    [output+di],36
        push    word    [adres]
ret

Newline:
	mov	ah,9
	mov	dx,ent
	int	21h
ret

Display:
        mov     ah,9
        mov     dx,label3
        int     21h
        mov     ah,9
        mov     dx,output
        int     21h    
ret

Compute:
        pop     word    [adres]
	mov	byte    [stackPointer],0
	xor	si, si
	xor	di, di
computeLoop:
	cmp	byte	[output+si],36
	je	finish
	cmp	byte	[output+si],' '
	je	space
	cmp	byte	[output+si],'+'
	je	dodaj
	cmp	byte	[output+si],'-'
	je	odejmij
	cmp	byte	[output+si],'*'
	je	pomnoz
	cmp	byte	[output+si],'/'
	je	podziel
	cmp	byte	[output+si],'0'
	jl	wrongSignException
	cmp	byte	[output+si],'9'
	ja	wrongSignException

	cmp	di,4
	ja	numberBiggerThan16bitsException
        xor     ax,ax
	mov	al,[output+si]
	mov	byte	[number+di],al
	inc	di
	inc	si
	jmp	computeLoop
space:
        inc     si
        cmp     byte    [number],36
        jne     multiDigitNumber
        xor	di,di
        jmp     computeLoop
multiDigitNumber:
        mov     di,4
        mov     bx,1
        mov     cx,10
mDNLoop:
        xor     ax,ax
        xor     dx,dx
        mov     al,[number+di]
        cmp     al,36
	je	dollar
        sub     al,'0'
        mul     bx
        add     word    [integer],ax
        mov     ax,bx
        mul     cx
        mov     bx,ax
        cmp     di,0
        je      finishMDN
        dec     di
        jmp     mDNLoop
dollar:
	cmp	di,0
	je	finishMDN
	dec	di
	jmp	mDNLoop
finishMDN:
        push    word    [integer]
        call    CleanNumber
	inc	byte	[stackPointer]
        jmp     computeLoop

dodaj:
	cmp	byte	[stackPointer],2
	jl	notEnoughArgumentsException
	pop	bx
	pop	ax
	add	ax,bx
	push	ax
	inc	si
	dec	byte    [stackPointer]
	jmp	computeLoop
odejmij:
	cmp	byte	[stackPointer],2
	jl	notEnoughArgumentsException
	pop	bx
	pop	ax
	sub	ax,bx
	push	ax
	inc	si
	dec	byte    [stackPointer]
	jmp	computeLoop
pomnoz:
	cmp	byte	[stackPointer],2
	jl	notEnoughArgumentsException
	pop	bx
	pop	ax
        xor     dx,dx
	mul     bx
        cmp     dx,0
        jne     multiplicationOverflowException
	push	ax
	inc	si
	dec	byte    [stackPointer]
	jmp	computeLoop
podziel:
	cmp	byte	[stackPointer],2
	jl	notEnoughArgumentsException
	pop	bx
        cmp     bx,0
        je      divideByZeroException
        pop	ax
        xor     dx,dx
	div     bx
	push	ax
	inc	si
	dec	byte    [stackPointer]
	jmp	computeLoop
finish:
        pop     word    [result]
        push    word    [adres]
ret

CleanNumber:
        mov     word    [integer],0
        mov     di,5
cleanNumberLoop:
        dec     di
        mov     byte    [number+di],36
        cmp     di,0
        jg      cleanNumberLoop
ret

DisplayResult:
        mov     ah,9
        mov     dx,label4
        int     21h
        xor     ax,ax
	mov	ax,[result]
	mov	bx,10
	mov	cx,0
podzial:
	xor	dx,dx
	div	bx
	push	dx
	inc	cx
	cmp	ax,0
	jne	podzial
	mov	ah,2
wysw:
	pop	dx
	add	dl,'0'
	int	21h
	dec	cx
	cmp	cl,0
	jg	wysw		
ret

Clean:
        mov     word    [result],0
	mov	byte	[input+1],0
        mov     di,2
cleanInput:
	mov	byte	[input+di],36
	inc     di
	cmp     di,29
        jle     cleanInput
        xor     di,di
cleanOutput:
	mov	byte	[output+di],36
	inc     di
	cmp     di,65
        jle     cleanOutput
ret

koniec: 
        mov     ax,4c00h
        int     21h

divideByZeroException:
        call    Newline
        mov     ah,9
        mov     dx,divideByZero
        int     21h
        call    Clean
        jmp     start
mismatchedParenException:
        call    Newline
        mov     ah,9
        mov     dx,mismatchedParen
        int     21h
        call    Clean
        jmp     start
lastSignIsOperatorException:
        call    Newline
        mov     ah,9
        mov     dx,lastSignIsOperator
        int     21h
        call    Clean
        jmp     start
wrongSignException:
        call    Newline
        mov     ah,9
        mov     dx,wrongSign
        int     21h
        call    Clean
        jmp     start
numberBiggerThan16bitsException:
        mov     ah,9
        mov     dx,numberBiggerThan16bits
        int     21h
        call    Clean
        jmp     start
notEnoughArgumentsException:
        mov     ah,9
        mov     dx,notEnoughArguments
        int     21h
        call    Clean
        jmp     start
multiplicationOverflowException:
        mov     ah,9
        mov     dx,multiplicationOverflow
        int     21h
        call    Clean
        jmp     start
        
input	db	26
        db	0
	TIMES	27	db	36 

output  TIMES	65	db	36
result          dw      0

ent	db	10,13,36

adres   dw      0
stackPointer	db	0
number	TIMES	5 db 36
integer         dw      0

mismatchedParen         dw      "There are mismatched parentheses in equation$"
lastSignIsOperator      dw      "Last sign cannot be an operator$"
wrongSign               dw      "Sign is not a number or operator$"
divideByZero            dw      "Do not divide by zero$"
numberBiggerThan16bits  dw      "Calculated number was biger than 16 bits$"
notEnoughArguments      dw      "Wrong number of arguments per operation$"
multiplicationOverflow  dw      "Result of multiplication is bigger than 16 bits$"

label1  	dw	"To translate and compute equation choose 1, to quit choose q$"
label2  	dw	"Infix notation: $"
label3  	dw	"Equation in RPN: $"
label4  	dw	"Result: $"
