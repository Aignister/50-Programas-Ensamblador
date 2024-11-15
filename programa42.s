// Luis Enrique Torres Murillo - 22210361
// Programa que escribe un archivo
// Codigo de alto nivel C#
/*
using System;
using System.IO;

namespace EscribirArchivo
{
    class Program
    {
        static void Main(string[] args)
        {
            // Ruta del archivo a crear (puedes cambiarla)
            string rutaArchivo = "miArchivo.txt";

            // Texto que deseas escribir en el archivo
            string texto = "Hola, este es el contenido de mi archivo.";

            try
            {
                // Crear un objeto StreamWriter para escribir en el archivo
                using (StreamWriter escritor = new StreamWriter(rutaArchivo))
                {
                    // Escribir el texto en el archivo
                    escritor.WriteLine(texto);

                    Console.WriteLine("El archivo se ha creado/sobreescrito correctamente.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al escribir el archivo: " + ex.Message);
            }
        }
    }
}
*/
// Programa Ensamblador
// Programa ARM64 para escribir en un archivo
.global _start

.data
    filename:   .asciz  "salida.txt"           // Nombre del archivo
    message:    .asciz  "Hola desde ARM64!\n"  // Mensaje a escribir
    len = . - message                          // Longitud del mensaje

.text
_start:
    // Abrir archivo (syscall open)
    mov     x0, #-100                   // AT_FDCWD para ruta relativa
    adr     x1, filename               // Nombre del archivo
    mov     x2, #0x241                // Flags: O_WRONLY|O_CREAT|O_TRUNC
    mov     x3, #0644                 // Permisos: rw-r--r--
    mov     x8, #56                   // Número de syscall openat
    svc     #0                        // Llamada al sistema
    
    // Guardar file descriptor
    mov     x19, x0                   // Guardar fd en x19
    
    // Escribir en archivo (syscall write)
    mov     x0, x19                   // File descriptor
    adr     x1, message              // Buffer con el mensaje
    mov     x2, #len                 // Longitud del mensaje
    mov     x8, #64                  // Número de syscall write
    svc     #0
    
    // Cerrar archivo (syscall close)
    mov     x0, x19                   // File descriptor
    mov     x8, #57                   // Número de syscall close
    svc     #0
    
    // Salir del programa (syscall exit)
    mov     x0, #0                    // Código de salida 0
    mov     x8, #93                   // Número de syscall exit
    svc     #0
