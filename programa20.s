// Luis Enrique Torres Murillo - 22210361
// Programa que realiza un ordenamiento de burbuja
// Codigo de alto nivel C#
/*
using System;

class OrdenamientoBurbuja
{
    static void Main()
    {
        Console.Write("Ingrese la cantidad de elementos en el arreglo: ");
        int tamaño = Convert.ToInt32(Console.ReadLine());
        int[] arreglo = new int[tamaño];

        for (int i = 0; i < tamaño; i++)
        {
            Console.Write($"Ingrese el elemento {i + 1}: ");
            arreglo[i] = Convert.ToInt32(Console.ReadLine());
        }

        for (int i = 0; i < arreglo.Length - 1; i++)
        {
            for (int j = 0; j < arreglo.Length - 1 - i; j++)
            {
                if (arreglo[j] > arreglo[j + 1])
                {
                    int temp = arreglo[j];
                    arreglo[j] = arreglo[j + 1];
                    arreglo[j + 1] = temp;
                }
            }
        }

        Console.WriteLine("Arreglo ordenado:");
        foreach (int num in arreglo)
        {
            Console.Write(num + " ");
        }
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    array: .word 7, 3, 9, 1, 4    // Array de ejemplo
    length: .word 5               // Longitud del array
    buffer: .ascii "   \n"        // Buffer temporal para cada número a imprimir

.section .text
_start:
    // Cargar la dirección del array y su longitud
    adr x19, array                // Dirección base del array en x19
    ldr w20, [x19, #16]           // Cargar la longitud (5) en w20 (posición relativa de length)

bubble_sort:
    mov w21, w20                  // Número de elementos restantes por ordenar
    sub w21, w21, #1              // w21 = length - 1 (comparaciones necesarias en la pasada actual)

sort_pass:
    mov x22, #0                   // x22 será el índice en el array para las comparaciones
    mov w23, #0                   // Bandera para verificar si hubo intercambios

compare_elements:
    ldr w24, [x19, x22, LSL #2]        // Cargar array[i] en w24
    add x0, x22, #1                    // x0 = i + 1
    ldr w25, [x19, x0, LSL #2]         // Cargar array[i+1] en w25

    cmp w24, w25                       // Comparar array[i] y array[i+1]
    b.le no_swap                       // Si array[i] <= array[i+1], no intercambiar

    // Intercambiar elementos
    str w25, [x19, x22, LSL #2]        // Guardar array[i+1] en array[i]
    str w24, [x19, x0, LSL #2]         // Guardar array[i] en array[i+1]
    mov w23, #1                        // Indicar que hubo un intercambio

no_swap:
    add x22, x22, #1                   // Incrementar índice
    subs w21, w21, #1                  // Restar 1 de las comparaciones restantes
    b.gt compare_elements              // Repetir comparaciones en la pasada actual

    // Comprobar si hubo algún intercambio; si no, el array está ordenado
    cmp w23, #0                        // Si no hubo intercambio en esta pasada, finalizar
    beq print_array

    // Reducir el número de elementos a ordenar y repetir
    sub w20, w20, #1
    cmp w20, #1
    b.gt bubble_sort

print_array:
    mov x22, #0                        // Reiniciar índice para imprimir elementos

print_loop:
    ldr w24, [x19, x22, LSL #2]        // Cargar elemento en w24
    adr x25, buffer                    // Dirección del buffer

    // Convertir el valor a ASCII y almacenarlo en el buffer
    mov w26, w24                       // Copiar el valor a w26 para convertir

    // Unidades
    mov w27, #10
    udiv w28, w26, w27                 // División: w28 = w26 / 10 (decenas)
    msub w29, w28, w27, w26            // Módulo: w29 = w26 % 10 (unidades)
    add w29, w29, #48                  // Convertir a ASCII
    strb w29, [x25, #1]                // Almacenar en buffer[1]

    // Decenas
    udiv w26, w26, w27                 // w26 = w26 / 10
    add w26, w26, #48                  // Convertir a ASCII
    strb w26, [x25]                    // Almacenar en buffer[0]

    // Syscall para imprimir el número
    mov x0, #1                         // File descriptor 1 (stdout)
    mov x1, x25                        // Dirección del buffer
    mov x2, #3                         // Tamaño del buffer (2 dígitos + '\n')
    mov x8, #64                        // Syscall write
    svc 0

    // Avanzar al siguiente elemento en el array
    add x22, x22, #1
    subs w20, w20, #1
    b.gt print_loop

    // Salida del programa
    mov x0, #0
    mov x8, #93
    svc 0
