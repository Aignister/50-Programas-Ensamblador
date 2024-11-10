// Luis Enrique Torres Murillo - 22210361
// Programa que calcula la longitud de una cadena
// Codigo de alto nivel C#
/*
using System;

class LongitudCadena
{
    static void Main()
    {
        Console.Write("Ingrese una cadena de texto: ");
        string cadena = Console.ReadLine();
        int longitud = cadena.Length;
        Console.WriteLine($"La longitud de la cadena es: {longitud}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    cadena: .ascii "Enrique"  // Cadena de ejemplo
    longitud: .word 0                // Lugar para almacenar la longitud calculada
    buffer: .ascii "   \n"           // Buffer para almacenar el resultado en ASCII

.section .text
_start:
    // Cargar la dirección de la cadena
    adr x0, cadena          // x0 apunta al inicio de la cadena
    mov x1, #0              // x1 será el contador para la longitud

loop:
    ldrb w2, [x0, x1]       // Cargar el byte actual de la cadena en w2
    cbz w2, end_loop        // Si w2 es 0 ('\0'), finaliza el bucle
    add x1, x1, #1          // Incrementar el contador
    b loop                  // Repetir el bucle

end_loop:
    adr x3, longitud        // Cargar la dirección de 'longitud' en x3
    str w1, [x3]            // Guardar la longitud de la cadena en la dirección de 'longitud'

    // Conversión a ASCII y almacenamiento en el buffer
    mov w4, w1              // Copiar la longitud a w4 para conversión
    adr x5, buffer          // Dirección del buffer

    // Unidades
    mov w6, #10
    udiv w7, w4, w6         // Dividir para obtener las decenas en w7
    msub w8, w7, w6, w4     // Calcular las unidades en w8
    add w8, w8, #48         // Convertir a ASCII
    strb w8, [x5, #2]       // Guardar en la posición de unidades del buffer

    // Decenas
    udiv w4, w7, w6         // Dividir para obtener las centenas
    msub w8, w4, w6, w7     // Calcular las decenas
    add w8, w8, #48         // Convertir a ASCII
    strb w8, [x5, #1]       // Guardar en la posición de decenas del buffer

    // Centenas
    add w8, w4, #48         // Convertir las centenas a ASCII
    strb w8, [x5]           // Guardar en la posición de centenas del buffer

    // Imprimir el valor de la longitud
    mov x0, #1              // File descriptor 1 (stdout)
    adr x1, buffer          // Dirección del buffer
    mov x2, #4              // Tamaño de la salida
    mov x8, #64             // syscall: write
    svc 0

    // Salir del programa
    mov x0, #0              // Código de salida
    mov x8, #93             // syscall: exit
    svc 0
