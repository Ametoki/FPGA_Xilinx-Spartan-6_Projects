#include <stdio.h>
#include <stdlib.h>

int main()
{
    int temp, i;
    double Freq, Counter;
    while(1)
    {
        printf("Enter the Frequency you want to generate:");
        scanf("%lf", &Freq);
        temp = (int)Freq;
        for(i = 1;i <= temp;i++)
        {
            Counter = 5E7 / (i * 2) - 1;
            printf("32'd%d:Counter <= %.0lf;\n", i, Counter);
        }
    }
    return 0;
}
