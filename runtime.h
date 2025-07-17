#ifndef RUNTIME_H
#define RUNTIME_H

#define MAX_VEC_SIZE 100

// Vector operations
void copy_vector(int* dest, int* src, int size);
void copy_array_to_vector(int* dest, int* src, int size);
void assign_scalar_to_vector(int* vec, int scalar, int size);

// Vector arithmetic operations
void vector_a_vector(int* result, int* left, int* right, int size);  // add
void vector_s_vector(int* result, int* left, int* right, int size);  // subtract
void vector_m_vector(int* result, int* left, int* right, int size);  // multiply
void vector_d_vector(int* result, int* left, int* right, int size);  // divide

// Vector-scalar operations
void vector_a_scalar(int* result, int* vec, int scalar, int size);   // add
void vector_s_scalar(int* result, int* vec, int scalar, int size);   // subtract
void vector_m_scalar(int* result, int* vec, int scalar, int size);   // multiply
void vector_d_scalar(int* result, int* vec, int scalar, int size);   // divide

// Special operations
int dot_product(int* left, int* right, int size);
void vector_index_vector(int* result, int* vec, int* indices, int size);

// Print functions
void print_vector(int* vec, int size);
void print_elements(char* elements);

#endif 