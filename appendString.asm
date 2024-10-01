;Tricount                  appendString.ASM
; Objective: Append one string to another.
; Input: 
;   - Address of the destination string (folder_name) on the stack.
;   - Address of the source string (file_name) on the stack.
; Output:
;   - The destination string is modified to include the source string at the end.
;   - The function does not return any value, but the destination string is updated in-place.
%include "io.mac"

.DATA
 
.UDATA

.CODE
    global appendString      ; Make the function global

    ; Function to append one string to another
    ; Arguments: address of the destination string, address of the source string
    appendString:
        push edi             ; Save the original value of edi
        push esi             ; Save the original value of esi

        mov edi, [esp + 12]  ; Load the address of the destination string (folder_name) into edi
        mov esi, [esp + 16]  ; Load the address of the source string (file_name) into esi

        ; Find the end of the destination string (folder_name)
        .find_end:
            cmp byte [edi], 0  ; Check for null terminator
            je .append         ; If we reach null, we are at the end of the string
            inc edi            ; Move to the next character
            jmp .find_end      ; Repeat until null terminator

        ; Start appending the source string (file_name) to the destination string
        .append:
            .copy_source:
                lodsb             ; Load byte from source string (from esi)
                stosb             ; Store it in destination string (to edi)
                test al, al       ; Check for null terminator
                jnz .copy_source  ; Repeat until null terminator

        pop esi              ; Restore the original value of esi
        pop edi              ; Restore the original value of edi
        ret