// Luis Enrique Torres Murillo - 22210361
// Programa que invierte una cadena
// Codigo de alto nivel C#
/*
using System;

class InvertirCadena
{
    static void Main()
    {
        Console.Write("Ingrese una cadena de texto: ");
        string cadena = Console.ReadLine();
        char[] caracteres = cadena.ToCharArray();
        Array.Reverse(caracteres);
        string cadenaInvertida = new string(caracteres);

        Console.WriteLine($"La cadena invertida es: {cadenaInvertida}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    input_str: .ascii "Enrique\n"      // Cadena original a invertir
    input_len: .word 7                 // Longitud de la cadena (sin contar el '\n')
    output_buffer: .space 8            // Buffer para la cadena invertida (espacio para '\n' y terminador)

.section .text
_start:
    // Cargar la longitud de la cadena
    adr x1, input_len
    ldr w1, [x1]                       // w1 = longitud de la cadena

    // Cargar la dirección de la cadena de entrada y salida
    adr x2, input_str                  // x2 apunta a la cadena original
    adr x3, output_buffer              // x3 apunta al buffer para la cadena invertida

invert_loop:
    // Obtener el último carácter de la cadena original
    sub x1, x1, #1                     // Decrementar índice (usar x1 en lugar de w1)
    ldrb w4, [x2, x1]                  // Cargar el carácter desde input_str
    strb w4, [x3], #1                  // Guardar el carácter en output_buffer y avanzar

    cbnz x1, invert_loop               // Si x1 no es cero, repetir el ciclo

    // Añadir nueva línea al final de la cadena invertida
    mov w4, #'\n'
    strb w4, [x3]                      // Añadir '\n' al final del buffer

    // Imprimir la cadena invertida
    mov x0, #1                         // Descriptor de archivo para stdout
    adr x1, output_buffer              // Dirección del buffer de salida
    mov x2, #8                         // Longitud de la cadena invertida
    mov x8, #64                        // Código de sistema para write
    svc 0

    // Salida del programa
    mov x0, #0                         // Código de salida 0
    mov x8, #93                        // Llamada al sistema para salir
    svc 0
