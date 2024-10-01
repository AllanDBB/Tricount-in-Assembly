; Tricount                  createFile.ASM
; Objective: 
;     To create a file in the current directory,
;     and handle any potential errors during the process.
;
; Input: 
;     The name of the file to create is passed via the stack.
;
; Output: 
;     - A file in the path on the stack
;     - Success message printed to standard output if file creation is successful.
;     - Error message printed to standard output if file creation fails.
;
; Note: This program uses Linux system calls to manage file operations.
%include "io.mac"

.DATA
    error_msg db 'Error: Unable to create file', 0 ; Error message
    success_msg db 'File created successfully!', 0 ; Success message

.UDATA

.CODE
    global createFile   ; Make the function global

createFile:
    ; Open or create the file
    mov eax, 8                    ; syscall: creat
    mov ebx, [esp + 4]            ; Load the file name address from the stack
    mov ecx, 0o755                ; Load the permissions into ECX
    ; 7 Read, write, and execute permissions for the owner.
    ; 5 Read and execute permissions for the group.
    ; 5 Read and execute permissions for others.

    int 0x80                      ; Execute the system call

    ; Check for errors
    cmp eax, 0
    jl .error                     ; If there is an error (eax < 0)

    ; File descriptor is returned in EAX, can be used for further operations if needed.
    ; Close the file
    mov eax, 6                    ; syscall: close
    mov ebx, eax                  ; Use the file descriptor returned from creat
    int 0x80                      ; Execute the system call

    ; Display success message
    PutStr success_msg

    ret                           ; Return to the caller function

.error:
    ; Error handling
    PutStr error_msg

    ret                           ; Return to the caller function