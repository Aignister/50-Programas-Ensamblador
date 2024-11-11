// Luis Enrique Torres Murillo - 22210361
// Programa que cuenta los bits activados en un numero
// Codigo de alto nivel C#
/*
using System;

namespace ContarBitsActivados
{
    class Program
    {
        static int ContarBitsActivados(int num)
        {
            int count = 0;
            while (num != 0)
            {
                count += num & 1;
                num >>= 1;
            }
            return count;
        }

        static void Main(string[] args)
        {
            int numero = 15; // En binario: 1111
            int bitsActivados = ContarBitsActivados(numero);

            Console.WriteLine($"El número {numero} tiene {bitsActivados} bits activados.");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    number: .word 0b11010110  // Número a analizar (214 en decimal)
    buffer: .ascii "   \n"    // Buffer para mostrar resultado
    msg_num: .ascii "Numero: "
    msg_num_len = . - msg_num
    msg_count: .ascii "Bits activados: "
    msg_count_len = . - msg_count

.section .text
_start:
    // Cargar el número
    adr x19, number
    ldr w20, [x19]        // w20 = número a analizar

    // Mostrar mensaje "Numero: "
    mov x0, #1
    adr x1, msg_num
    mov x2, msg_num_len
    mov x8, #64
    svc 0

    // Mostrar el número original
    mov w25, w20
    bl convert_print

    // Inicializar contador de bits
    mov w21, #0           // w21 será nuestro contador

count_loop:
    // Verificar si el número es 0
    cmp w20, #0
    beq print_result

    // Técnica 1: Usar AND con el número - 1
    // Esta técnica elimina el bit 1 menos significativo en cada iteración
    sub w22, w20, #1      // w22 = number - 1
    and w20, w20, w22     // number = number & (number - 1)
    
    // Incrementar contador
    add w21, w21, #1
    
    // Continuar el loop
    b count_loop

print_result:
    // Mostrar mensaje "Bits activados: "
    mov x0, #1
    adr x1, msg_count
    mov x2, msg_count_len
    mov x8, #64
    svc 0

    // Mostrar el resultado del conteo
    mov w25, w21
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
