SET SERVEROUTPUT ON;

REM *** CREAR BANCO *** 

DECLARE
  v_banco BANCOS_OBJ;
  BEGIN 
  v_banco := BANCOS_OBJ(1234,1221133212, 'BANCO EJEMPLO 1', 'ZARAGOZA','ZARAGOZA');
  v_banco.toString();
END;
/

EXECUTE INSERT_BANCOS(BANCOS_OBJ(1234,1221133212, 'BANCO EJEMPLO 1', 'ZARAGOZA','ZARAGOZA'));
EXECUTE INSERT_BANCOS(BANCOS_OBJ(1234,1221133212, 'BANCO EJEMPLO 1', 'ZARAGOZA','MADRID'));
EXECUTE DELETE_BANCOS(1234);

REM *** CREAR SUCURSAL *** 

DECLARE
  v_sucursal SUCURSALES_OBJ;
  BEGIN 
  v_sucursal := SUCURSALES_OBJ(1111,6000, 'SUCURSAL 3', 'PILON 33','PASTRANA','GUADALAJARA');
  v_sucursal.toString();
END;
/

EXECUTE INSERT_SUCURSALES(SUCURSALES_OBJ(1111,6000, 'SUCURSAL 3', 'PILON 33','PASTRANA','GUADALAJARA'));
EXECUTE DELETE_SUCURSALES(1111,6000);

REM *** CREAR CUENTAS *** 

DECLARE
  v_cuentas CUENTAS_OBJ;
  BEGIN 
  v_cuentas := CUENTAS_OBJ(1111,6000, 1897986524, SYSDATE,'CUENTA 1','DIRECCION CUENTA', 'ALBACETE', 0, 0);
  v_cuentas.toString();
END;
/

EXECUTE INSERT_CUENTAS(CUENTAS_OBJ(1111,6000, 1897986524, SYSDATE,'CUENTA 1','DIRECCION CUENTA', 'ALBACETE', 0, 0));
EXECUTE DELETE_CUENTAS(1111,6000,1897986524);

REM *** CREAR MOVIMIENTOS *** 

DECLARE
  v_movimientos MOVIMIENTOS_OBJ;
  BEGIN 
  v_movimientos := MOVIMIENTOS_OBJ(1111,6000, 1897986524, SYSDATE,'I', 300);
  v_movimientos.toString();
END;
/

EXECUTE INSERT_MOVIMIENTOS(MOVIMIENTOS_OBJ(1111,6000, 1897986524, SYSDATE,'I', 300));
EXECUTE INSERT_MOVIMIENTOS(MOVIMIENTOS_OBJ(1111,6000, 1897986524, SYSDATE + 1,'I', 300));
