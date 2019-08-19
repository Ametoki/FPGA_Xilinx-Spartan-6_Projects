#include <stdio.h>
#include <stdlib.h>

int main()
{
    double V, Vrms;
    while(1)
    {
        printf("\nEnter Vpp:\n");
        scanf("%lf", &V);
        Vrms = V * 0.3535533905932738;
        printf("Vrms is: %lf\n", Vrms);
    }
    return 0;
}
