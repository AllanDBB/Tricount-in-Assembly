; Tricount                 strLen.ASM
; Objective: 
;     Calculate the length of a string until the NULL character is found.
;
; Input: 
;     Takes a pointer to the string via the stack.
;
; Output: 
;     - The length of the string in EAX.
;     - Carry set (CF=1) if no string (NULL not found within the limit).
;     - Carry clear (CF=0) if a valid string length is calculated.
global strLen

%include "./io.mac"
STR_MAX   EQU   128   ; maximum string length

.DATA
    
strLen:

    push    EBP
    mov     EBP, ESP
    push    ECX
    push    EDI

	; Get the pointer to the string from the stack
    mov     EDI, [EBP + 8]  ; Pointer to the string
    mov     ECX, STR_MAX    ; Search limit
    cld                     ; Forward search
    mov     AL, 0           ; NULL character
    repne   scasb
    jcxz    sl_no_string    ; If NULL not found => no string
    dec     EDI             ; EDI points to the NULL character
    mov     EAX, EDI
    sub     EAX, [EBP + 8]  ; EAX = Length of the string
    clc                     ; No error
    jmp     SHORT sl_done

sl_no_string:
    stc                     ; Carry set => no string

sl_done:
    pop     EDI
    pop     ECX
    pop     EBP
    ret     4               ; Clean up the stack
