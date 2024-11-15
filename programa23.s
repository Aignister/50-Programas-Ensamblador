// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una transposicion de matriz
// Codigo de alto nivel C#
/*
using System;

namespace TransposicionMatriz
{
    class Program
    {
        static void Main(string[] args)
        {
            // Matriz original
            int[,] matriz = { { 1, 2, 3 }, { 4, 5, 6 }, { 7, 8, 9 } };

            // Obtener las dimensiones de la matriz
            int filas = matriz.GetLength(0);
            int columnas = matriz.GetLength(1);

            // Crear una matriz transpuesta con las dimensiones invertidas
            int[,] matrizTranspuesta = new int[columnas, filas];

            // Realizar la transposición
            for (int i = 0; i < filas; i++)
            {
                for (int j = 0; j < columnas; j++)
                {
                    matrizTranspuesta[j, i] = matriz[i, j];
                }
            }

            // Imprimir la matriz transpuesta
            Console.WriteLine("Matriz transpuesta:");
            for (int i = 0; i < columnas; i++)
            {
                for (int j = 0; j < filas; j++)
                {
                    Console.Write(matrizTranspuesta[i, j] + " ");
                }
                Console.WriteLine();
            }
        }
    }
}
*/
// Programa Ensamblador
// Programa para transponer una matriz en ARM64
.data
    // Mensajes del programa
    msg_titulo:  .string "\nTransposicion de Matriz\n"
    msg_dim:     .string "Ingrese la dimension de la matriz (N x N, max 10): "
    msg_input:   .string "\nIngrese los elementos de la matriz:\n"
    msg_elem:    .string "Ingrese elemento [%d][%d]: "
    msg_orig:    .string "\nMatriz Original:\n"
    msg_trans:   .string "\nMatriz Transpuesta:\n"
    msg_num:     .string "%d\t"
    msg_newline: .string "\n"
    fmt_input:   .string "%d"
    
    // Espacio para las matrices (máximo 10x10)
    .align 4
    matriz:         .skip 400    // 10x10 * 4 bytes
    transpuesta:    .skip 400    // 10x10 * 4 bytes
    
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

    // Mensaje para ingresar matriz
    adrp    x0, msg_input
    add     x0, x0, :lo12:msg_input
    bl      printf

    // Leer matriz
    mov     w20, 0             // i = 0
    adrp    x21, matriz        // x21 = dirección de matriz
    add     x21, x21, :lo12:matriz
loop_input_i:
    cmp     w20, w19
    b.ge    mostrar_original
    mov     w22, 0             // j = 0
loop_input_j:
    cmp     w22, w19
    b.ge    next_row_input

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
    b       loop_input_j
next_row_input:
    add     w20, w20, 1        // i++
    b       loop_input_i

mostrar_original:
    // Mostrar mensaje de matriz original
    adrp    x0, msg_orig
    add     x0, x0, :lo12:msg_orig
    bl      printf

    // Mostrar matriz original
    mov     w20, 0             // i = 0
loop_mostrar_orig_i:
    cmp     w20, w19
    b.ge    transponer
    mov     w22, 0             // j = 0
loop_mostrar_orig_j:
    cmp     w22, w19
    b.ge    next_row_mostrar_orig

    // Calcular índice y mostrar elemento
    mul     w24, w20, w19      // índice = i * N + j
    add     w24, w24, w22
    ldr     w1, [x21, w24, SXTW 2]
    adrp    x0, msg_num
    add     x0, x0, :lo12:msg_num
    bl      printf

    add     w22, w22, 1        // j++
    b       loop_mostrar_orig_j
next_row_mostrar_orig:
    // Nueva línea al final de cada fila
    adrp    x0, msg_newline
    add     x0, x0, :lo12:msg_newline
    bl      printf

    add     w20, w20, 1        // i++
    b       loop_mostrar_orig_i

transponer:
    // Realizar la transposición
    mov     w20, 0             // i = 0
    adrp    x22, transpuesta   // x22 = dirección de matriz transpuesta
    add     x22, x22, :lo12:transpuesta
loop_trans_i:
    cmp     w20, w19
    b.ge    mostrar_transpuesta
    mov     w23, 0             // j = 0
loop_trans_j:
    cmp     w23, w19
    b.ge    next_row_trans

    // Calcular índices para transposición
    mul     w24, w20, w19      // índice_orig = i * N + j
    add     w24, w24, w23
    mul     w25, w23, w19      // índice_trans = j * N + i
    add     w25, w25, w20

    // Realizar transposición
    ldr     w26, [x21, w24, SXTW 2]    // Cargar elemento original
    str     w26, [x22, w25, SXTW 2]    // Guardar en posición transpuesta

    add     w23, w23, 1        // j++
    b       loop_trans_j
next_row_trans:
    add     w20, w20, 1        // i++
    b       loop_trans_i

mostrar_transpuesta:
    // Mostrar mensaje de matriz transpuesta
    adrp    x0, msg_trans
    add     x0, x0, :lo12:msg_trans
    bl      printf

    // Mostrar matriz transpuesta
    mov     w20, 0             // i = 0
loop_mostrar_trans_i:
    cmp     w20, w19
    b.ge    end_program
    mov     w22, 0             // j = 0
loop_mostrar_trans_j:
    cmp     w22, w19
    b.ge    next_row_mostrar_trans

    // Calcular índice y mostrar elemento
    mul     w24, w20, w19      // índice = i * N + j
    add     w24, w24, w22
    ldr     w1, [x22, w24, SXTW 2]
    adrp    x0, msg_num
    add     x0, x0, :lo12:msg_num
    bl      printf

    add     w22, w22, 1        // j++
    b       loop_mostrar_trans_j
next_row_mostrar_trans:
    // Nueva línea al final de cada fila
    adrp    x0, msg_newline
    add     x0, x0, :lo12:msg_newline
    bl      printf

    add     w20, w20, 1        // i++
    b       loop_mostrar_trans_i

end_program:
    // Epílogo
    mov     w0, 0
    ldp     x29, x30, [sp], 16
    ret
