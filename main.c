#include <stdio.h>
#include "f.h"

int main(int argc, char *argv[]){
    if(argc < 3){
        printf("Arg missing.\n");
        return -1;
    }

    int n;
    sscanf(argv[2], "%d", &n);

    f(argv[1], n);
    
    printf("%s\n",argv[1]);
    
    return 0;
}