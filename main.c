#include <stdio.h>

extern void f(char* str);

int main(int argc, char* argv[]) {
    if(argc < 2){
        printf("Arg missing.\n");
        return -1;
    }
    
    printf("Before: %s\n", argv[1]);
    f(argv[1]);
    printf("After: %s\n", argv[1]);
    return 0;
}
