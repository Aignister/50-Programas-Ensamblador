// Luis Enrique Torres Murillo - 22210361
// Programa que lee la entrada desde el teclado
// Codigo de alto nivel C#
/*
using System;

class LeerEntrada
{
    static void Main()
    {
        Console.Write("Ingrese algún texto o número: ");
        string entrada = Console.ReadLine();
        Console.WriteLine($"La entrada ingresada es: {entrada}");
    }
}
*/
// Programa Ensamblador
.global _start

.section .bss
    input_buffer: .space 100     // Buffer de 100 bytes para almacenar la entrada

.section .text
_start:
    // Leer entrada desde el teclado
    mov x0, #0                   // Descriptor de archivo para stdin (teclado)
    adr x1, input_buffer         // Dirección del buffer de entrada
    mov x2, #100                 // Número máximo de bytes a leer
    mov x8, #63                  // Código del sistema para read
    svc 0                        // Llamada al sistema

    // Almacenar el número de bytes leídos en w3 (para usarlo al imprimir)
    mov w3, w0                   // Guardar el resultado de read (número de bytes leídos)

    // Imprimir la entrada
    mov x0, #1                   // Descriptor de archivo para stdout (pantalla)
    adr x1, input_buffer         // Dirección del buffer de entrada
    mov x2, x3                   // Número de bytes a imprimir (los mismos que se leyeron)
    mov x8, #64                  // Código del sistema para write
    svc 0                        // Llamada al sistema

    // Salir
    mov x0, #0                   // Código de salida
    mov x8, #93                  // Código del sistema para exit
    svc 0
