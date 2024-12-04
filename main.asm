; Tricount Debt Management - Save Multiple Debts in Memory

%include "io.mac"       
STR_MAX   EQU   128   ; maximum string length

extern requestMemory
extern fillStructure
extern addFirstLinkedList
extern nextNode
extern strLen 
extern createFile_Folder
extern writeFile
extern printUsers
extern saveUsers
extern cleanFIle
extern Conciliate
extern printDebts
extern readUsers

.DATA

    cols db 80
    rows db 24


    msg_intruction db 'Type name of the directory:',0

    title_text_zero db 'Welcome to Tricount in NASM', 0
    title_text_one db 'Students: Allan Bolaños (2024145458) & Brian Ramírez (2024109557) | IC-3101 Arquitectura de Computadores | Instituto Tecnológico de Costa Rica | II Semestre 2024',0
    title_text_two db 'Amount of debts: ', 0
    title_text_three db 'Amount of users: ', 0
    title_text_four db 'Amount of debts paid: ', 0
    
    load_message_question db '(1) Load memory', 0
    new_Memory db '(2) Create new memory', 0
    new_memory_close db '(3) Close', 0
    new_Memory_Name db 'Type the name of the new memory: ', 0


    menu_prompt db 'Menu | Please enter the number of the option.', 0
    init_option_1 db '(1) to add an user', 0
    init_option_2 db '(2) to add a debt', 0      
    init_option_3 db '(3) to conciliate', 0  
    init_option_4 db '(4) to see debts', 0 
    init_option_5 db '(5) to see users', 0
    init_option_6 db '(6) save memory', 0
    init_option_7 db '(7) Close', 0

    selection_prompt db 'Type here: ', 0

    create_debt_debtors_number db 'Type the number of debtors: ', 0
    create_debt_contant_size dd 16 ; Size of the estruture of the debt without debtors 16Bytes=4cells in memory


    add_user_name db 'Type the name of the user: ', 0

    success_msg db 'Debt created successfully!', 0

    debbuging db 'Debbuging', 0

    ;Files
    file1 db 'users.txt', 0
    file2 db 'conciliate_report.txt', 0

    ;Todo: Just for testing
    waitStr db '', 0; to present a message and wait for a key press
    enter_msg db 'Press enter to continue ', 0

.UDATA
    numberDebtor resd 1; Number of debtors
    debtsList resd 1; Pointer to the list of debts
    userList resd 1; Pointer to the list of users

    debsCounter resd 1; Counter of the debts
    userCounter resd 1;
    paidDebsCounter resd 1;

    temporaryBuffer resb STR_MAX ; Buffer to store the name of the user temporarily.
    strLenght resd 1 ; Length of the string

    ;Files
    directoryName resb 1 ; string to store the directory name

    ;textFile resb 1 ; string to store the text to write
    lengthTextFile resd 1     ; length of the string

    temporaryPointer resd 1 ; Temporary pointer to store the address of the memory requested


.CODE
    .STARTUP
    sub eax, eax
    mov [debtsList], eax

    Menu:
        PutStr title_text_zero
        nwln
        PutStr title_text_one
        nwln
        PutStr load_message_question
        nwln
        PutStr new_Memory
        nwln
        PutStr new_memory_close
        nwln
        PutStr selection_prompt
        GetInt ax

        cmp ax, 2
        je new_Memory_Setup

        cmp ax, 3
        je Close

        jmp Menu

    new_Memory_Setup:
        PutStr new_Memory_Name
        GetStr directoryName
        nwln
        je createFiles

    loopMemorySetup:
        ; Check if the memory is already created
        cmp eax, 1
        je addUser ; If alraedy exists, return to the menu
        
        call blankSpaces
        ; Header:
        PutStr title_text_zero
        nwln
        PutStr title_text_one
        nwln
        PutStr title_text_two
        PutLInt [debsCounter]
        nwln
        PutStr title_text_three
        PutLInt [userCounter]
        nwln 
        PutStr title_text_four
        PutLInt [paidDebsCounter]
        nwln

        nwln
        ;Initialize the program
        sub ax,ax
        PutStr init_option_1
        nwln
        PutStr init_option_2
        nwln
        PutStr init_option_3
        nwln
        PutStr init_option_4
        nwln
        PutStr init_option_5
        nwln
        PutStr init_option_6
        nwln     
        PutStr init_option_7
        nwln
        PutStr selection_prompt
    
        nwln
        nwln
        nwln
        nwln
        GetInt ax
        
        cmp ax, 1
        je addUser

        cmp ax, 2
        je createDebt

        cmp ax, 3
        je ConciliateDebts
        
        cmp ax, 4
        je seeDebts

        cmp ax, 5
        je seeUsers

        cmp ax, 6
        je saveMemory

        cmp ax, 7
        je .EXIT

        jmp loopMemorySetup

    addUser: ; Each user is a node that stores their information.
        ; Each user added has a unique ID (userCounter)
        ; also it has a pointer to the string with the name of the user.
        ; finally it has a 4 bytes to save the net change of the user.
        ; The structure of the user is [LENSTRUCT, ID, name, netChange, ptrNext]
        nwln
        nwln
        call blankSpaces
        nwln
        sub eax, eax ; Clear the register
        nwln
        PutStr add_user_name ; Ask for the name of the user
        
        mov eax, [userCounter] ; Load the ID of the user

        GetStr temporaryBuffer, STR_MAX; Load the name of the user
        nwln
        push DS 
        push temporaryBuffer
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
        mov esi, temporaryBuffer ; Load the address of the name of the user
        add edx, 4
        mov edi, edx ; Load the address of the memory requested || -: 4 byte  
        add ebx, 1
        mov ecx, [strLenght]  ; Load the length of the string
        rep movsb ; Copy the string to the memory requested || esi -> edi || ecx bytes 
        mov byte [edi + ecx], 0  ; Save the null character at the end of the string

        ; Now the memory is filled with the name of the user 
        ; And its saved on EDX. 

        mov [temporaryPointer], edx ; Save the address of the memory requested in a temporary pointer
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
        mov eax, [temporaryPointer] 
        mov [edx+8], eax; Save the address of the name of the user
        mov eax, 0
        mov [edx+12], eax ; Save the net change of the user   
        push userList
        call addFirstLinkedList

        ; Now the user is added to the list of users.

        add dword [userCounter], 1 ; Increase the counter of the users

        jmp loopMemorySetup

    createDebt:

        nwln
        nwln
        nwln
        nwln
        call blankSpaces

        sub eax, eax
        PutStr create_debt_debtors_number
 
        mov [numberDebtor], eax
        GetInt [numberDebtor]

        ;Table of users
        nwln
        push userList
        call printUsers
        nwln
        cmp eax, 1 ; Check if there are users
        PutStr enter_msg
        GetStr waitStr
        je loopMemorySetup


        mov eax, [numberDebtor]

        sub edx, edx
        ;Opeation to calculate the size of the of debtors in the structure
        sub bx,bx
        mov bx,4
        mul bx ; the format of the array is [deptorName, amount,...]
        mov bx,2
        mul bx ; the format of the array is [deptorName, amount,...]

        add eax, [create_debt_contant_size] ; total size of the debt structure

        push eax
        call requestMemory
        ;Now the address of the new structure is in edx
  
        ;Fill the structure with the data of the debt
        sub eax, eax
        mov eax, [numberDebtor]
        push userList
        push eax
        call fillStructure

        ;Now the structure is filled with the data of the debt in edx
        push debtsList
        call addFirstLinkedList

        ;Now the debt is added to the list of debts
        add dword [debsCounter], 1

        jmp loopMemorySetup

    createFiles:
        push directoryName
        push file1
        push file2
        call createFile_Folder
        jmp loopMemorySetup

    saveMemory:
        push directoryName ; Directory
        push file1 ; File
        call cleanFIle

        push directoryName ; Directory
        push file1 ; File
        push userList ; Text
        call saveUsers

        jmp .EXIT

    ConciliateDebts:
        nwln
        nwln
        nwln
        call blankSpaces
        push userList
        call Conciliate 
        nwln
        push eax
        sub eax, eax
        mov [debtsList], eax
        mov eax, [debsCounter]
        add dword [paidDebsCounter], eax
        mov dword [debsCounter], 0
        pop eax
        PutStr enter_msg
        GetStr waitStr
        jmp loopMemorySetup

    seeUsers:
        call blankSpaces
        push userList
        call printUsers
        mov eax, 0 ; Check if the list is empty But it is not necessary
        nwln
        nwln
        PutStr enter_msg
        GetStr waitStr

        push directoryName
        push file1
        call readUsers

        jmp loopMemorySetup
    
    seeDebts:
        call blankSpaces
        push debtsList
        call printDebts
        mov eax, 0 ; Check if the list is empty But it is not necessary
        nwln
        nwln
        call blankSpaces
        jmp loopMemorySetup


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
        leave
        ret


    Close:; Close the program
 
    .EXIT

   