-- Activar siempre al principio
SET SERVEROUTPUT ON;

-- Ejemplo de PROCEDURE, 
-- solo se le pone parentesis cuando se le pasa un parametro

CREATE PROCEDURE BORRAR_DPTO
IS 
  V_NUM_EMPLEADOS NUMBER(2);
BEGIN
  INSERT INTO DEPART VALUES (99, 'DPTO DE LOLO',NULL);
  UPDATE EMPLE SET DEPT_NO = 99
    WHERE DEPT_NO = 20;
  V_NUM_EMPLEADOS := SQL%ROWCOUNT;

  DELETE FROM DEPART WHERE DEPT_NO = 20;
  DBMS_OUTPUT.PUT_LINE(V_NUM_EMPLEADOS || ' EMPLEADOS UBICADOS EN PROVISIONAL');
  DBMS_OUTPUT.PUT_LINE('DEPT 20 BORRADO CON EXITO');

EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR (-20000, 'ERROR EN LA APLICACIÓN');
END BORRAR_DPTO;
/

-- Para ejecutar 
EXECUTE BORRAR_DPTO();

-- Para borrar
DROP PROCEDURE BORRAR_DPTO();

-- Para ver los errores de compliacion
SHOW ERRORS

-- IMPORTANTE: Los procedimientos almacenados NO devuelven datos
-- -> Hay que guardarlos en variables <-

-- Ejemplo MAL:

CREATE PROCEDURE VER_EMPLE(EMPLEADO NUMBER)
IS
BEGIN
  SELECT APELLIDO
    FROM EMPLE
    WHERE EMPLE.EMP_NO = EMPLEADO;
END VER_EMPLE;
/

-- Ejemplo BIEN:

CREATE PROCEDURE VER_EMPLE(EMPLEADO NUMBER)
IS
  V_APELLIDO VARCHAR2(10);
BEGIN
  SELECT APELLIDO INTO V_APELLIDO
    FROM EMPLE
    WHERE EMPLE.EMP_NO = EMPLEADO;
    DBMS_OUTPUT.PUT_LINE('EL EMPLEADO SE APELLIDA '|| V_APELLIDO);
END VER_EMPLE;
/

-- Si se queja de que el PROCEDURE ya existe, se puede hacer un DROP PROCEDURE o 
-- poner el procedure como CREATE OR REPLACE PROCEDURE.. (aunque este es peligroso porque
-- lo sobrescribe sin avisar)


-- Si por algún casual cambia el tipo de dato que le pasamos en el IS, se puede hacer lo siguiente:

CREATE PROCEDURE VER_EMPLE(EMPLEADO NUMBER)
IS
  V_APELLIDO EMPLE.APELLIDA%TYPE
BEGIN
  SELECT APELLIDO INTO V_APELLIDO
    FROM EMPLE
    WHERE EMPLE.EMP_NO = EMPLEADO;
    DBMS_OUTPUT.PUT_LINE('EL EMPLEADO SE APELLIDA '|| V_APELLIDO);

-- Página 289-290 para EXCEPCIONES
EXCEPTION
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO EXISTE EL EMPLEADO');
  WHEN TOO_MANY_ROWS THEN 
    DBMS_OUTPUT.PUT_LINE('DEMASIADOS VALORES PARA MOSTRAR');
  WHEN OTHERS THEN 
    DBMS_OUTPUT.PUT_LINE('ERROR DESCONOCIDO');
END VER_EMPLE;
/

-- Ejemplo de PROCEDIMIENTO
CREATE OR REPLACE PROCEDURE VER_DEPARTAMENTO (ID_DEPARTAMENTO NUMBER) 
AS
  V_NOMBRE VARCHAR2(14); -- V_NOMBRE DEPART.DNOMBRE%TYPE;
  V_LOCALIDAD VARCHAR2(14); -- V_LOCALIDAD DEPART.LOC%TYPE
BEGIN 
  SELECT DNOMBRE, LOC INTO V_NOMBRE, V_LOCALIDAD
    FROM DEPART
    WHERE DEPT_NO = ID_DEPARTAMENTO;
  DBMS_OUTPUT.PUT_LINE('N.DPTO: '|| ID_DEPARTAMENTO ||' - DPTO:' || V_NOMBRE || ' - LOCALIDAD: '|| V_LOCALIDAD);

EXCEPTION 
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO EXISTE EL DEPARTAMENTO');
END VER_DEPARTAMENTO;
/

-- Ejemplo de FUNCION
CREATE OR REPLACE FUNCTION SALUDAR(SEXO CHAR, NOMBRE VARCHAR2) RETURN VARCHAR2
AS
  V_MSJ VARCHAR2(5) DEFAULT 'SR.';
  V_NOMBRE VARCHAR2
BEGIN 
  IF SEXO = 'M' THEN 
    V_MSJ := 'SRA.';
  END IF;
  RETURN V_MSJ;
END SALUDAR;
/

BEGIN 
  DBMS_OUTPUT.PUT_LINE(SALUDAR('M')); 
END;
/

-- Ejemplo de CURSOR con LOOP (NO usar LOOP)
DECLARE
  CURSOR V_CUR IS 
    SELECT APELLIDO, OFICIO
      FROM EMPLE
      WHERE DEPT_NO = 20;
  V_APE EMPLE.APELLIDO%TYPE;
  V_OFI EMPLE.OFICIO%TYPE;
BEGIN
  OPEN V_CUR;
  LOOP 
    FETCH V_CUR INTO V_APE, V_OFI;
    EXIT WHEN V_CUR%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(V_APE || ' - ' || V_OFI);
  END LOOP;
  CLOSE V_CUR;
END;
/

-- Ejemplo de CURSOR con WHILE (usar WHILE)
-- IMPORTANTE:
  -- Cuando usas el WHILE hay que primero hacer un FECTH para que entre en el bucle
DECLARE
  CURSOR V_CUR IS 
    SELECT APELLIDO, OFICIO
      FROM EMPLE
      WHERE DEPT_NO = 20;
  V_APE EMPLE.APELLIDO%TYPE;
  V_OFI EMPLE.OFICIO%TYPE;
BEGIN
  OPEN V_CUR;
  FETCH V_CUR INTO V_APE, V_OFI;
  WHILE  V_CUR%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE(V_APE || ' - ' || V_OFI);
    FETCH V_CUR INTO V_APE, V_OFI;
  END LOOP;
  CLOSE V_CUR;
END;
/


-- Ejercicio de ejemplo: 

-- Hacer un procedimiento almacenado que reciba un codigo de fabricante  y una categoria 
-- y que nos liste los articulos

-- Utilizar la tabla ARTICULOS
CREATE OR REPLACE PROCEDURE LIST_ARTICULOS(COD_FAB NUMBER, CAT VARCHAR2)
AS
  CURSOR V_LISTA IS 
    SELECT ARTICULO, PRECIO_VENTA, EXISTENCIAS, CATEGORIA
      FROM ARTICULOS 
      WHERE COD_FABRICANTE = COD_FAB 
        AND CATEGORIA LIKE CAT;

  V_ARTICULO ARTICULOS.ARTICULO%TYPE;
  V_PRECIO_VENTA ARTICULOS.PRECIO_VENTA%TYPE;
  V_EXISTENCIAS ARTICULOS.EXISTENCIAS%TYPE;
  V_CATEGORIAS ARTICULOS.CATEGORIA%TYPE;

BEGIN 
  OPEN V_LISTA;
  FETCH V_LISTA INTO V_ARTICULO, V_PRECIO_VENTA, V_EXISTENCIAS, V_CATEGORIAS;

  IF V_LISTA%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('NO SE ENCUENTRAN LOS DATOS');
  ELSE 
    WHILE V_LISTA%FOUND LOOP
      DBMS_OUTPUT.PUT_LINE(V_ARTICULO || ' - ' || V_PRECIO_VENTA || ' EUR - ' ||  V_EXISTENCIAS || ' - ' || V_CATEGORIAS);
      FETCH V_LISTA INTO V_ARTICULO, V_PRECIO_VENTA, V_EXISTENCIAS, V_CATEGORIAS;
    END LOOP;
  END IF;
  CLOSE V_LISTA;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('NO SE ENCUENTRAN LOS DATOS');

END LIST_ARTICULOS;
/

-- Pagina 228: GUARDAR ARCHIVOS EN FICHEROS

-- OTRA MANERA DE HACER EL EJERCICIO DE LA SUMA
CREATE OR REPLACE PROCEDURE SUMA(NUM1 IN NUMBER, NUM2 IN NUMBER, TOTAL OUT NUMBER)
AS
BEGIN
  TOTAL := NUM1 + NUM2;
COMMIT;

EXCEPTION
WHEN OTHERS THEN 
  DBMS_OUTPUT.PUT_LINE ('ERROR' || SQLERRM);
  ROLLBACK;
END SUMA;
/

DECLARE
  TOTAL NUMBER;
BEGIN 
  SUMA(1,2,TOTAL);
  DBMS_OUTPUT.PUT_LINE(TOTAL);
END;
/

-- Procedimientos almacenados con datos de entrada y salida

CREATE OR REPLACE PROCEDURE SUMA (NUM1 IN NUMBER, NUM2 IN NUMBER, TOTAL OUT NUMBER)
IS 
BEGIN
  TOTAL:= NUM1 + NUM2;
END SUMA;
/

DECLARE
  TOTAL NUMBER;
BEGIN 
  SUMA(2,4,TOTAL);
  DBMS_OUTPUT.PUT_LINE('LA SUMA ES ' || TOTAL);
END;
/

-- Tablas de ejemplo del usuario HR (Hay que desbloquearlo de Oracle)

-- Mostrar el ultimo año que ha habido contrataciones en el departamento de Ventas "Sales" (Hacerlo generico)
CREATE OR REPLACE PROCEDURE ULTIMO_ANIO_CONTRATACION(DPTO IN VARCHAR2, FECHA OUT DATE)

-- Manera 1 de hacer la consulta
/*
SELECT EMPLOYEES.HIRE_DATE 
  FROM EMPLOYEES EMP 
  INNER JOIN DEPARTMENTS DEPT 
  ON EMP.DEPARTMENT_ID = DPET.DEPARTMENT_ID 
  AND DEPT.DEPARTMENT_NAME LIKE DPTO
*/ 


-- Manera 2 de hacer la consulta
SELECT MAX(EXTRACT(YEAR FROM EMPLOYEES.HIRE_DATE)) 
  FROM EMPLOYEES EMP, DEPARTMENTS DEPT 
  WHERE EMP.DEPARTMENT_ID = DEPT.DEPARTMENT_ID 
  AND DEPT.DEPARTMENT_NAME LIKE DPTO;


-- Cursores

-- EJ 1 
DECLARE 
  CURSOR V_DNI_PERSONAL IS 
    SELECT DNI
     FROM  PERSONAL;
  V_DNI PERSONAL.DNI%TYPE;
BEGIN
  OPEN V_DNI_PERSONAL;
    FETCH V_DNI_PERSONAL INTO V_DNI;
  WHILE V_DNI_PERSONAL%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('DNI Nº '|| V_DNI_PERSONAL%ROWCOUNT || ': ' || V_DNI);
    FETCH V_DNI_PERSONAL INTO V_DNI;
  END LOOP;
  CLOSE V_DNI_PERSONAL;
END;
/

-- EJ 2 (Con parametros)
DECLARE 
  CURSOR v_dni_personal(v_centro NUMBER) IS 
    SELECT DNI
     FROM  PERSONAL
     WHERE COD_CENTRO = v_centro;
  v_dni PERSONAL.DNI%TYPE;
BEGIN
  OPEN v_dni_personal(10);
    FETCH v_dni_personal INTO v_dni;
  WHILE v_dni_personal%FOUND LOOP
    DBMS_OUTPUT.PUT_LINE('DNI Nº '|| v_dni_personal%ROWCOUNT || ': ' || v_dni);
    FETCH v_dni_personal INTO v_dni;
  END LOOP;
  CLOSE v_dni_personal;
END;
/

-- Excepciones
DECLARE 
  CURSOR v_dni_personal(v_centro NUMBER) IS 
    SELECT DNI
     FROM  PERSONAL
     WHERE COD_CENTRO = v_centro;
  v_valorCursor v_dni_personal%ROWTYPE;
  e_dni_invalido EXCEPTION;
BEGIN
  OPEN v_dni_personal(10);
    FETCH v_dni_personal INTO v_valorCursor;
  WHILE v_dni_personal%FOUND LOOP
    -- Hacer que el programa no se bloquee cuando hay una excepcion
    BEGIN 
      IF v_valorCursor.DNI = 4123005 THEN
        RAISE e_dni_invalido;
      END IF;
      DBMS_OUTPUT.PUT_LINE('DNI Nº ' || v_dni_personal%ROWCOUNT || ': ' || v_valorCursor.DNI);
    EXCEPTION
        WHEN e_dni_invalido THEN
          DBMS_OUTPUT.PUT_LINE('EL DNI ' || v_valorCursor.DNI || ' ES INVALIDO');
    END;
    FETCH v_dni_personal INTO v_valorCursor;
  END LOOP;
  CLOSE v_dni_personal;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
END;
/

-- Hacer un for update de un cursor
DECLARE 
  CURSOR v_dni_personal(v_centro NUMBER) IS 
    SELECT DNI
     FROM  PERSONAL
     WHERE COD_CENTRO = v_centro 
     FOR UPDATE;

  v_valorCursor v_dni_personal%ROWTYPE;
  e_dni_invalido EXCEPTION;
BEGIN
  OPEN v_dni_personal(10);
  FETCH v_dni_personal INTO v_valorCursor;
  WHILE v_dni_personal%FOUND LOOP
    -- Hacer que el programa no se bloquee cuando hay una excepcion
    BEGIN 
      IF v_valorCursor.DNI = 4123005 THEN
        RAISE e_dni_invalido;
      END IF;
      IF v_valorCursor.DNI = 4480099 THEN
        UPDATE PERSONAL SET COD_CENTRO = 99
        WHERE CURRENT OF V_DNI_PERSONAL;
      END IF;
      DBMS_OUTPUT.PUT_LINE('DNI Nº '|| v_dni_personal%ROWCOUNT || ': ' || v_valorCursor.DNI);
    EXCEPTION
        WHEN e_dni_invalido THEN
          DBMS_OUTPUT.PUT_LINE('EL DNI ' || v_valorCursor.DNI || ' ES INVALIDO');
    END;
    FETCH v_dni_personal INTO v_valorCursor;
  END LOOP;
  CLOSE v_dni_personal;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
END;
/

-- FUNCIONES
CREATE OR REPLACE FUNCTION FORMATO_FECHA RETURN VARCHAR
AS  
  v_fecha VARCHAR2(100);
BEGIN 
  SELECT TO_CHAR(SYSDATE, 'DD/Mon/YYYY') INTO v_fecha 
    FROM DUAL;
  RETURN v_fecha;
END FORMATO_FECHA;
/

BEGIN
  DBMS_OUTPUT.PUT_LINE('LA FECHA ES ' || FORMATO_FECHA);
END;
/

-- Otra forma de ejecutar funciones
SELECT FORMATO_FECHA FROM DUAL;



-- Funcion que valide el DNI (Longitud 8)
-- y si es valida que devuelva la letra correspondiente

  -- Funciones

    -- Longitud == 8

CREATE OR REPLACE FUNCTION VALIDAR_DNI(DNI NUMBER) RETURN NUMBER
AS
  v_isValido NUMBER(1) DEFAULT 0;
BEGIN
  IF LENGTH(DNI) = 8 THEN
    v_isValido := 1;
  END IF;
  RETURN v_isValido;
END VALIDAR_DNI;
/

    -- Devolver letra correspondiente

CREATE OR REPLACE FUNCTION LETRA_DNI(DNI NUMBER) RETURN VARCHAR2
AS
  v_letraDNI VARCHAR(1) DEFAULT '';
  v_letras VARCHAR2(25) DEFAULT 'TRWAGMYFPDXBNJZSQVHLCKE';
BEGIN
  v_letraDNI := SUBSTR(v_letras,MOD(DNI,23)+1,1);
  RETURN v_letraDNI;
END LETRA_DNI;
/

  -- Aplicando la funcion

DECLARE 
  CURSOR v_dni_personal(v_centro NUMBER) IS 
    SELECT DNI
     FROM  PERSONAL
     WHERE COD_CENTRO = v_centro;
  v_valorCursor v_dni_personal%ROWTYPE;
  v_nuevoDni VARCHAR2(9);
  e_dni_invalido EXCEPTION;
BEGIN
  OPEN v_dni_personal(10);
    FETCH v_dni_personal INTO v_valorCursor;
  WHILE v_dni_personal%FOUND LOOP
    BEGIN 
      IF VALIDAR_DNI(v_valorCursor.DNI) = 1 THEN
        v_nuevoDni := CONCAT(TO_CHAR(v_valorCursor.DNI),LETRA_DNI(v_valorCursor.DNI));
        DBMS_OUTPUT.PUT_LINE('DNI Nº ' || v_dni_personal%ROWCOUNT || ': ' || v_nuevoDni);
      ELSE
        RAISE e_dni_invalido;
      END IF;
    EXCEPTION
        WHEN e_dni_invalido THEN
          DBMS_OUTPUT.PUT_LINE('EL DNI ' || v_valorCursor.DNI || ' ES INVALIDO');
    END;
    FETCH v_dni_personal INTO v_valorCursor;
  END LOOP;
  CLOSE v_dni_personal;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
END;
/

  -- Para que saque un valor que se pueda comprobar la funcion:

DECLARE 
  CURSOR v_dni_personal IS 
    SELECT DNI
     FROM  PERSONAL;
  v_valorCursor v_dni_personal%ROWTYPE;
  v_nuevoDni VARCHAR2(9);
  e_dni_invalido EXCEPTION;
BEGIN
  OPEN v_dni_personal;
    FETCH v_dni_personal INTO v_valorCursor;
  WHILE v_dni_personal%FOUND LOOP
    BEGIN 
      IF VALIDAR_DNI(v_valorCursor.DNI) = 1 THEN
        v_nuevoDni := CONCAT(TO_CHAR(v_valorCursor.DNI),LETRA_DNI(v_valorCursor.DNI));
        DBMS_OUTPUT.PUT_LINE('DNI Nº ' || v_dni_personal%ROWCOUNT || ': ' || v_nuevoDni);
      ELSE
        RAISE e_dni_invalido;
      END IF;
    EXCEPTION
        WHEN e_dni_invalido THEN
          DBMS_OUTPUT.PUT_LINE('EL DNI ' || v_valorCursor.DNI || ' ES INVALIDO');
    END;
    FETCH v_dni_personal INTO v_valorCursor;
  END LOOP;
  CLOSE v_dni_personal;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
END;
/


-- Crear una tabla de errores, con la fecha del error y el nombre del error

  -- Comprobar si existe la tabla 
CREATE OR REPLACE FUNCTION EXISTE_TABLA(TABLE_NAME VARCHAR2) RETURN NUMBER
AS
  v_existe NUMBER(1);
BEGIN
  SELECT COUNT(*) INTO v_existe
   FROM ALL_OBJECTS 
   WHERE OBJECT_TYPE IN ('TABLE') 
   AND OBJECT_NAME = TABLE_NAME;
   RETURN v_existe;
END EXISTE_TABLA;
/

 -- Crear la tabla si existe
CREATE OR REPLACE FUNCTION CREAR_TABLA(TABLE_NAME VARCHAR2) RETURN NUMBER
AS
  v_sql VARCHAR2(4000);
  v_creada NUMBER(1);
BEGIN
  v_sql := 'CREATE TABLE ERRORES_PROCEDURES (
    NOMBRE VARCHAR2(50) NOT NULL,
    NOMBRE_TABLA VARCHAR(50) NOT NULL,
    FECHA DATE NOT NULL
  );';
  EXECUTE IMMEDIATE v_sql;
  v_creada := EXISTE_TABLA(TABLE_NAME);
  RETURN v_creada;  
END CREAR_TABLA;
/

