// Luis Enrique Torres Murillo - 22210361
// Programa que realiza un desplazamiento a la izquierda y derecha
// Codigo de alto nivel C#
/*
using System;

namespace DesplazamientosDeBits
{
    class Program
    {
        static void Main(string[] args)
        {
            int numero = 15; // En binario: 1111
            int posiciones = 2;

            // Desplazamiento a la izquierda
            int desplazamientoIzquierda = numero << posiciones;
            Console.WriteLine($"Desplazamiento a la izquierda {posiciones} posiciones: {desplazamientoIzquierda} (en binario: {Convert.ToString(desplazamientoIzquierda, 2)})");

            // Desplazamiento a la derecha
            int desplazamientoDerecha = numero >> posiciones;
            Console.WriteLine($"Desplazamiento a la derecha {posiciones} posiciones: {desplazamientoDerecha} (en binario: {Convert.ToString(desplazamientoDerecha, 2)})");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    number: .word 8        // Número a desplazar (8 = 1000 en binario)
    shifts: .word 2        // Cantidad de posiciones a desplazar
    buffer: .ascii "   \n" // Buffer para mostrar resultados
    msg_orig: .ascii "Original: "
    msg_orig_len = . - msg_orig
    msg_left: .ascii "Left shift: "
    msg_left_len = . - msg_left
    msg_right: .ascii "Right shift: "
    msg_right_len = . - msg_right

.section .text
_start:
    // Cargar el número y la cantidad de desplazamientos
    adr x19, number
    ldr w20, [x19]        // w20 = número original
    adr x19, shifts
    ldr w21, [x19]        // w21 = cantidad de desplazamientos

    // Mostrar mensaje "Original: "
    mov x0, #1
    adr x1, msg_orig
    mov x2, msg_orig_len
    mov x8, #64
    svc 0

    // Mostrar número original
    mov w25, w20
    bl convert_print

    // Desplazamiento a la izquierda (LSL)
    // Mostrar mensaje "Left shift: "
    mov x0, #1
    adr x1, msg_left
    mov x2, msg_left_len
    mov x8, #64
    svc 0

    // Realizar LSL y mostrar resultado
    mov w22, w20          // Copiar número original
    lsl w22, w22, w21     // Desplazar a la izquierda
    mov w25, w22
    bl convert_print

    // Desplazamiento a la derecha (LSR)
    // Mostrar mensaje "Right shift: "
    mov x0, #1
    adr x1, msg_right
    mov x2, msg_right_len
    mov x8, #64
    svc 0

    // Realizar LSR y mostrar resultado
    mov w22, w20          // Copiar número original
    lsr w22, w22, w21     // Desplazar a la derecha
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
