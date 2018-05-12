lab3: lab3.c sort.c porownaj.s rdtsc.s
	gcc -m32 -g lab3.c porownaj.s rdtsc.s -o lab3

scanf-printf: scanf-printf.s
	gcc -m32 -g scanf-printf.s -o scanf-printf

all: lab3 scanf-printf

clean:
	rm -f lab3
	rm -f scanf-printf
