// Luis Enrique Torres Murillo - 22210361
// Programa que realiza la conversion de entero a ASCII
// Codigo de alto nivel C#
/*
using System;

class EnteroAAscii
{
    static void Main()
    {
        Console.Write("Ingrese un número entero (0-127) para convertir a ASCII: ");
        int numero = Convert.ToInt32(Console.ReadLine());
        if (numero >= 0 && numero <= 127)
        {
            char asciiChar = (char)numero;
            Console.WriteLine($"El carácter ASCII correspondiente al número {numero} es: '{asciiChar}'");
        }
        else
        {
            Console.WriteLine("Error: Ingrese un valor entre 0 y 127.");
        }
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    num: .word 123           // Número entero a convertir a ASCII
    buffer: .ascii "   \n"   // Buffer para almacenar el resultado en ASCII

.section .text
_start:
    // Cargar el número entero
    adr x19, num
    ldr w20, [x19]           // Cargar el valor de num en w20

    // Inicializar dirección del buffer
    adr x26, buffer

    // Unidades
    mov w27, #10
    udiv w28, w20, w27       // w28 = num / 10 (parte entera)
    msub w29, w28, w27, w20  // w29 = num % 10
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26, #2]

    // Decenas
    mov w20, w28             // Actualizar w20 a num / 10
    udiv w28, w20, w27       // w28 = (num / 10) / 10
    msub w29, w28, w27, w20  // w29 = (num / 10) % 10
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26, #1]

    // Centenas
    mov w29, w28             // w29 = (num / 10) / 10 (centenas)
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26]

    // Imprimir el resultado
    mov x0, #1               
    adr x1, buffer           
    mov x2, #4               
    mov x8, #64              
    svc 0

    // Salir
    mov x0, #0               
    mov x8, #93              
    svc 0
