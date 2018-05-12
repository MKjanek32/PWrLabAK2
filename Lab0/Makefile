hello: hello.o
	ld -melf_i386 hello.o -o hello

hello.o: hello.s
	as --32 hello.s -o hello.o

all: hello

clean:
	rm -f hello hello.o
