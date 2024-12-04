; Tricount                  readUsers.ASM
; Objective: 
;     
;
; Input: 
;    
;
; Output: 
;    
;     
;     
;
; 

global readUsers
extern readFile
extern StrToInt
extern strLen
extern requestMemory
extern addFirstLinkedList
%include "./io.mac"

.DATA
    number dd 0
    name_msg db 'Type the name of the user with the ID ', 0
    sig db ' : ', 0
    userCounter dd 0
.UDATA
    bufferUsers resb 1
    bufferAux resd 1
    name resb 1
    strLenght resb 1
    userList resd 1
.CODE
    readUsers:
        enter 0,0
        pusha
        
        push bufferUsers
        push dword [ebp+12]
        push dword [ebp+8]
        call readFile

        mov esi,bufferUsers
        
        sub eax, eax
        push number
        mov al, [esi]
        mov [bufferAux], eax
        push bufferAux
        call StrToInt

        nwln
        PutStr name_msg
        PutStr bufferAux
        PutStr sig
        GetStr name
        nwln
        nwln

        push DS 
        push name
        call strLen

        add eax, 1 ; Add one byte to save the null character
        mov [strLenght], eax ; Save the length of the string in ebx

        pop DS ; Restore the DS register
        
        ; Currently in eax is the length of the string.
        ; Request memory for the name of the user and save the address in edx.

        add eax, 5 ; Add five bytes to save the null ptr and the next ptr (nextNode necesary in function)
        push eax
        call requestMemory 
        
        ; Now the address of the memory requested for the name of the user is in edx
        ; Save the name of the user in the memory requested
        mov esi, name ; Load the address of the name of the user
        add edx, 4
        mov edi, edx ; Load the address of the memory requested || -: 4 byte  
        add ebx, 1
        mov ecx, [strLenght]  ; Load the length of the string
        rep movsb ; Copy the string to the memory requested || esi -> edi || ecx bytes 
        mov byte [edi + ecx], 0  ; Save the null character at the end of the string

        ; Now the memory is filled with the name of the user 
        ; And its saved on EDX. 

        mov [name], edx ; Save the address of the memory requested in a temporary pointer
        ; Now we need to create the structure of the user.

         ; The structure of the user is [LENSTRUCT, ID, name, netChange, ptrNext]

        ; Request memory for the structure of the user
        sub eax, eax
        mov eax, 20
        push eax
        call requestMemory

        ; Now the address of the memory requested for the structure of the user is in edx
        ; Fill the structure with the data of the user
        sub eax, eax
        mov eax, [userCounter]
        mov [edx+4], eax  ; Save the ID of the user
        mov eax, [name] 
        mov [edx+8], eax; Save the address of the name of the user
        mov eax, 0
        mov [edx+12], eax ; Save the net change of the user   
        push userList
        call addFirstLinkedList

        ; Now the user is added to the list of users.

        add dword [userCounter], 1 ; Increase the counter of the users

        mov eax, [userList]
        PutLInt [EAX]
        nwln
        PutLInt [EAX+4]
        nwln
        PutStr [eax+8]
        nwln
        PutLInt [EAX+12]
        nwln
        PutLInt [EAX+16]
        
        end:
        popa
        leave
        ret 8