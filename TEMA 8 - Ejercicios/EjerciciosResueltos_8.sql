-- Activar siempre al principio
SET SERVEROUTPUT ON;

-- Pagina 218
DECLARE
    v_num_empleados NUMBER(2);
BEGIN
    INSERT INTO depart VALUES (99, 'D PROVISIONAL',NULL);
    UPDATE emple SET dept_no = 99 
        WHERE emple.dept_no = 20;
    v_num_empleados := SQL%ROWCOUNT;
    DELETE FROM depart 
        WHERE depart.dept_no = 20;
    DBMS_OUTPUT.PUT_LINE(v_num_empleados || ' Empleados ubicados en PROVISIONAL');
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20000, 'Error en la aplicación');
END;
/

-- Pagina 222
DECLARE 
    v_app_emple VARCHAR2(10);
    v_of_emple VARCHAR2(10);
BEGIN
    SELECT apellido, oficio INTO v_app_emple, v_of_emple
        FROM emple
        WHERE emple.emp_no = 7900;
    DBMS_OUTPUT.PUT_LINE(v_app_emple || ' - ' || v_of_emple);
END;
/


-- Ejemplo de PROCEDURE, 
-- solo se le pone parentesis cuando se le pasa un parametro

CREATE PROCEDURE BORRAR_DPTO
IS 
    v_num_empleados NUMBER(2);
BEGIN
    INSERT INTO depart VALUES (99, 'DPTO DE LOLO',NULL);
    UPDATE emple SET dept_no = 99
    WHERE dept_no = 20;
    v_num_empleados := SQL%ROWCOUNT;

    DELETE FROM depart WHERE dept_no = 20;
    DBMS_OUTPUT.PUT_LINE(v_num_empleados || ' Empleados ubicados en PROVISIONAL');
    DBMS_OUTPUT.PUT_LINE('Dept 20 borrado con exito');

EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR (-20000, 'Error en la aplicación');
END;
/

-- Para ejecutar 
EXECUTE BORRAR_DPTO();

-- Para borrar
DROP PROCEDURE BORRAR_DPTO();

-- Para ver los errores de compliacion
SHOW ERRORS