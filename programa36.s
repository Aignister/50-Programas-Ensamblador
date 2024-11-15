// Luis Enrique Torres Murillo - 22210361
// Programa que convierte de binario a decimal
// Codigo de alto nivel C#
/*
using System;

class Program
{
    static void Main()
    {
        Console.Write("Ingrese el número binario: ");
        string binaryString = Console.ReadLine();

        int decimalNumber = 0;
        int power = 0;

        // Iteramos sobre cada dígito del número binario de derecha a izquierda
        for (int i = binaryString.Length - 1; i >= 0; i--)
        {
            // Convertimos el dígito a un entero
            int digit = int.Parse(binaryString[i].ToString());

            // Multiplicamos el dígito por la potencia correspondiente de 2 y lo sumamos al número decimal
            decimalNumber += digit * (int)Math.Pow(2, power);

            power++;
        }

        Console.WriteLine("El número decimal equivalente es: " + decimalNumber);
    }
}
*/
// Programa Ensamblador
.global _start

.data
    msg_input:  .ascii "Ingrese número binario: "
    len_input = . - msg_input
    msg_result: .ascii "Resultado decimal: "
    len_result = . - msg_result
    buffer:     .skip 32
    newline:    .ascii "\n"

.text
_start:
    // Imprimir mensaje de entrada
    mov x0, #1              // fd = 1 (stdout)
    ldr x1, =msg_input     // puntero al mensaje
    mov x2, #len_input     // longitud del mensaje
    mov x8, #64            // syscall write
    svc #0

    // Leer entrada del usuario
    mov x0, #0              // fd = 0 (stdin)
    ldr x1, =buffer        // buffer para almacenar entrada
    mov x2, #32            // tamaño máximo
    mov x8, #63            // syscall read
    svc #0
    
    // Inicializar registros
    mov x3, #0              // x3 = resultado decimal
    mov x4, #1              // x4 = potencia de 2
    sub x0, x0, #1          // ajustar longitud (quitar newline)
    mov x5, x0              // x5 = contador

convert_loop:
    cbz x5, print_result    // si contador = 0, imprimir resultado
    ldrb w6, [x1, x5]       // cargar byte
    sub x5, x5, #1          // decrementar contador
    
    cmp w6, #'1'            // comparar con '1'
    bne convert_loop        // si no es 1, siguiente iteración
    
    add x3, x3, x4          // sumar potencia actual
    lsl x4, x4, #1          // multiplicar potencia por 2
    b convert_loop

print_result:
    // Convertir resultado a ASCII
    mov x0, #0              // contador de dígitos
    mov x4, x3              // copiar resultado
    ldr x1, =buffer

convert_dec:
    mov x2, #10
    udiv x5, x4, x2         // dividir por 10
    msub x6, x5, x2, x4     // obtener residuo
    add x6, x6, #'0'        // convertir a ASCII
    strb w6, [x1, x0]       // guardar dígito
    add x0, x0, #1          // incrementar contador
    mov x4, x5              // actualizar número
    cbnz x4, convert_dec    // si no es 0, continuar

    // Invertir resultado
    mov x2, #0              // inicio
    sub x3, x0, #1          // fin
reverse_loop:
    cmp x2, x3
    bge print_final
    ldrb w4, [x1, x2]
    ldrb w5, [x1, x3]
    strb w5, [x1, x2]
    strb w4, [x1, x3]
    add x2, x2, #1
    sub x3, x3, #1
    b reverse_loop

print_final:
    // Imprimir mensaje de resultado
    mov x8, #64            // syscall write
    mov x0, #1             // fd = 1 (stdout)
    ldr x1, =msg_result    // mensaje
    mov x2, #len_result    // longitud
    svc #0
    
    // Imprimir número decimal
    mov x8, #64            // syscall write
    mov x0, #1             // fd = 1 (stdout)
    ldr x1, =buffer        // número convertido
    mov x2, x0             // longitud
    svc #0
    
    // Imprimir nueva línea
    mov x8, #64
    mov x0, #1
    ldr x1, =newline
    mov x2, #1
    svc #0

    // Salir del programa
    mov x8, #93            // syscall exit
    mov x0, #0             // código de retorno
    svc #0
