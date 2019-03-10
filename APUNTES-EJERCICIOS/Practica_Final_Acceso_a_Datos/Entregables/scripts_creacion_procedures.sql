SET SERVEROUTPUT ON;

CLEAR SCR 
DISCONNECT  
-- Conectarse como SYS y crear otro usuario
CONNECT SYS AS SYSDBA; 

DROP USER GUILLERMO; 

-- Usuario con el que trabajaremos
CREATE USER GUILLERMO IDENTIFIED BY Guillermo; 
GRANT DBA TO GUILLERMO; 
GRANT ALL PRIVILEGES TO GUILLERMO; 

GRANT SELECT, INSERT, UPDATE, DELETE ON BANCOS TO GUILLERMO;
GRANT SELECT, INSERT, UPDATE, DELETE ON SUCURSALES TO GUILLERMO;
GRANT SELECT, INSERT, UPDATE, DELETE ON CUENTAS TO GUILLERMO;
GRANT SELECT, INSERT, UPDATE, DELETE ON MOVIMIENTOS TO GUILLERMO;

REM *** PASANDO AL USUARIO GUILLERMO *** 

CLEAR SCR 
DISCONNECT

REM ***
REM SE VA A CONECTAR AL SIGUIENTE USUARIO
REM USUARIO: GUILLERMO 
REM CONTRASEÑA: Guillermo 
REM ****

CONNECT GUILLERMO

REM *** CREACION DE OBJETOS ***

-- OBJETO BANCOS
CREATE OR REPLACE TYPE BANCOS_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  NF_BANCO    VARCHAR2(10),
  NOMBRE_BANC VARCHAR2(30),
  DOM_FISCAL  VARCHAR(35),
  POBLACION   VARCHAR(35),
  MEMBER FUNCTION getCodBanco RETURN NUMBER,
  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER),
  MEMBER FUNCTION getNfBanco RETURN VARCHAR2,
  MEMBER PROCEDURE setNfBanco(nf_banco VARCHAR2),
  MEMBER FUNCTION getNombreBanc RETURN VARCHAR2,
  MEMBER PROCEDURE setNombreBanc(nombre_banc VARCHAR2),
  MEMBER FUNCTION getDomFiscal RETURN VARCHAR,
  MEMBER PROCEDURE setDomFiscal(dom_fiscal VARCHAR),
  MEMBER FUNCTION getPoblacion RETURN VARCHAR,
  MEMBER PROCEDURE setPoblacion(poblacion VARCHAR),
  MEMBER PROCEDURE toString
);
/

CREATE OR REPLACE TYPE BODY BANCOS_OBJ AS
  MEMBER FUNCTION getCodBanco RETURN NUMBER IS
    BEGIN RETURN COD_BANCO;
  END getCodBanco;

  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER) IS
    BEGIN
      SELF.COD_BANCO := cod_banco;
  END setCodBanco;

  MEMBER FUNCTION getNfBanco RETURN VARCHAR2 IS
    BEGIN RETURN NF_BANCO;
  END getNfBanco;

  MEMBER PROCEDURE setNfBanco(nf_banco VARCHAR2) IS
    BEGIN
      SELF.NF_BANCO := nf_banco;
  END setNfBanco;

  MEMBER FUNCTION getNombreBanc RETURN VARCHAR2 IS
    BEGIN RETURN NOMBRE_BANC;
  END getNombreBanc;

  MEMBER PROCEDURE setNombreBanc(nombre_banc VARCHAR2) IS
    BEGIN
      SELF.NOMBRE_BANC := nombre_banc;
  END setNombreBanc;

  MEMBER FUNCTION getDomFiscal RETURN VARCHAR IS
    BEGIN RETURN DOM_FISCAL;
  END getDomFiscal;

  MEMBER PROCEDURE setDomFiscal(dom_fiscal VARCHAR) IS 
    BEGIN
      SELF.DOM_FISCAL := dom_fiscal;
  END setDomFiscal;

  MEMBER FUNCTION getPoblacion RETURN VARCHAR IS 
    BEGIN RETURN POBLACION;
  END getPoblacion;

  MEMBER PROCEDURE setPoblacion(poblacion VARCHAR) IS
    BEGIN
      SELF.POBLACION := poblacion;
  END setPoblacion;
  
  MEMBER PROCEDURE toString IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('COD_BANCO ' || COD_BANCO);
      DBMS_OUTPUT.PUT_LINE('NF_BANCO ' || NF_BANCO);
      DBMS_OUTPUT.PUT_LINE('NOMBRE_BANC ' || NOMBRE_BANC);
      DBMS_OUTPUT.PUT_LINE('DOM_FISCAL ' || DOM_FISCAL);
      DBMS_OUTPUT.PUT_LINE('POBLACION ' || POBLACION);
    END toString;
END;
/

-- OBJETO SUCURSALES
CREATE OR REPLACE TYPE SUCURSALES_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  COD_SUCUR   NUMBER(4),
  NOMBRE_SUC  VARCHAR2(35),
  DIREC_SUC   VARCHAR2(35),
  LOC_SUC     VARCHAR2(20),
  PROV_SUC    VARCHAR2(20),
  MEMBER FUNCTION getCodBanco RETURN NUMBER,
  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER),
  MEMBER FUNCTION getCodSucur RETURN NUMBER,
  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER),
  MEMBER FUNCTION getNombreSuc RETURN VARCHAR2,
  MEMBER PROCEDURE setNombreSuc(nombre_suc VARCHAR2),
  MEMBER FUNCTION getDirecSuc RETURN VARCHAR2,
  MEMBER PROCEDURE setDirecSuc(direc_suc VARCHAR2),
  MEMBER FUNCTION getLocSuc RETURN VARCHAR2,
  MEMBER PROCEDURE setLocSuc(loc_suc VARCHAR2),
  MEMBER FUNCTION getProvSuc RETURN VARCHAR2,
  MEMBER PROCEDURE setProvSuc(prov_suc VARCHAR2),
  MEMBER PROCEDURE toString
);
/

CREATE OR REPLACE TYPE BODY SUCURSALES_OBJ AS
  MEMBER FUNCTION getCodBanco RETURN NUMBER IS
    BEGIN RETURN COD_BANCO;
  END getCodBanco;

  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER) IS
    BEGIN SELF.COD_BANCO := cod_banco;
  END setCodBanco;

  MEMBER FUNCTION getCodSucur RETURN NUMBER IS
    BEGIN RETURN COD_SUCUR;
  END getCodSucur;

  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER) IS
    BEGIN SELF.COD_SUCUR := cod_sucur;
  END setCodSucur;

  MEMBER FUNCTION getNombreSuc RETURN VARCHAR2 IS
    BEGIN RETURN NOMBRE_SUC;
  END getNombreSuc;

  MEMBER PROCEDURE setNombreSuc(nombre_suc VARCHAR2) IS
    BEGIN SELF.NOMBRE_SUC := nombre_suc;
  END setNombreSuc;

  MEMBER FUNCTION getDirecSuc RETURN VARCHAR2 IS
    BEGIN RETURN DIREC_SUC;
  END getDirecSuc; 

  MEMBER PROCEDURE setDirecSuc(direc_suc VARCHAR2) IS
    BEGIN SELF.DIREC_SUC := direc_suc;
  END setDirecSuc;

  MEMBER FUNCTION getLocSuc RETURN VARCHAR2 IS
    BEGIN RETURN LOC_SUC;
  END getLocSuc;

  MEMBER PROCEDURE setLocSuc(loc_suc VARCHAR2) IS
    BEGIN SELF.LOC_SUC := loc_suc;
  END setLocSuc;

  MEMBER FUNCTION getProvSuc RETURN VARCHAR2 IS
    BEGIN RETURN PROV_SUC;
  END getProvSuc;

  MEMBER PROCEDURE setProvSuc(prov_suc VARCHAR2) IS
    BEGIN SELF.PROV_SUC := prov_suc;
  END setProvSuc;

  MEMBER PROCEDURE toString IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('COD_BANCO ' || COD_BANCO);
      DBMS_OUTPUT.PUT_LINE('COD_SUCUR ' || COD_SUCUR);
      DBMS_OUTPUT.PUT_LINE('NOMBRE_SUC ' || NOMBRE_SUC);
      DBMS_OUTPUT.PUT_LINE('DIREC_SUC ' || DIREC_SUC);
      DBMS_OUTPUT.PUT_LINE('LOC_SUC ' || LOC_SUC);
      DBMS_OUTPUT.PUT_LINE('PROV_SUC ' || PROV_SUC);
    END toString;
END;
/

-- OBJETO CUENTAS
CREATE OR REPLACE TYPE CUENTAS_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  COD_SUCUR   NUMBER(4),
  NUM_CTA     NUMBER(10),
  FECHA_ALTA  DATE,
  NOMBRE_CTA  VARCHAR2(35),
  DIREC_CTA   VARCHAR2(35),
  POBLA_CTA   VARCHAR2(20),
  SALDO_DEBE  NUMBER(10),
  SALDO_HABER NUMBER(10),
  MEMBER FUNCTION getCodBanco RETURN NUMBER,
  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER),
  MEMBER FUNCTION getCodSucur RETURN NUMBER,
  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER),
  MEMBER FUNCTION getNumCta RETURN NUMBER,
  MEMBER PROCEDURE setNumCta(num_cta NUMBER),
  MEMBER FUNCTION getFechaAlta RETURN DATE,
  MEMBER PROCEDURE setFechaAlta(fecha_alta DATE),
  MEMBER FUNCTION getNombreCta RETURN VARCHAR2,
  MEMBER PROCEDURE setNombreCta(nombre_cta VARCHAR2),
  MEMBER FUNCTION getDirectCta RETURN VARCHAR2,
  MEMBER PROCEDURE setDirectCta(direct_cta VARCHAR2),
  MEMBER FUNCTION getPoblaCta RETURN VARCHAR2,
  MEMBER PROCEDURE setPoblaCta(pobla_cta VARCHAR2),
  MEMBER FUNCTION getSaldoDebe RETURN NUMBER,
  MEMBER PROCEDURE setSaldoDebe(saldo_debe NUMBER),
  MEMBER FUNCTION getSaldoHaber RETURN NUMBER,
  MEMBER PROCEDURE setSaldoHaber(saldo_haber NUMBER),
  MEMBER PROCEDURE toString
);
/

CREATE OR REPLACE TYPE BODY CUENTAS_OBJ AS
  MEMBER FUNCTION getCodBanco RETURN NUMBER IS
    BEGIN RETURN COD_BANCO;
  END getCodBanco;

  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER) IS
    BEGIN SELF.COD_BANCO:= cod_banco;
  END setCodBanco;

  MEMBER FUNCTION getCodSucur RETURN NUMBER IS
    BEGIN RETURN COD_SUCUR;
  END getCodSucur;

  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER) IS
    BEGIN SELF.COD_SUCUR:= cod_sucur;
  END setCodSucur;

  MEMBER FUNCTION getNumCta RETURN NUMBER IS
    BEGIN RETURN NUM_CTA;
  END getNumCta;

  MEMBER PROCEDURE setNumCta(num_cta NUMBER) IS
  BEGIN SELF.NUM_CTA:= num_cta;
  END setNumCta;

  MEMBER FUNCTION getFechaAlta RETURN DATE IS
    BEGIN RETURN FECHA_ALTA;
  END getFechaAlta;

  MEMBER PROCEDURE setFechaAlta(fecha_alta DATE) IS
    BEGIN SELF.FECHA_ALTA:= fecha_alta;
  END setFechaAlta;

  MEMBER FUNCTION getNombreCta RETURN VARCHAR2 IS
    BEGIN RETURN NOMBRE_CTA;
  END getNombreCta;

  MEMBER PROCEDURE setNombreCta(nombre_cta VARCHAR2) IS
    BEGIN SELF.NOMBRE_CTA:= nombre_cta;
  END setNombreCta;

  MEMBER FUNCTION getDirectCta RETURN VARCHAR2 IS
    BEGIN RETURN DIREC_CTA;
  END getDirectCta;

  MEMBER PROCEDURE setDirectCta(direct_cta VARCHAR2) IS
    BEGIN SELF.DIREC_CTA:= direct_cta;
  END setDirectCta;

  MEMBER FUNCTION getPoblaCta RETURN VARCHAR2 IS
    BEGIN RETURN POBLA_CTA;
  END getPoblaCta;

  MEMBER PROCEDURE setPoblaCta(pobla_cta VARCHAR2) IS
    BEGIN SELF.POBLA_CTA:= pobla_cta;
  END setPoblaCta;

  MEMBER FUNCTION getSaldoDebe RETURN NUMBER IS
    BEGIN RETURN SALDO_DEBE;
  END getSaldoDebe;

  MEMBER PROCEDURE setSaldoDebe(saldo_debe NUMBER) IS
    BEGIN SELF.SALDO_DEBE:= saldo_debe;
    END setSaldoDebe;

  MEMBER FUNCTION getSaldoHaber RETURN NUMBER IS
    BEGIN RETURN SALDO_HABER;
  END getSaldoHaber;

  MEMBER PROCEDURE setSaldoHaber(saldo_haber NUMBER) IS
    BEGIN SELF.SALDO_HABER:= saldo_haber;
  END setSaldoHaber;

  MEMBER PROCEDURE toString IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('COD_BANCO ' || COD_BANCO);
      DBMS_OUTPUT.PUT_LINE('COD_SUCUR ' || COD_SUCUR);
      DBMS_OUTPUT.PUT_LINE('NUM_CTA ' || NUM_CTA);
      DBMS_OUTPUT.PUT_LINE('FECHA_ALTA ' || FECHA_ALTA);
      DBMS_OUTPUT.PUT_LINE('NOMBRE_CTA ' || NOMBRE_CTA);
      DBMS_OUTPUT.PUT_LINE('DIREC_CTA ' || DIREC_CTA);
      DBMS_OUTPUT.PUT_LINE('POBLA_CTA ' || POBLA_CTA);
      DBMS_OUTPUT.PUT_LINE('SALDO_DEBE ' || SALDO_DEBE);
      DBMS_OUTPUT.PUT_LINE('SALDO_HABER ' || SALDO_HABER);
    END toString;
END;
/

-- OBJETO MOVIMIENTOS
CREATE OR REPLACE TYPE MOVIMIENTOS_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  COD_SUCUR   NUMBER(4),
  NUM_CTA     NUMBER(10),
  FECHA_MOV   DATE,
  TIPO_MOV    CHAR(1),
  IMPORTE     NUMBER(10),
  MEMBER FUNCTION getCodBanco RETURN NUMBER,
  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER),
  MEMBER FUNCTION getCodSucur RETURN NUMBER,
  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER),
  MEMBER FUNCTION getNumCta RETURN NUMBER,
  MEMBER PROCEDURE setNumCta(num_cta NUMBER),
  MEMBER FUNCTION getFechaMov RETURN DATE,
  MEMBER PROCEDURE setFechaMov(fecha_mov DATE),
  MEMBER FUNCTION getTipoMov RETURN CHAR,
  MEMBER PROCEDURE setTipoMov(tipo_mov CHAR),
  MEMBER FUNCTION getImporte RETURN NUMBER,
  MEMBER PROCEDURE setImporte(importe NUMBER),
  MEMBER PROCEDURE toString
);
/

CREATE OR REPLACE TYPE BODY MOVIMIENTOS_OBJ AS
  MEMBER FUNCTION getCodBanco RETURN NUMBER IS
    BEGIN RETURN COD_BANCO;
  END getCodBanco;

  MEMBER PROCEDURE setCodBanco(cod_banco NUMBER) IS
    BEGIN SELF.COD_BANCO := cod_banco;
  END setCodBanco;
  
  MEMBER FUNCTION getCodSucur RETURN NUMBER IS
    BEGIN RETURN COD_SUCUR;
  END getCodSucur;

  MEMBER PROCEDURE setCodSucur(cod_sucur NUMBER) IS
    BEGIN SELF.COD_SUCUR := cod_sucur;
  END setCodSucur;
  
  MEMBER FUNCTION getNumCta RETURN NUMBER IS
    BEGIN RETURN NUM_CTA;
  END getNumCta;

  MEMBER PROCEDURE setNumCta(num_cta NUMBER) IS
    BEGIN SELF.NUM_CTA := num_cta;
  END setNumCta;
  
  MEMBER FUNCTION getFechaMov RETURN DATE IS
    BEGIN RETURN FECHA_MOV;
  END getFechaMov;

  MEMBER PROCEDURE setFechaMov(fecha_mov DATE) IS
    BEGIN SELF.FECHA_MOV := fecha_mov;
  END setFechaMov;
  
  MEMBER FUNCTION getTipoMov RETURN CHAR IS
    BEGIN RETURN TIPO_MOV;
  END getTipoMov;

  MEMBER PROCEDURE setTipoMov(tipo_mov CHAR) IS
    BEGIN SELF.TIPO_MOV := tipo_mov;
  END setTipoMov;
  
  MEMBER FUNCTION getImporte RETURN NUMBER IS
    BEGIN RETURN IMPORTE;
  END getImporte;

  MEMBER PROCEDURE setImporte(importe NUMBER) IS
    BEGIN SELF.IMPORTE := importe;
  END setImporte;

  MEMBER PROCEDURE toString IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('COD_BANCO ' || COD_BANCO);
      DBMS_OUTPUT.PUT_LINE('COD_SUCUR ' || COD_SUCUR);
      DBMS_OUTPUT.PUT_LINE('NUM_CTA ' || NUM_CTA);
      DBMS_OUTPUT.PUT_LINE('FECHA_MOV ' || FECHA_MOV);
      DBMS_OUTPUT.PUT_LINE('TIPO_MOV ' || TIPO_MOV);
      DBMS_OUTPUT.PUT_LINE('IMPORTE ' || IMPORTE);
    END toString;
END;
/


REM *** CREACION DE OPERACIONES CUD ***

-- BANCOS_OBJ
CREATE OR REPLACE PROCEDURE INSERT_BANCOS(banco BANCOS_OBJ)
  IS
    e_noInsert EXCEPTION;
  BEGIN 
  INSERT INTO SYS.BANCOS (COD_BANCO, NF_BANCO, NOMBRE_BANC, DOM_FISCAL, POBLACION) 
    VALUES(banco.getCodBanco, banco.getNfBanco, banco.getNombreBanc, banco.getDomFiscal, banco.getPoblacion);

  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noInsert;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA INSERTADO EN TABLA BANCOS, INDICE DUPLICADO');
      ROLLBACK;
    WHEN e_noInsert THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO INSERTAR EN TABLA BANCOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR EN TABLA BANCOS');
      ROLLBACK;
END INSERT_BANCOS;
/

CREATE OR REPLACE PROCEDURE UPDATE_BANCOS(banco BANCOS_OBJ)
  IS
    e_noUpdate EXCEPTION;
  BEGIN
    UPDATE SYS.BANCOS 
      SET NF_BANCO = banco.getNfBanco, NOMBRE_BANC = banco.getNombreBanc, DOM_FISCAL = banco.getDomFiscal, POBLACION = banco.getPoblacion
      WHERE COD_BANCO = banco.getCodBanco;
  
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noUpdate;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noUpdate THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO ACTUALIZAR EN TABLA BANCOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL ACTUALIZAR EN TABLA BANCOS');
      ROLLBACK;
END UPDATE_BANCOS;
/

CREATE OR REPLACE PROCEDURE DELETE_BANCOS(v_cod_banco IN SYS.BANCOS.COD_BANCO%TYPE)
  IS
    e_noDelete EXCEPTION;
  BEGIN
    DELETE FROM SYS.BANCOS
      WHERE COD_BANCO = v_cod_banco;
     
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noDelete;
  END IF;
  COMMIT; 

  EXCEPTION 
    WHEN e_noDelete THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO BORRAR EN TABLA BANCOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL BORRAR EN TABLA BANCOS');
      ROLLBACK;
END DELETE_BANCOS;
/

-- SUCURSALES_OBJ
CREATE OR REPLACE PROCEDURE INSERT_SUCURSALES(sucursal SUCURSALES_OBJ)
  IS
    e_noInsert EXCEPTION;
  BEGIN 
  INSERT INTO SYS.SUCURSALES (COD_BANCO, COD_SUCUR, NOMBRE_SUC, DIREC_SUC, LOC_SUC, PROV_SUC)  
    VALUES(sucursal.getCodBanco, sucursal.getCodSucur, sucursal.getNombreSuc, sucursal.getDirecSuc, sucursal.getLocSuc, sucursal.getProvSuc);

  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noInsert;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noInsert THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO INSERTAR EN TABLA SUCURSALES');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR EN TABLA SUCURSALES');
      ROLLBACK;
END INSERT_SUCURSALES;
/

CREATE OR REPLACE PROCEDURE UPDATE_SUCURSALES(sucursal SUCURSALES_OBJ)
  IS
    e_noUpdate EXCEPTION;
  BEGIN 
    UPDATE SYS.SUCURSALES 
      SET NOMBRE_SUC = sucursal.getNombreSuc, DIREC_SUC = sucursal.getDirecSuc, LOC_SUC = sucursal.getLocSuc, PROV_SUC = sucursal.getProvSuc 
      WHERE COD_BANCO = sucursal.getCodBanco AND COD_SUCUR = sucursal.getCodSucur;
    
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noUpdate;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noUpdate THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO ACTUALIZAR EN TABLA SUCURSALES');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL ACTUALIZAR EN TABLA SUCURSALES');
      ROLLBACK;
END UPDATE_SUCURSALES;
/

CREATE OR REPLACE PROCEDURE DELETE_SUCURSALES(
  v_cod_banco IN SYS.SUCURSALES.COD_BANCO%TYPE,
  v_cod_sucur IN SYS.SUCURSALES.COD_SUCUR%TYPE)
  IS
    e_noDelete EXCEPTION;
  BEGIN
    DELETE FROM SYS.SUCURSALES
      WHERE COD_BANCO = v_cod_banco AND COD_SUCUR = v_cod_sucur;
     
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noDelete;
  END IF;
  COMMIT; 

  EXCEPTION 
    WHEN e_noDelete THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO BORRAR EN TABLA SUCURSALES');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL BORRAR EN TABLA SUCURSALES');
      ROLLBACK;
END DELETE_SUCURSALES;
/

-- CUENTAS_OBJ
CREATE OR REPLACE PROCEDURE INSERT_CUENTAS(cuentas CUENTAS_OBJ)
  IS
    e_noInsert EXCEPTION;
  BEGIN 
  INSERT INTO SYS.CUENTAS (COD_BANCO, COD_SUCUR, NUM_CTA, FECHA_ALTA, NOMBRE_CTA, DIREC_CTA, POBLA_CTA, SALDO_DEBE, SALDO_HABER)  
    VALUES(cuentas.getCodBanco, cuentas.getCodSucur, cuentas.getNumCta, cuentas.getFechaAlta, cuentas.getNombreCta, cuentas.getDirectCta, cuentas.getPoblaCta, cuentas.getSaldoDebe, cuentas.getSaldoHaber);

  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noInsert;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noInsert THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO INSERTAR EN TABLA CUENTAS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR EN TABLA CUENTAS');
      ROLLBACK;
END INSERT_CUENTAS;
/

CREATE OR REPLACE PROCEDURE UPDATE_CUENTAS(cuentas CUENTAS_OBJ)
  IS
    e_noUpdate EXCEPTION;
  BEGIN 
    UPDATE SYS.CUENTAS
      SET FECHA_ALTA = cuentas.getFechaAlta, NOMBRE_CTA = cuentas.getNombreCta, DIREC_CTA = cuentas.getDirectCta, POBLA_CTA = cuentas.getPoblaCta, SALDO_DEBE = cuentas.getSaldoDebe, SALDO_HABER = cuentas.getSaldoHaber
      WHERE COD_BANCO = cuentas.getCodBanco AND COD_SUCUR = cuentas.getCodSucur AND NUM_CTA = cuentas.getNumCta;
    
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noUpdate;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noUpdate THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO ACTUALIZAR EN TABLA CUENTAS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL ACTUALIZAR EN TABLA CUENTAS');
      ROLLBACK;

END UPDATE_CUENTAS;
/

CREATE OR REPLACE PROCEDURE DELETE_CUENTAS(
  v_cod_banco IN SYS.CUENTAS.COD_BANCO%TYPE,
  v_cod_sucur IN SYS.CUENTAS.COD_SUCUR%TYPE,
  v_num_cta IN SYS.CUENTAS.NUM_CTA%TYPE)
  IS
    e_noDelete EXCEPTION;
  BEGIN
    DELETE FROM SYS.CUENTAS
      WHERE COD_BANCO = v_cod_banco AND COD_SUCUR = v_cod_sucur AND NUM_CTA = v_num_cta;
     
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noDelete;
  END IF;
  COMMIT; 

  EXCEPTION 
    WHEN e_noDelete THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO BORRAR EN TABLA CUENTAS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL BORRAR EN TABLA CUENTAS');
      ROLLBACK;
END DELETE_CUENTAS;
/

-- MOVIMIENTOS_OBJ
CREATE OR REPLACE PROCEDURE INSERT_MOVIMIENTOS(movimiento MOVIMIENTOS_OBJ)
  IS
    e_noInsert EXCEPTION;
  BEGIN 
  INSERT INTO SYS.MOVIMIENTOS (COD_BANCO, COD_SUCUR, NUM_CTA, FECHA_MOV, TIPO_MOV, IMPORTE)  
    VALUES(movimiento.getCodBanco, movimiento.getCodSucur, movimiento.getNumCta, movimiento.getFechaMov, movimiento.getFechaMov, movimiento.getImporte);

  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noInsert;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noInsert THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO INSERTAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL INSERTAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
END INSERT_MOVIMIENTOS;
/

CREATE OR REPLACE PROCEDURE UPDATE_MOVIMIENTOS(movimiento MOVIMIENTOS_OBJ)
  IS
    e_noUpdate EXCEPTION;
  BEGIN 
    UPDATE SYS.MOVIMIENTOS 
      SET TIPO_MOV = movimiento.getTipoMov, IMPORTE = movimiento.getImporte  
      WHERE COD_BANCO = movimiento.getCodBanco AND COD_SUCUR = movimiento.getCodSucur AND NUM_CTA = movimiento.getNumCta AND FECHA_MOV = movimiento.getFechaMov;
    
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noUpdate;
  END IF;
  COMMIT;
  
  EXCEPTION 
    WHEN e_noUpdate THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO ACTUALIZAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL ACTUALIZAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
END UPDATE_MOVIMIENTOS;
/

CREATE OR REPLACE PROCEDURE DELETE_MOVIMIENTOS(
  v_cod_banco IN SYS.MOVIMIENTOS.COD_BANCO%TYPE,
  v_cod_sucur IN SYS.MOVIMIENTOS.COD_SUCUR%TYPE,
  v_num_cta IN SYS.MOVIMIENTOS.NUM_CTA%TYPE,
  v_fecha_mov IN SYS.MOVIMIENTOS.FECHA_MOV%TYPE)
  IS
    e_noDelete EXCEPTION;
  BEGIN
    DELETE FROM SYS.MOVIMIENTOS
      WHERE COD_BANCO = v_cod_banco AND COD_SUCUR = v_cod_sucur AND NUM_CTA = v_num_cta AND FECHA_MOV = v_fecha_mov;
     
  IF SQL%ROWCOUNT = 0 THEN
    RAISE e_noDelete;
  END IF;
  COMMIT; 

  EXCEPTION 
    WHEN e_noDelete THEN
      DBMS_OUTPUT.PUT_LINE('NO SE HA PODIDO BORRAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
    WHEN OTHERS THEN 
      DBMS_OUTPUT.PUT_LINE('ERROR AL BORRAR EN TABLA MOVIMIENTOS');
      ROLLBACK;
END DELETE_MOVIMIENTOS;
/

