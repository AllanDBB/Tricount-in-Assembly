; Tricount                  createFile&Folder.ASM
; Objective: 
;     Create the necesary files to the app and create
;     a folder to save it
;
; Input: 
;     The name of tthe files and the directory name on the stack.
;
; Output: 
;     - A files in the path on the stack
;     - Success message printed to standard output if file creation is successful.
;     - Error message printed to standard output if file creation fails.
;
; Note: This program uses Linux system calls to manage file operations.

global createFile_Folder 

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to create files or folder, maybe it already exists', 0 
    success_msg db 'Files and folder created successfully!', 0 
    returnPath db '..', 0

.UDATA

.CODE
createFile_Folder:

    enter 0,0
    ; Create the new directory
    mov ebx, [ebp+16]   ; Load the address of the directory name
    mov ecx, 0o775      ; Load the permissions into ECX
    ;7 Read, write, and execute permissions for the owner and group.
    ;5 Read for others

    sub eax,eax
    mov eax, 39          ; Syscall number for mkdir -https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
    int 80h              ; Call the interrupt, 

    ; Check for errors 
    ;A return value of 0 indicates success
    cmp eax, 0           ; Check if the call was successful
    jl .error            ; If eax < 0, there was an error

    ;Changing to the new directory
    sub ebx,ebx
    mov ebx, [ebp + 16]   ; Load the address of the directory name from the stack
    sub eax,eax
    mov eax, 12          ; Syscall number for chdir-https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
    int 80h              ; Call the interrupt

    ;TODO: Could we close the file?, it generates a error
    ; Create the 3 text files, it could vary
    mov ebx, [ebp+12]  ; Load the address of the file 1 name
    mov ecx, 0o777     
    sub eax,eax
    mov eax, 8          ; Syscall number for creat-https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
    int 80h             
    ; Close the file
    mov ebx, eax
    mov eax, 6                    ; syscall: close https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
    int 80H                       ; Execute the system call

    mov ebx, [ebp+8]  ; Load the address of the file 2 name
    mov ecx, 0o777       
    sub eax,eax
    mov eax, 8          
    int 80h              
    ; Close the file
    mov ebx, eax
    mov eax, 6                    ; syscall: close https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md
    int 80H                       ; Execute the system call
    
 
    ;PutStr success_msg
    ;nwln

    ; Change to the directory
    mov ebx, returnPath  ; Load the address of the directory name 
    mov eax, 12           ; Syscall number for chdir
    int 0x80              ; Call the interrupt

    ;cleaning
    sub eax,eax
    sub ebx,ebx
    sub ecx,ecx
    leave
    ret 16               ; Return to the caller function and clean stack

.error:
    ;Print error message
    PutStr error_msg     
    nwln                  

    ;cleaning
    
    sub ebx,ebx
    sub ecx,ecx
    leave
    sub eax, eax 
    mov eax, 1 ; Error code
    ret 16                       