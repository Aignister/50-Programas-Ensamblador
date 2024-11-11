// Luis Enrique Torres Murillo - 22210361
// Programa calcula el factorial de un numero
// Codigo de alto nivel C#
/*
using System;

class Factorial
{
    static void Main()
    {
        Console.Write("Ingrese un número para calcular su factorial: ");
        int numero = Convert.ToInt32(Console.ReadLine());
        int factorial = 1;

        for (int i = 1; i <= numero; i++)
        {
            factorial *= i;
        }

        Console.WriteLine($"El factorial de {numero} es: {factorial}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    N: .word 5                  // Número para el cual se calculará el factorial (ejemplo: 5)
    factorial_buffer: .ascii "        \n" // Buffer para almacenar el factorial en ASCII

.section .text
_start:
    // Inicializar el resultado del factorial en 1
    mov w0, #1                  // w0 será el acumulador del factorial (empieza en 1)
    mov w1, #1                  // w1 será el contador (empieza en 1)

    // Cargar el valor de N
    adr x2, N
    ldr w2, [x2]                // Cargar el valor de N en w2

calcular_factorial:
    cmp w1, w2                  // Comparar el contador con N
    bgt fin                     // Si el contador es mayor que N, terminar el bucle

    mul w0, w0, w1              // Multiplicar el acumulador por el contador
    add w1, w1, #1              // Incrementar el contador
    b calcular_factorial        // Repetir el ciclo

fin:
    // Ahora w0 contiene el factorial de N

    // Convertir el factorial a ASCII para impresión
    adr x3, factorial_buffer    // x3 apunta al buffer donde se almacenará el factorial en ASCII
    mov w4, w0                  // Copiar el resultado del factorial a w4 para convertirlo

    // Convertir unidades
    mov w5, #10
    udiv w6, w4, w5             // w6 = factorial / 10 (parte entera)
    msub w7, w6, w5, w4         // w7 = factorial % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #5]           // Guardar la unidad en el buffer

    mov w4, w6                  // Actualizar w4 a factorial / 10

    // Convertir decenas
    udiv w6, w4, w5             // w6 = (factorial / 10) / 10
    msub w7, w6, w5, w4         // w7 = (factorial / 10) % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #4]           // Guardar la decena en el buffer

    mov w4, w6                  // Actualizar w4 a (factorial / 10) / 10

    // Convertir centenas
    udiv w6, w4, w5             // w6 = ((factorial / 10) / 10) / 10
    msub w7, w6, w5, w4         // w7 = ((factorial / 10) / 10) % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #3]           // Guardar la centena en el buffer

    mov w4, w6                  // Actualizar w4 para convertir las unidades de mil

    // Convertir unidades de mil
    udiv w6, w4, w5             // w6 = (((factorial / 10) / 10) / 10) / 10
    msub w7, w6, w5, w4         // w7 = (((factorial / 10) / 10) / 10) % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #2]           // Guardar las unidades de mil en el buffer

    mov w4, w6                  // Actualizar w4 para convertir las decenas de mil

    // Convertir decenas de mil
    add w4, w4, #48             // Convertir a ASCII
    strb w4, [x3, #1]           // Guardar las decenas de mil en el buffer

    // Imprimir el resultado del factorial en pantalla
    mov x0, #1                  // Descriptor de archivo para stdout
    adr x1, factorial_buffer    // Dirección del buffer
    mov x2, #7                  // Número de bytes a imprimir
    mov x8, #64                 // Código del sistema para write
    svc 0

    // Salir
    mov x0, #0                  
    mov x8, #93                 
    svc 0
