// Luis Enrique Torres Murillo - 22210361
// Programa que suma los elementos en un arreglo
// Codigo de alto nivel C#
/*
using System;

class SumaArreglo
{
    static void Main()
    {
        Console.Write("Ingrese la cantidad de elementos en el arreglo: ");
        int tamaño = Convert.ToInt32(Console.ReadLine());
        int[] arreglo = new int[tamaño];
        int suma = 0;

        for (int i = 0; i < tamaño; i++)
        {
            Console.Write($"Ingrese el elemento {i + 1}: ");
            arreglo[i] = Convert.ToInt32(Console.ReadLine());
            suma += arreglo[i];
        }
        Console.WriteLine($"La suma de los elementos en el arreglo es: {suma}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    arreglo: .word 10, 20, 30, 40, 50  // Arreglo de 5 elementos enteros
    longitud: .word 5                   // Longitud del arreglo
    suma_buffer: .ascii "    \n"        // Buffer para almacenar el resultado en ASCII

.section .text
_start:
    // Inicializar suma en 0
    mov w0, #0                 // w0 será el acumulador de la suma

    // Cargar la dirección del arreglo y su longitud
    adr x1, arreglo            // x1 apunta al inicio del arreglo
    adr x2, longitud
    ldr w2, [x2]               // Cargar la longitud del arreglo en w2

sumar:
    cbz w2, fin                // Si la longitud es 0, saltar al final

    ldr w3, [x1], #4           // Cargar el siguiente elemento del arreglo en w3 y avanzar el puntero
    add w0, w0, w3             // Sumar el valor al acumulador w0
    sub w2, w2, #1             // Decrementar la longitud
    b sumar                    // Repetir el ciclo

fin:
    // Ahora w0 contiene la suma de los elementos del arreglo

    // Convertir la suma a ASCII para impresión
    adr x3, suma_buffer        // x3 apunta al buffer donde se almacenará la suma en ASCII
    mov w4, w0                 // Copiar la suma a w4 para convertirla

    // Convertir unidades
    mov w5, #10
    udiv w6, w4, w5            // w6 = suma / 10 (parte entera)
    msub w7, w6, w5, w4        // w7 = suma % 10
    add w7, w7, #48            // Convertir a ASCII
    strb w7, [x3, #3]          // Guardar la unidad en el buffer

    mov w4, w6                 // Actualizar w4 a suma / 10

    // Convertir decenas
    udiv w6, w4, w5            // w6 = (suma / 10) / 10
    msub w7, w6, w5, w4        // w7 = (suma / 10) % 10
    add w7, w7, #48            // Convertir a ASCII
    strb w7, [x3, #2]          // Guardar la decena en el buffer

    mov w4, w6                 // Actualizar w4 a (suma / 10) / 10

    // Convertir centenas
    add w4, w4, #48            // Convertir a ASCII
    strb w4, [x3, #1]          // Guardar la centena en el buffer

    // Imprimir la suma en pantalla
    mov x0, #1                 // Descriptor de archivo para stdout
    adr x1, suma_buffer        // Dirección del buffer
    mov x2, #4                 // Número de bytes a imprimir
    mov x8, #64                // Código del sistema para escribir
    svc 0

    // Salir
    mov x0, #0                 
    mov x8, #93                
    svc 0
