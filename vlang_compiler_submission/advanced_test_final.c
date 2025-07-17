#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "runtime.h"

#define MAX_VEC_SIZE 100

int main()
{
int a;
// DEB: Insert "a" type:1 size:0
int b;
// DEB: Insert "b" type:1 size:0
int result;
// DEB: Insert "result" type:1 size:0
int v1[4];
int v1_size = 4;
// DEB: Insert "v1" type:2 size:4
int v2[4];
int v2_size = 4;
// DEB: Insert "v2" type:2 size:4
int v3[4];
int v3_size = 4;
// DEB: Insert "v3" type:2 size:4
a = 10;
b = 3;
result = (a + (b * 2));
printf("a + b * 2 =");
printf("%d\n", result);
int temp0[MAX_VEC_SIZE];
int temp0_size = MAX_VEC_SIZE;
int temp_init_0[] = {5, 10, 15, 20};
copy_array_to_vector(temp0, temp_init_0, sizeof(temp_init_0)/sizeof(int));
copy_vector(v1, temp0, v1_size);
int temp1[MAX_VEC_SIZE];
int temp1_size = MAX_VEC_SIZE;
int temp_init_1[] = {1, 2, 3, 4};
copy_array_to_vector(temp1, temp_init_1, sizeof(temp_init_1)/sizeof(int));
copy_vector(v2, temp1, v2_size);
printf("v1 =");
print_vector(v1, v1_size);
printf("\n");
printf("v2 =");
print_vector(v2, v2_size);
printf("\n");
int temp2[MAX_VEC_SIZE];
int temp2_size = MAX_VEC_SIZE;
vector_a_vector(temp2, v1, v2, v1_size);
copy_vector(v3, temp2, v3_size);
printf("v1 + v2 =");
print_vector(v3, v3_size);
printf("\n");
int temp3[MAX_VEC_SIZE];
int temp3_size = MAX_VEC_SIZE;
vector_s_vector(temp3, v1, v2, v1_size);
copy_vector(v3, temp3, v3_size);
printf("v1 - v2 =");
print_vector(v3, v3_size);
printf("\n");
int temp4[MAX_VEC_SIZE];
int temp4_size = MAX_VEC_SIZE;
vector_m_scalar(temp4, v1, 2, v1_size);
copy_vector(v3, temp4, v3_size);
printf("v1 * 2 =");
print_vector(v3, v3_size);
printf("\n");
int temp5[MAX_VEC_SIZE];
int temp5_size = MAX_VEC_SIZE;
vector_a_scalar(temp5, v2, 5, v2_size);
copy_vector(v3, temp5, v3_size);
printf("v2 + 5 =");
print_vector(v3, v3_size);
printf("\n");
result = dot_product(v1, v2, v1_size);
printf("v1 @ v2 (dot product) =");
printf("%d\n", result);
result = v1[0];
printf("v1[0] =");
printf("%d\n", result);
result = v2[3];
printf("v2[3] =");
printf("%d\n", result);
result = ((a + b) * 2);
printf("(a + b) * 2 =");
printf("%d\n", result);
int temp6[MAX_VEC_SIZE];
int temp6_size = MAX_VEC_SIZE;
vector_a_vector(temp6, v1, v2, v1_size);
int temp7[MAX_VEC_SIZE];
int temp7_size = MAX_VEC_SIZE;
vector_m_scalar(temp7, temp6, 3, temp6_size);
copy_vector(v3, temp7, v3_size);
printf("(v1 + v2) * 3 =");
print_vector(v3, v3_size);
printf("\n");
return 0;
}
