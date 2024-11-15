// Luis Enrique Torres Murillo - 22210361
// Programa que cuenta las vocales y consonantes
// Codigo de alto nivel C#
/*
using System;

namespace ContadorVocalesConsonantes
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Ingrese un texto:");
            string texto = Console.ReadLine();

            int vocales = 0, consonantes = 0;
            string vocalesStr = "aeiouAEIOU";

            foreach (char caracter in texto)
            {
                if (char.IsLetter(caracter))
                {
                    if (vocalesStr.Contains(caracter))
                    {
                        vocales++;
                    }
                    else
                    {
                        consonantes++;
                    }
                }
            }

            Console.WriteLine("Vocales: " + vocales);
            Console.WriteLine("Consonantes: " + consonantes);
        }
    }
}
*/
// Programa Ensamblador
.section .data
string:     .asciz "Hello World"
vowels:     .word 0          // Contador de vocales
consonants: .word 0          // Contador de consonantes

.section .text
.global _start
_start:
    // Inicializar registros y apuntar al inicio de la cadena
    adr x0, string           // Dirección de la cadena en x0
    adr x1, vowels           // Dirección del contador de vocales
    adr x2, consonants       // Dirección del contador de consonantes
    mov x5, #1               // Registro auxiliar con el valor 1 para csel

count_loop:
    ldrb w3, [x0], #1        // Cargar el siguiente carácter en w3 y avanzar x0
    cbz w3, end_count        // Si el carácter es '\0', terminar el bucle

    // Comprobar si es una vocal (a, e, i, o, u, A, E, I, O, U)
    mov x4, 0                // Limpieza de registro para comparación
    cmp w3, 'a'
    csel x4, x4, x5, eq      // Si es 'a', marcar como vocal
    cmp w3, 'e'
    csel x4, x4, x5, eq
    cmp w3, 'i'
    csel x4, x4, x5, eq
    cmp w3, 'o'
    csel x4, x4, x5, eq
    cmp w3, 'u'
    csel x4, x4, x5, eq
    cmp w3, 'A'
    csel x4, x4, x5, eq
    cmp w3, 'E'
    csel x4, x4, x5, eq
    cmp w3, 'I'
    csel x4, x4, x5, eq
    cmp w3, 'O'
    csel x4, x4, x5, eq
    cmp w3, 'U'
    csel x4, x4, x5, eq

    cbnz x4, increment_vowel // Si es vocal, incrementar contador de vocales

    // Comprobar si es consonante (letra alfabética no vocal)
    cmp w3, 'a'
    cset x4, cs              // Si es letra alfabética
    cmp w3, 'z'
    cset x4, cs
    cmp w3, 'A'
    cset x4, cs
    cmp w3, 'Z'
    cset x4, cs
    cbz x4, count_loop       // Si no es letra, continuar

increment_consonant:
    ldr w4, [x2]             // Leer el contador de consonantes
    add w4, w4, #1           // Incrementar
    str w4, [x2]             // Guardar en memoria
    b count_loop             // Continuar con el siguiente carácter

increment_vowel:
    ldr w4, [x1]             // Leer el contador de vocales
    add w4, w4, #1           // Incrementar
    str w4, [x1]             // Guardar en memoria
    b count_loop             // Continuar con el siguiente carácter

end_count:
    // Terminar programa (sólo para simuladores)
    mov w0, #0               // Exit code
    mov x8, #93              // syscall exit
    svc #0
