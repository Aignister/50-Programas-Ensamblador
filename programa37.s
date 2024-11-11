// Luis Enrique Torres Murillo - 22210361
// Programa que convierte de decimal a hexadecimal
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static string DecimalToHexadecimal(int decimalNumber)
    {
        if (decimalNumber == 0)
            return "";
        
        int remainder = decimalNumber % 16;
        int quotient = decimalNumber / 16;

        char hexDigit = GetHexDigit(remainder);
        
        return DecimalToHexadecimal(quotient) + hexDigit;
    }

    static char GetHexDigit(int value)
    {
        if (value >= 0 && value <= 9)
            return (char)(value + '0');
        else
            return (char)('A' + (value - 10));
    }

    static void Main()
    {
        Console.Write("Ingrese un número decimal: ");
        int decimalNumber = int.Parse(Console.ReadLine());

        string hexadecimalNumber = DecimalToHexadecimal(decimalNumber);

        Console.WriteLine("El número hexadecimal equivalente es: " + hexadecimalNumber);
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    decimal: .word 123        // Valor decimal a convertir
    buffer: .ascii "0x     \n"   // Buffer para el resultado en hexadecimal
.section .text
_start:
    // Cargar el valor decimal
    adr x19, decimal
    ldr w20, [x19]           
    
    // Convertir a hexadecimal
    adr x21, buffer
    mov x22, #4               // Índice del buffer (desde el final)
    
loop:
    // Obtener el dígito hexadecimal menos significativo
    and w23, w20, #0xF        // Máscara para obtener el dígito menos significativo
    
    // Convertir a ASCII
    cmp w23, #9
    bgt letra                // Si es mayor a 9, es una letra
    add w23, w23, #0x30       // Convertir a ASCII (0-9)
    b continuar
letra:
    add w23, w23, #0x37       // Convertir a ASCII (A-F)
continuar:
    // Almacenar el dígito en el buffer
    strb w23, [x21, x22]
    
    // Desplazar el valor decimal a la derecha 4 bits
    lsr w20, w20, #4
    
    // Decrementar el índice del buffer
    sub x22, x22, #1
    
    // Continuar hasta que todos los dígitos se hayan procesado
    cmp x22, #0
    bge loop
    
    // Agregar el prefijo "0x"
    mov w23, #0x30
    strb w23, [x21]
    mov w23, #0x78
    strb w23, [x21, #1]
    
    // Imprimir el valor hexadecimal
    mov x0, #1               
    adr x1, buffer           
    mov x2, #7               
    mov x8, #64              
    svc 0
    
    // Salir
    mov x0, #0               
    mov x8, #93              
    svc 0
