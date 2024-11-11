// Luis Enrique Torres Murillo - 22210361
// Programa realiza la potencia (x^n)
// Codigo de alto nivel C#
/*
using System;

namespace CalculadoraPotencia
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Write("Ingrese la base (x): ");
            double baseNum = Convert.ToDouble(Console.ReadLine());

            Console.Write("Ingrese el exponente (n): ");
            int exponente = Convert.ToInt32(Console.ReadLine());

            // Usando el método Math.Pow()
            double resultadoPow = Math.Pow(baseNum, exponente);
            Console.WriteLine($"Usando Math.Pow(): {baseNum}^{exponente} = {resultadoPow}");

            // Usando un bucle for
            double resultadoFor = 1;
            for (int i = 0; i < exponente; i++)
            {
                resultadoFor *= baseNum;
            }
            Console.WriteLine($"Usando un bucle for: {baseNum}^{exponente} = {resultadoFor}");

            // Usando recursividad
            double resultadoRecursivo = PotenciaRecursiva(baseNum, exponente);
            Console.WriteLine($"Usando recursividad: {baseNum}^{exponente} = {resultadoRecursivo}");
        }

        static double PotenciaRecursiva(double baseNum, int exponente)
        {
            if (exponente == 0)
            {
                return 1;
            }
            else
            {
                return baseNum * PotenciaRecursiva(baseNum, exponente - 1);
            }
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    base: .word 2        // Base (x)
    exponente: .word 3   // Exponente (n)
    buffer: .ascii "    \n"   // Buffer para el resultado (4 dígitos + salto de línea)

.section .text
_start:
    // Cargar valores iniciales
    adr x19, base
    ldr w20, [x19]           // w20 = base (x)
    adr x19, exponente
    ldr w21, [x19]           // w21 = exponente (n)
    
    // Inicializar resultado
    mov w22, #1              // w22 será nuestro resultado, comenzamos con 1
    
    // Si el exponente es 0, ya tenemos el resultado (1)
    cbz w21, conversion
    
bucle_potencia:
    // Multiplicar resultado actual por la base
    mul w22, w22, w20        // resultado = resultado * base
    // Decrementar el exponente
    sub w21, w21, #1         // exponente--
    // Si el exponente no es 0, continuar multiplicando
    cbnz w21, bucle_potencia

conversion:
    // Convertir el resultado a ASCII
    mov w25, w22             // Copiar resultado a w25
    adr x26, buffer
    
    // Convertir cada dígito a ASCII
    // Unidades
    mov w27, #10
    udiv w28, w25, w27       
    msub w29, w28, w27, w25  
    add w29, w29, #48        
    strb w29, [x26, #3]
    
    // Decenas
    mov w25, w28             
    udiv w28, w25, w27       
    msub w29, w28, w27, w25  
    add w29, w29, #48        
    strb w29, [x26, #2]
    
    // Centenas
    mov w25, w28             
    udiv w28, w25, w27       
    msub w29, w28, w27, w25  
    add w29, w29, #48        
    strb w29, [x26, #1]
    
    // Miles
    mov w29, w28             
    add w29, w29, #48        
    strb w29, [x26]
    
    // Imprimir resultado
    mov x0, #1               // stdout
    adr x1, buffer           // dirección del buffer
    mov x2, #5               // longitud (4 dígitos + salto de línea)
    mov x8, #64              // syscall write
    svc 0
    
    // Salir del programa
    mov x0, #0               // código de salida
    mov x8, #93              // syscall exit
    svc 0
