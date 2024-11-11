// Luis Enrique Torres Murillo - 22210361
// Programa que identifica si un numero es Armstrong
// Codigo de alto nivel C#
/*
using System;

namespace NumeroArmstrong
{
    class Program
    {
        static int CalcularSumaDigitosElevados(int num)
        {
            int suma = 0;
            int originalNum = num;
            int numDigitos = num.ToString().Length;

            while (num > 0)
            {
                int digito = num % 10;
                suma += (int)Math.Pow(digito, numDigitos);
                num /= 10;
            }

            return suma;
        }

        static bool EsNumeroArmstrong(int num)
        {
            return num == CalcularSumaDigitosElevados(num);
        }

        static void Main(string[] args)
        {
            Console.Write("Ingrese un número: ");
            int numero = int.Parse(Console.ReadLine());

            if (EsNumeroArmstrong(numero))
            {
                Console.WriteLine($"{numero} es un número de Armstrong.");
            }
            else
            {
                Console.WriteLine($"{numero} no es un número de Armstrong.");
            }
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    number: .word 153      // Número a verificar
    buffer: .ascii "   \n" // Buffer para mostrar resultados
    msg_num: .ascii "Numero: "
    msg_num_len = . - msg_num
    msg_is: .ascii " es Armstrong\n"
    msg_is_len = . - msg_is
    msg_not: .ascii " no es Armstrong\n"
    msg_not_len = . - msg_not

.section .text
_start:
    // Cargar el número
    adr x19, number
    ldr w20, [x19]        // w20 = número original
    mov w21, w20          // w21 = copia para contar dígitos
    mov w22, w20          // w22 = copia para procesar dígitos

    // Mostrar mensaje "Numero: "
    mov x0, #1
    adr x1, msg_num
    mov x2, msg_num_len
    mov x8, #64
    svc 0

    // Mostrar el número
    mov w25, w20
    bl convert_print

    // Contar dígitos
    mov w23, #0           // w23 = contador de dígitos
    mov w24, #10          // w24 = divisor (10)
count_digits:
    udiv w25, w21, w24    // Dividir por 10
    add w23, w23, #1      // Incrementar contador
    mov w21, w25          // Actualizar número
    cbnz w21, count_digits // Continuar si no es cero

    // Calcular suma de potencias
    mov w21, #0           // w21 = suma total
process_digits:
    udiv w25, w22, w24    // w25 = número / 10
    msub w26, w25, w24, w22 // w26 = dígito actual (residuo)
    
    // Calcular potencia (dígito ^ num_digitos)
    mov w27, #1           // w27 = resultado de la potencia
    mov w28, w23          // w28 = exponente (num_digitos)
power_loop:
    cbz w28, power_done
    mul w27, w27, w26     // Multiplicar por el dígito
    sub w28, w28, #1
    b power_loop
power_done:
    add w21, w21, w27     // Sumar a la suma total
    
    mov w22, w25          // Actualizar número para siguiente iteración
    cbnz w22, process_digits

    // Comparar suma con número original
    cmp w20, w21
    bne not_armstrong

is_armstrong:
    // Mostrar mensaje "es Armstrong"
    mov x0, #1
    adr x1, msg_is
    mov x2, msg_is_len
    mov x8, #64
    svc 0
    b end_program

not_armstrong:
    // Mostrar mensaje "no es Armstrong"
    mov x0, #1
    adr x1, msg_not
    mov x2, msg_not_len
    mov x8, #64
    svc 0

end_program:
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
    mov x2, #3
    mov x8, #64
    svc 0

    // Restaurar registros y retornar
    ldp x29, x30, [sp], #16
    ret
