; Tricount                   readFile.ASM
; Objective:
;     Read the content of a file where each line has entries separated by space (` `)
;     with records ending in double space (`  `) and lines by newline characters (`\n`).
; 
; Input:
;     - File name and directory passed via the stack.
;     - Buffer to store the data.
;
; Output:
;     - Parsed data is stored in memory or printed.
;     - Error message if the file cannot be read.

global readFile
%include "./io.mac"

.DATA
    newline db 0x0A, 0                 ; Newline character for Linux '\n'
    semicolon db ';', 0                ; Semicolon character
    double_semicolon db ";;", 0        ; Double semicolon indicator
    error_msg db 'Error: Unable to read the file', 0
    readSuccess_msg db 'File read successfully!', 0
    returnPath db '..', 0
.UDATA

.CODE
readFile:
    ; Set up the stack frame
    enter 0,0
    pusha

     ; Change to the directory
    
    mov ebx, [ebp + 12]   ; Load the address of the directory name from the stack
    mov eax, 12           ; Syscall number for chdir
    int 0x80              ; Call the interrupt

    cmp eax, 0
    jl .error             ; If eax < 0, there was an error

    ; Open the file (system call)
    ; System call: open (Linux, x86)
    ;   eax = 5 (sys_open)
    ;   ebx = filename pointer
    ;   ecx = flags (O_RDONLY)
    ;   edx = mode (not used for read)

    ; Get the file name and directory from the stack
    mov ebx, [ebp+8]          ; File name
    mov eax, 5                ; sys_open
    mov ecx, 0                ; O_RDONLY (read only)
    int 0x80                  ; Call the kernel
    
    ; Check if the file opened successfully
    cmp eax, 0
    js .error                 ; If eax < 0, go to error
    mov ebx, eax              ; Store file descriptor in ebx
    
    ; Read from the file (system call)
    ; System call: read (Linux, x86)
    ;   eax = 3 (sys_read)
    ;   ebx = file descriptor
    ;   ecx = buffer pointer
    ;   edx = buffer size
    
    mov eax, 3                ; sys_read
    mov ecx, [ebp+16]           ; Buffer to store data
    mov edx, 1024             ; Maximum bytes to read (adjust as needed)
    int 0x80                  ; Call the kernel
    
    ; Check if the read was successful
    cmp eax, 0
    js .error                 ; If eax < 0, go to error
    mov ecx, eax              ; ecx = number of bytes read
    
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

    
    
    ; Successfully finished parsing
    .done:
        jmp .end

    ; Error handling
    .error:
        PutStr error_msg
    
    ; Clean up and return
    .end:
        popa
        leave
        ret 12