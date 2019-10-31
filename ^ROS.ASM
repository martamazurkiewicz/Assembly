	;trojkat rosnacy z gwiazdek
	;uzytkownik podaje liczbe wierszy ma trojkat
	org	100h
	mov	ah,2
	jmp	prosba

pobranie:
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
	mov	cl,1
	jmp	petla

petla:
	cmp	ch,bl
	jl	petlawiersz
	je	petlawiersz
	jmp	koniec

petlawiersz:
	inc	cl
	mov	dl,'*'
	int	21h
	cmp	cl,ch
	jl	petlawiersz
	je	petlawiersz
	mov	cl,1
	mov	dl,13
	int	21h
	mov	dl,10
	int	21h
	inc	ch
	jmp	petla

prosba:	
	mov	dl,'I'
	int	21h
	mov	dl,'l'
	int	21h
	mov	dl,'e'
	int	21h
	mov	dl,' '
	int	21h
	mov	dl,'g'
	int	21h
	mov	dl,'w'
	int	21h
	mov	dl,'i'
	int	21h
	mov	dl,'a'
	int	21h
	mov	dl,'z'
	int	21h
	mov	dl,'d'
	int	21h
	mov	dl,'e'
	int	21h
	mov	dl,'k'
	int	21h
	mov	dl,'?'
	int	21h
	mov	dl,10
	int	21h
	mov	dl,13
	int	21h
	jmp	pobranie
koniec:
	mov	ax,4C00h
	int	21h