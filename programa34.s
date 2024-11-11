// Luis Enrique Torres Murillo - 22210361
// Programa que encuentra el segundo elemento mas grande de un arreglo
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static void Main()
    {
        int[] numeros = { 3, 7, 2, 9, 5 };

        int maximo = int.MinValue;
        int segundoMaximo = int.MinValue;

        foreach (int num in numeros)
        {
            if (num > maximo)
            {
                segundoMaximo = maximo;
                maximo = num;
            }
            else if (num > segundoMaximo && num != maximo)
            {
                segundoMaximo = num;
            }
        }

        Console.WriteLine("El segundo elemento más grande es: " + segundoMaximo);
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    // Arreglo de ejemplo
    array: .word 12, 35, 1, 10, 34, 1, 35, 8, 20    // Arreglo con números (incluyendo duplicados)
    len = (. - array) / 4                            // Longitud del arreglo
    
    // Variables para almacenar resultados
    max: .word 0                                     // Para almacenar el máximo
    second_max: .word 0                              // Para almacenar el segundo máximo
    
    // Buffer para imprimir
    msg1: .ascii "Elemento mas grande: "
    len1 = . - msg1
    msg2: .ascii "\nSegundo elemento mas grande: "
    len2 = . - msg2 - len1
    buffer: .ascii "   \n"                          // Buffer para números (3 dígitos + newline)
    
.section .text
_start:
    // Inicializar registros
    adr x19, array                                  // Dirección base del arreglo
    mov x20, #0                                     // Índice actual
    
    // Cargar primer elemento como máximo inicial
    ldr w21, [x19]                                  // w21 = máximo
    mov w22, #-1                                    // w22 = segundo máximo (inicializado con -1)
    
buscar_maximo:
    // Verificar si hemos terminado el arreglo
    cmp x20, #len
    beq encontrar_segundo
    
    // Cargar elemento actual
    lsl x23, x20, #2                               // x23 = índice * 4
    ldr w24, [x19, x23]                            // w24 = array[índice]
    
    // Comparar con máximo actual
    cmp w24, w21
    ble no_es_maximo                               // Si es menor o igual, saltar
    // Es nuevo máximo
    mov w22, w21                                   // Anterior máximo pasa a ser segundo
    mov w21, w24                                   // Actualizar máximo
    b siguiente
    
no_es_maximo:
    // Comparar con segundo máximo
    cmp w24, w22
    ble siguiente                                  // Si es menor o igual, saltar
    cmp w24, w21
    beq siguiente                                  // Si es igual al máximo, saltar
    mov w22, w24                                   // Actualizar segundo máximo
    
siguiente:
    add x20, x20, #1                              // Incrementar índice
    b buscar_maximo
    
encontrar_segundo:
    // Guardar resultados
    adr x23, max
    str w21, [x23]
    adr x23, second_max
    str w22, [x23]
    
    // Imprimir mensaje para el máximo
    mov x0, #1                                     // stdout
    adr x1, msg1                                   // mensaje
    mov x2, #len1                                  // longitud
    mov x8, #64                                    // syscall write
    svc 0
    
    // Imprimir máximo
    mov w25, w21                                   // Número a imprimir
    bl imprimir_numero
    
    // Imprimir mensaje para el segundo máximo
    mov x0, #1                                     // stdout
    adr x1, msg2                                   // mensaje
    mov x2, #len2                                  // longitud
    mov x8, #64                                    // syscall write
    svc 0
    
    // Imprimir segundo máximo
    mov w25, w22                                   // Número a imprimir
    bl imprimir_numero
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
    
imprimir_numero:
    // Guarda los registros que se van a usar
    stp x29, x30, [sp, #-16]!
    
    // Preparar buffer
    adr x26, buffer
    
    // Convertir a ASCII (3 dígitos)
    mov w27, #10                                   // Divisor
    
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
    mov x0, #1                                     // stdout
    mov x1, x26                                    // buffer
    mov x2, #4                                     // longitud (3 dígitos + newline)
    mov x8, #64                                    // syscall write
    svc 0
    
    // Restaurar registros
    ldp x29, x30, [sp], #16
    ret
