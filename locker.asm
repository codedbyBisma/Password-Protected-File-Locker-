section .data
    welcome     db "== FILE LOCKER SYSTEM ==", 10, 0
    menu        db "1. Lock File", 10, "2. Unlock File", 10, "3. Exit", 10, 0
    choiceMsg   db "Enter your choice: ", 0
    passPrompt  db "Enter password: ", 0
    correctPass db "admin", 0
    passFail    db 10, "Incorrect password! Attempts left: ", 0
    passFailFinal db 10, "Incorrect password! No attempts left. Exiting...", 10, 0
    accessOK    db 10, "Access Granted!", 10, 0
    filePrompt  db "Enter file name: ", 0
    contentPrompt db "Enter content to lock: ", 0
    unlockMsg   db "File content: ", 0
    successLock db 10, "File locked successfully!", 10, 0
    star        db "*", 0
    newline     db 10, 0

section .bss
    choice      resb 4
    password    resb 32
    filename    resb 100
    fileBuffer  resb 256
    attempts    resb 1
    content     resb 256

section .text
    global _start

_start:
    mov byte [attempts], 3

show_menu:
    ; Display welcome
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome
    mov edx, 24
    int 0x80

    ; Display menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, 36
    int 0x80

    ; Get choice
    mov eax, 4
    mov ebx, 1
    mov ecx, choiceMsg
    mov edx, 19
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, choice
    mov edx, 4
    int 0x80
    mov byte [choice + eax - 1], 0

    cmp byte [choice], '3'
    je exit

password_prompt:
    ; Ask for password
    mov eax, 4
    mov ebx, 1
    mov ecx, passPrompt
    mov edx, 17
    int 0x80

    mov edi, password
read_loop:
    mov eax, 3
    mov ebx, 0
    mov ecx, edi
    mov edx, 1
    int 0x80
    cmp byte [edi], 10
    je check_password
    push edi
    mov eax, 4
    mov ebx, 1
    mov ecx, star
    mov edx, 1
    int 0x80
    pop edi
    inc edi
    jmp read_loop

check_password:
    mov byte [edi], 0
    mov esi, password
    mov edi, correctPass
compare_loop:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne wrong_password
    cmp al, 0
    je correct_password
    inc esi
    inc edi
    jmp compare_loop

wrong_password:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    dec byte [attempts]
    cmp byte [attempts], 0
    jle no_attempts_left

    mov eax, 4
    mov ebx, 1
    mov ecx, passFail
    mov edx, 36
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, attempts
    add byte [attempts], '0'
    mov edx, 1
    int 0x80
    sub byte [attempts], '0'

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp password_prompt

no_attempts_left:
    mov eax, 4
    mov ebx, 1
    mov ecx, passFailFinal
    mov edx, 45
    int 0x80
    jmp exit

correct_password:
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, accessOK
    mov edx, 17
    int 0x80

    cmp byte [choice], '1'
    je lock_file
    cmp byte [choice], '2'
    je unlock_file

    jmp show_menu

lock_file:
    ; Ask file name
    mov eax, 4
    mov ebx, 1
    mov ecx, filePrompt
    mov edx, 18
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, filename
    mov edx, 100
    int 0x80
    mov byte [filename + eax - 1], 0

    ; Ask for content
    mov eax, 4
    mov ebx, 1
    mov ecx, contentPrompt
    mov edx, 25
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, content
    mov edx, 256
    int 0x80
    mov byte [content + eax - 1], 0

    ; Open file (create or truncate)
    mov eax, 5
    mov ebx, filename
    mov ecx, 577      ; O_CREAT | O_WRONLY | O_TRUNC
    mov edx, 438      ; 0666
    int 0x80
    mov ebx, eax

    ; Write to file
    mov eax, 4
    mov ecx, content
    mov edx, 256
    int 0x80

    ; Close
    mov eax, 6
    int 0x80

    ; Success message
    mov eax, 4
    mov ebx, 1
    mov ecx, successLock
    mov edx, 28
    int 0x80

    jmp show_menu

unlock_file:
    ; Ask for filename
    mov eax, 4
    mov ebx, 1
    mov ecx, filePrompt
    mov edx, 18
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, filename
    mov edx, 100
    int 0x80
    mov byte [filename + eax - 1], 0

    ; Open file
    mov eax, 5
    mov ebx, filename
    mov ecx, 0
    int 0x80
    cmp eax, 0
    jl show_menu
    mov ebx, eax

    ; Read file
    mov eax, 3
    mov ecx, fileBuffer
    mov edx, 256
    int 0x80
    mov esi, eax

    ; Close file
    mov eax, 6
    int 0x80

    ; Show "File content: "
    mov eax, 4
    mov ebx, 1
    mov ecx, unlockMsg
    mov edx, 14
    int 0x80

    ; Show content
    mov eax, 4
    mov ebx, 1
    mov ecx, fileBuffer
    mov edx, esi
    int 0x80

    ; Newline after content
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    jmp show_menu

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80