#include <stdio.h>
#include <stdlib.h>

int main()
{
    double Freq, Counter;
    while(1)
    {
        printf("Enter the Frequency you want to generate:");
        scanf("%lf", &Freq);
        Counter = 5E7 / (Freq * 2) - 1;
        printf("The size of counter should be:%.2lf\n\n", Counter);
    }
    return 0;
}
