; Tricount                  StrToInt.ASM
; Objective: 
;     Convert a string representing a non-negative integer to an actual integer.
;
; Input: 
;     The address of the string to be converted is passed via the stack.
;
; Output: 
;     - The converted integer is returned in EAX.
;     - Error message printed if the conversion fails.

global StrToInt
%include "./io.mac"

.DATA
    digits db "0123456789", 0        ; Digits lookup table
    error_msg db 'Error: Invalid number format', 0 
    success_msg db 'Conversion successful!', 0

.CODE
StrToInt:
    ; Set up the stack frame
    enter 0,0
    pusha

    ; Load the address of the input string
    mov esi, [ebp+8]     ; ESI points to the input string

    ; Initialize variables
    xor eax, eax         ; EAX will hold the result (initialize to 0)
    mov ebx, 10          ; EBX is the base multiplier (10 for decimal)

    .parse_digits:
        ; Parse each digit until a non-digit character is found
        mov al, [esi]       ; Load the current character

        cmp al, 0           ; Check if it's the end of the string (null terminator)
        je .conversion_done ; If end of string, jump to end parsing
        cmp al, '0'         ; Check if it's less than '0'
        jb .error           ; If it's not a digit, go to error
        cmp al, '9'         ; Check if it's greater than '9'
        ja .error           ; If it's not a digit, go to error

        ; Convert ASCII character to integer (0-9)
        sub al, '0'         ; Convert ASCII to integer value
        movzx edx, al       ; Move the digit into EDX

        ; Update result in EAX (multiply by 10 and add the new digit)
        imul eax, ebx       ; EAX *= 10
        add eax, edx        ; EAX += current digit

        ; Move to the next character
        inc esi
        jmp .parse_digits

    .conversion_done:
        mov ebx, [ebp+12]   ; Load the address of the result variable
        mov [ebx], eax   ; Store the result in the number variable
        jmp .cleanup

    .error:
        ; If an invalid character was encountered, print error
        PutStr error_msg
        xor eax, eax        ; Return 0 to indicate error

    .cleanup:
        ; Clean up and return
        popa
        leave
        ; Return, result is in EAX

        ret 8