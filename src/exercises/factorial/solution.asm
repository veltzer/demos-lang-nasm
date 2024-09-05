section .text
    global _start

_start:
    ; Initialize variables
    mov rdi, 4
    mov rax, 1             ; Initialize factorial to 1
    cmp rdi, 0             ; Check if input is 0
    je end                 ; If input is 0, jump to the end

loop:
    mul rdi               ; Multiply factorial by the current number
    dec rdi               ; Decrement the number
    cmp rdi, 1             ; Check if we've reached 1
    jg loop                ; If number is greater than 1, continue the loop

end:
    ; Exit the program with rdi as result
    mov rdi, rax             ; Move rax with the result to rdi
    mov rax, 60            ; System call number for exit
    syscall
