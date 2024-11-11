// Luis Enrique Torres Murillo - 22210361
// Programa que realiza una cola usando un arreglo
// Codigo de alto nivel C#
/*
using System;

class Cola
{
    private int[] elementos;
    private int frente;
    private int final;
    private int capacidad;

    public Cola(int tamano)
    {
        elementos = new int[tamano];
        frente = -1;
        final = -1;
        capacidad = tamano;
    }

    public void Encolar(int valor)
    {
        if (estaLlena())
        {
            Console.WriteLine("La cola está llena");
        }
        else
        {
            if (frente == -1)
            {
                frente = 0;
            }
            final++;
            elementos[final] = valor;
        }
    }

    public int Desencolar()
    {
        if (estaVacia())
        {
            throw new Exception("La cola está vacía");
        }
        else
        {
            int valor = elementos[frente];
            if (frente == final)
            {
                frente = final = -1;
            }
            else
            {
                frente++;
            }
            return valor;
        }
    }

    public void MostrarCola()
    {
        if (estaVacia())
        {
            Console.WriteLine("La cola está vacía");
        }
        else
        {
            Console.WriteLine("Los elementos de la cola son:");
            for (int i = frente; i <= final; i++)
            {
                Console.WriteLine(elementos[i]);
            }
        }
    }

    public bool estaLlena()
    {
        return final == capacidad - 1;
    }

    public bool estaVacia()
    {
        return frente == -1;
    }
}

class Program
{
    static void Main(string[] args)
    {
        Cola miCola = new Cola(5); // Creamos una cola con capacidad para 5 elementos

        miCola.Encolar(10);
        miCola.Encolar(20);
        miCola.Encolar(30);

        miCola.MostrarCola();

        int valor = miCola.Desencolar();
        Console.WriteLine("El valor desencolado es: " + valor);

        miCola.MostrarCola();
    }
}
*/
// Programa Ensamblador
.global _start

.section .data
    // Definición del arreglo para la cola (capacidad: 10 elementos)
    queue_array: .skip 40        // 10 elementos * 4 bytes cada uno
    queue_front: .word 0         // Índice del frente de la cola
    queue_rear:  .word 0         // Índice del final de la cola
    queue_size:  .word 10        // Tamaño máximo de la cola
    queue_count: .word 0         // Número actual de elementos
    
    // Mensajes para output
    msg_enq:    .ascii "Elemento encolado: "
    len_enq:    .word . - msg_enq
    msg_deq:    .ascii "Elemento desencolado: "
    len_deq:    .word . - msg_deq
    msg_error:   .ascii "Error: Cola llena/vacía\n"
    len_error:   .word . - msg_error
    newline:     .ascii "\n"
    
    // Buffer para convertir números a ASCII
    number_buffer: .skip 12

.section .text
_start:
    // Ejemplo de uso de la cola
    // Encolar algunos números
    mov x0, #5
    bl enqueue
    mov x0, #10
    bl enqueue
    mov x0, #15
    bl enqueue
    
    // Desencolar algunos números
    bl dequeue
    bl dequeue
    
    // Salir del programa
    mov x0, #0
    mov x8, #93
    svc #0

// Función para convertir número a ASCII e imprimir
print_number:
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
    
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// Función enqueue: añade un elemento al final de la cola
enqueue:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    mov x19, x0  // Guardar valor a insertar
    
    // Imprimir mensaje enqueue
    mov x0, #1
    adr x1, msg_enq
    adr x2, len_enq
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    // Imprimir valor
    mov x0, x19
    bl print_number
    
    // Verificar si la cola está llena
    adr x20, queue_count
    ldr w21, [x20]
    adr x22, queue_size
    ldr w22, [x22]
    cmp w21, w22
    b.ge enq_error
    
    // Obtener índice rear
    adr x22, queue_rear
    ldr w23, [x22]
    
    // Insertar elemento
    adr x24, queue_array
    lsl w25, w23, #2
    add x24, x24, x25
    str w19, [x24]
    
    // Actualizar rear
    add w23, w23, #1
    adr x24, queue_size
    ldr w24, [x24]
    udiv w25, w23, w24
    msub w23, w25, w24, w23  // rear = (rear + 1) % size
    str w23, [x22]
    
    // Incrementar count
    add w21, w21, #1
    str w21, [x20]
    
    b enq_end

enq_error:
    mov x0, #1
    adr x1, msg_error
    adr x2, len_error
    ldr x2, [x2]
    mov x8, #64
    svc #0

enq_end:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret

// Función dequeue: remueve y retorna el elemento del frente de la cola
dequeue:
    stp x29, x30, [sp, #-16]!
    stp x19, x20, [sp, #-16]!
    
    // Verificar si la cola está vacía
    adr x19, queue_count
    ldr w20, [x19]
    cmp w20, #0
    b.eq deq_error
    
    // Obtener índice front
    adr x21, queue_front
    ldr w22, [x21]
    
    // Obtener elemento
    adr x23, queue_array
    lsl w24, w22, #2
    add x23, x23, x24
    ldr x25, [x23]
    
    // Imprimir mensaje dequeue
    mov x0, #1
    adr x1, msg_deq
    adr x2, len_deq
    ldr x2, [x2]
    mov x8, #64
    svc #0
    
    // Imprimir valor
    mov x0, x25
    bl print_number
    
    // Actualizar front
    add w22, w22, #1
    adr x23, queue_size
    ldr w23, [x23]
    udiv w24, w22, w23
    msub w22, w24, w23, w22  // front = (front + 1) % size
    str w22, [x21]
    
    // Decrementar count
    sub w20, w20, #1
    str w20, [x19]
    
    mov x0, x25  // Retornar valor
    b deq_end

deq_error:
    mov x0, #1
    adr x1, msg_error
    adr x2, len_error
    ldr x2, [x2]
    mov x8, #64
    svc #0
    mov x0, #-1

deq_end:
    ldp x19, x20, [sp], #16
    ldp x29, x30, [sp], #16
    ret
