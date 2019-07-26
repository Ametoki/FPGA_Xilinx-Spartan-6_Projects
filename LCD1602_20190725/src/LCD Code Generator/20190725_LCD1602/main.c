#include <stdio.h>
#include <stdlib.h>

int main()
{
    unsigned int i;
    for(i = 0;i <= 31;i++)
    {
        printf("6'd%d: data_display <= String[%d:%d];\n", i, 255 - i * 8, 255 + 1 - (i + 1) * 8);
    }
    return 0;
}
