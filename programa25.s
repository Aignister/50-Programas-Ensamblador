// Luis Enrique Torres Murillo - 22210361
// Programa que realiza operaciones AND, OR, XOR a nivel de bits
// Codigo de alto nivel C#
/*
using System;

namespace OperacionesBitABit
{
    class Program
    {
        static void Main(string[] args)
        {
            // Números enteros a los que se les aplicarán las operaciones
            int num1 = 10; // En binario: 1010
            int num2 = 5;   // En binario: 0101

            // Operación AND bit a bit (&)
            int resultadoAND = num1 & num2;
            Console.WriteLine($"num1 AND num2 = {resultadoAND} (en binario: {Convert.ToString(resultadoAND, 2)})");

            // Operación OR bit a bit (|)
            int resultadoOR = num1 | num2;
            Console.WriteLine($"num1 OR num2 = {resultadoOR} (en binario: {Convert.ToString(resultadoOR, 2)})");

            // Operación XOR bit a bit (^)
            int resultadoXOR = num1 ^ num2;
            Console.WriteLine($"num1 XOR num2 = {resultadoXOR} (en binario: {Convert.ToString(resultadoXOR, 2)})");

            // Complemento a dos (~)
            int complementoADos = ~num1;
            Console.WriteLine($"Complemento a dos de num1 = {complementoADos} (en binario: {Convert.ToString(complementoADos, 2)})");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    num1: .word 0b1010    // Primer número (10 en binario)
    num2: .word 0b1100    // Segundo número (12 en binario)
    newline: .ascii "\n"  // Carácter de nueva línea para formato
    buffer: .ascii "   \n" // Buffer para mostrar resultados

.section .text
_start:
    // Cargar los números
    adr x19, num1
    ldr w20, [x19]        // w20 = num1
    adr x19, num2
    ldr w21, [x19]        // w21 = num2

    // Realizar operación AND
    and w22, w20, w21     // w22 = w20 AND w21
    // Guardar resultado y mostrar
    mov w25, w22
    bl convert_print

    // Realizar operación OR
    orr w22, w20, w21     // w22 = w20 OR w21
    // Guardar resultado y mostrar
    mov w25, w22
    bl convert_print

    // Realizar operación XOR
    eor w22, w20, w21     // w22 = w20 XOR w21
    // Guardar resultado y mostrar
    mov w25, w22
    bl convert_print

    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0

// Subrutina para convertir a ASCII y mostrar
convert_print:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    
    adr x26, buffer
    mov w27, #10

    // Unidades
    udiv w28, w25, w27
    msub w29, w28, w27, w25
    add w29, w29, #48
    strb w29, [x26, #2]
    
    // Decenas
    mov w25, w28
    udiv w28, w25, w27
    msub w29, w28, w27, w25
    add w29, w29, #48
    strb w29, [x26, #1]
    
    // Centenas
    mov w29, w28
    add w29, w29, #48
    strb w29, [x26]

    // Imprimir resultado
    mov x0, #1
    mov x1, x26
    mov x2, #4
    mov x8, #64
    svc 0

    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
