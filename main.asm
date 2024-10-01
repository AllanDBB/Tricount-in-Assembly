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
    folder_name resb 2

.CODE
   ;TODO: Research the correct way to import funtions
    extern createFolder      ; Declare the external function
    ;extern createFile        ; Declare the external function
    extern appendString      ; Declare the external function

    .STARTUP
        ; Create folder
        GetStr folder_name,1
        push folder_name     ; Push the address of the folder name onto the stack
        call createFolder    ; Call the createFolder function
        add esp, 4          ; Clean up the stack after the call

        ; Crear archivo deudas.txt
        push file_name1             ; Empujar la dirección del nombre del archivo
        push folder_name            ; Empujar la dirección del nombre de la carpeta
        call appendString           ; Llamar a la función appendString para concatenar
        add esp, 8                  ; Limpiar la pila

        PutStr folder_name
        ;push folder_name            ; Empujar el nombre de carpeta + archivo
        ;call createFile             ; Llamar a createFile
        ;add esp, 4                  ; Limpiar la pila

    .EXIT