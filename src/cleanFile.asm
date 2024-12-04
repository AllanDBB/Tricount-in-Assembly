
; Tricount                  clearFIle.ASM
; Objective: 
;     Clear the content of a file in the specified path.
;
; Input: 
;     The directory name, the file name  passed via the stack.
;
; Output: 
;     - The content of the file is cleared
;     - Success message printed if the operation is successful.
;     - Error message printed if the operation fails.
;
; Note: This program uses Linux system calls to manage file operations.

global cleanFIle

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to write to file', 0 
    success_msg db 'Text appended to file successfully!', 0
    returnPath db '..', 0
    blank db '',0


.UDATA

.CODE
cleanFIle:
    enter 0,0
   
    pusha                  ; Save all registers
    ; Change to the directory
    mov ebx, [ebp + 12]   ; Load the address of the directory name from the stack
    mov eax, 12           ; Syscall number for chdir
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ; Open the file in append mode
    mov eax, 5            ; Syscall number for open
    mov ebx, [ebp+8]     ; Load the address of the file name
    mov ecx, 577         ; Flags: O_WRONLY | O_CREAT |TRUNC 
    mov edx, 0o644        ; Permissions (rw-r--r--)
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error
    

    mov ebx, eax          ; Store the file descriptor in ebx

    ; Write to the file
    mov eax, 4            ; Syscall number for write
    mov ecx,blank    ; Load the address of the text to write
    mov edx, 0      ; Load the length of the text
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
        ret 8