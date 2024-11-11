// Luis Enrique Torres Murillo - 22210361
// Programa que calcula el minimo comun multiplo
// Codigo de alto nivel C#
/*
using System;

namespace MinimoComunMultiplo
{
    class Program
    {
        static int CalcularMCD(int a, int b)
        {
            while (b != 0)
            {
                int temp = b;
                b = a % b;
                a = temp;
            }
            return a;
        }

        static int CalcularMCM(int a, int b)
        {
            return (a * b) / CalcularMCD(a, b);
        }

        static void Main(string[] args)
        {
            Console.Write("Ingrese el primer número: ");
            int num1 = int.Parse(Console.ReadLine());

            Console.Write("Ingrese el segundo número: ");
            int num2 = int.Parse(Console.ReadLine());

            int mcm = CalcularMCM(num1, num2);

            Console.WriteLine($"El mínimo común múltiplo de {num1} y {num2} es: {mcm}");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    num1: .word 48        // Primer número
    num2: .word 36        // Segundo número
    buffer: .ascii "   \n" // Buffer para mostrar resultados
    msg_nums: .ascii "Numeros: "
    msg_nums_len = . - msg_nums
    msg_and: .ascii " y "
    msg_and_len = . - msg_and
    msg_lcm: .ascii "\nMCM: "
    msg_lcm_len = . - msg_lcm

.section .text
_start:
    // Cargar los números
    adr x19, num1
    ldr w20, [x19]        // w20 = primer número
    adr x19, num2
    ldr w21, [x19]        // w21 = segundo número

    // Guardar copias de los números originales
    mov w22, w20          // w22 = copia de num1
    mov w23, w21          // w23 = copia de num2

    // Mostrar mensaje "Numeros: "
    mov x0, #1
    adr x1, msg_nums
    mov x2, msg_nums_len
    mov x8, #64
    svc 0

    // Mostrar primer número
    mov w25, w20
    bl convert_print

    // Mostrar " y "
    mov x0, #1
    adr x1, msg_and
    mov x2, msg_and_len
    mov x8, #64
    svc 0

    // Mostrar segundo número
    mov w25, w21
    bl convert_print

    // Primero calculamos el MCD para usarlo en el MCM
gcd_loop:
    udiv w24, w20, w21    // w24 = num1 / num2
    msub w24, w24, w21, w20 // w24 = num1 % num2 (residuo)
    mov w20, w21          // num1 = num2
    mov w21, w24          // num2 = residuo
    cbnz w21, gcd_loop    // Continuar si residuo != 0

    // w20 contiene el MCD
    // Calcular MCM = (num1 * num2) / MCD
    mul w24, w22, w23     // w24 = num1 * num2
    udiv w24, w24, w20    // w24 = (num1 * num2) / MCD

    // Mostrar mensaje "MCM: "
    mov x0, #1
    adr x1, msg_lcm
    mov x2, msg_lcm_len
    mov x8, #64
    svc 0

    // Mostrar el MCM
    mov w25, w24
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

    // Imprimir número
    mov x0, #1
    mov x1, x26
    mov x2, #4
    mov x8, #64
    svc 0

    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
