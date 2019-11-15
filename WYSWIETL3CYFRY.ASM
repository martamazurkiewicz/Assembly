	org	100h

	xor	ax,ax
	mov	ax,001
	push	ax
	call	cyfra	
	jmp	koniec
cyfra:
	xor	bx,bx
	pop	bx	;adres cyfra ze stosu
	pop	ax	;liczba ze stosu
	xor	dx,dx
	mov	dl,100
	div	dl
	mov	dh,ah	;reszta z dzielenia przez 100 w dh
	push	ax
	call	ifZeroOrNumber
	mov	dl,10
	mov	al,dh	;reszta z dzielenia przez 100 w al
	div	dl
	mov	dh,ah	;reszta z dzielenia przez 10 w dh
	push	ax
	call	ifZeroOrNumber
	mov	al,dh
	push	ax
	call	ifZeroOrNumber
	push	bx
	ret	
ifZeroOrNumber:
	xor	cx,cx
	pop	cx
	pop	dx
	add	dl,'0'
	mov	ah,2
	int	21h
	xor	ax,ax
	push	cx
	ret
koniec:
	mov	ax,4C00h
	int	21h