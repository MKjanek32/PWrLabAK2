.globl set_fpu
.type set_fpu, @function

set_fpu:
push %ebp
mov %esp, %ebp

fldcw 8(%esp)

pop %ebp
ret
