// Luis Enrique Torres Murillo - 22210361
// Programa que convierte de decimal a binario
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static void Main()
    {
        int decimalNumber = 25;
        string binaryNumber = "";

        while (decimalNumber > 0)
        {
            binaryNumber = decimalNumber % 2 + binaryNumber;
            decimalNumber /= 2;
        }

        Console.WriteLine("El número decimal " + decimalNumber + " en binario es: " + binaryNumber);
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    numero: .word 42           // Número decimal a convertir
    
    // Mensajes y buffers
    msg: .ascii "Binario: "
    len_msg = . - msg
    
    buffer: .ascii "00000000000000000000000000000000\n"   // 32 bits + newline
    len_buffer = . - buffer
    
.section .text
_start:
    // Cargar el número a convertir
    adr x19, numero
    ldr w20, [x19]            // w20 contiene el número decimal
    
    // Imprimir mensaje inicial
    mov x0, #1                // stdout
    adr x1, msg               // mensaje
    mov x2, #len_msg          // longitud del mensaje
    mov x8, #64               // syscall write
    svc 0
    
    // Preparar para la conversión
    adr x21, buffer           // Dirección del buffer
    mov w22, #31              // Posición en el buffer (empezando desde el final)
    mov w23, #0              // Contador de bits
    
convertir:
    // Obtener el bit menos significativo
    and w24, w20, #1         // w24 = número & 1
    
    // Convertir bit a ASCII ('0' o '1')
    add w24, w24, #48        // Convertir a ASCII
    strb w24, [x21, x22]     // Guardar en buffer
    
    // Desplazar el número a la derecha
    lsr w20, w20, #1         // número = número >> 1
    
    // Ajustar posición y contador
    sub w22, w22, #1         // Mover posición a la izquierda
    add w23, w23, #1         // Incrementar contador de bits
    
    // Verificar si hemos procesado 32 bits
    cmp w23, #32
    bne convertir
    
    // Encontrar el primer '1' para eliminar ceros iniciales innecesarios
    adr x21, buffer
    mov w22, #0              // Índice inicial
    
encontrar_inicio:
    cmp w22, #31             // Si llegamos al final, imprimir todo
    beq imprimir
    
    ldrb w24, [x21, x22]
    cmp w24, #49            // Comparar con '1'
    beq imprimir
    
    add w22, w22, #1
    b encontrar_inicio
    
imprimir:
    // Calcular longitud a imprimir
    mov w25, #32
    sub w25, w25, w22       // Longitud = 32 - posición inicial
    add w25, w25, #1        // +1 para el newline
    
    // Imprimir resultado
    mov x0, #1              // stdout
    add x1, x21, x22        // buffer + posición inicial
    mov x2, x25             // longitud
    mov x8, #64             // syscall write
    svc 0
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
