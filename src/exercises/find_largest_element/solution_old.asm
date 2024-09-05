section .data
    array: dd 5, 12, 3, 8, 15   ; Define the array data

section .text
    global _start

_start:
    mov rdi, array          ; Load the base address of the array into rdi
    mov rsi, 5              ; Set the number of elements in the array (rsi)

    mov rax, [rdi]       ; Initialize largest element to the first element in the array
    mov rcx, rsi          ; Initialize loop counter with the number of elements
    add rdi, 4            ; Move rdi to point to the second element

loop:
    cmp rcx, 0            ; Check if we've processed all elements
    je end                ; If yes, jump to the end

    cmp [rdi], rax        ; Compare the current element with the largest element
    jle skip              ; If current element is less than or equal to largest, skip

    mov rax, [rdi]        ; Update largest element with the current element

skip:
    add rdi, 4            ; Move to the next element
    dec rcx               ; Decrement the loop counter
    jmp loop              ; Continue the loop

end:
    ; Exit the program (largest element is now in rax)
    mov rdi, rax
    mov rax, 60
    syscall
