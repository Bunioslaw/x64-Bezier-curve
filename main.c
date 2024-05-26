#include <stdio.h>

extern int f(char* str);

int main() {
    char str[] = "Hello, World!";
    printf("Before: %s\n", str);
    printf("Address of str: %p\n", (void*)str);
    f(str);
    printf("After: %s\n", str);
    return 0;
}
