// Luis Enrique Torres Murillo - 22210361
// Programa que realiza la rotacion de un arreglo, izquierda o derecha
// Codigo de alto nivel C#
/*
using System;

namespace RotacionArreglo
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] numeros = { 1, 2, 3, 4, 5 };
            int rotaciones = 2; // Número de rotaciones hacia la derecha

            Console.WriteLine("Arreglo original:");
            ImprimirArreglo(numeros);

            // Rotar hacia la derecha utilizando un arreglo auxiliar
            int[] numerosRotadosDerecha = RotarDerechaConArregloAuxiliar(numeros, rotaciones);
            Console.WriteLine("Arreglo rotado hacia la derecha con arreglo auxiliar:");
            ImprimirArreglo(numerosRotadosDerecha);

            // Rotar hacia la derecha in-place
            RotarDerechaInPlace(numeros, rotaciones);
            Console.WriteLine("Arreglo rotado hacia la derecha in-place:");
            ImprimirArreglo(numeros);

            // Rotar hacia la izquierda utilizando un arreglo auxiliar
            int[] numerosRotadosIzquierda = RotarIzquierdaConArregloAuxiliar(numeros, rotaciones);
            Console.WriteLine("Arreglo rotado hacia la izquierda con arreglo auxiliar:");
            ImprimirArreglo(numerosRotadosIzquierda);

            // Rotar hacia la izquierda in-place
            RotarIzquierdaInPlace(numeros, rotaciones);
            Console.WriteLine("Arreglo rotado hacia la izquierda in-place:");
            ImprimirArreglo(numeros);
        }

        // Rotar hacia la derecha utilizando un arreglo auxiliar
        static int[] RotarDerechaConArregloAuxiliar(int[] arreglo, int rotaciones)
        {
            int n = arreglo.Length;
            int[] resultado = new int[n];
            for (int i = 0; i < n; i++)
            {
                resultado[(i + rotaciones) % n] = arreglo[i];
            }
            return resultado;
        }

        // Rotar hacia la derecha in-place
        static void RotarDerechaInPlace(int[] arreglo, int rotaciones)
        {
            int n = arreglo.Length;
            rotaciones %= n; // Para manejar rotaciones mayores que el tamaño del arreglo
            Reverse(arreglo, 0, n - 1);
            Reverse(arreglo, 0, rotaciones - 1);
            Reverse(arreglo, rotaciones, n - 1);
        }

        // Rotar hacia la izquierda utilizando un arreglo auxiliar
        static int[] RotarIzquierdaConArregloAuxiliar(int[] arreglo, int rotaciones)
        {
            int n = arreglo.Length;
            int[] resultado = new int[n];
            for (int i = 0; i < n; i++)
            {
                resultado[i] = arreglo[(i + n - rotaciones) % n];
            }
            return resultado;
        }

        // Rotar hacia la izquierda in-place
        static void RotarIzquierdaInPlace(int[] arreglo, int rotaciones)
        {
            int n = arreglo.Length;
            rotaciones %= n;
            Reverse(arreglo, 0, n - 1);
            Reverse(arreglo, 0, n - rotaciones - 1);
            Reverse(arreglo, n - rotaciones, n - 1);
        }

        // Función auxiliar para invertir un segmento del arreglo
        static void Reverse(int[] arreglo, int inicio, int fin)
        {
            while (inicio < fin)
            {
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
    array: .word 1, 2, 3, 4, 5     // Arreglo de ejemplo
    len = (. - array) / 4          // Longitud del arreglo
    rotaciones: .word 2            // Número de posiciones a rotar
    direccion: .word 1             // 1 = izquierda, 2 = derecha
    
    // Buffer para imprimir números
    buffer: .ascii "   \n"         // 3 dígitos + salto de línea
    
.section .text
_start:
    // Cargar parámetros
    adr x19, array                // Dirección base del arreglo
    adr x20, rotaciones
    ldr w20, [x20]               // Número de rotaciones
    adr x21, direccion
    ldr w21, [x21]               // Dirección de rotación
    
    // Ajustar rotaciones si son mayores que len
    mov w22, #len
    sdiv w23, w20, w22           // División
    msub w20, w23, w22, w20      // Módulo (rotaciones efectivas)
    
    // Verificar dirección
    cmp w21, #2
    beq rotar_derecha
    
rotar_izquierda:
    // Si rotaciones = 0, saltar a imprimir
    cbz w20, imprimir_array
    
    // Guardar primer elemento
    ldr w24, [x19]               // Temporal = array[0]
    
    // Mover elementos una posición a la izquierda
    mov x25, #0                  // Índice
bucle_izq:
    add x26, x25, #1            // Siguiente posición
    cmp x26, #len
    beq fin_bucle_izq
    
    lsl x27, x26, #2            // Offset siguiente = índice * 4
    ldr w28, [x19, x27]         // Cargar siguiente elemento
    sub x27, x27, #4            // Offset actual
    str w28, [x19, x27]         // Guardar en posición actual
    
    add x25, x25, #1            // Incrementar índice
    b bucle_izq
    
fin_bucle_izq:
    // Colocar el elemento temporal al final
    mov x27, #len
    sub x27, x27, #1
    lsl x27, x27, #2
    str w24, [x19, x27]
    
    // Decrementar contador de rotaciones
    sub w20, w20, #1
    b rotar_izquierda
    
rotar_derecha:
    // Si rotaciones = 0, saltar a imprimir
    cbz w20, imprimir_array
    
    // Guardar último elemento
    mov x25, #len
    sub x25, x25, #1
    lsl x25, x25, #2
    ldr w24, [x19, x25]         // Temporal = array[len-1]
    
    // Mover elementos una posición a la derecha
    mov x25, #len
    sub x25, x25, #1            // Índice = len - 1
bucle_der:
    cbz x25, fin_bucle_der
    
    sub x26, x25, #1            // Posición anterior
    lsl x27, x26, #2            // Offset anterior = índice * 4
    ldr w28, [x19, x27]         // Cargar elemento anterior
    lsl x27, x25, #2            // Offset actual
    str w28, [x19, x27]         // Guardar en posición actual
    
    sub x25, x25, #1            // Decrementar índice
    b bucle_der
    
fin_bucle_der:
    // Colocar el elemento temporal al inicio
    str w24, [x19]
    
    // Decrementar contador de rotaciones
    sub w20, w20, #1
    b rotar_derecha
    
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
