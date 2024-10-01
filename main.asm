; Tricount                  main.ASM
; Objective: 
; Input: 
; Output: 

%include "io.mac"          
;%include "createFolder.mac"   

.DATA
    file_name1 db '/deudas.txt', 0
    file_name2 db '/personas.txt', 0
    file_name3 db '/o.txt', 0

.UDATA
    folder_name resb 1

.CODE
   ;TODO: Research the correct way to import functions
    extern createFolder      ; Declare the external function
    extern createFile        ; Declare the external function
    extern appendString      ; Declare the external function

    .STARTUP
        GetStr folder_name, 1   ; Get the path name from user input
        ; Create folder
        push folder_name        ; Push the address of the folder name onto the stack
        call createFolder     ; Call the createFolder function
        add esp, 4            ; Clean up the stack after the call

        ; Create file deudas.txt
        mov edx, folder_name    ; Move the address of the path name to edx
        push file_name1       ; Push the address of the file name
        push edx              ; Push the address of the folder name
        call appendString      ; Call the appendString function to concatenate
        add esp, 8            ; Clean up the stack
    
        push edx              ; Push the folder name + file name
        call createFile       ; Call createFile
        add esp, 4            ; Clean up the stack

    .EXIT