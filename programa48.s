// Luis Enrique Torres Murillo - 22210361
// Programa que genera numeros aleatorios con semilla
// Codigo de alto nivel C#
/*
using System;

class GeneradorNumerosAleatorios
{
    static void Main(string[] args)
    {
        // Semilla para el generador de números aleatorios
        int semilla = 12345;

        // Crear una instancia del generador de números aleatorios con la semilla especificada
        Random random = new Random(semilla);

        // Generar 10 números aleatorios entre 1 y 100
        for (int i = 0; i < 10; i++)
        {
            int numeroAleatorio = random.Next(1, 101);
            Console.WriteLine("Número aleatorio: " + numeroAleatorio);
        }
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    // Parámetros del generador LCG
    seed:       .quad 12345      // Semilla inicial
    multiplier: .quad 1597       // Multiplicador (a)
    increment:  .quad 51749      // Incremento (c)
    modulus:    .quad 244944     // Módulo (m)
    
    // Cantidad de números a generar
    count:      .word 10
    
    // Mensajes y buffers
    msg_seed:    .ascii "Semilla inicial: "
    len_seed:    .word . - msg_seed
    msg_random:  .ascii "Número aleatorio generado: "
    len_random:  .word . - msg_random
    newline:     .ascii "\n"
    number_buffer: .skip 20

.section .text
_start:
    // Imprimir semilla inicial
    mov x0, #1
    adr x1, msg_seed
    adr x2, len_seed
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    adr x0, seed
    ldr x0, [x0]
    bl print_number
    
    // Generar números aleatorios
    adr x19, count
    ldr w19, [x19]      // Cargar cantidad de números a generar
    
generate_loop:
    cbz w19, exit       // Si count == 0, terminar
    
    // Imprimir mensaje
    mov x0, #1
    adr x1, msg_random
    adr x2, len_random
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    // Generar siguiente número aleatorio
    bl next_random
    
    // Imprimir número generado
    bl print_number
    
    sub w19, w19, #1    // Decrementar contador
    b generate_loop

exit:
    mov x0, #0
    mov x8, #93
    svc #0

// Función next_random: genera el siguiente número aleatorio
// Usa la fórmula: next = (seed * multiplier + increment) % modulus
next_random:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    // Cargar valores actuales
    adr x19, seed
    ldr x0, [x19]       // Cargar semilla actual
    adr x20, multiplier
    ldr x20, [x20]      // Cargar multiplicador
    
    // Realizar multiplicación
    mul x0, x0, x20
    
    // Sumar incremento
    adr x20, increment
    ldr x20, [x20]
    add x0, x0, x20
    
    // Aplicar módulo
    adr x20, modulus
    ldr x20, [x20]
    udiv x21, x0, x20
    msub x0, x21, x20, x0
    
    // Guardar nuevo valor como semilla
    str x0, [x19]
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// Función print_number: convierte e imprime un número
print_number:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0         // Guardar número a imprimir
    
    // Preparar buffer
    adr x20, number_buffer
    mov x21, #0         // Contador de dígitos
    mov x22, #10        // Divisor
    
convert_loop:
    udiv x23, x19, x22
    msub x24, x23, x22, x19
    add w24, w24, #48   // Convertir a ASCII
    strb w24, [x20, x21]
    add x21, x21, #1
    mov x19, x23
    cbnz x19, convert_loop
    
    // Revertir dígitos
    mov x23, #0         // Índice inicial
    sub x24, x21, #1    // Índice final
    
reverse_loop:
    cmp x23, x24
    b.ge print_num
    ldrb w25, [x20, x23]
    ldrb w26, [x20, x24]
    strb w26, [x20, x23]
    strb w25, [x20, x24]
    add x23, x23, #1
    sub x24, x24, #1
    b reverse_loop
    
print_num:
    // Imprimir número
    mov x0, #1
    mov x1, x20
    mov x2, x21
    mov x8, #64
    svc #0
    
    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
