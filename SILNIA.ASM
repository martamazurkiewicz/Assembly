	org	100h
	;silnia dziala do 8! (16 bitow)
	mov	ah,2
	xor	cx,cx
	mov	cx,0
	jmp	silnia0
mnozenie:
	xor	ax,ax
	xor	dx,dx
	pop	ax	;wynik
	mov	cx,[licznik]
	mul	cx
	inc	cx
	mov	[licznik],cx
	push	ax	;wynik
	inc	di
	push	di
	call	wyswietlanieEtykiet
	pop	ax	;wynik
	push	ax
	push	ax
	call	WYSWIETLANIE
	mov	cx,[licznik]
	cmp	cx,9	
	jl	mnozenie
	je	koniec
silnia0:
	xor	ax,ax
	mov	ax,1
	push	ax	;wynik
	inc	cx
	mov	[licznik],cx
	mov	di,0
	push	di
	call	wyswietlanieEtykiet
	xor	ax,ax
	pop	ax	;wynik
	push	ax
	push	ax
	call	WYSWIETLANIE
	jmp	mnozenie
koniec:
	mov	ax, 4C00h
	int	21h

wyswietlanieEtykiet:
	pop	word	[adresEtykiety]	;adres
	pop	di	;ktora iteracja
	mov	ah,2
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	mov	dl,[etykieta+di]
	int	21h
	mov	ah,9
	mov	dx,wykrzyknik
	int	21h
	push	word	[adresEtykiety]
	ret

WYSWIETLANIE:
	pop	word	[adres]
	xor	ax,ax
	pop	ax	;cyfra
	mov	cx,10000 ;iterator
	jmp	petla	
petla:
	cmp	cx,0
	je	end
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
	mov	byte 	[bool],1
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
end:
	mov	byte	[bool],0
	push	word	[adres]
	ret

;zmienne wyswietlania	
dziesiec	dw	10
reszta	dw	0
adres	dw	0
bool	db	0	;jak cyfry juz byly wyswietlane bool=1
;zmienne silni
licznik	dw	0
adresEtykiety	dw	0
etykieta	dw	"012345678"
wykrzyknik	dw	"!: ",'$'