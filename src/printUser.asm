 ; Tricount                 printUsers.ASM
; Objective: 
;     Print the users in the linked list
;
; Input: 
;     Takes the address of the head of the linked list via stack
;
; Output: 
;     - The users in the linked list printed
;     - Error message printed if the list is empty.
;   - In eax, 1 if the list is empty, 0 otherwise
;


global printUsers 

%include "io.mac"

.DATA
    nonUsers_msg db 'There are no users included', 0
    list_msg db 'The users are: ', 0
    id_msg db 'ID: ', 0
    name_msg db 'Name: ', 0
    addFirstUser db 'Add a user first... You will be redirected. ', 0
    space db '------------------------------- ', 0
.UDATA
   
.CODE
    printUsers:
        enter 0,0
        sub edx,edx 
        sub eax,eax
        sub ecx,ecx
        mov ecx,[ebp+8] ; Load the address of the head of the linked list

        cmp [ecx],eax
        je .empty

        nwln
        PutStr list_msg

        nwln
        PutStr space
        
        ;Load the first node
        mov edx,[ecx]

        .print:
            ;Print the ID
            nwln
            PutStr id_msg
            PutLInt [edx+4]
            nwln

            ;Print the name
            PutStr name_msg
            sub eax,eax
            sub ecx,ecx
            mov ecx,[edx+8]; Load the address of the name
            PutStr ecx ; Print the name
            nwln
            PutStr space

            ;Move to the next node
            mov eax,[edx]
            mov edx,[edx+eax]

           ;Check if is the end of the list
            cmp edx,0
            jne .print
            sub eax,eax
        jmp exit


    .empty:
        nwln
        mov eax, 1 ; Check if the list is empty
        call blankSpaces
        PutStr nonUsers_msg
        nwln
        PutStr addFirstUser

    exit:
        ;Cleaning
        sub ecx,ecx
        sub ebx,ebx
        leave
        ret 4

blankSpaces:
        enter 0,0
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        nwln
        leave
        ret