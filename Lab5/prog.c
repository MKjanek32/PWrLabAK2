#include <stdio.h>
#include <stdlib.h>

unsigned long long int rdtsc(void);

double integral_sse_single(double from, double to, unsigned steps);
double integral_sse(double from, double to, unsigned steps);
double integral_asm(double from, double to, unsigned steps);
double integral(double from, double to, unsigned steps);
void eval_integral_function(double (*fun)(double, double, unsigned), double, double, unsigned);

/*
 * compile: gcc -m32 prog.c rdtsc.s -o prog
 * run: ./prog 0.001 1000 10000
 */
int main(int argc, char * argv[])
{
    double from, to;
    unsigned int steps;

    from = atof(argv[1]);
    to = atof(argv[2]);
    steps = atof(argv[3]);
    printf("Evaluating functions with params: from: %f to: %f in %u steps\n", from, to, steps);

    printf("\nC double precision:\n");
    eval_integral_function(&integral, from, to, steps);
    printf("\nAssembly SSE scalar double precision:\n");
    eval_integral_function(&integral_asm, from, to, steps);
    printf("\nAssembly SSE vectorized double precision:\n");
    eval_integral_function(&integral_sse, from, to, steps);
    printf("\nAssembly SSE vectorized single precision:\n");
    eval_integral_function(&integral_sse_single, from, to, steps);
}

double integral(double from, double to, unsigned steps)
{
    //from xmm1
    //to xmm2
    //steps xmm3
    //xmm4
    double width = (to - from)/steps;
    //xmm0
    double integralAcc = 0;
    int i;

    for(i = 0; i < steps; i++)
    {
        //xmm5
        double middle = from + i*width + width/2;
        //xmm6
        double surface = width/middle;
        integralAcc += surface;
    }

    return integralAcc;
}

void eval_integral_function(double (*fun)(double, double, unsigned), double from, double to, unsigned steps)
{

    unsigned long long int start, time = 0;
    double result;
    int i;

    // Averaging with 100 repeats
    for(i = 0; i < 100; i++)
    {
        start = rdtsc();
        result = fun(from, to, steps);
        time += rdtsc() - start;   
    }

    time = time/100;
    printf("Result: %f, time elapsed (average from 100 runs): %llu \n", result, time);

}
