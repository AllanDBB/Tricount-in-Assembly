; Tricount                  createFile.ASM
; Objective: 
;      To create a file in the current directory,
;      it isn't able to create 2 files with the 
;      same name and extention. 
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

global createFile 

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to create file, maybe it already exists', 0 ; Error message
    success_msg db 'File created successfully!', 0 ; Success message

.UDATA

.CODE
createFile:
    ;Create the file
    enter 0,0
    mov ebx, [ebp + 8]            ; Load the file name address from the stack
    mov eax, 8                    ; syscall: creat https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
    mov ecx, 0o775      ; Load the permissions into ECX
    ;7 Read, write, and execute permissions for the owner and group.
    ;5 Read for others

    int 80H                       ; Execute the system call

    ; Check for errors
    cmp eax, 0
    jl .error                     ; If there is an error (eax < 0)

    ; Close the file
    mov eax, 6                    ; syscall: close https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
    int 80H                       ; Execute the system call

    ; Display success message
    PutStr success_msg
    nwln

    ;cleaning
    sub eax,eax
    sub ebx,ebx
    sub ecx,ecx
    leave
    ret 4                          ; Return to the caller function

.error:
    ; Error handling
    PutStr error_msg
    nwln
    ;cleaning
    sub eax,eax
    sub ebx,ebx
    sub ecx,ecx
    leave
    ret 4                             ; Return to the caller function