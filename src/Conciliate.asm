; Tricount                 Conciliate.ASM
; Objective: 
;     Handle the conciliation of payments between users.
;
; Input: 
;     Takes user payment data via predefined variables.
;
; Output: 
;     - Displays messages indicating who paid whom and the payment amounts.
;     - Uses predefined strings for formatting output.

%include "./io.mac"
global Conciliate
.DATA
    ; User payment amount to another user
    Payment db ' paid ', 0
    topaying db ' to ', 0

    WasGreater2 db ' was greater than ', 0
    WasEqual2 db ' was equal to ', 0
    WasLess2 db ' was less than ', 0

.UDATA

.CODE
    Conciliate:
        enter 0,0
        pusha

        mov eax, [ebp+8] ; Load the pointer to the first node of the linked list STRUCT: [len_struct, ID, name, netChange, ptrNext]
        mov eax, [eax]
        jmp PushNegatives

    PushNegatives:
        cmp eax, 0
        je DoSubstractions
        
        mov ebx, [eax+12] ; Load the net change of the user [STRUCT, ID, name, netChange, ptrNext]
        cmp ebx, 0  ; Compare the net change of the user with 0
        
        je NextNode
        cmp ebx, 0
        jg NextNode

        push eax
        jmp NextNode

    NextNode:
        mov eax, [eax+16] ; Load the next node of the linked list    
        jmp PushNegatives


    DoSubstractions:
        sub ebx, ebx
        mov edx, [ebp+8]
        mov edx, [edx]

    MiddleStep:
        cmp edx, 0
        je Exit

        mov ecx, [edx+12]
        
        cmp ecx, 0
        jl NextPositive
        cmp ecx, 0
        je NextPositive

        pop eax ; SEGMENATION FAULT PROBABLY
        mov ebx, [eax+12]

        add ecx, ebx
        
        cmp ecx, 0
        jg WasGreater

        cmp ecx, 0
        je WasEqual

        cmp ecx, 0
        jl WasLess



    NextPositive:
        mov edx, [edx+16]
        jmp MiddleStep

    WasGreater:
        PutStr [eax+8]
        PutStr Payment
        mov ebx, [eax+12]
        neg ebx
        PutLInt ebx
        PutStr topaying
        PutStr [edx+8]
        nwln
        sub ebx, ebx
        mov [eax+12], ebx
        mov [edx+12], ecx
        jmp DoSubstractions

    WasEqual:
        PutStr [eax+8]
        PutStr Payment
        mov ebx, [eax+12]
        neg ebx
        PutLInt ebx
        PutStr topaying
        PutStr [edx+8]
        nwln
        sub ebx, ebx
        mov [eax+12], ebx
        mov [edx+12], ebx
        jmp NextPositive

    WasLess:
        PutStr [eax+8]
        PutStr Payment
        PutLInt [edx+12]
        PutStr topaying
        PutStr [edx+8]
        nwln
        sub ebx, ebx
        mov [eax+12], ecx
        mov [edx+12], ebx
        push eax
        jmp NextPositive


    Exit:
        popa
        leave
        ret 4
