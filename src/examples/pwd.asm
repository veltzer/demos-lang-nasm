; built according to the sample at https://www.youtube.com/watch?v=zKsj7XUFtlM&ab_channel=NirLichtman

section .data
buffer:
times 256 db 0

global _start
section .text
_start:
; getcwd(buffer, 256)
mov rax, 79 ; NR_getcwd
mov rdi, buffer
mov rsi, 256
syscall

; write(buffer)
mov rax, 1 ; NR_write
mov rdi, 1 ; fd=1
mov rsi, buffer
mov rdx, 256
syscall

; exit(0)
mov rax, 60
mov rdi, 0
syscall
