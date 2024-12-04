 ; Tricount                 addFisrtLinkedList.ASM
; Objective: 
;     Add nodes to the linked list
;
; Input: 
;     Takes edx as the address the new node
;     Takes a variable via stack with the address of the head of the linked list
;
; Output: 
;     - The new node added to the linked list in first position
;

;Format of the memory: edx->[number of bytes, ..... , ..... , ptrNext]

global addFirstLinkedList 

%include "io.mac"

.DATA

.UDATA
   
.CODE
    addFirstLinkedList:
        enter 0,0
        sub ecx,ecx 
        sub eax,eax
        mov ecx,[ebp+8] ; Load the address of the head of the linked list

        cmp [ecx],eax
        je .empty

        

        ;If the linked list is not empty
        sub eax,eax
        mov eax,[edx] ; Load the address of the head of the linked list
        mov ebx,[ecx] ; Load the address of the new node
        mov [edx+eax],ebx ; Save the address of the new node in the next pointer of the new node
        mov [ecx],edx ; Save the address of the new node as the new head of the linked list
        jmp exit

        .empty:
            mov [ecx],edx   ; Save the address of the new node as the new head of the linked list

            
      
    exit:
        ;Cleaning
        sub eax,eax
        sub ecx,ecx
        sub ebx,ebx
        leave
        ret 4