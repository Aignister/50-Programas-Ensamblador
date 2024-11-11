// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una busqueda binaria
// Codigo de alto nivel C#
/*
using System;

class BinarySearch
{
    static int BinarySearchIterative(int[] arr, int x)
    {
        int l = 0, r = arr.Length - 1;
        while (l <= r)
        {
            int mid = l + (r - l) / 2;

            // Si el elemento es menor, el elemento objetivo debe estar en la submatriz izquierda
            if (arr[mid] < x)
                l = mid + 1;

            // Si el elemento es mayor, el elemento objetivo debe estar en la submatriz derecha
            else if (arr[mid] > x)
                r = mid - 1;

            // Elemento encontrado
            else
                return mid;
        }

        // Elemento no encontrado
        return -1;
    }

    static int BinarySearchRecursive(int[] arr, int l, int r, int x)
    {
        if (r >= l)
        {
            int mid = l + (r - l) / 2;

            // Si el elemento es presente en el punto medio del array
            if (arr[mid] == x)
                return mid;

            // Si el elemento es menor que el mid, entonces está presente en la submatriz izquierda
            if (arr[mid] > x)
                return BinarySearchRecursive(arr, l, mid - 1, x);

            // De lo contrario el elemento está presente en la submatriz derecha
            return BinarySearchRecursive(arr, mid + 1, r, x);
        }

        // Elemento no encontrado
        return -1;
    }

    static void Main(string[] args)
    {
        int[] arr = { 2, 3, 4, 10, 40 };
        int n = arr.Length;
        int x = 10;

        // Función iterativa
        int result = BinarySearchIterative(arr, x);
        if (result == -1)
            Console.WriteLine("El elemento no está presente en el array");
        else
            Console.WriteLine("El elemento está presente en el índice " + result);

        // Función recursiva
        result = BinarySearchRecursive(arr, 0, n - 1, x);
        if (result == -1)
            Console.WriteLine("El elemento no está presente en el array");
        else
            Console.WriteLine("El elemento está presente en el índice " + result);
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
array: .word 1, 3, 5, 7, 9, 11, 13, 15 // Arreglo ordenado
target: .word 15                        // Valor a buscar
size: .word 8                          // Tamaño del arreglo
result: .word -1                       // Resultado (-1 indica que no se encontró)
output_buffer: .ascii "   \n"           // Buffer para almacenar el resultado como texto

.section .text
_start:
    // Cargar tamaño del arreglo y valor objetivo
    adr x10, size
    ldr w11, [x10]                     // w11 = tamaño del arreglo
    adr x12, target
    ldr w13, [x12]                     // w13 = valor objetivo
    adr x14, array                     // Dirección del arreglo

    // Inicializar índices
    mov w15, #0                        // w15 = índice bajo (low)
    sub w16, w11, #1                   // w16 = índice alto (high) = tamaño - 1

binary_search:
    // Comprobar si low > high
    cmp w15, w16
    bgt not_found                      // Si low > high, salir con resultado -1

    // Calcular índice medio
    add w17, w15, w16                  // w17 = low + high
    lsr w17, w17, #1                   // w17 = (low + high) / 2 (índice medio)

    // Cargar el valor en el índice medio
    sxtw x17, w17                      // Extender w17 a x17 para usar como índice
    ldr w18, [x14, x17, lsl #2]        // w18 = array[middle]

    // Comparar valor medio con el objetivo
    cmp w18, w13
    beq found                          // Si array[middle] == target, encontró el valor
    blt search_right                   // Si array[middle] < target, buscar en la derecha

search_left:
    // Si array[middle] > target, buscar en la izquierda
    sub w16, w17, #1                   // high = middle - 1
    b binary_search

search_right:
    // Si array[middle] < target, buscar en la derecha
    add w15, w17, #1                   // low = middle + 1
    b binary_search

found:
    // Almacenar el índice encontrado en result
    adr x19, result
    str w17, [x19]
    b print_result                     // Saltar a impresión del resultado

not_found:
    // Almacenar -1 en result si no se encuentra
    adr x19, result
    mov w20, #-1
    str w20, [x19]

print_result:
    // Preparar el resultado para imprimirlo en ASCII
    adr x21, result                    // Dirección del resultado
    ldr w22, [x21]                     // Cargar el valor de result en w22
    adr x23, output_buffer             // Dirección del buffer de salida

    // Convertir el resultado en caracteres ASCII
    mov w24, w22                       // Copiar el valor del resultado a w24

    // Unidades
    mov w25, #10
    udiv w26, w24, w25                 // w26 = w24 / 10 (decenas)
    msub w27, w26, w25, w24            // w27 = w24 % 10 (unidades)
    add w27, w27, #48                  // Convertir a ASCII
    strb w27, [x23, #2]

    // Decenas
    udiv w24, w26, w25                 // w24 = w26 / 10 (decenas)
    msub w27, w24, w25, w26            // w27 = w26 % 10
    add w27, w27, #48                  // Convertir a ASCII
    strb w27, [x23, #1]

    // Centenas
    add w27, w24, #48                  // Convertir a ASCII
    strb w27, [x23]

    // Imprimir el buffer en la salida estándar
    mov x0, #1                         // Descriptor de archivo para salida estándar
    adr x1, output_buffer              // Dirección del buffer de salida
    mov x2, #4                         // Longitud del buffer (3 dígitos + '\n')
    mov x8, #64                        // Número de syscall para write
    svc 0

    // Salir del programa
    mov x0, #0                         // Código de salida 0
    mov x8, #93                        // Número de syscall para exit
    svc 0
