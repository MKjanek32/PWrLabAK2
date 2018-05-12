test: prog.c rdtsc.s integral_asm.s integral_sse.s integral_sse_single.s
	gcc -m32 prog.c rdtsc.s integral_asm.s integral_sse.s integral_sse_single.s -o prog
	./prog 0.001 1000 100000
