// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una busqueda lineal
// Codigo de alto nivel C#
/*
using System;

class BusquedaLineal
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

        Console.Write("Ingrese el número a buscar: ");
        int valorBuscado = Convert.ToInt32(Console.ReadLine());
        bool encontrado = false;

        for (int i = 0; i < arreglo.Length; i++)
        {
            if (arreglo[i] == valorBuscado)
            {
                Console.WriteLine($"El valor {valorBuscado} fue encontrado en la posición {i}.");
                encontrado = true;
                break;
            }
        }

        if (!encontrado)
        {
            Console.WriteLine($"El valor {valorBuscado} no fue encontrado en el arreglo.");
        }
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    array: .word 5, 3, 7, 1, 9, 4          // Arreglo de enteros
    array_len: .word 6                     // Longitud del arreglo
    target: .word 7                        // Valor a buscar
    found_msg: .ascii "Encontrado en posicion: "   // Mensaje si se encuentra el valor
    not_found_msg: .ascii "No encontrado"   // Mensaje si el valor no está
    result_buffer: .space 12               // Buffer aumentado para el resultado
    newline: .ascii "\n"                   // Carácter de nueva línea

.section .text
_start:
    // Cargar la longitud del arreglo
    adr x1, array_len
    ldr w1, [x1]                           // w1 = longitud del arreglo

    // Cargar el valor de búsqueda (target)
    adr x2, target
    ldr w2, [x2]                           // w2 = valor a buscar

    // Cargar la dirección del arreglo y preparar índice
    adr x3, array                          // x3 apunta al inicio del arreglo
    mov w4, #0                             // w4 será el índice actual en la búsqueda

find_loop:
    // Comparar si hemos alcanzado el final del arreglo
    cmp w4, w1
    beq not_found                          // Si hemos revisado todos los elementos, ir a "no encontrado"

    ldr w5, [x3], #4                       // Cargar el valor actual del arreglo y avanzar
    cmp w5, w2                             // Comparar el valor actual con el valor de búsqueda
    beq found                              // Si se encuentra el valor, ir a "found"

    add w4, w4, #1                         // Incrementar el índice
    b find_loop                            // Repetir el ciclo

not_found:
    // Imprimir "No encontrado"
    mov x0, #1                             // Descriptor de archivo para stdout
    adr x1, not_found_msg                  // Dirección del mensaje de no encontrado
    mov x2, #12                            // Longitud del mensaje
    mov x8, #64                            // Código de sistema para write
    svc 0
    
    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc 0
    
    b exit                                 // Salir del programa

found:
    // Imprimir "Encontrado en posicion: "
    mov x0, #1                             // Descriptor de archivo para stdout
    adr x1, found_msg                      // Dirección del mensaje
    mov x2, #23                            // Longitud del mensaje
    mov x8, #64                            // Código de sistema para write
    svc 0

    // Convertir el índice a ASCII
    mov w3, w4                             // Mover índice a w3 para convertir
    mov x4, #0                             // Inicializar contador de dígitos
    adr x5, result_buffer                  // Obtener dirección del buffer
    add x5, x5, #11                        // Apuntar al final del buffer
    mov w7, #10                            // Divisor = 10

convert_loop:
    udiv w6, w3, w7                        // Dividir número entre 10
    msub w8, w6, w7, w3                    // Obtener el residuo (dígito actual)
    add w8, w8, #48                        // Convertir a ASCII
    strb w8, [x5]                          // Guardar dígito
    sub x5, x5, #1                         // Mover puntero hacia atrás
    add x4, x4, #1                         // Incrementar contador
    mov w3, w6                             // Actualizar número para siguiente iteración
    cbnz w3, convert_loop                  // Continuar si quedan dígitos

    // Imprimir el resultado
    add x5, x5, #1                         // Ajustar puntero al primer dígito
    mov x1, x5                             // Preparar dirección para imprimir
    mov x2, x4                             // Usar contador como longitud
    mov x0, #1
    mov x8, #64
    svc 0

    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc 0

exit:
    // Salir del programa
    mov x0, #0                             // Código de salida 0
    mov x8, #93                            // Llamada al sistema para salir
    svc 0
