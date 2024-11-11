// Luis Enrique Torres Murillo - 22210361
// Programa que encuentra el maximo en un arreglo
// Codigo de alto nivel C#
/*
using System;

class MaximoArreglo
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

        int maximo = arreglo[0];
        foreach (int num in arreglo)
        {
            if (num > maximo)
            {
                maximo = num;
            }
        }

        Console.WriteLine($"El valor máximo en el arreglo es: {maximo}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    array: .word 3, 7, 1, 9, 4          // Arreglo de enteros
    array_len: .word 5                  // Longitud del arreglo
    result_msg: .ascii "Maximo: "       // Mensaje para el resultado
    result_buffer: .space 12            // Buffer aumentado para el resultado
    newline: .ascii "\n"                // Carácter de nueva línea

.section .text
_start:
    // Cargar la longitud del arreglo
    adr x1, array_len
    ldr w1, [x1]                        // w1 = longitud del arreglo

    // Cargar la dirección del arreglo y el primer valor como máximo inicial
    adr x2, array                       // x2 apunta al inicio del arreglo
    ldr w3, [x2], #4                    // Cargar el primer valor como máximo inicial y avanzar

find_max_loop:
    subs w1, w1, #1                     // Decrementar el contador de elementos
    beq print_max                       // Si no hay más elementos, imprimir el máximo

    ldr w4, [x2], #4                    // Cargar el siguiente valor del arreglo y avanzar
    cmp w4, w3                          // Comparar el valor actual con el máximo
    csel w3, w4, w3, gt                 // Si el valor actual es mayor, actualizar el máximo
    b find_max_loop                     // Repetir el ciclo

print_max:
    // Imprimir el mensaje "Maximo: "
    mov x0, #1                          // Descriptor de archivo para stdout
    adr x1, result_msg                  // Dirección del mensaje
    mov x2, #8                          // Longitud del mensaje
    mov x8, #64                         // Código de sistema para write
    svc 0

    // Convertir el valor máximo a ASCII
    mov x4, #0                          // Inicializar contador de dígitos
    adr x5, result_buffer               // Obtener dirección del buffer
    add x5, x5, #11                     // Apuntar al final del buffer
    mov w7, #10                         // Divisor = 10

convert_loop:
    udiv w6, w3, w7                     // Dividir número entre 10
    msub w8, w6, w7, w3                 // Obtener el residuo (dígito actual)
    add w8, w8, #48                     // Convertir a ASCII
    strb w8, [x5]                       // Guardar dígito
    sub x5, x5, #1                      // Mover puntero hacia atrás
    add x4, x4, #1                      // Incrementar contador
    mov w3, w6                          // Actualizar número para siguiente iteración
    cbnz w3, convert_loop               // Continuar si quedan dígitos

    // Imprimir el resultado
    add x5, x5, #1                      // Ajustar puntero al primer dígito
    mov x1, x5                          // Preparar dirección para imprimir
    mov x2, x4                          // Usar contador como longitud
    mov x0, #1
    mov x8, #64
    svc 0

    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc 0

    // Salir del programa
    mov x0, #0                          // Código de salida 0
    mov x8, #93                         // Llamada al sistema para salir
    svc 0
