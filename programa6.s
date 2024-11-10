// Luis Enrique Torres Murillo - 22210361
// Programa que realiza la conversion de ASCII a entero
// Codigo de alto nivel C#
/*
using System;

class AsciiAEntero
{
    static void Main()
    {
        Console.Write("Ingrese un carácter ASCII: ");
        char asciiChar = Console.ReadKey().KeyChar;
        int asciiValue = (int)asciiChar;
        Console.WriteLine($"\nEl valor ASCII entero de '{asciiChar}' es: {asciiValue}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    buffer: .ascii "123"     // Número ASCII a convertir
    result_buffer: .ascii "   \n" // Buffer para almacenar el resultado en ASCII

.section .text
_start:
    // Cargar la dirección del buffer
    adr x19, buffer
    mov w20, #0              // w20 servirá como acumulador para el resultado

    // Convertir centenas
    ldrb w21, [x19]          // Cargar primer carácter (centenas)
    sub w21, w21, #48        // Convertir de ASCII a entero (restar 48)
    mov w22, #100            // Multiplicar por 100 (posición de las centenas)
    mul w21, w21, w22
    add w20, w20, w21        // Acumular en w20

    // Convertir decenas
    ldrb w21, [x19, #1]      // Cargar segundo carácter (decenas)
    sub w21, w21, #48        // Convertir de ASCII a entero
    mov w22, #10             // Multiplicar por 10 (posición de las decenas)
    mul w21, w21, w22
    add w20, w20, w21        // Acumular en w20

    // Convertir unidades
    ldrb w21, [x19, #2]      // Cargar tercer carácter (unidades)
    sub w21, w21, #48        // Convertir de ASCII a entero
    add w20, w20, w21        // Acumular en w20

    // Convertir el resultado a ASCII para imprimirlo
    adr x26, result_buffer

    // Unidades
    mov w27, #10
    udiv w28, w20, w27       // w28 = resultado / 10
    msub w29, w28, w27, w20  // w29 = resultado % 10
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26, #2]

    mov w20, w28             // Actualizar w20 a resultado / 10

    // Decenas
    udiv w28, w20, w27       // w28 = (resultado / 10) / 10
    msub w29, w28, w27, w20  // w29 = (resultado / 10) % 10
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26, #1]

    // Centenas
    mov w29, w28             // w29 = (resultado / 10) / 10 (centenas)
    add w29, w29, #48        // Convertir a ASCII
    strb w29, [x26]

    // Imprimir el resultado
    mov x0, #1               // Descriptor de archivo para stdout
    adr x1, result_buffer    // Dirección del buffer
    mov x2, #4               // Número de bytes a imprimir
    mov x8, #64              // Código del sistema para escribir
    svc 0

    // Salir
    mov x0, #0               
    mov x8, #93              
    svc 0
