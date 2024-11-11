// Luis Enrique Torres Murillo - 22210361
// Programa que detecta desbordamiento de suma
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static void Main()
    {
        int a = int.MaxValue;
        int b = 1;

        try
        {
            int resultado = checked(a + b);
            Console.WriteLine("El resultado de la suma es: " + resultado);
        }
        catch (OverflowException ex)
        {
            Console.WriteLine("Se produjo un desbordamiento: " + ex.Message);
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    num1: .word 0x7FFFFFFF   // Valor máximo de 32 bits sin signo
    num2: .word 0x00000001   // Valor a sumar
    result: .word 0          // Resultado de la suma
    overflow_msg: .ascii "Desbordamiento de suma detectado\n"
    overflow_msg_len = . - overflow_msg

.section .text
_start:
    // Cargar los valores a sumar
    adr x0, num1
    ldr w1, [x0]
    adr x0, num2
    ldr w2, [x0]

    // Realizar la suma
    add w3, w1, w2

    // Comprobar si hay desbordamiento
    cmp w3, w1
    bvs overflow

    // Almacenar el resultado
    adr x0, result
    str w3, [x0]

    // Salir normalmente
    mov x0, #0
    mov x8, #93
    svc 0

overflow:
    // Imprimir mensaje de desbordamiento
    mov x0, #1
    adr x1, overflow_msg
    mov x2, overflow_msg_len
    mov x8, #64
    svc 0

    // Salir con código de error
    mov x0, #1
    mov x8, #93
    svc 0
