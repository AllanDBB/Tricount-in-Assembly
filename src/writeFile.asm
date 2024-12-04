
; Tricount                  writeFile.ASM
; Objective: 
;     Append text to a file in the specified path.
;
; Input: 
;     The directory name, the file name, the text to write  are passed via the stack.
;     The length of the text is also passed via the stack.
;     If the last parameter is 1, a new line is inserted after the text.
;
; Output: 
;     - Text appended to file
;     - Success message printed if the operation is successful.
;     - Error message printed if the operation fails.
;
; Note: This program uses Linux system calls to manage file operations.

global writeFile

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to write to file', 0 
    success_msg db 'Text appended to file successfully!', 0
    returnPath db '..', 0
    nw db ' ',0

    nwline db 0Ah

.UDATA

.CODE
writeFile:
    enter 0,0
    pusha                  ; Save all registers
    ; Change to the directory
    mov ebx, [ebp + 20]   ; Load the address of the directory name from the stack
    mov eax, 12           ; Syscall number for chdir
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ; Open the file in append mode
    mov eax, 5            ; Syscall number for open
    mov ebx, [ebp+16]     ; Load the address of the file name
    mov ecx, 1026         ; Flags: O_WRONLY | O_CREAT | O_APPEND (decimal 1026)
    mov edx, 0o644        ; Permissions (rw-r--r--)
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error
    

    mov ebx, eax          ; Store the file descriptor in ebx

    ; Write to the file
    mov eax, 4            ; Syscall number for write
    mov ecx, [ebp+12]     ; Load the address of the text to write
    mov edx, [ebp+8]      ; Load the length of the text
    int 0x80              ; Call the interrupt

    ; Write to the file
    mov eax, 4            ; Syscall number for write
    mov ecx, nw           ; Load the address of the text to write
    mov edx, 1            ; Load the length of the text
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ;Insert a new line
    mov eax, 1
    cmp [ebp+24],eax
    jne .close

    ; Write to the file
    mov eax, 4            ; Syscall number for write
    mov ecx, nwline           ; Load the address of the text to write
    mov edx, 1            ; Load the length of the text
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ; Close the file
    .close:
    mov eax, 6            ; Syscall number for close
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ; Change to the directory
    mov ebx, returnPath  ; Load the address of the directory name 
    mov eax, 12           ; Syscall number for chdir
    int 0x80              ; Call the interrupt

    ; Print success message
    ;PutStr success_msg
    ;nwln
    jmp .exit

    .error:
        ; Print error message
        PutStr error_msg
        nwln

    .exit:
        ; Cleaning
        popa                   ; Restore all registers
        leave
        ret 16