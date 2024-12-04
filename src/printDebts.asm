; Tricount                 printDebts.ASM
; Objective: 
;     Print the debts in the linked list
;
; Input: 
;     Takes the address of the head of the linked list via the stack.
;
; Output: 
;     - The debts in the linked list are printed.
;     - Error message printed if the list is empty.
;     - In eax, 1 if the list is empty, 0 otherwise.
global printDebts

%include "io.mac"

.DATA
    nonUsers_msg db 'There are no debts included', 0
    list_msg db 'The debts are: ', 0
    guarantor_msg db 'Guarantor: ', 0
    debtor_msg db 'Debtor: ', 0
    amount_msg db 'Amount: ', 0
    totalAmount_msg db 'Total Amount: ', 0
    space db '------------------------------- ', 0

    waitStr db '', 0; to present a message and wait for a key press
    enter_msg db 'Press enter to continue ', 0

.UDATA
    limiteDebtor resd 1   ; Variable to store the number of debtors

.CODE
printDebts:
    enter 0,0
    xor eax, eax          ; Initialize eax to 0
    mov ecx, [ebp + 8]    ; Load the address of the head of the linked list

    cmp [ecx], eax        ; Check if the list is empty
    je empty              ; Jump to empty if the list is empty

    nwln
    PutStr list_msg
  

    ; Load the first node
    mov edx, [ecx]        ; edx points to the first node

print_loop:
    nwln
    PutStr space
    nwln
    ; Print the guarantor
    PutStr guarantor_msg
    mov ebx, [edx + 4]    ; Get the pointer to the guarantor's name
    PutStr [ebx + 8]      ; Print the guarantor's name

    ; Print the debtors
    nwln
    xor ecx, ecx          ; Clear ecx for the debtor counter
    mov ecx, [edx]        ; Get the number of debtors
    sub ecx, 8            ; Adjust to exclude the guarantor and the total amount fields
    mov [limiteDebtor], ecx ; Store the number of debtors
    mov ecx, 8            ; Offset for the first debtor entry

print_debtors:
    nwln
    PutStr debtor_msg
    mov esi, [edx + ecx]   ; Get the pointer to the debtor
    mov esi, [esi + 8]     ; Get the pointer to the debtor's name
    PutStr esi             ; Print the debtor's name
    add ecx, 4             ; Move to the next debtor

    nwln
    PutStr amount_msg
    mov eax, [edx + ecx]   ; Get the debtor's amount
    PutLInt eax            ; Print the amount
    add ecx, 4             ; Move to the next field

    cmp ecx, [limiteDebtor] ; Check if all debtors have been printed
    jl print_debtors

print_total:
    nwln
    PutStr totalAmount_msg
    mov ecx, [limiteDebtor] ; Load the total amount offset
    add ecx, 4             ; Adjust to the total amount field
    mov eax, [edx + ecx]    ; Get the total amount
    PutLInt eax             ; Print the total amount

    call blankSpaces
    
    nwln
    PutStr space
    nwln
    PutStr enter_msg
    nwln
    GetStr waitStr
    nwln

    ; Move to the next node
    mov eax, [edx]         ; Get the pointer to the next node
    mov edx, [edx + eax]   ; Move to the next node
    cmp edx, 0             ; Check if it's the end of the list
    jne print_loop         ; If not, continue printing

    xor eax, eax           ; Indicate the list is not empty
    jmp exit


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
    leave
    ret

empty:
    nwln
    mov eax, 1             ; Indicate the list is empty
    PutStr nonUsers_msg
    nwln
    PutStr space
    nwln
    PutStr enter_msg
    nwln
    GetStr waitStr
    nwln

    
exit:
    nwln
    PutStr space
    leave
    ret 4