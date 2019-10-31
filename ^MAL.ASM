	;buduje malejacy trojkat z *, 
	;ktorego liczbe wierszy i giazdek podaje uzytkownik
	org	100h
	mov	ah,2
	jmp	prosba
pytanie:
	mov	ah,1
	int	21h
	sub	al,'0'
	mov	bl,al
	mov	ah,2
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	xor	cx,cx
	mov	ch,1
	mov	cl,bl
	jmp	petla
petla:
	cmp	ch,bl
	jl	petlawiersze
	je	petlawiersze
	jmp	koniec
petlawiersze:
	mov	dl,'*'
	int	21h
	dec	cl
	cmp	cl,ch
	ja	petlawiersze
	je	petlawiersze
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	mov	cl,bl
	inc	ch
	jmp	petla
prosba:
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	mov	dl,'*'
	int	21h
	mov	dl,'?'
	int	21h
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	jmp	pytanie
koniec:
	mov	ah,4Ch
	int	21h