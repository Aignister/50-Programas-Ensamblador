// Luis Enrique Torres Murillo - 22210361
// Programa que encuentra el prefijo mas comun mas largo en cadenas
// Codigo de alto nivel C#
/*
using System;
using System.Collections.Generic;
using System.Linq;

namespace PrefijoComunMasLargo
{
    class Program
    {
        static void Main(string[] args)
        {
            // Conjunto de cadenas
            string[] cadenas = { "algoritmo", "algoritmia", "algebra", "algebraico" };

            // Encontrar el prefijo más común y más largo
            string prefijoComun = ObtenerPrefijoComunMasLargo(cadenas);

            // Imprimir el resultado
            Console.WriteLine("El prefijo más común y más largo es: " + prefijoComun);
        }

        static string ObtenerPrefijoComunMasLargo(string[] cadenas)
        {
            if (cadenas.Length == 0)
            {
                return "";
            }

            // Obtener la longitud de la cadena más corta
            int longitudMinima = cadenas.Min(cadena => cadena.Length);

            // Iterar sobre cada posible longitud del prefijo
            for (int i = longitudMinima; i >= 1; i--)
            {
                // Obtener los primeros i caracteres de cada cadena
                string[] prefijos = cadenas.Select(cadena => cadena.Substring(0, i)).ToArray();

                // Verificar si todos los prefijos son iguales
                if (prefijos.Distinct().Count() == 1)
                {
                    return prefijos[0];
                }
            }

            // Si no se encontró ningún prefijo común, retornar una cadena vacía
            return "";
        }
    }
}
*/
// Programa Ensamblador
.section .data
    str1: .ascii "programming\0"
    str2: .ascii "programmer\0"
    str3: .ascii "progress\0"
    strings: .quad str1, str2, str3  // Arreglo de punteros a cadenas
    num_strings: .quad 3             // Número de cadenas en el arreglo

.section .text
    .global _start

_start:
    // Inicializar punteros
    ldr x0, =strings         // x0 apunta al arreglo de cadenas
    ldr x1, =num_strings     // x1 es el número de cadenas
    ldr x1, [x1]             // Cargar el valor de num_strings en x1

    // Llamar a la función de prefijo común
    bl longest_common_prefix

    // Terminar el programa
    mov x8, 93               // syscall_exit
    svc 0

// Función para encontrar el prefijo común más largo
// x0 = puntero al arreglo de cadenas
// x1 = número de cadenas
// Resultado en x2 (longitud del prefijo común)

longest_common_prefix:
    mov x2, 0                // x2 será la longitud del prefijo común
    cbz x1, end              // Si no hay cadenas, regresar

check_prefix:
    // Cargar el primer carácter de la primera cadena en x3
    ldr x3, [x0]             // Cargar la dirección de la primera cadena en x3
    add x3, x3, x2           // Avanzar a la posición x2
    ldrb w3, [x3]            // Cargar el carácter actual de la primera cadena

    cbz w3, end              // Si alcanzamos el final, regresar

    // Comparar el carácter actual con el de las demás cadenas
    mov x4, 1                // Índice para la cadena actual

compare_loop:
    cmp x4, x1               // Comparar índice con el número de cadenas
    beq all_match            // Si todas las cadenas coinciden, incrementar prefijo

    // Cargar el carácter actual de la cadena x4 en w5
    ldr x5, [x0, x4, lsl #3] // Cargar la dirección de la cadena x4
    add x5, x5, x2           // Avanzar a la posición x2
    ldrb w5, [x5]            // Cargar el carácter actual

    cmp w3, w5               // Comparar caracteres
    bne end                  // Si no coinciden, terminamos el prefijo común

    add x4, x4, 1            // Siguiente cadena
    b compare_loop

all_match:
    add x2, x2, 1            // Aumentar longitud del prefijo común
    b check_prefix

end:
    // x2 contiene la longitud del prefijo común más largo
    ret
