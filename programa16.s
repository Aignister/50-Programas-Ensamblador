// Luis Enrique Torres Murillo - 22210361
// Programa que verifica si una cadena es palindromo
// Codigo de alto nivel C#
/*
using System;

class VerificarPalindromo
{
    static void Main()
    {
        Console.Write("Ingrese una cadena de texto: ");
        string cadena = Console.ReadLine();
        string invertida = new string(cadena.ToCharArray().Reverse().ToArray());

        if (cadena.Equals(invertida, StringComparison.OrdinalIgnoreCase))
        {
            Console.WriteLine("La cadena es un palíndromo.");
        }
        else
        {
            Console.WriteLine("La cadena no es un palíndromo.");
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    palindrome_str: .ascii "Enrique\n"     // Cadena a verificar (sin espacios)
    palindrome_len: .word 7                // Longitud de la cadena (sin contar el '\n')
    pal_msg: .ascii "Es palindromo\n"      // Mensaje si es palíndromo
    not_pal_msg: .ascii "No es palindromo\n" // Mensaje si no es palíndromo
.section .text
_start:
    // Cargar la longitud de la cadena
    adr x1, palindrome_len
    ldr w1, [x1]                          // w1 = longitud de la cadena
    // Calcular la mitad de la longitud para comparar
    lsr w2, w1, #1                        // w2 = longitud / 2
    // Cargar las direcciones de inicio y final de la cadena
    adr x3, palindrome_str                // x3 apunta al inicio de la cadena
    // Se debe usar la extensión de `w1` a 64 bits para que la operación sea válida
    add x4, x3, x1                        // x4 = dirección final de la cadena (sin el '\n')
    sub x4, x4, #1                        // Ajustar al último carácter (sin el '\n')
check_palindrome_loop:
    // Comparar caracteres del inicio y el final
    ldrb w5, [x3], #1                     // Cargar el carácter desde el inicio y avanzar
    ldrb w6, [x4], #-1                    // Cargar el carácter desde el final y retroceder
    cmp w5, w6                            // Comparar los dos caracteres
    b.ne not_palindrome                   // Si son diferentes, no es palíndromo
    subs w2, w2, #1                       // Decrementar el contador de la mitad
    b.gt check_palindrome_loop            // Si w2 > 0, continuar comparando
palindrome:
    // Imprimir "Es palíndromo"
    mov x0, #1                            // Descriptor de archivo para stdout
    adr x1, pal_msg                       // Dirección del mensaje "Es palíndromo"
    mov x2, #14                           // Longitud del mensaje
    mov x8, #64                           // Código de sistema para write
    svc 0
    b end                                 // Salir del programa
not_palindrome:
    // Imprimir "No es palíndromo"
    mov x0, #1                            // Descriptor de archivo para stdout
    adr x1, not_pal_msg                   // Dirección del mensaje "No es palíndromo"
    mov x2, #17                           // Longitud del mensaje
    mov x8, #64                           // Código de sistema para write
    svc 0
end:
    // Salida del programa
    mov x0, #0                            // Código de salida 0
    mov x8, #93                           // Llamada al sistema para salir
    svc 0
