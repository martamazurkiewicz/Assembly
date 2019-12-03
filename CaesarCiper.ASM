	org	100h
start:
	call	menu	
	call	pobierzKod
	call	pobierzPrzesuniecie
	call	toLower
	call	toSpace
	call	dodajPrzesuniecie
	call	wyswietl
	call	wyczysc
	jmp	start

newline:
	mov	ah,9
	mov	dx,ent
	int	21h
ret
menu:
	call	newline
	mov	ah,9
	mov	dx,etykieta1
	int	21h
	mov	ah,1
	int	21h
	cmp	al,'q'
	je	koniec
	cmp	al,'1'
	jne	menu
ret
pobierzKod:
	call	newline
	mov	ah,9
	mov	dx,etykieta2
	int	21h
	call	newline
	mov	ah,10
	mov	dx,kod
	int	21h	
ret

pobierzPrzesuniecie:
	;przesuniecie jest w [resztaModulo]
	call 	newline
	mov	ah,9
	mov	dx,etykieta3
	int	21h
	mov	ah,10
	mov	dx,przesuniecie
	int	21h
ParseToInt:
	mov	bx,1
	xor	cx,cx
	mov	cl,[przesuniecie+1]
	xor	si,si
	mov	si,cx
	inc	si
	mov	cx,10
petla:
	sub	byte	[przesuniecie+si],'0'
	xor	dx,dx
	xor	ax,ax
	mov	al,[przesuniecie+si]
	mul	bx
	add	word	[przesun],ax
	xor	dx,dx
	mov	ax,bx
	mul	cx
	mov	bx,ax
	dec	si
	cmp	si,1
	ja	petla

moduloZPrzesuniecia:
	xor	dx,dx
	mov	ax,[przesun]
	mov	cx,26
	div	cx
	mov	byte	[resztaModulo],dl
ret

toLower:
	xor	cx,cx
	mov	cl,[kod+1]
	xor	si,si
	mov	si,cx
	inc	si
zamienWielkaLitere:
	cmp	byte	[kod+si],'A'
	jb	warunek2
	cmp	byte	[kod+si],'Z'
	ja	warunek2
	add	byte	[kod+si],32
warunek2:
	dec	si
	cmp	si,1
	ja	zamienWielkaLitere
ret

toSpace:
	xor	cx,cx
	mov	cl,[kod+1]
	xor	si,si
	mov	si,cx
	inc	si	
naSpacje:
	cmp	byte	[kod+si],'a'
	jb	spacja
	cmp	byte	[kod+si],'z'
	ja	spacja
	dec	si
	cmp	si,1
	ja	naSpacje
ret
spacja:
	mov	byte	[kod+si],' '
	dec	si
	cmp	si,1
	ja	naSpacje
ret

dodajPrzesuniecie:
	xor	cx,cx
	mov	cl,[kod+1]
	xor	si,si
	mov	si,cx
	inc	si
dodaj:
	cmp	byte	[kod+si],' '
	je	warunek
	xor	ax,ax
	mov	al,[resztaModulo]
	add	byte	[kod+si],al
	cmp	byte	[kod+si],'z'
	ja	zapetl
warunek:
	dec	si
	cmp	si,1
	ja	dodaj
ret
zapetl:
	sub	byte	[kod+si],26
	jmp	warunek

wyswietl:
	call	newline
	mov	ah,9
	mov	dx,kod+2
	int	21h
ret

wyczysc:
	mov	byte	[kod+1],0
	xor	si,si
	mov	si,29	
czyszczenie:
	mov	byte	[kod+si],'$'
	dec	si
	cmp	si,1
	ja	czyszczenie

wyczyscPrzesuniecie:
	mov	word	[przesun],0
	mov	byte	[resztaModulo],0
	mov	byte	[przesuniecie+1],0
	xor	si,si
	mov	si,9
czyszczeniePrzesuniecia:
	mov	byte	[przesuniecie+si],'$'
	dec	si
	cmp	si,1
	ja	czyszczeniePrzesuniecia
ret

koniec:
	mov	ax,4c00h
	int	21h

ent	db	10,13,36
przesuniecie	db	6
		db	0
		times	7	db	36
kod	db	26
	db	0
	times	27	db	36
przesun		dw	0
resztaModulo	db	0
etykieta1	dw	"Aby zaszyfrowac wybierz 1, aby wyjsc wybierz q: $"
etykieta2	dw	"Podaj wiadomosc do zaszyfrowania:$"
etykieta3	dw	"Podaj przesuniecie: $"