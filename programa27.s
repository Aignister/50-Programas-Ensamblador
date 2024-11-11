// Luis Enrique Torres Murillo - 22210361
// Programa que establece, borra y alterna bits
// Codigo de alto nivel C#
/*
using System;

namespace ManipulacionDeBits
{
    class Program
    {
        static void Main(string[] args)
        {
            int numero = 15; // En binario: 1111
            int posicion = 1; // Posición del bit a modificar (contando desde 0)

            // Estableciendo un bit
            int numeroConBitEstablecido = numero | (1 << posicion);
            Console.WriteLine($"Número con el bit {posicion} establecido: {numeroConBitEstablecido} (en binario: {Convert.ToString(numeroConBitEstablecido, 2)})");

            // Borrando un bit
            int numeroConBitBorrado = numero & ~(1 << posicion);
            Console.WriteLine($"Número con el bit {posicion} borrado: {numeroConBitBorrado} (en binario: {Convert.ToString(numeroConBitBorrado, 2)})");

            // Alternando un bit
            int numeroConBitAlternado = numero ^ (1 << posicion);
            Console.WriteLine($"Número con el bit {posicion} alternado: {numeroConBitAlternado} (en binario: {Convert.ToString(numeroConBitAlternado, 2)})");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    number: .word 0b1010   // Número inicial (10 en decimal)
    bitpos: .word 2        // Posición del bit a manipular (0-31)
    buffer: .ascii "   \n" // Buffer para mostrar resultados
    msg_orig: .ascii "Original:    "
    msg_orig_len = . - msg_orig
    msg_set: .ascii "Set bit:     "
    msg_set_len = . - msg_set
    msg_clear: .ascii "Clear bit:   "
    msg_clear_len = . - msg_clear
    msg_toggle: .ascii "Toggle bit:  "
    msg_toggle_len = . - msg_toggle

.section .text
_start:
    // Cargar el número y la posición del bit
    adr x19, number
    ldr w20, [x19]        // w20 = número original
    adr x19, bitpos
    ldr w21, [x19]        // w21 = posición del bit

    // Mostrar número original
    mov x0, #1
    adr x1, msg_orig
    mov x2, msg_orig_len
    mov x8, #64
    svc 0
    mov w25, w20
    bl convert_print

    // SET BIT (establecer bit en 1)
    // Fórmula: number | (1 << bitpos)
    mov w22, #1           // w22 = 1
    lsl w22, w22, w21     // w22 = 1 << bitpos
    orr w23, w20, w22     // w23 = number | (1 << bitpos)
    
    // Mostrar resultado de SET
    mov x0, #1
    adr x1, msg_set
    mov x2, msg_set_len
    mov x8, #64
    svc 0
    mov w25, w23
    bl convert_print

    // CLEAR BIT (establecer bit en 0)
    // Fórmula: number & ~(1 << bitpos)
    mov w22, #1           // w22 = 1
    lsl w22, w22, w21     // w22 = 1 << bitpos
    mvn w22, w22          // w22 = ~(1 << bitpos)
    and w23, w20, w22     // w23 = number & ~(1 << bitpos)
    
    // Mostrar resultado de CLEAR
    mov x0, #1
    adr x1, msg_clear
    mov x2, msg_clear_len
    mov x8, #64
    svc 0
    mov w25, w23
    bl convert_print

    // TOGGLE BIT (invertir bit)
    // Fórmula: number ^ (1 << bitpos)
    mov w22, #1           // w22 = 1
    lsl w22, w22, w21     // w22 = 1 << bitpos
    eor w23, w20, w22     // w23 = number ^ (1 << bitpos)
    
    // Mostrar resultado de TOGGLE
    mov x0, #1
    adr x1, msg_toggle
    mov x2, msg_toggle_len
    mov x8, #64
    svc 0
    mov w25, w23
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
