#include "runtime.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Basic vector operations
void copy_vector(int* dest, int* src, int size) {
    for (int i = 0; i < size; i++) {
        dest[i] = src[i];
    }
}

void copy_array_to_vector(int* dest, int* src, int size) {
    for (int i = 0; i < size; i++) {
        dest[i] = src[i];
    }
}

void assign_scalar_to_vector(int* vec, int scalar, int size) {
    for (int i = 0; i < size; i++) {
        vec[i] = scalar;
    }
}

// Vector arithmetic operations
void vector_a_vector(int* result, int* left, int* right, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = left[i] + right[i];
    }
}

void vector_s_vector(int* result, int* left, int* right, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = left[i] - right[i];
    }
}

void vector_m_vector(int* result, int* left, int* right, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = left[i] * right[i];
    }
}

void vector_d_vector(int* result, int* left, int* right, int size) {
    for (int i = 0; i < size; i++) {
        if (right[i] != 0) {
            result[i] = left[i] / right[i];
        } else {
            result[i] = 0; // Handle division by zero
        }
    }
}

// Vector-scalar operations
void vector_a_scalar(int* result, int* vec, int scalar, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = vec[i] + scalar;
    }
}

void vector_s_scalar(int* result, int* vec, int scalar, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = vec[i] - scalar;
    }
}

void vector_m_scalar(int* result, int* vec, int scalar, int size) {
    for (int i = 0; i < size; i++) {
        result[i] = vec[i] * scalar;
    }
}

void vector_d_scalar(int* result, int* vec, int scalar, int size) {
    if (scalar != 0) {
        for (int i = 0; i < size; i++) {
            result[i] = vec[i] / scalar;
        }
    } else {
        // Handle division by zero
        for (int i = 0; i < size; i++) {
            result[i] = 0;
        }
    }
}

// Special operations
int dot_product(int* left, int* right, int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += left[i] * right[i];
    }
    return sum;
}

void vector_index_vector(int* result, int* vec, int* indices, int size) {
    for (int i = 0; i < size; i++) {
        int index = indices[i];
        if (index >= 0 && index < size) {
            result[i] = vec[index];
        } else {
            result[i] = 0; // Handle out of bounds
        }
    }
}

// Print functions
void print_vector(int* vec, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", vec[i]);
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]");
}

void print_elements(char* elements) {
    // This is a placeholder for element printing
    // In real implementation, this would parse and print the elements
    printf("%s", elements);
} 