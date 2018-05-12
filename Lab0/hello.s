# AK2 Lab0
# Jan Potocki 2017

EXIT = 1
READ = 3 
WRITE = 4 
STDOUT = 1 
SYSCALL32 = 0x80

.align 32
.data
msg: .ascii "Hello, world!\n"
len = . - msg

.text
.global _start

_start:
mov $len, %edx
mov $msg, %ecx
mov $STDOUT, %ebx
mov $WRITE, %eax
int $SYSCALL32

mov $EXIT, %eax 
int $SYSCALL32
