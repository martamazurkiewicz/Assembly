	org	100h

	;DO 2^16-1=65535
	xor	ax,ax
	mov	ax,06302
	mov	cx,10000 ;iterator
	jmp	petla	
petla:
	cmp	cx,0
	je	koniec
	xor	dx,dx
	div	cx
	mov	[reszta],dx
	push	ax	;liczba calkowita na stos
	call	ifZeroOrNumber
	;dzielenie iteratora przez 10 i skok spowrotem do petla	
	xor	dx,dx
	mov	ax,cx
	div	word	[dziesiec]
	mov	cx,ax
	mov	ax,[reszta]
	jmp	petla	
ifZeroOrNumber:
	xor	bx,bx
	pop	bx	;adres
	pop	dx	;wynik
	cmp	dx,0
	je	zero
	mov	byte [bool],1
	add	dl,'0'
	mov	ah,2
	int	21h
	push	bx
	ret
zero:
	cmp	byte	[bool],0
	je	null
	mov	ah,2
	mov	dl,'0'
	int	21h
	push	bx	;adres ifZeroOrNumber
	ret
null:
	push	bx
	ret
koniec:
	mov	ax,4C00h	
	int	21h
dziesiec	dw	10
reszta	dw	0
bool	db	0	;jak cyfry juz byly wyswietlane bool=1