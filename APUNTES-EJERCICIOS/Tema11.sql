-- Pagina 271

SET SERVEROUTPUT ON;

-- Ejercicio 1
CREATE OR REPLACE PROCEDURE SUMA(NUM1 NUMBER, NUM2 NUMBER)
AS
  V_RESULTADO NUMBER;
BEGIN
  V_RESULTADO := NUM1 + NUM2;
  DBMS_OUTPUT.PUT_LINE('LA SUMA ES: ' || V_RESULTADO);
END SUMA;
/

-- Ejercicio 2
