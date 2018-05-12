#include <stdlib.h>
#include <stdio.h>

#define NE_DOUBLE_EXT_PREC 0x037F
#define NE_DOUBLE_PREC 0x027F
#define NE_SINGLE_PREC 0x007F

#define DOWN_DOUBLE_EXT_PREC 0x077F
#define DOWN_DOUBLE_PREC 0x067F
#define DOWN_SINGLE_PREC 0x047F

#define UP_DOUBLE_EXT_PREC 0x0B7F
#define UP_DOUBLE_PREC 0x0A7F
#define UP_SINGLE_PREC 0x087F

#define ZERO_DOUBLE_EXT_PREC 0x0F7F
#define ZERO_DOUBLE_PREC 0x0E7F
#define ZERO_SINGLE_PREC 0x0C7F

double jedenprzezx(double x);

int main(int argc, char * argv[])
{
    int iloscPrzedz = atoi(argv[3]);
    double kon = atof(argv[2]);
    double pocz = atof(argv[1]);
    double szerPrzedz = (kon - pocz)/iloscPrzedz;
    double calka[12];

    for(int i = 0; i < 12; i++)
        calka[i] = 0;

    for(int i = 0; i < iloscPrzedz; i++)
    {
        double srodekPrzedz = pocz + i*szerPrzedz + szerPrzedz/2;
        double pole;

        set_fpu(NE_DOUBLE_EXT_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[0] += pole;

        set_fpu(NE_DOUBLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[1] += pole;

        set_fpu(NE_SINGLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[2] += pole;

        set_fpu(DOWN_DOUBLE_EXT_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[3] += pole;

        set_fpu(DOWN_DOUBLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[4] += pole;

        set_fpu(DOWN_SINGLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[5] += pole;

        set_fpu(UP_DOUBLE_EXT_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[6] += pole;

        set_fpu(UP_DOUBLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[7] += pole;

        set_fpu(UP_SINGLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[8] += pole;

        set_fpu(ZERO_DOUBLE_EXT_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[9] += pole;

        set_fpu(ZERO_DOUBLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[10] += pole;

        set_fpu(ZERO_SINGLE_PREC);
        pole = szerPrzedz*jedenprzezx(srodekPrzedz);
        calka[11] += pole;
    }

    printf("FPU CW: %04hx %f\n", NE_DOUBLE_EXT_PREC, calka[0]);
    printf("FPU CW: %04hx %f\n", NE_DOUBLE_PREC, calka[1]);
    printf("FPU CW: %04hx %f\n", NE_SINGLE_PREC, calka[2]);
    printf("FPU CW: %04hx %f\n", DOWN_DOUBLE_EXT_PREC, calka[3]);
    printf("FPU CW: %04hx %f\n", DOWN_DOUBLE_PREC, calka[4]);
    printf("FPU CW: %04hx %f\n", DOWN_SINGLE_PREC, calka[5]);
    printf("FPU CW: %04hx %f\n", UP_DOUBLE_EXT_PREC, calka[6]);
    printf("FPU CW: %04hx %f\n", UP_DOUBLE_PREC, calka[7]);
    printf("FPU CW: %04hx %f\n", UP_SINGLE_PREC, calka[8]);
    printf("FPU CW: %04hx %f\n", ZERO_DOUBLE_EXT_PREC, calka[9]);
    printf("FPU CW: %04hx %f\n", ZERO_DOUBLE_PREC, calka[10]);
    printf("FPU CW: %04hx %f\n", ZERO_SINGLE_PREC, calka[11]);

    return 0;
}
