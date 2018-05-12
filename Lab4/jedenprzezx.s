.globl jedenprzezx
.type jedenprzezx, @function

jedenprzezx:
push %ebp
mov %esp, %ebp

fld1
fdivl 8(%esp)

pop %ebp
ret
