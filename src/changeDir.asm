
; Tricount                  changeDir.ASM
; Objective: 
;      To chage the current dir 
;
; Input: 
;     The path of the dir to chage
;
; Output: 
;     - Change the dir to create files or others things
;     - Success message printed
;     - Error message printed
;
; Note: This program uses Linux system calls to manage file operations.

global changeDir

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to create file, maybe it already exists', 0 ; Error message
    success_msg db 'File created successfully!', 0 ; Success message

.UDATA

.CODE
    changeDir:
        enter 0,0
        ;Changing to the new directory
        sub ebx,ebx
        mov ebx, [ebp + 8]   ; Load the address of the directory name from the stack
        sub eax,eax
        mov eax, 12          ; Syscall number for chdir-https://chromium.googlesource.com/chromiumos/docs/+/master/constants/syscalls.md 
        int 80h              ; Call the interrupt
        leave
        ret 4