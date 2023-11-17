; this demo is how to do ping(1) in assembly according to:
; https://www.youtube.com/watch?v=SxtX0VWZuME&ab_channel=NirLichtman
; this uses the following system calls:
; - socket(2)
; - sendto(2)
; - recvfrom(2)
; - write(2)
; You can find the system call numbers in:
; /usr/include/x86_64-linux-gnu/asm/unistd_64.h
;
; You need to run this example with sudo(1) because ICMP is not permitted for regular users.
; remember that ping(1) is SUID.

global _start

section .data
 
address:
; the address we ping
dw 2
; the port we will ping
dw 0
; the address we ping 8.8.8.8
db 8
db 8
db 8
db 8
; padding to make the structure.
dd 0
dd 0

packet:
db 8 ; the type if the packet (echo request)
db 0 ; payload (0)

checksum:
dw 9 ; this is the checksum of the package (pre-calculated)
dw 0 ; padding
dw 1 ; sequence number so that replies could be correlated with requests

buffer:
times 1024 db 0ffh ; of size 1024

good:
db "good"

bad:
db "bad"

section .text

_start:

; socket(2)
mov rax, 41 ; NR_socket
mov rdi, 2 ; family (ipv4)
mov rsi, 3 ; type (raw socket)
mov rdx, 1 ; protocol (ICMP)
syscall
mov r12, rax ; save the return code

not word [checksum]; fix the checksum

; sendto(2)
mov rax, 44 ; NR_sendto
mov rdi, r12 ; file descriptor of socket
mov rsi, packet ; the packet buffer
mov rdx, 8 ; packet buffer length
mov r10, 0 ; flags
mov r8, address ; address
mov r9, 16 ; length of address
syscall

; recvfrom(2)
mov rax, 45 ; NR_recvfrom
mov rdi, r12 ; file descriptor of socket
mov rsi, buffer ; buffer to receive the packet
mov rdx, 1024 ; length of the receive buffer
mov r10, 0 ; flags
mov r8, 0 ; address
mov r9, 0 ; length of the address
syscall

cmp word [buffer+20], 0
jne failure

; write(2)
mov rax, 1 ; NR_write
mov rdi, 1 ; file descriptor (stdout)
mov rsi, good ; buffer
mov rdx, 4 ; length of buffer
syscall

failure:
; write(2)
mov rax, 1 ; NR_write
mov rdi, 1 ; file descriptor (stdout)
mov rsi, bad; buffer
mov rdx, 3 ; length of buffer
syscall
jmp $

error:
end:
; exit(r8)
mov rax, 60
mov rdi, r8
syscall
