; Tricount                  createFolder.ASM
; Objective: Create a folder in a specific path
; Input: Address of the directory name on the stack
; Output: Directory created or error message displayed

%include "io.mac"          

.DATA
    error_msg db 'Error: Unable to create, because the name already exists!', 0 ; Error message

.UDATA

.CODE
    global createFolder   ; Make the function global

    ; Function to create a directory with specified permissions
    ; Argument: address of the directory epx

    createFolder:
    ; The address of the directory name is at [esp + 4]
        mov ebx, [esp + 4]   ; Load the address of the directory name from the stack

        mov ecx, 0o755       ; Load the permissions into ECX
        ;7 Read, write, and execute permissions for the owner.
        ;5 Read and execute permissions for the group.
        ;5 Read and execute permissions for others.

        mov eax, 39          ; Syscall number for mkdir -https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
        int 80h              ; Call the interrupt, looks system call number stored in EAX

        ; Check for errors 
        ;A return value of 0 indicates success, while any negative value indicates an error.
        cmp eax, 0           ; Check if the call was successful
        jl .error            ; If eax < 0, there was an error

        ret                   ; Return if successful

    .error:
        ; Print error message
        PutStr error_msg     ; Call PutStr to display the error message
        nwln                  ; New line for better readability
        ret                   ; Return from the function
