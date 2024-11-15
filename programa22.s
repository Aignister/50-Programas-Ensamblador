// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una suma de matrices
// Codigo de alto nivel C#
/*
using System;

class SumaMatrices
{
    static void Main(string[] args)
    {
        // Tamaño de las matrices
        int filas = 2;
        int columnas = 3;

        // Inicializar las matrices
        int[,] matriz1 = { { 1, 2, 3 }, { 4, 5, 6 } };
        int[,] matriz2 = { { 7, 8, 9 }, { 10, 11, 12 } };

        // Crear una matriz para almacenar el resultado
        int[,] resultado = new int[filas, columnas];

        // Sumar las matrices elemento a elemento
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                resultado[i, j] = matriz1[i, j] + matriz2[i, j];
            }
        }

        // Imprimir la matriz resultante
        Console.WriteLine("La matriz resultante de la suma es:");
        for (int i = 0; i < filas; i++)
        {
            for (int j = 0; j < columnas; j++)
            {
                Console.Write(resultado[i, j] + " ");
            }
            Console.WriteLine();
        }
    }
}
*/
// Programa Ensamblador
// Programa para sumar dos matrices en ARM64
.data
    // Mensajes del programa
    msg_titulo:  .string "\nSuma de Matrices\n"
    msg_dim:     .string "Ingrese la dimension de las matrices (N x N, max 10): "
    msg_mat1:    .string "\nIngrese elementos de la primera matriz:\n"
    msg_mat2:    .string "\nIngrese elementos de la segunda matriz:\n"
    msg_elem:    .string "Ingrese elemento [%d][%d]: "
    msg_result:  .string "\nMatriz Resultante:\n"
    msg_num:     .string "%d\t"
    msg_newline: .string "\n"
    fmt_input:   .string "%d"
    
    // Espacio para las matrices (máximo 10x10)
    .align 4
    matriz1:    .skip 400    // 10x10 * 4 bytes
    matriz2:    .skip 400    // 10x10 * 4 bytes
    resultado:  .skip 400    // 10x10 * 4 bytes
    
.text
.global main
.align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Mostrar título
    adrp    x0, msg_titulo
    add     x0, x0, :lo12:msg_titulo
    bl      printf

    // Solicitar dimensión
    adrp    x0, msg_dim
    add     x0, x0, :lo12:msg_dim
    bl      printf

    // Leer dimensión
    sub     sp, sp, 16
    mov     x1, sp
    adrp    x0, fmt_input
    add     x0, x0, :lo12:fmt_input
    bl      scanf
    ldr     w19, [sp]          // w19 = dimensión N
    add     sp, sp, 16

    // Mensaje para primera matriz
    adrp    x0, msg_mat1
    add     x0, x0, :lo12:msg_mat1
    bl      printf

    // Leer primera matriz
    mov     w20, 0             // i = 0
    adrp    x21, matriz1       // x21 = dirección de matriz1
    add     x21, x21, :lo12:matriz1
loop_mat1_i:
    cmp     w20, w19
    b.ge    input_mat2
    mov     w22, 0             // j = 0
loop_mat1_j:
    cmp     w22, w19
    b.ge    next_row1

    // Mostrar prompt para elemento
    adrp    x0, msg_elem
    add     x0, x0, :lo12:msg_elem
    mov     w1, w20
    mov     w2, w22
    bl      printf

    // Leer elemento
    sub     sp, sp, 16
    mov     x1, sp
    adrp    x0, fmt_input
    add     x0, x0, :lo12:fmt_input
    bl      scanf
    ldr     w23, [sp]          // w23 = elemento leído
    add     sp, sp, 16

    // Calcular índice y almacenar elemento
    mul     w24, w20, w19      // índice = i * N + j
    add     w24, w24, w22
    str     w23, [x21, w24, SXTW 2]

    add     w22, w22, 1        // j++
    b       loop_mat1_j
next_row1:
    add     w20, w20, 1        // i++
    b       loop_mat1_i

input_mat2:
    // Mensaje para segunda matriz
    adrp    x0, msg_mat2
    add     x0, x0, :lo12:msg_mat2
    bl      printf

    // Leer segunda matriz
    mov     w20, 0             // i = 0
    adrp    x21, matriz2       // x21 = dirección de matriz2
    add     x21, x21, :lo12:matriz2
loop_mat2_i:
    cmp     w20, w19
    b.ge    sumar_matrices
    mov     w22, 0             // j = 0
loop_mat2_j:
    cmp     w22, w19
    b.ge    next_row2

    // Mostrar prompt para elemento
    adrp    x0, msg_elem
    add     x0, x0, :lo12:msg_elem
    mov     w1, w20
    mov     w2, w22
    bl      printf

    // Leer elemento
    sub     sp, sp, 16
    mov     x1, sp
    adrp    x0, fmt_input
    add     x0, x0, :lo12:fmt_input
    bl      scanf
    ldr     w23, [sp]          // w23 = elemento leído
    add     sp, sp, 16

    // Calcular índice y almacenar elemento
    mul     w24, w20, w19      // índice = i * N + j
    add     w24, w24, w22
    str     w23, [x21, w24, SXTW 2]

    add     w22, w22, 1        // j++
    b       loop_mat2_j
next_row2:
    add     w20, w20, 1        // i++
    b       loop_mat2_i

sumar_matrices:
    // Realizar la suma de matrices
    mov     w20, 0             // i = 0
    adrp    x21, matriz1       // x21 = dirección de matriz1
    add     x21, x21, :lo12:matriz1
    adrp    x22, matriz2       // x22 = dirección de matriz2
    add     x22, x22, :lo12:matriz2
    adrp    x23, resultado     // x23 = dirección de resultado
    add     x23, x23, :lo12:resultado

loop_suma_i:
    cmp     w20, w19
    b.ge    mostrar_resultado
    mov     w24, 0             // j = 0
loop_suma_j:
    cmp     w24, w19
    b.ge    next_row_suma

    // Calcular índice
    mul     w25, w20, w19      // índice = i * N + j
    add     w25, w25, w24

    // Sumar elementos
    ldr     w26, [x21, w25, SXTW 2]    // elemento de matriz1
    ldr     w27, [x22, w25, SXTW 2]    // elemento de matriz2
    add     w28, w26, w27              // suma
    str     w28, [x23, w25, SXTW 2]    // guardar en resultado

    add     w24, w24, 1        // j++
    b       loop_suma_j
next_row_suma:
    add     w20, w20, 1        // i++
    b       loop_suma_i

mostrar_resultado:
    // Mostrar mensaje de resultado
    adrp    x0, msg_result
    add     x0, x0, :lo12:msg_result
    bl      printf

    // Mostrar matriz resultante
    mov     w20, 0             // i = 0
    adrp    x21, resultado     // x21 = dirección de resultado
    add     x21, x21, :lo12:resultado

loop_mostrar_i:
    cmp     w20, w19
    b.ge    end_program
    mov     w22, 0             // j = 0
loop_mostrar_j:
    cmp     w22, w19
    b.ge    next_row_mostrar

    // Calcular índice y mostrar elemento
    mul     w24, w20, w19      // índice = i * N + j
    add     w24, w24, w22
    ldr     w1, [x21, w24, SXTW 2]
    adrp    x0, msg_num
    add     x0, x0, :lo12:msg_num
    bl      printf

    add     w22, w22, 1        // j++
    b       loop_mostrar_j
next_row_mostrar:
    // Nueva línea al final de cada fila
    adrp    x0, msg_newline
    add     x0, x0, :lo12:msg_newline
    bl      printf

    add     w20, w20, 1        // i++
    b       loop_mostrar_i

end_program:
    // Epílogo
    mov     w0, 0
    ldp     x29, x30, [sp], 16
    ret
