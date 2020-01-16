org     100h
        call    Znak
        call    Wykladnik
        call    Potega 
        call    PoliczCalosci
        call    Wyswietl
        mov     ah,2
        mov     dl,' '
        int     21h
        call    OstatniaJedynka
        call    PoliczMianownik
        call    PoliczLicznik
        mov     eax,[licznik]
        cmp     eax,0
        je      koniec
        call    Wyswietl
        mov     ah,2
        mov     dl,'/'
        int     21h
        mov     eax,[mianownik]
        call    Wyswietl
koniec:
        mov     ax,4c00h
        int     21h

Znak:
        mov     eax,[zmienna]
        ;and     eax,7fffffffh
        shr     eax,31
        cmp     eax,0
        jne     minus
ret
minus:
        mov     dl,'-'
        mov     ah,2
        int     21h
ret

Wykladnik:
        mov     eax,[zmienna]
        shl     eax,1
        shr     eax,1
        shr     eax,23
        sub     eax,127 ;cecha (wykladnik)
        mov     dword   [wykladnik],eax
ret

Potega:
        mov     ecx,eax
        mov     eax,1
        shl     eax,cl
        ;eax=2^ebx
        mov     dword   [potega2],eax
ret

Wyswietl:
	;w eax jest liczba
	mov	ebx,10
	mov	cx,0
division:
	xor	edx,edx
	div	ebx
	push	dx	;push reminder
	inc	cx
	cmp	eax,0
	jne	division
	mov	ah,2
display:
	pop	dx
	add	dl,'0'
	int	21h
	dec	cx
	cmp	cx,0
	jg	display
ret       

PoliczCalosci:
        mov     eax,[zmienna]
        shl     eax,9
        shr     eax,9
        mov     ecx,23
        sub     ecx,[wykladnik]
        shr     eax,cl
        or      eax,[potega2]
        mov     dword   [calosci],eax
ret

OstatniaJedynka:
        mov     ebx,2
        mov     ecx,0
        mov     eax,[zmienna]
        shl     eax,9
        shr     eax,9
petla4:
        xor     edx,edx
        div     ebx
        cmp     edx,1
        je      koniec4
        inc     ecx
        jmp     petla4
koniec4:
        mov     dword   [ostatniaJedynka],ecx
ret

PoliczMianownik:
        mov     ecx,23
        sub     ecx,[wykladnik]
        sub     ecx,[ostatniaJedynka]
        mov     eax,1
        shl     eax,cl
        mov     dword   [mianownik],eax
ret

PoliczLicznik:
        mov     eax,[zmienna]
        mov     ecx,9
        add     ecx,[wykladnik]
        shl     eax,cl
        shr     eax,cl
        mov     ecx,[ostatniaJedynka]
        shr     eax,cl
        mov     dword   [licznik],eax
ret

;kalkulator dziala dla liczb calkowitych pod warunkiem zapisu liczby jako liczba.0
zmienna dd      -13.625
;zmienna dd      -17.25
;zmienna dd      -100.0
wykladnik       dd      0
potega2       dd      0
calosci dd      0
licznik   dd      0
ostatniaJedynka dd      0
mianownik       dd      0
