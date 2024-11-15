// Calculadora simple en ARM64
.data
    menu:       .string "\nCalculadora Simple\n1. Suma\n2. Resta\n3. Multiplicacion\n4. Division\n5. Salir\nElija una opcion: "
    prompt1:    .string "\nIngrese primer numero: "
    prompt2:    .string "Ingrese segundo numero: "
    resultado:  .string "\nResultado: %d\n"
    divxcero:   .string "\nError: Division por cero\n"
    fmt:        .string "%d"
    
.text
.global main
.align 2

main:
    stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
    mov     x29, sp                  // Actualizar frame pointer

menu_loop:
    // Mostrar menú
    adrp    x0, menu                 // Cargar dirección del menú
    add     x0, x0, :lo12:menu
    bl      printf

    // Leer opción
    sub     sp, sp, 16              // Espacio para variables locales
    mov     x2, sp                  // Dirección para guardar input
    adrp    x0, fmt                 // Format string para scanf
    add     x0, x0, :lo12:fmt
    mov     x1, x2
    bl      scanf

    ldr     w19, [sp]              // Cargar opción seleccionada
    add     sp, sp, 16             // Restaurar stack

    // Salir si opción es 5
    cmp     w19, 5
    b.eq    end_program

    // Leer primer número
    adrp    x0, prompt1
    add     x0, x0, :lo12:prompt1
    bl      printf

    sub     sp, sp, 16
    mov     x2, sp
    adrp    x0, fmt
    add     x0, x0, :lo12:fmt
    mov     x1, x2
    bl      scanf
    ldr     w20, [sp]              // Primer número en w20
    add     sp, sp, 16

    // Leer segundo número
    adrp    x0, prompt2
    add     x0, x0, :lo12:prompt2
    bl      printf

    sub     sp, sp, 16
    mov     x2, sp
    adrp    x0, fmt
    add     x0, x0, :lo12:fmt
    mov     x1, x2
    bl      scanf
    ldr     w21, [sp]              // Segundo número en w21
    add     sp, sp, 16

    // Switch para operaciones
    cmp     w19, 1
    b.eq    suma
    cmp     w19, 2
    b.eq    resta
    cmp     w19, 3
    b.eq    multiplicacion
    cmp     w19, 4
    b.eq    division
    b       menu_loop

suma:
    add     w22, w20, w21
    b       mostrar_resultado

resta:
    sub     w22, w20, w21
    b       mostrar_resultado

multiplicacion:
    mul     w22, w20, w21
    b       mostrar_resultado

division:
    // Verificar división por cero
    cmp     w21, 0
    b.eq    div_zero
    sdiv    w22, w20, w21
    b       mostrar_resultado

div_zero:
    adrp    x0, divxcero
    add     x0, x0, :lo12:divxcero
    bl      printf
    b       menu_loop

mostrar_resultado:
    adrp    x0, resultado
    add     x0, x0, :lo12:resultado
    mov     w1, w22
    bl      printf
    b       menu_loop

end_program:
    mov     w0, 0                   // Código de retorno 0
    ldp     x29, x30, [sp], 16     // Restaurar frame pointer y link register
    ret
