// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una multiplicacion de amtrices
// Codigo de alto nivel C#
/*
using System;

class MatrixMultiplication
{
    static void MultiplyMatrices(int[,] mat1, int[,] mat2, int[,] result)
    {
        int m = mat1.GetLength(0), n = mat1.GetLength(1);
        int p = mat2.GetLength(1);

        // Verificar si las matrices se pueden multiplicar
        if (n != mat2.GetLength(0))
        {
            Console.WriteLine("El número de columnas de la primera matriz debe ser igual al número de filas de la segunda matriz.");
            return;
        }

        // Multiplicar las matrices
        for (int i = 0; i < m; i++)
        {
            for (int j = 0; j < p; j++)
            {
                result[i, j] = 0;
                for (int k = 0; k < n; k++)
                {
                    result[i, j] += mat1[i, k] * mat2[k, j];
                }
            }
        }
    }

    static void PrintMatrix(int[,] mat)
    {
        int m = mat.GetLength(0), n = mat.GetLength(1);
        for (int i = 0; i < m; i++)
        {
            for (int j = 0; j < n; j++)
            {
                Console.Write(mat[i, j] + " ");
            }
            Console.WriteLine();
        }
    }

    static void Main(string[] args)
    {
        int[,] mat1 = { { 1, 2, 3 },
                        { 4, 5, 6 } };
        int[,] mat2 = { { 7, 8 },
                        { 9, 10 },
                        { 11, 12 } };
        int[,] result = new int[mat1.GetLength(0), mat2.GetLength(1)];

        MultiplyMatrices(mat1, mat2, result);

        Console.WriteLine("Resultado de la multiplicación:");
        PrintMatrix(result);
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
matrixA: .word 1, 2, 3, 4       // Matriz A (2x2): | 1 2 |
                                //                 | 3 4 |
matrixB: .word 5, 6, 7, 8       // Matriz B (2x2): | 5 6 |
                                //                 | 7 8 |
matrixC: .space 16              // Matriz C (2x2) para el resultado
output_buffer: .ascii "   \n   \n" // Buffer para imprimir el resultado

.section .text
_start:
    // Cargar direcciones de matrices
    adr x10, matrixA            // x10 apunta a matrixA
    adr x11, matrixB            // x11 apunta a matrixB
    adr x12, matrixC            // x12 apunta a matrixC

    // Multiplicación de matrices 2x2
    // C[0][0] = A[0][0] * B[0][0] + A[0][1] * B[1][0]
    ldr w0, [x10]               // A[0][0]
    ldr w1, [x11]               // B[0][0]
    mul w2, w0, w1              // A[0][0] * B[0][0]

    ldr w0, [x10, #4]           // A[0][1]
    ldr w1, [x11, #8]           // B[1][0]
    mul w3, w0, w1              // A[0][1] * B[1][0]
    add w4, w2, w3              // C[0][0]

    str w4, [x12]               // Guardar C[0][0] en matrixC

    // C[0][1] = A[0][0] * B[0][1] + A[0][1] * B[1][1]
    ldr w0, [x10]               // A[0][0]
    ldr w1, [x11, #4]           // B[0][1]
    mul w2, w0, w1              // A[0][0] * B[0][1]

    ldr w0, [x10, #4]           // A[0][1]
    ldr w1, [x11, #12]          // B[1][1]
    mul w3, w0, w1              // A[0][1] * B[1][1]
    add w4, w2, w3              // C[0][1]

    str w4, [x12, #4]           // Guardar C[0][1] en matrixC

    // C[1][0] = A[1][0] * B[0][0] + A[1][1] * B[1][0]
    ldr w0, [x10, #8]           // A[1][0]
    ldr w1, [x11]               // B[0][0]
    mul w2, w0, w1              // A[1][0] * B[0][0]

    ldr w0, [x10, #12]          // A[1][1]
    ldr w1, [x11, #8]           // B[1][0]
    mul w3, w0, w1              // A[1][1] * B[1][0]
    add w4, w2, w3              // C[1][0]

    str w4, [x12, #8]           // Guardar C[1][0] en matrixC

    // C[1][1] = A[1][0] * B[0][1] + A[1][1] * B[1][1]
    ldr w0, [x10, #8]           // A[1][0]
    ldr w1, [x11, #4]           // B[0][1]
    mul w2, w0, w1              // A[1][0] * B[0][1]

    ldr w0, [x10, #12]          // A[1][1]
    ldr w1, [x11, #12]          // B[1][1]
    mul w3, w0, w1              // A[1][1] * B[1][1]
    add w4, w2, w3              // C[1][1]

    str w4, [x12, #12]          // Guardar C[1][1] en matrixC

    // Conversión de resultados en matrixC a ASCII y guardado en output_buffer
    adr x13, matrixC
    adr x14, output_buffer

    mov x5, #0                  // Cambiado a x5 para el índice
convert_to_ascii:
    ldr w6, [x13, x5, lsl #2]   // Cargar cada valor de matrixC
    mov w7, w6                  // Copiar el valor a w7 para conversión

    // Unidades
    mov w8, #10
    udiv w9, w7, w8             // w9 = w7 / 10 (decenas)
    msub w10, w9, w8, w7        // w10 = w7 % 10 (unidades)
    add w10, w10, #48           // Convertir a ASCII
    
    // Calcular offset correcto para el buffer de salida
    mov x15, x5, lsl #2         // x15 = x5 * 4
    strb w10, [x14, x15]        // Guardar carácter en output_buffer

    // Decenas
    udiv w7, w9, w8             // w7 = w9 / 10 (centenas)
    msub w10, w7, w8, w9        // w10 = w9 % 10 (decenas)
    add w10, w10, #48           // Convertir a ASCII
    sub x15, x15, #1            // Decrementar offset
    strb w10, [x14, x15]        // Guardar carácter en output_buffer

    // Centenas
    add w10, w7, #48            // Convertir a ASCII
    sub x15, x15, #1            // Decrementar offset
    strb w10, [x14, x15]        // Guardar carácter en output_buffer

    // Verificar si quedan más elementos por convertir
    add x5, x5, #1
    cmp x5, #4
    blt convert_to_ascii

    // Imprimir el resultado en la salida estándar
    mov x0, #1                  // Descriptor de archivo para salida estándar
    adr x1, output_buffer       // Dirección del buffer de salida
    mov x2, #8                  // Longitud del buffer
    mov x8, #64                 // Número de syscall para write
    svc 0

    // Salir del programa
    mov x0, #0                  // Código de salida 0
    mov x8, #93                 // Número de syscall para exit
    svc 0
