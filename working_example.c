#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "runtime.h"

#define MAX_VEC_SIZE 100

int main()
{
    // Variable declarations
    int x;
    int y;
    int v[3];
    int v_size = 3;
    
    // Assignments
    x = 5;
    y = 10;
    
    // Vector initialization
    int temp_init[] = {1, 2, 3};
    copy_array_to_vector(v, temp_init, sizeof(temp_init)/sizeof(int));
    
    // Arithmetic
    x = x + y;
    
    // Vector scalar multiplication
    vector_m_scalar(v, v, 2, v_size);
    
    // Output
    printf("x = %d\n", x);
    printf("v = ");
    print_vector(v, v_size);
    printf("\n");
    
    return 0;
} 