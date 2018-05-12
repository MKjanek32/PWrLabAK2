.text
.global rdtsc

rdtsc:
push %ebp
mov %esp, %ebp

rdtsc
movl 8(%esp), %ecx
movl %eax, (%ecx)
movl %edx, 4(%ecx)

pop %ebp
ret
