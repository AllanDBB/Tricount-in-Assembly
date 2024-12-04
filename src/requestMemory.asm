 ; Tricount                  requestMemory.ASM
; Objective: 
;     Reserve memory for the app to save the debts and their attributes
;
; Input: 
;     The number of bytes to be reserved is passed via the stack.
;
; Output: 
;     - The memory direction where the memory starts is returned in the edx register.
;     - Success message printed .
;     - Error message printed.
;
; Note: This program uses Linux system calls to manage file operations.
;Format of the memory: edx->[number of bytes, ..... , ..... , end]<- ebx

global requestMemory 

%include "./io.mac"

.DATA
    error_msg db 'Error: Unable to request memory', 0 
    success_msg db 'The memory has been reserved successfully!', 0 

.UDATA
   
.CODE
    requestMemory:
        enter 0,0
        sub edx,edx
        mov	eax, 45		   ;sys_brk
        sub	ebx, ebx
        int	80h

        mov edx,eax        ;save the address when start of the memory for this structure

       
        add	eax, [ebp+8]   ;number of bytes to be reserved
        
        mov	ebx, eax       ; save the quantity of bytes in ebx
        mov	eax, 45		   ;sys_brk
        int	80h
        
        sub eax ,eax
        mov eax, [ebp+8]   ;load the number of bytes to eax
        mov [edx],eax      ;save the number of bytes of this structure in the first cell of the memory
        
        cmp eax,0
        jl	error	;exit, if error 
        
        mov eax,4
        sub [edx],eax      ;to have the exact address of the last cell for this structure
        
        ;By this time, the address of the memory of this structure is in edx

        ;PutStr success_msg
        jmp exit

    error:
        PutStr error_msg    
      
    exit:
        ;Cleaning
        sub eax,eax
        sub ebx,ebx
        leave
        ret 4