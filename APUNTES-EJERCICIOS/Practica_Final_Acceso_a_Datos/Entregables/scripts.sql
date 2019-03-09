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


REM *** CREACION DE OBJETOS ***

-- OBJETO BANCOS
CREATE OR REPLACE TYPE BANCOS_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  NF_BANCO    VARCHAR2(10),
  NOMBRE_BANC VARCHAR2(30),
  DOM_FISCAL  VARCHAR(35),
  POBLACION   VARCHAR(35),
  MEMBER FUNCTION getCodBanco RETURN NUMBER;
  MEMBER FUNCTION getNfBanco RETURN VARCHAR2;
  MEMBER FUNCTION getNombreBanc RETURN VARCHAR2;
  MEMBER FUNCTION getDomFiscal RETURN VARCHAR;
  MEMBER FUNCTION getPoblacion RETURN VARCHAR;
  MEMBER FUNCTION setCodBanco(_cod_banco NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setNfBanco(_nf_banco VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setNombreBanc(_nombre_banc VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setDomFiscal(_dom_fiscal VARCHAR) RETURN NUMBER;
  MEMBER FUNCTION setPoblacion(_poblacion VARCHAR) RETURN NUMBER;
  MEMBER PROCEDURE toString,
);

-- OBJETO SUCURSALES
CREATE OR REPLACE TYPE SUCURSALES_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  COD_SUCUR   NUMBER(4),
  NOMBRE_SUC  VARCHAR2(35),
  DIREC_SUC   VARCHAR2(35),
  LOC_SUC     VARCHAR2(20),
  PROV_SUC    VARCHAR2(20),
  MEMBER FUNCTION getCodBanco RETURN NUMBER;
  MEMBER FUNCTION getCodSucur RETURN NUMBER;
  MEMBER FUNCTION getNombreSuc VARCHAR2;
  MEMBER FUNCTION getDirecSuc VARCHAR2; 
  MEMBER FUNCTION getLocSuc VARCHAR2;
  MEMBER FUNCTION getProvSuc VARCHAR2;
  MEMBER FUNCTION setCodBanco(_cod_banco NUMBER) return NUMBER;
  MEMBER FUNCTION setCodSucur(_cod_sucur NUMBER) return NUMBER;
  MEMBER FUNCTION setNombreSuc(_nombre_suc VARCHAR2) return NUMBER;
  MEMBER FUNCTION setDirecSuc(_direc_suc VARCHAR2) return NUMBER;
  MEMBER FUNCTION setLocSuc(_loc_suc VARCHAR2) return NUMBER;
  MEMBER FUNCTION setProvSuc(_prov_suc VARCHAR2) return NUMBER;
  MEMBER FUNCTION toString,
);

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
  MEMBER FUNCTION getCodBanco RETURN NUMBER;
  MEMBER FUNCTION getCodSucur RETURN NUMBER;
  MEMBER FUNCTION getNumCta RETURN NUMBER;
  MEMBER FUNCTION getFechaAlta RETURN DATE;
  MEMBER FUNCTION getNombreCta RETURN VARCHAR2;
  MEMBER FUNCTION getDirectCta RETURN VARCHAR2;
  MEMBER FUNCTION getPoblaCta RETURN VARCHAR2;
  MEMBER FUNCTION getSaldoDebe RETURN NUMBER;
  MEMBER FUNCTION getSaldoHaber RETURN NUMBER;
  MEMBER FUNCTION setCodBanco(_cod_banco NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setCodSucur(_cod_sucur NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setNumCta(_num_cta NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setFechaAlta(_fecha_alta DATE) RETURN NUMBER;
  MEMBER FUNCTION setNombreCta(_nombre_cta VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setDirectCta(_direct_cta VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setPoblaCta(_pobla_cta VARCHAR2) RETURN NUMBER;
  MEMBER FUNCTION setSaldoDebe(_saldo_debe NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setSaldoHaber(_saldo_haber NUMBER) RETURN NUMBER;
  MEMBER PROCEDURE toString;
);

-- OBJETO MOVIMIENTOS
CREATE OR REPLACE TYPE MOVIMIENTOS_OBJ AS OBJECT (
  COD_BANCO   NUMBER(4),
  COD_SUCUR   NUMBER(4),
  NUM_CTA     NUMBER(10),
  FECHA_MOV   DATE,
  TIPO_MOV    CHAR(1),
  IMPORTE     NUMBER(10),
  MEMBER FUNCTION getCodBanco RETURN NUMBER;
  MEMBER FUNCTION getCodSucur RETURN NUMBER;
  MEMBER FUNCTION getNumCta RETURN NUMBER;
  MEMBER FUNCTION getFechaMov RETURN DATE;
  MEMBER FUNCTION getTipoMov RETURN CHAR;
  MEMBER FUNCTION getImporte RETURN NUMBER;
  MEMBER FUNCTION setCodBanco(_cod_banco NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setCodSucur(_cod_sucur NUMBER) RETURN NUMBER;
  MEMBER FUNCTION setNumCta(_num_cta NUMBER) RETURN NUMBER;
  MEMBER FUNCTION getFechaMov(_fecha_mov DATE) RETURN NUMBER;
  MEMBER FUNCTION getTipoMov(_tipo_mov CHAR) RETURN NUMBER;
  MEMBER FUNCTION getImporte(_importe NUMBER) RETURN NUMBER;
  MEMBER PROCEDURE toString;
);