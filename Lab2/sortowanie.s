# AK2 Lab2
# Jan Potocki 2017

# Deklaracje funkcji systemowych
EXIT = 1
READ = 3
WRITE = 4
STDIN = 0
STDOUT = 1
SYSCALL32 = 0x80

# Stale
b_size = 660000             # Glowny bufor
k_size = 256                # Pomocniczy bufor (do zamiany kolejnosci)

.bss
bufor: .space b_size
kopia: .space k_size
licznik: .long

.text
.global main

main:
# Wczytanie ze standardowego wejscia
mov $b_size, %edx
mov $bufor, %ecx
mov $STDIN, %ebx
mov $READ, %eax
int $SYSCALL32


# Sortowanie
# Rejestry zarezerwowane na cala dlugosc petli:
# ecx - indeks petli
# esi - adres 1 liczby
# edi - adres 2 liczby
# Do etykiety "gotowy:" przy tym NIE KOMBINOWAC!
# ...inaczej stanie sie "Cud nad klawiatura" ;-)
mov $0, %ebx
mov bufor, %bl              # Liczba przebiegow...
dec %ebx                    # ...o 1 mniejsza od ilosci liczb

przebieg:
mov $0, %ecx                # Ustawienie indeksu na 0
mov %ebx, licznik           # Zapisanie licznika do RAM i zwolnienie rejestru

sort:
# Adresy
mov $0, %eax                # Wyliczenie adresu 1 liczby
mov bufor+1, %al
mul %ecx
add $2, %eax
lea bufor(%eax), %esi

mov $0, %eax                # Wyliczenie adresu 2 liczby
mov bufor+1, %al
mov %ecx, %ebx
inc %ebx
mul %ebx
add $2, %eax
lea bufor(%eax), %edi

# Porownanie bajt po bajcie
# esi - adres 1 liczby
# edi - adres 2 liczby
# edx - indeks
mov $0, %edx
mov bufor+1, %dl

bajt:
dec %edx
mov (%esi, %edx,), %al
cmp (%edi, %edx,), %al
ja zamien                   # Niewlasciwa kolejnosc -> zamiana
jb gotowy                   # Wlasciwa kolejnosc
cmp $0, %edx
jne bajt
jmp gotowy                  # Wszystkie bajty rowne

zamien:
# esi - adres zrodlowy
# edi - adres docelowy
# edx - indeks
mov $0, %edx                # Kopiowanie 1 liczby do bufora pomocniczego
bk:
mov (%esi, %edx, 1), %al
mov %al, kopia(%edx)
inc %edx
cmp bufor+1, %dl
jl bk

mov $0, %edx                # Kopiowanie 2 liczby w miejsce 1
bb:
mov (%edi, %edx, 1), %al
mov %al, (%esi, %edx, 1)
inc %edx
cmp bufor+1, %dl
jl bb

mov $0, %edx                # Kopiowanie 1 liczby z bufora w miejsce 2
kb:
mov kopia(%edx), %al
mov %al, (%edi, %edx, 1)
inc %edx
cmp bufor+1, %dl
jl kb

gotowy:
inc %ecx                    # Sprawdzenie warunkow koncowych
mov licznik, %ebx
cmp %ebx, %ecx
jl sort
dec %ebx
cmp $0, %ebx
jg przebieg

# Zapis na standardowe wyjscie
zapis:
mov bufor+1, %al
mulb bufor
add $2, %eax                # Wyliczenie dlugosci ciagu

mov %eax, %edx
mov $bufor, %ecx
mov $STDOUT, %ebx
mov $WRITE, %eax
int $SYSCALL32

# Wyjscie z programu
mov $EXIT, %eax 
int $SYSCALL32
