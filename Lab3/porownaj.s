.text
.global porownaj

porownaj:
#push %ecx
#push %edx
push %ebp
mov %esp, %ebp

mov 8(%esp), %ecx
mov 12(%esp), %edx
cmp %edx, %ecx
jae mniejsza
jb wieksza

mniejsza:
mov $0, %eax
jmp koniec

wieksza:
mov $1, %eax

koniec:
pop %ebp
#pop %edx
#pop %ecx
ret
