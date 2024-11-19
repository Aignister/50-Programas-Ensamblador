// Luis Enrique Torres Murillo - 22210361
// Programa que mide el tiempo de ejecucion de una funcion
// Codigo de alto nivel C#
/*
using System;
using System.Diagnostics;

class Program
{
    static void Main()
    {
        // Función a medir
        int Factorial(int n)
        {
            if (n == 0)
                return 1;
            else
                return n * Factorial(n - 1);
        }

        // Medir el tiempo de ejecución
        Stopwatch stopwatch = new Stopwatch();
        stopwatch.Start();

        int resultado = Factorial(10);

        stopwatch.Stop();

        Console.WriteLine("El factorial de 10 es: " + resultado);
        Console.WriteLine("Tiempo de ejecución: " + stopwatch.ElapsedMilliseconds + " ms");
    }
}
*/
// Programa Ensamblador
    .section .data
result:     .word 0     // Reserva espacio en memoria para el resultado

    .section .text
    .global _start

_start:
    // Leer la frecuencia del contador (CNTFRQ_EL0)
    mrs x0, CNTFRQ_EL0

    // Leer el contador inicial (CNTVCT_EL0)
    mrs x1, CNTVCT_EL0

    // Llamar a la función
    bl my_function

    // Leer el contador final (CNTVCT_EL0)
    mrs x2, CNTVCT_EL0

    // Calcular la diferencia (ciclos)
    sub x3, x2, x1      // x3 = ciclos transcurridos

    // Dividir ciclos por frecuencia para obtener tiempo en segundos
    udiv x4, x3, x0     // x4 = tiempo en segundos (entero)

    // Construir la dirección de 'result' usando instrucciones válidas
    adrp x5, result     // Cargar la página base de 'result'
    add x5, x5, :lo12:result // Agregar el offset para obtener la dirección completa

    // Guardar el resultado en la dirección de 'result'
    str w4, [x5]        // Guardar el valor de x4 en memoria

    // Salir del programa
    movz x8, #93        // syscall: exit (usar movz para valores inmediatos grandes)
    movz x0, #0         // exit code 0
    svc 0

// Función que realiza un cálculo simple para medir el tiempo
my_function:
    mov x5, 0           // Inicializa un contador
    movz x6, #1000      // Mover un valor inmediato válido
    lsl x6, x6, #10     // Construir el valor 1000000 como (1000 << 10)
loop:
    add x5, x5, 1       // Incrementar el contador
    cmp x5, x6          // Comparar con el límite
    bne loop            // Repetir si no se alcanza el límite
    ret
