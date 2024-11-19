// Luis Enrique Torres Murillo - 22210361
// Programa que realiza un ordenamiento por mezcla
// Codigo de alto nivel C#
/*
public static void MergeSort(int[] array)
{
    if (array.Length <= 1)
        return; // Un array de un elemento ya está ordenado

    int mid = array.Length / 2;
    int[] left = new int[mid];
    int[] right = new int[array.Length - mid];

    // Copiar elementos a los arreglos izquierdo y derecho
    Array.Copy(array, 0, left, 0, mid);
    Array.Copy(array, mid, right, 0, array.Length - mid);

    // Llamar recursivamente a MergeSort para ordenar las mitades
    MergeSort(left);
    MergeSort(right);

    // Fusionar las mitades ordenadas
    Merge(array, left, right);
}

private static void Merge(int[] array, int[] left, int[] right)
{
    int i = 0, j = 0, k = 0;

    while (i < left.Length && j < right.Length)
    {
        if (left[i] <= right[j])
        {
            array[k] = left[i];
            i++;
        }
        else
        {
            array[k] = right[j];
            j++;
        }
        k++;
    }

    // Copiar los elementos restantes (si los hay)
    while (i < left.Length)
    {
        array[k] = left[i];
        i++;
        k++;
    }

    while (j < right.Length)
    {
        array[k] = right[j];
        j++;
        k++;
    }
}
*/
// Programa Ensamblador
// Merge Sort implementación en ARM64
.global _start

// Sección de datos
.data
array:  .quad   64, 34, 25, 12, 22, 11, 90, 1    // Array de ejemplo
n:      .quad   8                                 // Tamaño del array
temp:   .skip   64                               // Array temporal para mezcla

// Sección de texto (código)
.text
_start:
    // Preparar registros para llamada inicial
    adr     x0, array          // Dirección base del array
    mov     x1, #0            // left = 0
    ldr     x2, =n           
    ldr     x2, [x2]         // Cargar n
    sub     x2, x2, #1       // right = n-1
    bl      mergeSort        // Llamar a mergeSort(array, 0, n-1)
    
    // Salir del programa
    mov     x8, #93         // syscall exit
    mov     x0, #0          // código de retorno
    svc     #0

// mergeSort(arr[], left, right)
mergeSort:
    stp     x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    mov     x29, sp                   // Establecer frame pointer
    
    // Verificar si left < right
    cmp     x1, x2                    // Comparar left con right
    bge     mergeSortEnd             // Si left >= right, terminar
    
    // Calcular mid = (left + right)/2
    add     x3, x1, x2               // x3 = left + right
    lsr     x3, x3, #1              // x3 = (left + right)/2
    
    // Guardar parámetros
    stp     x0, x1, [sp, #-16]!     // Guardar array y left
    stp     x2, x3, [sp, #-16]!     // Guardar right y mid
    
    // mergeSort primera mitad
    mov     x2, x3                   // right = mid
    bl      mergeSort               // mergeSort(arr, left, mid)
    
    // Restaurar parámetros y preparar segunda llamada
    ldp     x2, x3, [sp], #16
    ldp     x0, x1, [sp], #16
    
    // mergeSort segunda mitad
    add     x1, x3, #1              // left = mid + 1
    bl      mergeSort               // mergeSort(arr, mid+1, right)
    
    // merge las mitades ordenadas
    bl      merge                   // merge(arr, left, mid, right)
    
mergeSortEnd:
    ldp     x29, x30, [sp], #16    // Restaurar frame pointer y link register
    ret

// merge(arr[], left, mid, right)
merge:
    stp     x29, x30, [sp, #-16]!   // Guardar frame pointer y link register
    mov     x29, sp
    
    // Inicializar índices
    mov     x4, x1                  // i = left
    add     x5, x3, #1             // j = mid + 1
    mov     x6, x1                  // k = left
    
mergeLoop:
    cmp     x4, x3                  // Si i > mid
    bgt     copyRightArray
    cmp     x5, x2                  // Si j > right
    bgt     copyLeftArray
    
    // Comparar elementos
    ldr     x7, [x0, x4, lsl #3]   // arr[i]
    ldr     x8, [x0, x5, lsl #3]   // arr[j]
    cmp     x7, x8
    bgt     copyFromRight
    
copyFromLeft:
    str     x7, [x0, x6, lsl #3]   // temp[k] = arr[i]
    add     x4, x4, #1             // i++
    b       continueLoop
    
copyFromRight:
    str     x8, [x0, x6, lsl #3]   // temp[k] = arr[j]
    add     x5, x5, #1             // j++
    
continueLoop:
    add     x6, x6, #1             // k++
    b       mergeLoop
    
copyLeftArray:
    cmp     x4, x3                  // Si i > mid, terminar
    bgt     mergeEnd
    ldr     x7, [x0, x4, lsl #3]   // Copiar elemento restante
    str     x7, [x0, x6, lsl #3]
    add     x4, x4, #1
    add     x6, x6, #1
    b       copyLeftArray
    
copyRightArray:
    cmp     x5, x2                  // Si j > right, terminar
    bgt     mergeEnd
    ldr     x8, [x0, x5, lsl #3]   // Copiar elemento restante
    str     x8, [x0, x6, lsl #3]
    add     x5, x5, #1
    add     x6, x6, #1
    b       copyRightArray
    
mergeEnd:
    ldp     x29, x30, [sp], #16    // Restaurar frame pointer y link register
    ret
