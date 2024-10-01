; Tricount                  main.ASM
; Objective: 
; Input: 
; Output: 

%include "io.mac"          
;%include "createFolder.mac"   

.DATA
 

.UDATA
    folder_name resb 1
.CODE
   ;TODO: Research the correct way to import funtions
   extern createFolder  ; Declare the external function

    .STARTUP
        GetStr folder_name,1
        push folder_name     ; Push the address of the directory name onto the stack
        call createFolder  ; Call the createFolder function
        add esp, 4         ; Clean up the stack after the call

    .EXIT


