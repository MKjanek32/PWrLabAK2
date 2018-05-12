.file "rdtsc.s"
.text
.globl rdtsc
.type rdtsc, @function

rdtsc:

rdtscp
ret
