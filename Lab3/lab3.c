#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include "sort.c"

int main(int argc, char *argv[])
{
    unsigned int tablica[1000000];
    unsigned int ilosc;
    unsigned long long int start, stop, czas;

    int input = input = open(argv[1], O_RDONLY);
    int output = output = open("sortowane.bin", O_WRONLY | O_CREAT, 0644);

    rdtsc(&start);
    read(input, &ilosc, 4);
    read(input, tablica, 4*ilosc);
    rdtsc(&stop);

    close(input);

    czas = stop - start;
    printf("Wczytanie: %llu\n", czas);

    rdtsc(&start);
    desc_sort(ilosc, tablica);
    rdtsc(&stop);
    
    czas = stop - start;
    printf("Sortowanie: %llu\n", czas);

    rdtsc(&start);
    write(output, &ilosc, 4);
    write(output, tablica, 4*ilosc);
    rdtsc(&stop);

    close(output);

    czas = stop - start;
    printf("Zapis: %llu\n\n", czas);

    //DEBUG
    //for(int i = 0; i < ilosc; i++)
    //    printf("%u\n", tablica[i]);

    return 0;
}
