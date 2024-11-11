// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una pila usando un arreglo
// Codigo de alto nivel C#
/*
using System;

class Pila
{
    private int[] elementos;
    private int tope;

    public Pila(int capacidad)
    {
        elementos = new int[capacidad];
        tope = -1; // Inicializamos el tope en -1 para indicar que la pila está vacía
    }

    public void Apilar(int valor)
    {
        if (tope == elementos.Length - 1)
        {
            Console.WriteLine("La pila está llena");
        }
        else
        {
            tope++;
            elementos[tope] = valor;
        }
    }

    public int Desapilar()
    {
        if (tope == -1)
        {
            throw new Exception("La pila está vacía");
        }
        else
        {
            int valor = elementos[tope];
            tope--;
            return valor;
        }
    }

    public void MostrarPila()
    {
        if (tope == -1)
        {
            Console.WriteLine("La pila está vacía");
        }
        else
        {
            Console.WriteLine("Los elementos de la pila son:");
            for (int i = tope; i >= 0; i--)
            {
                Console.WriteLine(elementos[i]);
            }
        }
    }
}

class Program
{
    static void Main(string[] args)
    {
        Pila miPila = new Pila(5); // Creamos una pila con capacidad para 5 elementos

        miPila.Apilar(10);
        miPila.Apilar(20);
        miPila.Apilar(30);

        miPila.MostrarPila();

        int valor = miPila.Desapilar();
        Console.WriteLine("El valor desapilado es: " + valor);

        miPila.MostrarPila();
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    // Definición del arreglo para la pila (capacidad: 10 elementos)
    stack_array: .skip 40        // 10 elementos * 4 bytes cada uno
    stack_top:   .word 0         // Índice del tope de la pila
    stack_size:  .word 10        // Tamaño máximo de la pila
    
    // Mensajes para output
    msg_push:    .ascii "Elemento insertado: "
    len_push:    .word . - msg_push
    msg_pop:     .ascii "Elemento extraído: "
    len_pop:     .word . - msg_pop
    msg_error:   .ascii "Error: Pila llena/vacía\n"
    len_error:   .word . - msg_error
    newline:     .ascii "\n"
    
    // Buffer para convertir números a ASCII
    number_buffer: .skip 12
    
.section .text
_start:
    // Ejemplo de uso de la pila
    // Push algunos números
    mov x0, #5
    bl push
    mov x0, #10
    bl push
    mov x0, #15
    bl push
    
    // Pop algunos números
    bl pop
    bl pop
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

// Función para convertir número a ASCII e imprimir
print_number:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    mov x19, x0  // Guardar número a convertir
    
    // Preparar buffer
    adr x20, number_buffer
    mov x21, #0  // Contador de dígitos
    mov x22, #10 // Divisor
    
convert_loop:
    udiv x23, x19, x22     // Dividir por 10
    msub x24, x23, x22, x19 // Obtener residuo
    add x24, x24, #48      // Convertir a ASCII
    strb w24, [x20, x21]   // Guardar en buffer
    add x21, x21, #1       // Incrementar contador
    mov x19, x23           // Actualizar número
    cbnz x19, convert_loop // Si aún hay dígitos, continuar
    
    // Revertir los dígitos
    mov x23, #0            // Índice inicio
    sub x24, x21, #1       // Índice final
reverse_loop:
    cmp x23, x24
    b.ge print_num
    ldrb w25, [x20, x23]
    ldrb w26, [x20, x24]
    strb w26, [x20, x23]
    strb w25, [x20, x24]
    add x23, x23, #1
    sub x24, x24, #1
    b reverse_loop
    
print_num:
    // Imprimir número
    mov x0, #1
    mov x1, x20
    mov x2, x21
    mov x8, #64
    svc #0
    
    // Imprimir nueva línea
    mov x0, #1
    adr x1, newline
    mov x2, #1
    mov x8, #64
    svc #0
    
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// Función push: añade un elemento a la pila
push:
    // Guardar registros y valor a insertar
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0  // Guardar valor a insertar
    
    // Imprimir mensaje push
    mov x0, #1
    adr x1, msg_push
    adr x2, len_push
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    // Imprimir valor
    mov x0, x19
    bl print_number
    
    // Cargar dirección base de la pila y el tope actual
    adr x20, stack_top
    ldr w21, [x20]
    
    // Verificar si la pila está llena
    adr x22, stack_size
    ldr w22, [x22]
    cmp w21, w22
    b.ge push_error
    
    // Calcular dirección donde insertar
    adr x22, stack_array
    lsl w23, w21, #2
    add x22, x22, x23
    
    // Guardar elemento
    str w19, [x22]
    
    // Incrementar tope
    add w21, w21, #1
    str w21, [x20]
    
    b push_end

push_error:
    // Imprimir mensaje de error
    mov x0, #1
    adr x1, msg_error
    adr x2, len_error
    ldr x2, [x2]
    mov x8, #64
    svc #0

push_end:
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// Función pop: extrae un elemento de la pila
pop:
    // Guardar registros
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    // Cargar dirección base de la pila y el tope actual
    adr x19, stack_top
    ldr w20, [x19]
    
    // Verificar si la pila está vacía
    cmp w20, #0
    b.le pop_error
    
    // Decrementar tope
    sub w20, w20, #1
    str w20, [x19]
    
    // Calcular dirección del elemento a extraer
    adr x21, stack_array
    lsl w22, w20, #2
    add x21, x21, x22
    
    // Cargar elemento
    ldr x23, [x21]
    
    // Imprimir mensaje pop
    mov x0, #1
    adr x1, msg_pop
    adr x2, len_pop
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    // Imprimir valor extraído
    mov x0, x23
    bl print_number
    
    mov x0, x23  // Retornar valor en x0
    b pop_end

pop_error:
    // Imprimir mensaje de error
    mov x0, #1
    adr x1, msg_error
    adr x2, len_error
    ldr x2, [x2]
    mov x8, #64
    svc #0
    mov x0, #-1  // Retornar -1 en caso de error

pop_end:
    // Restaurar registros
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
