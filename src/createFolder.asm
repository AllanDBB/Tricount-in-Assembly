; Tricount                  createFolder.ASM
; Objective: Create a folder in a specific path
; Input: Address of the directory name on the stack
; Output: Directory created or error message displayed

%include "./io.mac"          
global createFolder   ; Make the function global

.DATA
    success_msg db 'Folder created successfully!', 0 ; Success message
    error_msg db 'Error: Unable to create, because the name already exists!', 0 ; Error message

.UDATA

.CODE

    ; Function to create a directory with specified permissions
    ; Argument: address of the directory 

    createFolder:
        enter 0,0
        ; The address of the directory name is at [ebp + 8]
        mov ebx, [ebp + 8]   ; Load the address of the directory name from the stack

        mov ecx, 0o777       ; Load the permissions into ECX
        ;7 Read, write, and execute permissions for the owner and group.

        sub eax,eax
        mov eax, 39          ; Syscall number for mkdir -https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
        int 80h              ; Call the interrupt, looks system call number stored in EAX

        ; Check for errors 
        ;A return value of 0 indicates success, while any negative value indicates an error.
        cmp eax, 0           ; Check if the call was successful
        jl .error            ; If eax < 0, there was an error

        PutStr success_msg
        nwln
        
        ;cleaning
        sub eax,eax
        sub ebx,ebx
        sub ecx,ecx
        leave
        ret 4                          ; Return to the caller function

    .error:
        ; Print error message
        PutStr error_msg     ; Call PutStr to display the error message
        nwln                  ; New line for better readability

        ;cleaning
        sub eax,eax
        sub ebx,ebx
        sub ecx,ecx
        leave
        ret 4                          ; Return to the caller function
