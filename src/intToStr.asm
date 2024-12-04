; Tricount                  intToStr.ASM
; Objective: 
;     Convert an integer to a string, including trailing zeros.
;
; Input: 
;     The integer to be converted is passed via the stack.
;     The address of the buffer where the string will be stored is also passed via the stack.
;
; Output: 
;     - The string representation of the integer in the buffer.
;     - Optional success message printed if the operation is successful.
;     - Error message printed if the operation fails.

global intToStr
%include "./io.mac"

.DATA
    digits db "0123456789", 0        ; Digits lookup table
    error_msg db 'Error: Unable to convert integer', 0 
    success_msg db 'Conversion successful!', 0

.UDATA

.CODE
intToStr:
    ; Set up the stack frame
    enter 0,0
    pusha
    mov esi, [ebp+8]      ; Load the integer to convert
    mov eax, [ebp+12]     ; Load the output buffer address
    push esi              ; Save the output string pointer on the stack for later use
    push eax              ; Save the value of EAX on the stack because the next loop will change its value

    mov edi, 1            ; To keep the number of digits in the original number
    mov ecx, 1            ; To keep the divisor
    mov ebx, 10           ; To divide the number by ten in each iteration
    .checkNegCount:
        cmp eax, 0
        jge .get_divisor
        neg eax
        mov byte [esi], '-'
        inc esi
    .get_divisor:
        xor edx, edx
        div ebx           ; Reduce EAX by one digit
        
        cmp eax, 0        ; Compare EAX with zero
        je ._after        ; Break the loop if equal
        imul ecx, 10      ; Otherwise, increase the divisor (ECX) ten times
        inc edi           ; Increment number of digits (EDI)
        jmp .get_divisor  ; Unconditional jump to the start of the loop

    ._after:
        pop eax           ; Get back the value of EAX from the stack
        push edi          ; Put the number of digits on the stack for later
    .checkNegToString:
        cmp eax, 0
        jge .to_string
        neg eax

    .to_string:
        xor edx, edx
        div ecx           ; Divide the number (EAX) by the divisor to get the first digit from the left

        add al, '0'       ; Add the base (48) to the digit because we want to store an ASCII string
        mov [esi], al     ; Move the value into the string
        inc esi           ; Increment the pointer to the next byte

        push edx          ; Push the remaining part of the number onto the stack
        xor edx, edx      
        mov eax, ecx     
        mov ebx, 10       
        div ebx           ; Reduce the divisor (ECX) ten times
        mov ecx, eax      ; Put the new divisor back into (ECX)

        pop eax           ; Pop the top of the stack into (EAX). It's the remaining part of the number
        
        cmp ecx, 0        ; Check if the divisor has become zero
        jg .to_string     ; If not, repeat the same process

    pop edx               ; Pop the number of digits in the original number from the stack (EDI)
    pop esi               ; Restore ESI to the beginning of the string before returning

    popa
    leave
    ; Return
    ret 8