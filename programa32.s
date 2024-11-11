// Luis Enrique Torres Murillo - 22210361
// Programa invierte los elementos de un arreglo
// Codigo de alto nivel C#
/*
using System;

namespace InvertirArreglo
{
    class Program
    {
        static void Main(string[] args)
        {
            // Crear un arreglo de ejemplo
            int[] numeros = { 1, 2, 3, 4, 5 };

            // Mostrar el arreglo original
            Console.WriteLine("Arreglo original:");
            ImprimirArreglo(numeros);

            // Invertir el arreglo usando un bucle for
            InvertirConBucleFor(numeros);
            Console.WriteLine("Arreglo invertido con bucle for:");
            ImprimirArreglo(numeros);

            // Restablecer el arreglo a su estado original
            Array.Copy(numeros, new[] { 1, 2, 3, 4, 5 }, numeros.Length);

            // Invertir el arreglo usando el método Reverse
            Array.Reverse(numeros);
            Console.WriteLine("Arreglo invertido con Array.Reverse:");
            ImprimirArreglo(numeros);

            // Restablecer el arreglo a su estado original
            Array.Copy(numeros, new[] { 1, 2, 3, 4, 5 }, numeros.Length);

            // Invertir el arreglo usando LINQ
            var numerosInvertidos = numeros.Reverse();
            Console.WriteLine("Arreglo invertido con LINQ:");
            ImprimirArreglo(numerosInvertidos.ToArray());
        }

        static void InvertirConBucleFor(int[] arreglo)
        {
            int inicio = 0;
            int fin = arreglo.Length - 1;
            while (inicio < fin)
            {
                // Intercambiar elementos
                int temp = arreglo[inicio];
                arreglo[inicio] = arreglo[fin];
                arreglo[fin] = temp;
                inicio++;
                fin--;
            }
        }

        static void ImprimirArreglo(int[] arreglo)
        {
            foreach (int numero in arreglo)
            {
                Console.Write(numero + " ");
            }
            Console.WriteLine();
        }
    }
}
*/
// Programa Ensamblador
.global _start
.section .data
    // Arreglo original
    array: .word 1, 2, 3, 4, 5    // Arreglo de ejemplo
    len = (. - array) / 4         // Longitud del arreglo
    
    // Buffer para imprimir números
    buffer: .ascii "   \n"        // 3 dígitos + salto de línea
    newline: .ascii "\n"
    
.section .text
_start:
    // Inicializar registros para los índices
    adr x19, array               // Dirección base del arreglo
    mov x20, #0                  // Índice inicial
    mov x21, #len               // Longitud del arreglo
    sub x21, x21, #1            // Índice final (len - 1)
    
bucle_inversion:
    // Verificar si hemos terminado (índice_inicial >= índice_final)
    cmp x20, x21
    bge imprimir_array
    
    // Cargar elementos a intercambiar
    lsl x22, x20, #2            // x22 = índice_inicial * 4
    lsl x23, x21, #2            // x23 = índice_final * 4
    
    // Cargar valores
    ldr w24, [x19, x22]         // w24 = array[índice_inicial]
    ldr w25, [x19, x23]         // w25 = array[índice_final]
    
    // Intercambiar valores
    str w25, [x19, x22]         // array[índice_inicial] = w25
    str w24, [x19, x23]         // array[índice_final] = w24
    
    // Actualizar índices
    add x20, x20, #1            // índice_inicial++
    sub x21, x21, #1            // índice_final--
    
    b bucle_inversion

imprimir_array:
    // Inicializar para imprimir
    mov x20, #0                 // Índice para impresión
    
bucle_impresion:
    // Verificar si hemos terminado de imprimir
    cmp x20, #len
    beq salir
    
    // Cargar elemento actual
    lsl x22, x20, #2            // x22 = índice * 4
    ldr w25, [x19, x22]         // w25 = array[índice]
    
    // Convertir a ASCII y guardar en buffer
    adr x26, buffer
    
    // Proceso de conversión a ASCII (3 dígitos)
    mov w27, #10                // Divisor
    
    // Unidades
    udiv w28, w25, w27
    msub w29, w28, w27, w25
    add w29, w29, #48
    strb w29, [x26, #2]
    
    // Decenas
    mov w25, w28
    udiv w28, w25, w27
    msub w29, w28, w27, w25
    add w29, w29, #48
    strb w29, [x26, #1]
    
    // Centenas
    mov w29, w28
    add w29, w29, #48
    strb w29, [x26]
    
    // Imprimir número
    mov x0, #1                  // stdout
    mov x1, x26                 // buffer
    mov x2, #4                  // longitud (3 dígitos + newline)
    mov x8, #64                 // syscall write
    svc 0
    
    // Siguiente elemento
    add x20, x20, #1
    b bucle_impresion

salir:
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc 0
