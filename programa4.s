// Luis Enrique Torres Murillo - 22210361
// Programa que realiza la multiplicacion de 2 numeros
// Codigo de alto nivel C#
/*
using System;

class MultiplicacionNumeros
{
    static void Main()
    {
        Console.Write("Ingrese el primer número: ");
        double numero1 = Convert.ToDouble(Console.ReadLine());
        Console.Write("Ingrese el segundo número: ");
        double numero2 = Convert.ToDouble(Console.ReadLine());
        double multiplicacion = numero1 * numero2;
        Console.WriteLine($"La multiplicación es: {multiplicacion}");
    }
}

*/
// Programa Ensamblador
.global _start

.section .data
    num1: .word 6            // Primer número
    num2: .word 7            // Segundo número
    buffer: .ascii "   \n"   // Buffer para el resultado

.section .text
_start:
    // Cargar los números
    adr x19, num1
    ldr w20, [x19]           
    adr x21, num2
    ldr w22, [x21]           

    // Multiplicar los números
    mul w23, w20, w22        // w23 = num1 * num2

    // Conversión a ASCII
    mov w25, w23             
    adr x26, buffer

    // Unidades
    mov w27, #10
    udiv w28, w25, w27       
    msub w29, w28, w27, w25  
    add w29, w29, #48        
    strb w29, [x26, #2]

    mov w25, w28             

    // Decenas
    udiv w28, w25, w27       
    msub w29, w28, w27, w25  
    add w29, w29, #48        
    strb w29, [x26, #1]

    // Centenas
    mov w29, w28             
    add w29, w29, #48        
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
