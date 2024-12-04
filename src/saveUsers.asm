; Tricount                  saveUser.ASM
; Objective: 
;     To save in a file the users of the debts list
;
; Input: 
;     The directory name, the file name and list pointer are passed via the stack.
;
; Output: 
;     - The content of the memory printed and stored in the file
;     - Success message printed if the operation is successful.
;     - Error message printed if the operation fails.
;
; Note: This program uses Linux system calls to manage file operations.

global saveUsers
extern writeFile
extern strLen
extern intToStr
%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to save the memory', 0 
    success_msg db 'Saved successfully!', 0
    saving_msg db 'Saving the memory in directory: ', 0
    empty db '', 0
    emptyList_msg db 'The memory is empty', 0
    blank db '', 0
    

.UDATA
    bufferId resb 1 
    bufferName resb 1
    
.CODE
    saveUsers:
        enter 0,0
 
        sub eax, eax
        mov eax , [ebp+8] ; get the userLits pointer

        sub ebx, ebx
        mov ebx,0
        cmp [eax], ebx;If the list is empty, return
        je emptyList
        

        mov eax, [eax]
        mov edx , eax ; save the pointer to the user list
        nwln
        PutStr saving_msg
        PutStr [ebp+16]
        nwln
        looping:
            sub eax, eax
            ;Savind ID
 
            mov eax, [edx+4] ; get the ID
            push eax
            push bufferId
            call intToStr ; convert the ID to string
            push DS
            push bufferId
            
            call strLen; get the length of the string

           ;the length is in eax
          sub ebx, ebx
           mov ebx, 0
           push ebx ; no enter
      
           mov ebx,[ebp+16]
           push ebx ; the directory name

           mov ebx,[ebp+12]
           push ebx ; the file name

           mov ebx, bufferId
           push ebx ; the string
           push eax ; length of the string
    
           call writeFile ; write the ID in the file

            ;Saving the name
            push DS
            mov eax, [edx+8]
            push eax
            call strLen; get the length of the string
            ;the length is in eax

            sub ebx, ebx
            mov ebx, 0
            push ebx ;no  enter

            mov ebx,[ebp+16]
            push ebx ; the directory name

            mov ebx,[ebp+12]
            push ebx ; the file name

            mov ebx, [edx+8]
            push ebx ; the string

            push eax ; length of the string

            call writeFile ; write the name in the file

            ;Saving a blank space
            push DS
            push blank
            call strLen; get the length of the string
            ;the length is in eax

            sub ebx, ebx
            mov ebx, 1
            push ebx ; no enter

            sub ebx, ebx
            mov ebx,[ebp+16]
            push ebx ; the directory name

            mov ebx,[ebp+12]
            push ebx ; the file name

            mov ebx, blank
            push ebx ; the string

            push eax ; length of the string

            call writeFile ; write the netChange in the file
            

        ;next node
            sub eax, eax
            mov eax, [edx+16] 
            cmp eax, 0
            je endLooping
            mov edx,eax
            jmp looping
            
        emptyList:
            nwln
            nwln
            PutStr emptyList_msg
            nwln
            nwln
        
        endLooping:
        leave
        ret 12