// Luis Enrique Torres Murillo - 22210361
// Programa suma los N primeros numeros naturales
// Codigo de alto nivel C#
/*
using System;

class SumaNaturales
{
    static void Main()
    {
        Console.Write("Ingrese un número N: ");
        int N = Convert.ToInt32(Console.ReadLine());
        int suma = 0;

        for (int i = 1; i <= N; i++)
        {
            suma += i;
        }

        Console.WriteLine($"La suma de los primeros {N} números naturales es: {suma}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    N: .word 10                 // Número de elementos a sumar, en este caso los primeros 10 números naturales
    suma_buffer: .ascii "    \n" // Buffer para almacenar la suma en ASCII

.section .text
_start:
    // Inicializar suma en 0
    mov w0, #0                  // w0 será el acumulador de la suma
    mov w1, #1                  // w1 será el contador (empieza en 1)

    // Cargar el valor de N
    adr x2, N
    ldr w2, [x2]                // Cargar el valor de N en w2

sumar:
    cmp w1, w2                  // Comparar el contador con N
    bgt fin                     // Si el contador es mayor que N, terminar el bucle

    add w0, w0, w1              // Sumar el valor del contador al acumulador
    add w1, w1, #1              // Incrementar el contador
    b sumar                     // Repetir el ciclo

fin:
    // Ahora w0 contiene la suma de los primeros N números naturales

    // Convertir la suma a ASCII para impresión
    adr x3, suma_buffer         // x3 apunta al buffer donde se almacenará la suma en ASCII
    mov w4, w0                  // Copiar la suma a w4 para convertirla

    // Convertir unidades
    mov w5, #10
    udiv w6, w4, w5             // w6 = suma / 10 (parte entera)
    msub w7, w6, w5, w4         // w7 = suma % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #3]           // Guardar la unidad en el buffer

    mov w4, w6                  // Actualizar w4 a suma / 10

    // Convertir decenas
    udiv w6, w4, w5             // w6 = (suma / 10) / 10
    msub w7, w6, w5, w4         // w7 = (suma / 10) % 10
    add w7, w7, #48             // Convertir a ASCII
    strb w7, [x3, #2]           // Guardar la decena en el buffer

    mov w4, w6                  // Actualizar w4 a (suma / 10) / 10

    // Convertir centenas
    add w4, w4, #48             // Convertir a ASCII
    strb w4, [x3, #1]           // Guardar la centena en el buffer

    // Imprimir la suma en pantalla
    mov x0, #1                  // Descriptor de archivo para stdout
    adr x1, suma_buffer         // Dirección del buffer
    mov x2, #4                  // Número de bytes a imprimir
    mov x8, #64                 // Código del sistema para write
    svc 0

    // Salir
    mov x0, #0                  
    mov x8, #93                 
    svc 0
