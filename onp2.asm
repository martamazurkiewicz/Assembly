        org     100h
start:  
        mov     ah,10
        mov     dx,input
        int     21h
        call    Newline
        call    Converse
        call    Display
        call    Newline
        call    Compute
        call    DisplayResult
        jmp     koniec

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
        push    word    [adres]
ret

Newline:
	mov	ah,9
	mov	dx,ent
	int	21h
ret

Display:
        mov     ah,9
        mov     dx,output
        int     21h    
ret

Compute:
        pop     word    [adres1]
        xor     si,si
        ;xor     ax,ax
        ;mov     al,'!'
        ;push    ax      ;jak na stosie bedzie '!' oznacza to ze stos jest pusty
petla2:
        cmp     byte    [output+si],36
        je      getResult
        xor     ax,ax
        mov     al,[output+si]
        cmp     al,'0'
        jl      operator
        sub     al,'0'
        push    ax
        add     si,2
        jmp     petla2
operator:
        cmp     al,'+'
        je      dodaj
        cmp     al,'-'
        je      odejmij
        cmp     al,'*'
        je      pomnoz      
        cmp     al,'/'
        je      podziel
dodaj:
        pop     bx
        pop     ax
        add     ax,bx
        push    ax
        add     si,2
        jmp     petla2
odejmij:
        pop     bx
        pop     ax
        sub     ax,bx
        push    ax
        add     si,2
        jmp     petla2
pomnoz:
        pop     bx
        pop     ax
        xor     dx,dx
        mul     bx
        push    ax
        add     si,2
        jmp     petla2
podziel:
        pop     bx
        pop     ax
        cmp     bx,0
        je      divideByZeroException
        xor     dx,dx
        div     bx
        push    ax
        add     si,2
        jmp     petla2
getResult:
        pop     word    [result]
        push    word    [adres1]
ret

DisplayResult:
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

koniec: 
        mov     ax,4c00h
        int     21h

divideByZeroException:
        call    Newline
        mov     ah,9
        mov     dx,divideByZero
        int     21h
        jmp     koniec

mismatchedParenException:
        call    Newline
        mov     ah,9
        mov     dx,mismatchedParen
        int     21h
        jmp     koniec

lastSignIsOperatorException:
        call    Newline
        mov     ah,9
        mov     dx,lastSignIsOperator
        int     21h
        jmp     koniec

wrongSignException:
        call    Newline
        mov     ah,9
        mov     dx,wrongSign
        int     21h
        jmp     koniec
        
input	db	26
        db	0
	TIMES	27	db	36 

output  TIMES	100	db	36
result  dw      0


ent	db	10,13,36
adres   dw      0
adres1  dw      0

mismatchedParen         dw      "There are mismatched parentheses in equision$"
lastSignIsOperator      dw      "Last sign cannot be an operator$"
wrongSign               dw      "Sign is not a number or operator$"
divideByZero            dw      "Do not divide by zero$"