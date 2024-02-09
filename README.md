# BBDD-StoredProcedures-Events-SQL
Diseño y Programación de una BBDD (MySQL)

ACTIVIDAD:

Crear manualmente (CREATE TABLE) una tabla denominada horario_semanal.Agregar los siguientes campos:
mes: varchar(15)
año: int
semana: varchar(15)
hora: time
sala: varchar(15)
monitor: varchar(20)
lunes: varchar(40).
martes: varchar(40).
miércoles: varchar(40).
jueves: varchar(40).
viernes: varchar(40).
sábado: varchar(40).
domingo: varchar(40).

Crear un procedimiento almacenado que realice lo siguiente:
Vaciar la tabla horario_semanal.

Crear el horario para la semana en curso.Llenar los campos con la siguiente información
mes: El mes en letra. Ejemplo: Octubre
anho: Año en 4 dígitos. Ejemplo: 2023
semana: Con el texto del xx al xx. Ejemplo: del 23 al 29
hora: La hora de la actividad.
sala: Nombre de la sala (instalación). Ejemplo: Sala de Spinning
monitor: varchar(20). Nombre resumido del monitor. Ejemplo C. Alcala
En los campos lunes a domingo colocar el nombre de la actividad que se impartirá.
Ejemplo CYCLING

Crear un evento que ejecute cada día el procedimiento anterior a las 8 de la mañana.

Crear manualmente una tabla denominada domiciliaciones.

Agregar los siguientes campos: idSocioPrincipal, mes, año, concepto, cuentaDomiciliación, Banco, importe.

Crear un procedimiento almacenado que realice lo siguiente:
Vaciar la tabla domiciliaciones

Generar las domiciliaciones del mes a los socios no corporativos que se encuentren activos. Para ello se deberá incluir en la tabla la cuota de su mensualidad, las inscripciones a actividades extras y los descuentos por recomendaciones.

Crear un evento que se ejecute el día 1 de cada mes para exportar la tabla domiciliaciones generada por el procedimiento anterior a un archivo de texto.
Inventar un procedimiento almacenado que permita optimizar las operaciones del gimnasio.
