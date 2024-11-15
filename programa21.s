// Luis Enrique Torres Murillo - 22210361
// Programa que realiza un ordenamiento por seleccion
// Codigo de alto nivel C#
/*
using System;

namespace OrdenamientoPorSeleccion
{
    class Program
    {
        static void Main(string[] args)
        {
            // Arreglo de números a ordenar
            int[] numeros = { 64, 25, 12, 22, 11 };

            // Llamada a la función de ordenamiento por selección
            OrdenarPorSeleccion(numeros);

            // Imprimir el arreglo ordenado
            Console.WriteLine("Arreglo ordenado:");
            foreach (int numero in numeros)
            {
                Console.Write(numero + " ");
            }
        }

        static void OrdenarPorSeleccion(int[] arreglo)
        {
            int n = arreglo.Length;

            // Un bucle externo para recorrer todos los elementos del arreglo
            for (int i = 0; i < n - 1; i++)
            {
                // Encontrar el índice del elemento mínimo en el subarreglo no ordenado
                int indiceMinimo = i;
                for (int j = i + 1; j < n; j++)
                {
                    if (arreglo[j] < arreglo[indiceMinimo])
                    {
                        indiceMinimo = j;
                    }
                }

                // Intercambiar el elemento mínimo con el primer elemento del subarreglo no ordenado
                int temp = arreglo[indiceMinimo];
                arreglo[indiceMinimo] = arreglo[i];
                arreglo[i] = temp;
            }
        }
    }
}
*/
// Programa Ensamblador
// Programa de ordenamiento por selección en ARM64
.data
    // Mensajes del programa
    msg_inicio:  .string "\nPrograma de Ordenamiento por Seleccion\n"
    msg_input:   .string "Ingrese la cantidad de numeros (maximo 20): "
    msg_numero:  .string "Ingrese numero %d: "
    msg_orig:    .string "\nArreglo original:\n"
    msg_ord:     .string "\nArreglo ordenado:\n"
    msg_elem:    .string "%d "
    msg_newline: .string "\n"
    fmt_input:   .string "%d"
    
    // Arreglo para almacenar los números
    .align 4
    array:      .skip 80    // Espacio para 20 números (20 * 4 bytes)
    
.text
.global main
.align 2

main:
    // Prólogo
    stp     x29, x30, [sp, -16]!
    mov     x29, sp

    // Mostrar mensaje de inicio
    adrp    x0, msg_inicio
    add     x0, x0, :lo12:msg_inicio
    bl      printf

    // Solicitar tamaño del arreglo
    adrp    x0, msg_input
    add     x0, x0, :lo12:msg_input
    bl      printf

    // Leer tamaño
    sub     sp, sp, 16
    mov     x1, sp
    adrp    x0, fmt_input
    add     x0, x0, :lo12:fmt_input
    bl      scanf
    ldr     w19, [sp]          // w19 = tamaño del arreglo
    add     sp, sp, 16

    // Leer números
    mov     w20, 0             // w20 = contador
    adrp    x21, array         // x21 = dirección base del arreglo
    add     x21, x21, :lo12:array

input_loop:
    cmp     w20, w19
    b.ge    show_original

    // Mostrar prompt para cada número
    adrp    x0, msg_numero
    add     x0, x0, :lo12:msg_numero
    add     w1, w20, 1
    bl      printf

    // Leer número
    sub     sp, sp, 16
    mov     x1, sp
    adrp    x0, fmt_input
    add     x0, x0, :lo12:fmt_input
    bl      scanf
    ldr     w22, [sp]          // w22 = número leído
    add     sp, sp, 16

    // Guardar número en el arreglo
    str     w22, [x21, w20, SXTW 2]
    add     w20, w20, 1
    b       input_loop

show_original:
    // Mostrar arreglo original
    adrp    x0, msg_orig
    add     x0, x0, :lo12:msg_orig
    bl      printf

    mov     w20, 0             // Contador
print_orig_loop:
    cmp     w20, w19
    b.ge    sort_array
    
    ldr     w1, [x21, w20, SXTW 2]
    adrp    x0, msg_elem
    add     x0, x0, :lo12:msg_elem
    bl      printf
    
    add     w20, w20, 1
    b       print_orig_loop

sort_array:
    // Algoritmo de ordenamiento por selección
    mov     w20, 0             // i = 0
outer_loop:
    cmp     w20, w19
    b.ge    show_sorted
    
    mov     w22, w20          // min_idx = i
    add     w23, w20, 1       // j = i + 1

inner_loop:
    cmp     w23, w19
    b.ge    swap_min
    
    // Comparar array[j] con array[min_idx]
    ldr     w24, [x21, w23, SXTW 2]
    ldr     w25, [x21, w22, SXTW 2]
    cmp     w24, w25
    b.ge    next_inner
    
    mov     w22, w23          // Actualizar min_idx

next_inner:
    add     w23, w23, 1
    b       inner_loop

swap_min:
    // Intercambiar elementos si es necesario
    cmp     w22, w20
    b.eq    next_outer
    
    ldr     w24, [x21, w20, SXTW 2]    // temp = array[i]
    ldr     w25, [x21, w22, SXTW 2]    // array[min_idx]
    str     w25, [x21, w20, SXTW 2]    // array[i] = array[min_idx]
    str     w24, [x21, w22, SXTW 2]    // array[min_idx] = temp

next_outer:
    add     w20, w20, 1
    b       outer_loop

show_sorted:
    // Mostrar nueva línea
    adrp    x0, msg_newline
    add     x0, x0, :lo12:msg_newline
    bl      printf

    // Mostrar mensaje de arreglo ordenado
    adrp    x0, msg_ord
    add     x0, x0, :lo12:msg_ord
    bl      printf

    // Imprimir arreglo ordenado
    mov     w20, 0             // Contador
print_sorted_loop:
    cmp     w20, w19
    b.ge    end_program
    
    ldr     w1, [x21, w20, SXTW 2]
    adrp    x0, msg_elem
    add     x0, x0, :lo12:msg_elem
    bl      printf
    
    add     w20, w20, 1
    b       print_sorted_loop

end_program:
    // Mostrar nueva línea final
    adrp    x0, msg_newline
    add     x0, x0, :lo12:msg_newline
    bl      printf

    // Epílogo
    mov     w0, 0
    ldp     x29, x30, [sp], 16
    ret
