 ; Tricount                  fillStrucutre.ASM
; Objective: 
;     Find the structure in the memory and fill it with the data 
; Input: 
;     The number of deptors is passed via the stack.
;
; Output: 
;     - The structure filled with the data of the debt
;     - Success message printed .
;     - Error message printed.
;
;Format of the memory: edx->[number of bytes, ptrguarantor , [ptrdebtors,amount], totalAmount, ptrNext]<- ebx

global fillStructure 

%include "io.mac"

.DATA
    error_msg db 'Error: Unable to fill the structure', 0 
    success_msg db 'The structure has been filled successfully!', 0 
    create_debt_guarantor_msg db 'Type the guarantor ID of the debt: ', 0
    create_debt_amount db 'Type the amount of the debt: ', 0

    create_debt_debtors_name db 'Type the ID of the debtor: ', 0
    create_debt_debtors_amount db 'Type the amount of the debtor: ', 0

    not_found_user_msg db 'The user was not found', 0
    found_user_msg db 'The user was found', 0

.UDATA
    structureSize resd 1;
    debtors resd 1
    userList resd 1


.CODE
    fillStructure:
        enter 0,0
        sub eax,eax
        nwln

        mov eax,[ebp+12] ; Load the address of the head of the linked list of  user
        ;Load the first node
        mov eax,[eax]
        mov [userList],eax

        ;Fill the guarantor
        jmp AskforGuarantor
        guarantorNotFound:
            sub eax,eax
            sub ebx,ebx
            pop ebx
            pop eax
        AskforGuarantor:
            PutStr create_debt_guarantor_msg
            GetInt [edx+4]
            push eax
            push ebx
            mov eax, [edx+4+ebx]
            mov ebx, [userList]
            push eax    ;User ID
            push ebx    ;First node of the linked list
            call searchUser
            cmp eax,-1
            je guarantorNotFound
            pop ebx
            mov [edx+4+ebx], eax ; Save the address of the debtor in the structure
            pop eax
            nwln

        ;Fill the deptors
        sub ebx,ebx
        sub eax,eax
        mov ebx,4        ; The offsets to add the debtors
        mov ecx, [ebp+8] ; Load the number of debtors

    CompleteDebtors:
        jmp AskforDebtor
        debtorNotFound:
            sub eax,eax
            sub ebx,ebx
            pop ebx
            pop eax
        
        AskforDebtor:
        PutStr create_debt_debtors_name
        GetInt [edx+4+ebx]   ; Fill the name of the debtor

        push eax
        push ebx
        mov eax, [edx+4+ebx]
        mov ebx, [userList]
        push eax    ;User ID
        push ebx    ;First node of the linked list
        call searchUser
        cmp eax,-1
        je debtorNotFound
        pop ebx
        mov [edx+4+ebx], eax ; Save the address of the debtor in the structure
        
        ;pop eax

        add ebx,4           ; Move the pointer to the AMOUNT of the debtor
        push ecx
        PutStr create_debt_debtors_amount
        GetLInt ecx ; Fill the amount of the debtor
        sub [eax+12],ecx ; Save the amount of the debtor
        mov [edx+4+ebx],ecx ; Save the address of the debtor in the structure
        pop ecx
        pop eax
        ;Fill the total amount
        add eax,[edx+4+ebx] ; Add the amount of the debtor to the total amount

        add ebx,4
        loop CompleteDebtors ; Repeat the process for the number of debtors


        mov [edx+4+ebx],eax ; Save the total amount of the debt
        sub ecx,ecx
        mov ecx, [edx+4] ; Load the number of debtors
        add [ecx+12],eax



        ;Fill the pointer to the next debt
        ;TODO: Implement the next debt
        cmp edx,0
        jl	error	;exit, if error 
        jmp exit

    searchUser:
        enter 0,0
        loopSearch:
        mov eax,[ebp+8] ; Linked list
        mov eax,[eax+4] ; Load the first node

        cmp [ebp+12], eax;Compare the ID of the user with the guarantor
        je foundUser

        mov eax,[ebp+8] ; Linked list
        mov ebx,[eax+16]; Load the pointer to the next user

        cmp ebx,0
        je notFoundUser
        mov [ebp+8],ebx
        jmp loopSearch


        leave
        ret 8

    foundUser:
        mov eax,[ebp+8] ; Load the address of the head of the linked list
        leave
        ret 8
    notFoundUser:
        mov eax,-1
        nwln
        PutStr not_found_user_msg
        nwln
        leave
        ret 8
        
    sub ecx,ecx
    sub eax,eax
    sub ebx,ebx
   

    error:
        PutStr error_msg    
      
    exit:
        ;Cleaning
        sub eax,eax
        sub ebx,ebx
        leave
        ret 4