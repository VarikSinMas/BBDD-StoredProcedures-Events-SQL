use icx0_p3_6;

/*
Crear manualmente (CREATE TABLE) una tabla denominada horario_semanal.
*/

CREATE TABLE `horario_semanal` (
  `mes` varchar(15),
  `anho` int,
  `semana` varchar(15),
  `hora` time,
  `sala` varchar(40),
  `monitor` varchar(20),
  `lunes` varchar(40),
  `martes` varchar(40),
  `miércoles` varchar(40),
  `jueves` varchar(40),
  `viernes` varchar(40),
  `sábado` varchar(40),
  `domingo` varchar(40)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*  
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

*/

DELIMITER //

CREATE PROCEDURE CrearHorarioSemanal(
    IN p_mes VARCHAR(15),
    IN p_anho INT,
    IN p_semana VARCHAR(15),
    IN p_hora TIME,
    IN p_sala VARCHAR(40),
    IN p_monitor VARCHAR(20),
    IN p_lunes VARCHAR(40),
    IN p_martes VARCHAR(40),
    IN p_miercoles VARCHAR(40),
    IN p_jueves VARCHAR(40),
    IN p_viernes VARCHAR(40),
    IN p_sabado VARCHAR(40),
    IN p_domingo VARCHAR(40)
)
BEGIN
    -- Vaciar la tabla horario_semanal
    TRUNCATE TABLE horario_semanal;

    -- Insertar el horario para la semana en curso
    INSERT INTO horario_semanal (`mes`, `anho`, `semana`, `hora`, `sala`, `monitor`, `lunes`, `martes`, `miércoles`, `jueves`, `viernes`, `sábado`, `domingo`)
    VALUES (p_mes, p_anho, p_semana, p_hora, p_sala, p_monitor, p_lunes, p_martes, p_miercoles, p_jueves, p_viernes, p_sabado, p_domingo);
END //

DELIMITER ;

CALL CrearHorarioSemanal(
    'Diciembre', -- Mes en letra
    2023, -- Año en 4 dígitos
    'del 12 al 18', -- Texto de la semana
    '10:00:00', -- Hora de la actividad
    'Sala Spinning', -- Nombre de la sala (instalación)
    'C. Alcala', -- Nombre resumido del monitor
    'CYCLING', -- Actividad para el lunes
    'YOGA VITAL', -- Actividad para el martes
    'BAILE LATINO', -- Actividad para el miércoles
    'HIT', -- Actividad para el jueves
    'PILATES PAREJA', -- Actividad para el viernes
    'ZUMBA', -- Actividad para el sábado
    'ZUMBA' -- Actividad para el domingo
);

/*
Crear un evento que ejecute cada día el procedimiento anterior a las 8 de la mañana.
*/

CREATE EVENT IF NOT EXISTS EjecutarProcedimientoDiario
ON SCHEDULE EVERY 1 DAY
STARTS CURRENT_TIMESTAMP
DO
  CALL CrearHorarioSemanal(
    'Diciembre', -- Mes en letra
    2023, -- Año en 4 dígitos
    'del 12 al 18', -- Texto de la semana
    '08:00:00', -- Hora de la actividad
    'Sala de Spinning', -- Nombre de la sala (instalación)
    'C. Alcala', -- Nombre resumido del monitor
    'CYCLING', -- Actividad para el lunes
    'YOGA VITAL', -- Actividad para el martes
    'BAILE LATINO', -- Actividad para el miércoles
    'HIT', -- Actividad para el jueves
    'PILATES PAREJA', -- Actividad para el viernes
    'ZUMBA', -- Actividad para el sábado
    'ZUMBA' -- Actividad para el domingo
  );

/*
Crear manualmente una tabla denominada domiciliaciones.
Agregar los siguientes campos: idSocioPrincipal, mes, año, concepto, cuentaDomiciliación, Banco, importe.
*/

CREATE TABLE domiciliaciones (
  idDomiciliacion INT NOT NULL AUTO_INCREMENT,
  idSocioPrincipal INT NOT NULL,
  mes VARCHAR(20) NOT NULL,
  anho INT NOT NULL,
  concepto VARCHAR(100) NOT NULL,
  cuentaDomiciliacion VARCHAR(20) NOT NULL,
  Banco VARCHAR(50) NOT NULL,
  importe DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (idDomiciliacion)
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*
Crear un procedimiento almacenado que realice lo siguiente:
Vaciar la tabla domiciliaciones
Generar las domiciliaciones del mes a los socios no corporativos que se encuentren activos. Para ello se deberá incluir en la tabla la cuota de su mensualidad, 
las inscripciones a actividades extras y los descuentos por recomendaciones.
*/

DELIMITER //

CREATE PROCEDURE GenerarDomiciliaciones()
BEGIN
    -- Vaciar la tabla domiciliaciones
    TRUNCATE TABLE domiciliaciones;
    
    -- Insertar domiciliaciones para socios no corporativos activos - Cuota mensualidad
    INSERT INTO domiciliaciones (idSocioPrincipal, mes, anho, concepto, cuentaDomiciliacion, Banco, importe)
    SELECT
        s.id_socio AS idSocioPrincipal,
        MONTH(NOW()) AS mes,
        YEAR(NOW()) AS anho,
        'Cuota mensualidad' AS concepto,
        COALESCE(p.cuenta, 'ValorPorDefecto') AS cuentaDomiciliacion,
        COALESCE(p.banco, 'BancoPorDefecto') AS Banco,
        pl.cuota_mensual AS importe
    FROM
        socio s
    INNER JOIN
        plan pl ON s.id_plan = pl.id_plan
    LEFT JOIN
        principal p ON s.id_socio = p.idsocio
    LEFT JOIN
        corporativo c ON s.id_socio = c.id_socio
    WHERE
        s.activo = 1
        AND c.id_socio IS NULL; -- Seleccionar socios no corporativos activos

    -- Insertar inscripciones a actividades extras
    INSERT INTO domiciliaciones (idSocioPrincipal, mes, anho, concepto, cuentaDomiciliacion, Banco, importe)
    SELECT
        i.idSocio AS idSocioPrincipal,
        MONTH(NOW()) AS mes,
        YEAR(NOW()) AS anho,
        'Inscripción a actividad extra' AS concepto,
        COALESCE(p.cuenta, 'ValorPorDefecto') AS cuentaDomiciliacion,
        COALESCE(p.banco, 'BancoPorDefecto') AS Banco,
        a.precio_sesion AS importe
    FROM
        inscripciones i
    INNER JOIN
        socio s ON i.idSocio = s.id_socio
    INNER JOIN
        actividad a ON i.idActividad = a.id_actividad
    LEFT JOIN
        principal p ON s.id_socio = p.idsocio
    LEFT JOIN
        corporativo c ON s.id_socio = c.id_socio
    WHERE
        MONTH(i.fechaSesion) = MONTH(NOW())
        AND YEAR(i.fechaSesion) = YEAR(NOW())
        AND s.activo = 1
        AND c.id_socio IS NULL; -- Seleccionar inscripciones de socios no corporativos activos
    
    -- Insertar descuentos por recomendaciones
    INSERT INTO domiciliaciones (idSocioPrincipal, mes, anho, concepto, cuentaDomiciliacion, Banco, importe)
    SELECT
        d.idSocio AS idSocioPrincipal,
        MONTH(d.fechaDescuento) AS mes,
        YEAR(d.fechaDescuento) AS anho,
        'Descuento por recomendación' AS concepto,
        COALESCE(p.cuenta, 'ValorPorDefecto') AS cuentaDomiciliacion,
        COALESCE(p.banco, 'BancoPorDefecto') AS Banco,
        d.Importe AS importe
    FROM
        descuentos d
    INNER JOIN
        socio s ON d.idSocioRecomendado = s.id_socio
    LEFT JOIN
        principal p ON s.id_socio = p.idsocio
    LEFT JOIN
        corporativo c ON s.id_socio = c.id_socio
    WHERE
        MONTH(d.fechaDescuento) = MONTH(NOW())
        AND YEAR(d.fechaDescuento) = YEAR(NOW())
        AND s.activo = 1
        AND c.id_socio IS NULL; -- Seleccionar descuentos de socios no corporativos activos
END//

DELIMITER ;

-- Ejecugar el store procedure
CALL GenerarDomiciliaciones();

/*
Crear un evento que se ejecute el día 1 de cada mes para exportar la tabla domiciliaciones generada por el procedimiento anterior a un archivo de texto.
*/

DELIMITER //

CREATE EVENT ExportarTablaDomiciliaciones
ON SCHEDULE
    EVERY 1 MONTH
    STARTS CURRENT_DATE + INTERVAL 1 DAY -- Ejecutar el día 1 de cada mes
ON COMPLETION PRESERVE
DO
BEGIN
    SELECT *
    FROM domiciliaciones
    INTO OUTFILE "c:/domiciliacion/domiciliaciones.txt"
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    LINES TERMINATED BY '\n';
END//

DELIMITER ;

/*
Inventar un procedimiento almacenado que permita optimizar las operaciones del gimnasio.

Se neceita obtener el total de inscripciones de un socio específico en un rango de fechas.
*/

DELIMITER //
CREATE PROCEDURE ObtenerTotalInscripciones(
    IN p_idSocio INT,
    IN p_fechaInicio DATE,
    IN p_fechaFin DATE,
    OUT p_totalInscripciones INT
)
BEGIN
    SELECT COUNT(*) INTO p_totalInscripciones
    FROM inscripciones
    WHERE idSocio = p_idSocio
    AND fechaSesion BETWEEN p_fechaInicio AND p_fechaFin;
END//
DELIMITER ;

/*
Este procedimiento almacenado ObtenerTotalInscripciones recibe tres parámetros de entrada: p_idSocio (identificación del socio), p_fechaInicio y p_fechaFin (para establecer el rango de fechas). 
El parámetro de salida p_totalInscripciones retorna el número total de inscripciones del socio dentro del rango de fechas especificado.
*/
CALL ObtenerTotalInscripciones(1, '2023-01-01', '2023-12-31', @total);
SELECT @total AS Total_Inscripciones;


