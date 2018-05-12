# AK2 Lab1
# Jan Potocki 2017

# Deklaracje funkcji systemowych
EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL32 = 0x80

# Stale
b_size = 80
klucz = 1

.bss
bufor: .space b_size

.text
.global main

main:
# Wczytanie ze standardowego wejscia
mov $b_size, %edx
mov $bufor, %ecx
mov $STDIN, %ebx
mov $READ, %eax
int $SYSCALL32

# Przesuwanie
mov $klucz, %dl		# Przygotowanie do przesuwania: klucz, indeks
xor %esi, %esi

znak:
mov bufor(%esi), %al	# Pobranie znaku z bufora
cmp $'\n', %al		# Konczenie na znaku nowej linii
je zapis
cmp $'0', %al		# Cyfra
jl gotowy
cmp $'9', %al
jg litera1
add %dl, %al
cmp $'9', %al
jle gotowy
sub $'9', %al
dec %al
add $'0', %al

litera1:		# Wielka litera
cmp $'A', %al
jl gotowy
cmp $'Z', %al
jg litera2
add %dl, %al
cmp $'Z', %al
jle gotowy
sub $'Z', %al
dec %al
add $'A', %al

litera2:		# Mala litera
cmp $'a', %al
jl gotowy
cmp $'z', %al		# Poza zakresem
jg gotowy
add %dl, %al
cmp $'z', %al
jle gotowy
sub $'z', %al
dec %al
add $'a', %al

gotowy:			# Zapis do bufora
mov %al, bufor(%esi)
inc %esi
jmp znak

# Zapis na standardowe wyjscie
zapis:
mov $b_size, %edx
mov $bufor, %ecx
mov $STDOUT, %ebx
mov $WRITE, %eax
int $SYSCALL32

# Wyjscie z programu
mov $EXIT, %eax 
int $SYSCALL32
