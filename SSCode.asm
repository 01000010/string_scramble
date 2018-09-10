; Scramble a string 

;.386
.model flat,C
;.stack 4096


.data

iMod	DD	?
iSize	DD  ?
iSeed	DD	?

.code

;********************************************************************************

STScramble32 proc C

	; Procedure Prolog

	push ebp		; Save the old base pointer value
	mov ebp, esp	; Set the new base pointer value.

	sub esp, 4		; Make room for one 4-byte local variable.

	push ebx
	push edi
	push esi

	; Procedure Body

	push [ebp+8]
	call STLength32
	add esp, 4

	cmp eax,1
	jle exit

	mov [ebp-4], eax	; save string size

	push eax
	call RDSetSize
	add esp, 4

	push [ebp+12]
	call RDSetSeed
	add esp, 4

    mov edi, [ebp+8]
	mov esi, edi
	mov ebx, [ebp-4]

next_char:

	call RDRandom

	mov ecx, [esi]
	mov edx, [edi+eax*4]
	mov [edi+eax*4], ecx
	mov [esi], edx

	add esi, 4
	dec ebx

	jnz next_char

	mov eax, [ebp-4]

exit:

	; Subroutine Epilogue 

	pop esi
	pop edi
	pop ebx

	mov  esp, ebp		; Deallocate local variables
	pop  ebp			; Restore the caller's base pointer value
	ret
			
STScramble32 endp

;********************************************************************************

STUnscramble32 proc public

	; Procedure Prolog

	push ebp			; Save the old base pointer value
	mov ebp, esp		; Set the new base pointer value.

	sub esp, 4		; Make room for one 4-byte local variable.

	push ebx
	push edi
	push esi

	; Procedure Body

	push [ebp+8]		; Get the string length
	call STLength32
	add esp, 4

	cmp eax,1
	jle exit

	mov [ebp-4], eax			; save string size

	push eax
	call RDSetSize
	add esp, 4

	push [ebp+12]
	call RDSetSeed
	add esp, 4

	mov  ebx, [ebp-4]			; retrieve the string size
	mov  edi, [ebp+8]			; get the start of the string
	lea  esi, [edi+ebx*4]		; calculate end of the string

next_char:

	sub  esi, 4

	call RDRandomReverse

	mov  ecx, [esi]
	mov  edx, [edi+eax*4]
	mov  [edi+eax*4], ecx
	mov  [esi], edx

	cmp esi,edi

	jne next_char

	xor eax,eax

exit:

	; Subroutine Epilogue 

	pop  esi
	pop  edi
	pop  ebx

	mov  esp, ebp		; Deallocate local variables
	pop  ebp			; Restore the caller's base pointer value
	ret			

STUnscramble32 endp


;********************************************************************************

STCopy32 proc public

	; Procedure Prolog

	push ebp		; Save the old base pointer value
	mov  ebp, esp	; Set the new base pointer value.

	push esi		; Save the values of registers that the function
	push edi

	; Procedure Body

	mov  edi, [ebp+8]
	mov  esi, [ebp+12]
	mov  ecx, [ebp+16]

	cld
	rep  movsd 

	mov eax, [ebp+8]

    ; Subroutine Epilogue 

	pop  edi
	pop  esi

	pop  ebp			; Restore the caller's base pointer value
	ret

STCopy32 endp

;********************************************************************************

STFill32 proc public

	; Procedure Prolog

	push ebp		; Save the old base pointer value
	mov  ebp, esp	; Set the new base pointer value.

	push edi		; Save the values of registers that the function

	; Procedure Body

	mov  edi, [ebp+8]
	mov  eax, [ebp+12]
	mov  ecx, [ebp+16]

	cld
	rep  stosd 

	mov eax, [ebp+8]

    ; Subroutine Epilogue 

	pop  edi

	pop  ebp			; Restore the caller's base pointer value
	ret

STFill32 endp


;********************************************************************************

STLength32 proc public


	; Procedure Prolog

	push ebp		; Save the old base pointer value
	mov  ebp, esp	; Set the new base pointer value.
	push edi		; Save the values of registers that the function

    ; Procedure Body

	xor  eax, eax
	mov  edi, [ebp+8]   ; Move value of parameter 1 into EDI
	xor  ecx, ecx
	not  ecx

	cld
    repnz scasd 

	not  ecx
	dec  ecx
	mov  eax,ecx

    ; Subroutine Epilogue 

	pop  edi
	pop  ebp			; Restore the caller's base pointer value
	ret

STLength32 endp

;********************************************************************************

RDIsPrime proc public

	; Procedure Prolog

	push ebp			; Save the old base pointer value
	mov  ebp, esp		; Set the new base pointer value.

    push ebx
	push edi
	push esi

    ; Procedure Body

	mov eax, [ebp+8]	

	test eax,eax		; check for zero
	je not_prime        ;

	cmp eax,3			; check for number less than or equal to 3
	jle is_prime        ;

	test eax,1			; check for even numbers
	jz not_prime 		;

	mov  ebx, eax		; save the number we are checking
	mov  esi, 3			; start by dividing by 3	
	mov  edi, ebx		; check division up to half our number
	shr  edi, 1			;
	
prime_check_loop:

	mov eax, ebx        ; retreive our number
	xor edx, edx		; clear high bits for division

	cmp esi, edi        ; check if we made it half way up
	jae is_prime		;     if so we are prime. 	

	idiv esi			; Do our division
	test edx, edx		; test remainder
	jz not_prime		; if it's zero we are not prime
	
	add esi,2			; get next number to check.
	jmp prime_check_loop

not_prime:

	xor eax, eax

is_prime:

    ; Subroutine Epilogue 

	pop  esi
	pop  edi
	pop  ebx

	pop  ebp			; Restore the caller's base pointer value
	ret

RDIsPrime endp

;********************************************************************************

RDFindNextPrimeCongruentTo3Mod4 proc public

	; Procedure Prolog

	push ebp			; Save the old base pointer value
	mov  ebp, esp		; Set the new base pointer value.

	push ebx
	
    ; Procedure Body

	mov ebx, [ebp+8]	; Get lenght
	shr ebx, 2          ; Find first number below the length (ebx) 
	shl ebx, 2          ;    that satisfies ebx is congruent to 3 mod 4
	dec ebx             ;

next_num:

    add ebx, 4

    push ebx
	call RDIsPrime
	add esp, 4

	test ax,ax
	jz next_num
	  
    ; Subroutine Epilogue 

	pop  ebx

	pop  ebp			; Restore the caller's base pointer value
	ret

RDFindNextPrimeCongruentTo3Mod4 endp

;********************************************************************************

RDSetSize proc public

	; Procedure Prolog	

	push ebp			; Save the old base pointer value.
	mov ebp, esp		; Set the new base pointer value.

	; Procedure Body

	mov  eax,[ebp+8]
	mov  iSize, eax

	push [ebp+8]		; Set maximum to parameter 1
	call RDFindNextPrimeCongruentTo3Mod4
	add esp, 4

	mov  iMod, eax
	xor  ecx, ecx
	mov  iSeed, ecx

	; Subroutine Epilogue 

	pop ebp				; Restore the caller's base pointer value
	ret

RDSetSize endp

;********************************************************************************

RDSetSeed proc public

	; Procedure Prolog

	push ebp			; Save the old base pointer value.
	mov ebp, esp		; Set the new base pointer value.

	; Procedure Body

	mov  edx, 0			; set the seed. Take the modulous in case
	mov  eax, [ebp+8]	;	the caller specifies a number above iMod
	idiv iMod			;
	mov  iSeed, edx		;

  	; Subroutine Epilogue 

	pop ebp				; Restore the caller's base pointer value
	ret

RDSetSeed endp

;********************************************************************************

RDRandom proc public

	; Procedure Prolog

	push ebp				; Save the old base pointer value.
	mov  ebp, esp			; Set the new base pointer value.

	push esi
	push edi

	; Procedure Body

    mov  esi, iSeed

next_seed:

	mov  ecx, esi			; Save our seed for high check later
    mov  eax, esi			; Put seed in eax for processing
	imul eax				; Square seed
	idiv iMod				; Mod seed
	mov  edi, edx			; Save result for return 

	shl  ecx, 1				; check for upper range
	cmp  ecx, iMod			;
	jb   not_high			;

	mov edi, iMod			; We are in the upper range so subtract result from iMod
	sub edi, edx			;

not_high:

	inc  esi				; increment our seed
    mov  eax, esi			; Get ready for division
	xor  edx, edx			; clear for division
	idiv iMod				; Mod our seed so it wraps if when it gets to the end of the number range
	mov  esi, edx			; Save the result in the seed register

	cmp edi, iSize			; Did we find a number in the range?
	jae next_seed			; If not try next seed

    mov  iSeed, esi			; Save the seed we are on
	mov  eax, edi			; Set the reuturn value

    ; Subroutine Epilogue 

	pop edi
	pop esi

	pop ebp				; Restore the caller's base pointer value
	ret

RDRandom endp

;********************************************************************************

RDRandomReverse proc public

	; Procedure Prolog

	push ebp				; Save the old base pointer value.
	mov  ebp, esp			; Set the new base pointer value.

	push esi
	push edi

	; Procedure Body

    mov  esi, iSeed

next_seed:

	add  esi, iMod			; Instead of just decrementing our seed
	dec  esi				;    we add iMod and dec one to keep it from going negetive 
	mov  eax, esi			; Get ready for division
	xor  edx, edx			; Clear for division
	idiv iMod				; Mod seed
	mov  esi, edx			; Save result for later

	mov  ecx, esi			; Save our seed for high check later
    mov  eax, esi			; Put Seed in eax for processing
	imul eax				; Square seed
	idiv iMod				; Mod seed
	mov  edi, edx			; Save result for return 

    shl  ecx, 1				; check for upper range
	cmp  ecx, iMod			;
	jb   not_high			;

	mov edi, iMod
	sub edi, edx

not_high:

	cmp  edi, iSize			; Did we find a number in the range?
	jae  next_seed			; If not try next seed

    mov  iSeed, esi			; Save the seed we are on
	mov  eax, edi			; Set the reuturn value

    ; Subroutine Epilogue 

	pop edi
	pop esi

	pop ebp				; Restore the caller's base pointer value
	ret

RDRandomReverse endp

;********************************************************************************

end 