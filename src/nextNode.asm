 ; Tricount                  nextNode.ASM
; Objective: 
;     Pass to the next node in the linked list
; Input: 
;     Takes the pointer to the head of the linked list via stack
;
; Output: 
;     - The next node in the linked list in edx
;     - Error message printed.
;
;Format of the memory: edx->[number of bytes, guarantor , [debtors,amount], totalAmount, ptrNext]

global nextNode 

%include "./io.mac"

.DATA
    error_msg db 'Error: You have reached the last node', 0 


.UDATA


.CODE
    nextNode:
        enter 0,0
        sub eax,eax
        sub ebx,ebx
        sub ecx,ecx
        nwln
        mov eax,[ebp+8] ; Load the address of the head of the linked list
        mov ebx,[eax] ; Load the address of the new node
        mov ecx, [ebx]
        
        mov edx,[ebx+ecx] ; Load the address of the next node
        
        cmp edx,0
        je error
        jmp exit

            

    error:
        PutStr error_msg    
      
    exit:
        ;Cleaning
        sub eax,eax
        sub ebx,ebx
        leave
        ret 4