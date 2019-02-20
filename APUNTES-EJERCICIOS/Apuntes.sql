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


-- Aplicando las funciones

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

  IF EXISTE_TABLA('ERRORES_PROCEDURES') = 0 THEN
    DBMS_OUTPUT.PUT_LINE('SE CREA TABLA');
    -- EXECUTE IMMEDIATE 'CREATE TABLE ERRORES_PROCEDURES (
    --   ID_ERROR NUMBER(10) NOT NULL,
    --   DESCRIPCION VARCHAR2(50) NOT NULL,
    --   FECHA DATE NOT NULL
    -- );';

  END IF;

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
          DBMS_OUTPUT.PUT_LINE('DNI Nº ' || v_dni_personal%ROWCOUNT || ': ' || v_valorCursor.DNI);
          -- INSERT INTO ERRORES_PROCEDURES (ID_ERROR, DESCRIPCION, FECHA) VALUES (v_dni_personal%ROWCOUNT, 'Error en DNI: ' || v_valorCursor.DNI, TO_DATE(TO_CHAR(SYSDATE,'DD/MM/YYYY')));
    END;
    FETCH v_dni_personal INTO v_valorCursor;
  END LOOP;
  CLOSE v_dni_personal;

EXCEPTION 
  WHEN NO_DATA_FOUND THEN 
    DBMS_OUTPUT.PUT_LINE('NO HAY DATOS');
  -- WHEN OTHERS THEN
  --   DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/


-- Registros y colecciones (Pg 320 libro)
  -- Tablas Anidadas

TYPE ejemplo_tabla IS TABLE OF VARCHAR2(30)
-- TODO


-- Tipo OBJECTO (TYPE OBJECT)
-- Es un objeto el cual tiene atributos, metodos
-- Se pueden hacer INSERTS a tablas con dicho objeto


-- Ejemplo de aplicación de objetos

-- PARA LA TABLA LIBROS

DROP TABLE LIBROS cascade constraints;

CREATE TABLE LIBROS_TAB (
  ID_LIBRO  NUMBER(4),
  TITULO    VARCHAR2(32),
  AUTOR     VARCHAR2(22),
  EDITORIAL VARCHAR2(15),
  PAGINA    NUMBER(3),
  CONSTRAINT PK_LIBRO PRIMARY KEY (ID_LIBRO)
 ) ;

INSERT INTO LIBROS_TAB VALUES (1111,'LA COLMENA', 'CELA, CAMILO JOSÉ', 'PLANETA',240);
INSERT INTO LIBROS_TAB VALUES (1211,'LA HISTORIA DE MI HIJO', 'GORDIMER, NADINE', 'TIEM.MODERNOS',327);
INSERT INTO LIBROS_TAB VALUES (1212,'LA MIRADA DEL OTRO', 'G.DELGADO, FERNANDO', 'PLANETA',298);
INSERT INTO LIBROS_TAB VALUES (1233,'ÚLTIMAS TARDES CON TERESA','MARSE, JUAN', 'CÍRCULO',350);
INSERT INTO LIBROS_TAB VALUES (1235,'LA NOVELA DE P. ANSUREZ','TORRENTE B., GONZALO', 'PLANETA',162);

-- Se crea el objeto correspondiente con sus métodos
CREATE OR REPLACE TYPE LIBROS_OBJ AS OBJECT (
  ID_LIBRO  NUMBER(4),
  TITULO    VARCHAR2(32),
  AUTOR     VARCHAR2(22),
  EDITORIAL VARCHAR2(15),
  PAGINA    NUMBER(3),
  MEMBER PROCEDURE toString,
  MEMBER FUNCTION getIdLibro RETURN NUMBER;
  MEMBER FUNCTION getTitulo RETURN VARCHAR2;
  MEMBER FUNCTION getAutor RETURN VARCHAR2;
  MEMBER FUNCTION getEditorial RETURN VARCHAR2;
  MEMBER FUNCTION getPagina RETURN NUMBER;
  MEMBER FUNCTION setIdLibro(_idLibro NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setTitulo(_titulo VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setAutor(_autor VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setEditorial(_editorial VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setPagina(_pagina NUMBER) RETURN NUMBER;
);
/

-- Para desarrollar los métodos hay que modificar el objeto a través del BODY
CREATE OR REPLACE TYPE BODY LIBROS_OBJ AS
  MEMBER PROCEDURE toString
  IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('ID ' || ID_LIBRO);
    DBMS_OUTPUT.PUT_LINE('TITULO ' || TITULO);
    DBMS_OUTPUT.PUT_LINE('AUTOR ' || AUTOR);
    DBMS_OUTPUT.PUT_LINE('EDITORIAL ' || EDITORIAL);
    DBMS_OUTPUT.PUT_LINE('PAGINA ' || PAGINA);
  END toString;
  
  MEMBER FUNCTION getIdLibro RETURN NUMBER
  IS
  BEGIN RETURN ID_LIBRO;
  END getIdLibro;

  MEMBER FUNCTION getTitulo RETURN VARCHAR2
  IS
  BEGIN RETURN TITULO;
  END getTitulo;

  MEMBER FUNCTION getAutor RETURN VARCHAR2
  IS
  BEGIN RETURN AUTOR;
  END getAutor;

  MEMBER FUNCTION getEditorial RETURN VARCHAR2
  IS
  BEGIN RETURN EDITORIAL;
  END getEditorial;

  MEMBER FUNCTION getPagina RETURN NUMBER
  IS
  BEGIN RETURN PAGINA;
  END getPagina;

  MEMBER FUNCTION setIdLibro(_idLibro NUMBER) RETURN NUMBER
  IS
    v_exito NUMBER DEFAULT 1;
  BEGIN
    ID_LIBRO := _idLibro;

    EXCEPTION 
    WHEN OTHERS THEN 
      v_exito := 0;
      DBMS_OUTPUT.PUT_LINE('LONGITUD IDLIBRO INCORRECTA');
    RETURN v_exito;
  END setIdLibro;

  MEMBER FUNCTION setTitulo(_titulo VARCHAR2) RETURN NUMBER
  IS
    v_exito NUMBER DEFAULT 1;
  BEGIN
    TITULO := _titulo;

    EXCEPTION 
    WHEN e_longitud_invalida THEN 
      v_exito := 0;
      DBMS_OUTPUT.PUT_LINE('LONGITUD TITULO INCORRECTA');
    RETURN v_exito;
  END setTitulo;

  MEMBER FUNCTION setAutor(_autor VARCHAR2) RETURN NUMBER
  IS
    v_exito NUMBER DEFAULT 1;
  BEGIN
    AUTOR := _autor;
      
    EXCEPTION 
    WHEN e_longitud_invalida THEN 
      v_exito := 0;
      DBMS_OUTPUT.PUT_LINE('LONGITUD AUTOR INCORRECTA');
    RETURN v_exito;
  END setAutor;

  MEMBER FUNCTION setEditorial(_editorial VARCHAR2) RETURN NUMBER
  IS
    v_exito NUMBER DEFAULT 1;
  BEGIN
    EDITORIAL := _editorial;

    EXCEPTION 
    WHEN e_longitud_invalida THEN 
      v_exito := 0;
      DBMS_OUTPUT.PUT_LINE('LONGITUD EDITORIAL INCORRECTA');
    RETURN v_exito;
  END setEditorial;


  MEMBER FUNCTION setPagina(_pagina NUMBER) RETURN NUMBER
  IS
    v_exito NUMBER DEFAULT 1;
  BEGIN
    PAGINA := _pagina
    
    EXCEPTION 
    WHEN e_longitud_invalida THEN 
      v_exito := 0;
      DBMS_OUTPUT.PUT_LINE('LONGITUD PAGINA INCORRECTA');
    RETURN v_exito;
  END setPagina;

END;
/

-- Para ejecutarlo
DECLARE
  v_libro LIBROS_OBJ;
BEGIN
  v_libro := LIBROS_OBJ(1432,'TITULO EJEMPLO','AUTOR EJEMPLO','EDITORIAL EJEMPLO',111);
  -- GETTERS
  DBMS_OUTPUT.PUT_LINE(v.libro.getIdLibro);
  DBMS_OUTPUT.PUT_LINE(v.libro.getTitulo);
  DBMS_OUTPUT.PUT_LINE(v.libro.getAutor);
  DBMS_OUTPUT.PUT_LINE(v.libro.getEditorial);
  DBMS_OUTPUT.PUT_LINE(v.libro.getPagina);
  -- SETTERS
  DBMS_OUTPUT.PUT_LINE(v.libro.setIdLibro(24));
  DBMS_OUTPUT.PUT_LINE(v.libro.setTitulo('TITULO UPDATE'));
  DBMS_OUTPUT.PUT_LINE(v.libro.setAutor('AUTOR UPDATE'));
  DBMS_OUTPUT.PUT_LINE(v.libro.setEditorial('EDITORIAL UPDATE'));
  DBMS_OUTPUT.PUT_LINE(v.libro.setPagina(100));
  -- TOSTRING
  v_libro.toString;

END;
/

-- TRIGGERS - Pg 308 libro - (NO SE PUEDEN CREAR EN SYS - SYS AS SYSDBA)

-- 3 TIPOS:
  -- DDL: Los que afectan a las tablas
    -- Ejemplo de trigger (Cada vez que hay un insert, delete, update) guardar esa infro en una tabla de  logs
  -- DML: Afectan a las vistas (Cada vez que se invoca una vista)
  -- Sistema (Cuando hay acciones de sistema)

-- En los Triggers usar siempre el ON FOR EACH ROW para que no bloquee la tabla completa
-- sino solo la fila con la que se va a trabajar
-- El WHEN es la condición del Trigger para que haga o no haga.

-- Sobre el OLD y NEW
  -- For an INSERT trigger, OLD contains no values, and NEW contains the new values.
  -- For an UPDATE trigger, OLD contains the old values, and NEW contains the new values.
  -- For a DELETE trigger, OLD contains the old values, and NEW contains no values.


-- Hay que hacerlo como otro usuario
CREATE OR REPLACE TRIGGER tr_ejemplo 
  BEFORE -- o también AFTER
  DELETE -- OR INSERT OR UPDATE acciones para las que se activa el trigger
  ON tabla_ejemplo
  FOR EACH ROW 
  -- WHEN condicion (condicion en la que entra el trigger)
DECLARE
  v_ejemplo NUMBER(3);
BEGIN
  v_ejemplo := 4;
  IF v_ejemplo = 4 THEN
    RAISE exc_ejemplo;
  END IF;
EXCEPTION 
  WHEN exc_ejemplo THEN 
    DBMS_OUTPUT.PUT_LINE('HA SALTADO EL ERROR');
END tr_ejemplo;
/

-- Ejemplo de trigger que cada vez que se elimine un elemento de una tabla haga un log por consola
CREATE OR REPLACE TRIGGER mostrar_consola_preborrado
  BEFORE DELETE 
  ON LIBROS2 
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('SE VA A BORRAR EL REGISTRO ' || :OLD.COD_LIBRO);
END;
/

CREATE OR REPLACE TRIGGER mostrar_consola_posborrado
  AFTER DELETE
  ON LIBROS2
  FOR EACH ROW
BEGIN
  DBMS_OUTPUT.PUT_LINE('SE HA BORRADO EL REGISTRO ' || :OLD.COD_LIBRO);
END;
/

-- Trigger de borrado y que inserte en una tabla el mensaje de borrado

CREATE TABLE tabla_log_borrado (
  MENSAJE_BORRADO VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER insertar_tabla_log 
  AFTER DELETE 
  ON LIBROS2 
  FOR EACH ROW
BEGIN
  INSERT INTO tabla_log_borrado VALUES ('SE HA BORRADO EL REGISTRO CON ID ' || :OLD.COD_LIBRO || ' A LAS ' || TO_CHAR(SYSDATE, 'DD-MM-YYY HH24:MI:SS'));
END; 
/

-- Trigger con condicion de registro 'bloqueado' que lanza excepción a la aplicación.

CREATE OR REPLACE trigger_exception
  BEFORE DELETE
  FOR EACH ROW
DECLARE
  e_trigger EXCEPTION;
BEGIN 
  IF (:OLD.UNIDADES < 6) THEN
      INSERT INTO tabla_log_borrado VALUES ('ERROR AL ELEIMINAR REGISTRO CON ID ' || :OLD.COD_LIBRO || ' A LAS ' || TO_CHAR(SYSDATE, 'DD-MM-YYY HH24:MI:SS'));
      RAISE e_trigger;
  END IF;

  EXCEPTION
    WHEN e_trigger THEN
      -- DBMS_OUTPUT.PUT_LINE('EL REGISTRO CON ID ' || :OLD.COD_LIBRO || ' ESTÁ PROTEGIDO');
      RAISE_APPLICATION_ERROR(-20000, 'EL REGISTRO CON ID ' || :OLD.COD_LIBRO || ' ESTÁ PROTEGIDO');
      -- Esto no va a funcionar porque en el momento que saca el exception hace un rollback de todo
END;
/

CREATE OR REPLACE trigger_control_cantidad 
  BEFORE INSERT
  FOR EACH ROW
DECLARE
  cantidad_error EXCEPTION;
BEGIN
  IF(:NEW.DEPT_NO = 10) THEN
    SELECT COUNT(*) FROM DEPART WHERE DEPT_NO = 10;

    EXCEPTION DATA_FOUND THEN
      -- DBMS_OUTPUT.PUT_LINE('YA EXISTE UN REGISTRO CON LA ID ' || :OLD.COD_LIBRO);
      RAISE_APPLICATION_ERROR(-20000, 'YA EXISTE UN REGISTRO CON LA ID ' || :OLD.COD_LIBRO);
  END IF;
END;
/
