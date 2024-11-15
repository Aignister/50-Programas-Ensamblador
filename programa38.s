// Luis Enrique Torres Murillo - 22210361
// Programa que convierte de hexadecimal a decimal
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static int HexadecimalToDecimal(string hexadecimal)
    {
        int decimalNumber = 0;
        int power = hexadecimal.Length - 1;

        foreach (char hexDigit in hexadecimal)
        {
            int digitValue = GetDecimalValue(hexDigit);
            decimalNumber += digitValue * (int)Math.Pow(16, power);
            power--;
        }

        return decimalNumber;
    }

    static int GetDecimalValue(char hexDigit)
    {
        if (char.IsDigit(hexDigit))
        {
            return hexDigit - '0';
        }
        else
        {
            return char.ToUpper(hexDigit) - 'A' + 10;
        }
    }

    static void Main()
    {
        Console.Write("Ingrese un número hexadecimal: ");
        string hexadecimalNumber = Console.ReadLine();

        int decimalNumber = HexadecimalToDecimal(hexadecimalNumber);

        Console.WriteLine("El número decimal equivalente es: " + decimalNumber);
    }
}
*/
// Programa Ensamblador
.section .data
hex_string: .asciz "1A3F"   // Cambia este valor para probar diferentes números hexadecimales.
output_format: .asciz "El valor decimal es: %d\n"

.section .bss
result: .skip 8   // Espacio para almacenar el valor decimal

.section .text
.global _start

_start:
    // Puntero a la cadena hexadecimal
    ldr x0, =hex_string
    // Llama a la función para convertir
    bl hex_to_decimal
    
    // Imprimir el resultado
    ldr x0, =output_format
    ldr x1, =result
    str x1, [x1]     // Guarda el valor decimal en 'result'
    mov x2, x1        // El valor a imprimir
    mov x8, 64         // syscall: write
    mov x0, 1          // file descriptor: stdout
    svc #0

    // Terminar el programa
    mov x8, 93         // syscall: exit
    mov x0, 0          // status 0
    svc #0

// Función para convertir un número hexadecimal a decimal
// Entrada: x0 = puntero a la cadena hexadecimal
// Salida: x0 = valor decimal
hex_to_decimal:
    mov x1, 0          // Inicializa el valor decimal en 0
    mov x2, 0          // Variable para almacenar el dígito hexadecimal

convert_loop:
    ldrb w3, [x0], #1  // Lee el siguiente carácter de la cadena
    cmp w3, #0         // ¿Es el fin de la cadena?
    beq end_conversion // Si es el fin, termina el bucle

    // Convertir el carácter hexadecimal en su valor numérico
    cmp w3, #'0'       // Si es '0' <= carácter <= '9'
    bge convert_digit
    cmp w3, #'A'       // Si es 'A' <= carácter <= 'F'
    bge convert_letter
    cmp w3, #'a'       // Si es 'a' <= carácter <= 'f'
    blt end_conversion // Si no es ninguno, termina

convert_digit:
    sub w2, w3, #'0'   // Resta '0' para obtener el valor numérico
    b next_digit

convert_letter:
    cmp w3, #'a'
    bge lower_case
    sub w2, w3, #'A'   // Si es mayúscula, resta 'A' y suma 10
    add w2, w2, #10
    b next_digit

lower_case:
    sub w2, w3, #'a'   // Si es minúscula, resta 'a' y suma 10
    add w2, w2, #10

next_digit:
    // Multiplicar el valor actual por 16 (base hexadecimal)
    // y agregar el nuevo dígito
    lsl x1, x1, #4     // x1 = x1 * 16
    add x1, x1, x2     // x1 += dígito hexadecimal actual
    b convert_loop     // Repetir para el siguiente carácter

end_conversion:
    mov x0, x1         // Almacena el resultado decimal en x0
    ret
