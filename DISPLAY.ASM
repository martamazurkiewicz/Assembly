	org	100h
	pop	dx
	cmp	dx,0
	je	zero
	mov	bx,10
	mov	cx,0
division:
	xor	dx,dx
	div	bx
	push	dx	;push reminder
	inc	cx
	cmp	ax,0
	jne	division
	mov	ah,2
display:
	pop	dx
	add	dl,'0'
	int	21h
	dec	cx
	cmp	cx,0
	jg	display
end:
	mov	ax,4C00h
	int	21h
zero:
	mov	dx,'0'
	mov	ah,2
	int	21h
	jmp	end
	