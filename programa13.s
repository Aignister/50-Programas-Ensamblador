// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una serie de Fibonacci
// Codigo de alto nivel C#
/*
using System;

class SerieFibonacci
{
    static void Main()
    {
        Console.Write("Ingrese la cantidad de términos en la serie de Fibonacci: ");
        int n = Convert.ToInt32(Console.ReadLine());
        int a = 0, b = 1, c;

        Console.Write("Serie de Fibonacci: ");
        for (int i = 0; i < n; i++)
        {
            Console.Write(a + " ");
            c = a + b;
            a = b;
            b = c;
        }
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    buffer: .asciz "    "        // Buffer para 3 dígitos + espacio
    newline: .byte 10            // Solo el carácter de nueva línea (ASCII 10)
    
.section .text
_start:
    // Inicializar Fibonacci
    mov w19, #0                  // F(0)
    mov w20, #1                  // F(1)
    mov w21, #10                 // N = 10 términos

    // Imprimir primer número (0)
    mov w0, w19
    bl print_num
    
    // Decrementar contador
    sub w21, w21, #1
    
fibo_loop:
    // Verificar si terminamos
    cmp w21, #0
    ble exit
    
    // Imprimir número actual
    mov w0, w20
    bl print_num
    
    // Calcular siguiente número
    add w22, w19, w20            // Nuevo = F(n-2) + F(n-1)
    mov w19, w20                 // F(n-2) = F(n-1)
    mov w20, w22                 // F(n-1) = Nuevo
    
    // Actualizar contador
    sub w21, w21, #1
    b fibo_loop

print_num:
    // Preservar registros
    stp x29, x30, [sp, #-16]!    
    mov w22, w0                  // Guardar número a convertir
    
    // Limpiar buffer
    adr x0, buffer
    mov w1, #32                  // Espacio (ASCII 32)
    strb w1, [x0]
    strb w1, [x0, #1]
    strb w1, [x0, #2]
    
    // Convertir número a ASCII
    mov x1, #0                   // Índice en buffer
    mov w2, w22                  // Número a convertir
    
convert_loop:
    mov w3, #10
    udiv w4, w2, w3              // w4 = número / 10
    msub w5, w4, w3, w2          // w5 = número % 10
    add w5, w5, #48              // Convertir a ASCII
    strb w5, [x0, x1]            // Guardar dígito
    add x1, x1, #1               // Siguiente posición
    mov w2, w4                   // Preparar para siguiente dígito
    cmp w2, #0
    bne convert_loop
    
    // Agregar espacio
    mov w2, #32                  // Espacio
    strb w2, [x0, #3]            // Agregar al final del número
    
    // Imprimir número
    mov x0, #1                   // stdout
    adr x1, buffer              // buffer
    mov x2, #4                   // longitud (3 dígitos + espacio)
    mov x8, #64                  // syscall write
    svc 0
    
    // Restaurar registros
    ldp x29, x30, [sp], #16
    ret

exit:
    // Imprimir nueva línea final
    mov x0, #1                   // stdout
    adr x1, newline             // nueva línea
    mov x2, #1                   // longitud
    mov x8, #64                  // syscall write
    svc 0
    
    // Salir normalmente
    mov x0, #0                   // código de retorno
    mov x8, #93                  // syscall exit
    svc 0
