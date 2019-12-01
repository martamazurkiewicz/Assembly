	org	100h	
	call	newline
	call	getline
	call	newline
	call	naInt
	jmp	koniec
	
newline:
	mov	ah,9
	mov	dx,ent
	int	21h
ret
getline:
	mov	ah,10
	mov	dx,wejscie
	int	21h
ret
naInt:
	mov	bx,1
	xor	cx,cx
	mov	cl,[wejscie+1]
	mov	si,cx
	inc	si
	mov	cx,10
petla:
	sub	byte	[wejscie+si],48
	xor	dx,dx
	xor	ax,ax
	mov	al,[wejscie+si]
	mul	bx
	add	word	[wynik],ax
	xor	dx,dx
	mov	ax,bx
	mul	cx
	mov	bx,ax
	dec	si
	cmp	si,1
	jne	petla
ret
koniec:
	mov	ax,4c00h
	int	21h

ent	db	10,13,36
wejscie	db	6
	db	0
	times	7	db	36
wynik	dw	0