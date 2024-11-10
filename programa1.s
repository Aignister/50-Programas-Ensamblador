// Luis Enrique Torres Murillo - 22210361
// Programa que convierte la temperatura de Celcius a Farenheit
// Codigo de alto nivel C#
/*
using System;

class ConvertirTemperatura
{
    static void Main()
    {
        Console.Write("Ingrese la temperatura en Celsius: ");
        double celsius = Convert.ToDouble(Console.ReadLine());
        double fahrenheit = (celsius * 9 / 5) + 32;
        Console.WriteLine($"La temperatura en Fahrenheit es: {fahrenheit}°F");
    }
}

*/
// Programa Ensamblador
.global _start

.section .data
    celsius: .word 25        // Valor en Celsius (ejemplo: 25°C)
    buffer: .ascii "   \n"   // Buffer para el resultado en Fahrenheit

.section .text
_start:
    // Cargar el valor en Celsius
    adr x19, celsius
    ldr w20, [x19]           

    // Calcular Fahrenheit: F = (C * 9 / 5) + 32
    mov w21, #9
    mul w22, w20, w21        // w22 = C * 9

    mov w23, #5
    udiv w24, w22, w23       // w24 = (C * 9) / 5

    add w24, w24, #32        // w24 = (C * 9 / 5) + 32 (resultado en Fahrenheit)

    // Conversión a ASCII (similar al código anterior)
    mov w25, w24             // Copiar Fahrenheit a w25
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

    // Imprimir el valor en Fahrenheit
    mov x0, #1               
    adr x1, buffer           
    mov x2, #4               
    mov x8, #64              
    svc 0

    // Salir
    mov x0, #0               
    mov x8, #93              
    svc 0
