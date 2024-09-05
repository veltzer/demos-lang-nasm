section .data
    array: dd 5, 12, 3, 8, 15   ; Define the array data
    newline: db 0xA             ; Newline character
    buffer: times 12 db 0        ; Buffer to store the string representation (enough for 32-bit integers)

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
    je print_result        ; If yes, jump to print the result

    cmp [rdi], rax        ; Compare the current element with the largest element
    jle skip              ; If current element is less than or equal to largest, skip

    mov rax, [rdi]        ; Update largest element with the current element

skip:
    add rdi, 4            ; Move to the next element
    dec rcx               ; Decrement the loop counter
    jmp loop              ; Continue the loop

print_result:
    ; Convert the largest element (in rax) to a string
    mov rdi, buffer        ; Point rdi to the buffer
    mov rcx, 10             ; Divisor for base-10 conversion
    mov rbx, 0              ; Initialize string length counter

convert_loop:
    mov rdx, 0              ; Clear rdx for division
    div rcx                 ; Divide rax by 10 (quotient in rax, remainder in rdx)
    add rdx, '0'            ; Convert remainder to ASCII digit
    mov [rdi], dl           ; Store the digit in the buffer
    inc rdi                 ; Move to the next position in the buffer
    inc rbx                 ; Increment string length counter
    cmp rax, 0              ; Check if quotient is 0
    jne convert_loop        ; If not, continue the loop

    ; Print the string in reverse order (since we built it backward)
    mov rax, 1              ; System call number for write
    mov rdi, 1              ; File descriptor for stdout (1)
    mov rsi, buffer         ; Address of the buffer
    mov rdx, rbx            ; Number of bytes to write (string length)
    syscall

    ; Print a newline
    mov rax, 1              ; System call number for write
    mov rdi, 1              ; File descriptor for stdout (1)
    mov rsi, newline        ; Address of the newline character
    mov rdx, 1              ; Number of bytes to write
    syscall

    ; Exit the program
    mov rdi, 0
    mov rax, 60
    syscall
