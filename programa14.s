// Luis Enrique Torres Murillo - 22210361
// Programa que verifica si un numero es primo
// Codigo de alto nivel C#
/*
using System;

class VerificarPrimo
{
    static void Main()
    {
        Console.Write("Ingrese un número para verificar si es primo: ");
        int numero = Convert.ToInt32(Console.ReadLine());
        bool esPrimo = true;

        if (numero <= 1)
        {
            esPrimo = false;
        }
        else
        {
            for (int i = 2; i <= Math.Sqrt(numero); i++)
            {
                if (numero % i == 0)
                {
                    esPrimo = false;
                    break;
                }
            }
        }

        if (esPrimo)
            Console.WriteLine($"{numero} es un número primo.");
        else
            Console.WriteLine($"{numero} no es un número primo.");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    N: .word 29                      // Número a verificar (ejemplo: 29)
    prime_msg: .ascii "Es primo\n"   // Mensaje si es primo
    not_prime_msg: .ascii "No es primo\n" // Mensaje si no es primo

.section .text
_start:
    // Cargar el valor de N
    adr x0, N
    ldr w0, [x0]                    // Cargar el número en w0

    // Verificar si N <= 1 (no primo)
    cmp w0, #2
    blt not_prime                   // Si N < 2, no es primo
    b.eq prime                      // Si N == 2, es primo (caso especial)

    // Configurar valores iniciales para la verificación
    mov w1, #2                      // w1 será el divisor inicial

check_prime_loop:
    mul w2, w1, w1                  // w2 = w1 * w1 (cuadrado del divisor)
    cmp w2, w0                      // Comparar w2 con N
    b.gt prime                      // Si w1^2 > N, es primo (ya hemos verificado todos los divisores)

    udiv w3, w0, w1                 // w3 = N / w1 (división)
    msub w4, w3, w1, w0             // w4 = N - (w3 * w1) (resto)
    cbz w4, not_prime               // Si el resto es 0, no es primo (w1 divide a N)

    add w1, w1, #1                  // Incrementar el divisor
    b check_prime_loop              // Repetir el ciclo

prime:
    // Imprimir "Es primo"
    mov x0, #1                      // Descriptor de archivo para stdout
    adr x1, prime_msg               // Dirección del mensaje "Es primo"
    mov x2, #9                      // Tamaño del mensaje
    mov x8, #64                     // Código de sistema para write
    svc 0
    b end                           // Salir del programa

not_prime:
    // Imprimir "No es primo"
    mov x0, #1                      // Descriptor de archivo para stdout
    adr x1, not_prime_msg           // Dirección del mensaje "No es primo"
    mov x2, #12                     // Tamaño del mensaje
    mov x8, #64                     // Código de sistema para write
    svc 0

end:
    // Salir del programa
    mov x0, #0                      // Código de salida 0
    mov x8, #93                     // Llamada al sistema para salir
    svc 0
