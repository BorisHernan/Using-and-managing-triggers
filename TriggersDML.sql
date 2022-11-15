--Código para Sys :
--Creando TableSpace en Sys/dba
CREATE TABLESPACE TBSLABORATORIO LOGGING
DATAFILE 'C:\oraclexe\app\oracle\oradata\XE\TBSLABORATORIO.dbf' SIZE 1024M
EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT AUTO;

--Creando el usuario OA691417276
create user OA691417276 identified by OracleAcademy
 default tablespace TBSLABORATORIO
 quota 1000M on TBSLABORATORIO;

--Dando permisos del administrador al usuario OA691417276
grant dba to OA691417276;

--TABLA DE CONTROL  ( EVENTOS, FECHAS, ACCION)
CREATE TABLE CONTROL_LOG
(
EVENTO  VARCHAR2(100),
FECHA DATE DEFAULT SYSDATE,
ACCION VARCHAR2(50)
);
/

--ELIMINAR TABLA DE CONTROL
Drop table CONTROL_LOG;

--GUÍA DE UN TRIGGER
--CREATE OR REPLACE <nombre> <tiempo> <evento> ON <SCHEMA|DATABASE> 

--ACCIONES DE REGISTROS DE TRIGGERS CON CREATE, DROP Y ALTER
CREATE OR REPLACE TRIGGER BORRAR_EVENTO
AFTER DROP
ON SCHEMA
BEGIN
    INSERT INTO CONTROL_LOG (EVENTO,ACCION) VALUES ('EL USUARIO ELIMINO UN OBJETO','DROP');
END;
/

CREATE OR REPLACE TRIGGER ALTER_EVENTO
AFTER ALTER
ON SCHEMA
BEGIN
    INSERT INTO CONTROL_LOG (EVENTO,ACCION) VALUES (USER,'ALTER');
END;
/

CREATE OR REPLACE TRIGGER CREAR_EVENTO
AFTER CREATE
ON SCHEMA
BEGIN
    INSERT INTO CONTROL_LOG (EVENTO,ACCION) VALUES (USER,'CREATE');
END;
/

--Ejemplo : CREACION - ELIMINAR

CREATE TABLE PRUEBA (EJEMPLO NUMBER);

DROP TABLE PRUEBA;


--CREACION - ALTER :
CREATE TABLE PERSONA (
    IDPER integer PRIMARY KEY
);

ALTER TABLE VENTA2 ADD CONSTRAINT VENTA_PERSONA FOREIGN KEY (IDPER) REFERENCES PERSONA (IDPER);

CREATE TABLE VENTA2 (
    IDVEN integer PRIMARY KEY,
    IDPER integer  NOT NULL
);
DROP TABLE VENTA2;


--VERFICAR LA TABLA CONTROL :
SELECT EVENTO,TO_CHAR (fecha, 'dd-MM-YYYY hh:mm:ss') AS Fecha, ACCION FROM CONTROL_LOG;

--TRIGGERS PARA EVENTOS DE BASE DATOS

CREATE TABLE log_accesos (
    usuarios varchar2(50),
    FECHA DATE DEFAULT SYSDATE,
    accion varchar2(50)
);

--Trigger para conexión
CREATE OR REPLACE TRIGGER tr_log_acceso AFTER LOGON ON SCHEMA 
BEGIN 
    insert into log_accesos(usuarios,accion) values (user,'Se conecto');
END;
/

--Trigger antes de la desconexión
CREATE OR REPLACE TRIGGER tr_log_desconexion BEFORE LOGOFF ON SCHEMA 
BEGIN 
    insert into log_accesos(usuarios,accion) values (user,'Se desconecto');
END;
/

--SELECCION DE TABLA DE CONEXION Y DESCONEXION :
SELECT usuarios,TO_CHAR (fecha, 'dd-MM-YYYY hh:mm:ss') AS Fecha, accion FROM log_accesos;

--TABLA DE CONTACTOS

CREATE TABLE CONTACTOS (
    ID NUMBER PRIMARY KEY,
    NOMBRE VARCHAR2(30),
    TELEFONO VARCHAR2(30)
);

--TABLA DE SEGUIMIENTO
    
CREATE TABLE LOG_CONTACTO (
    NOMBRE VARCHAR2(30),
    TELEFONO VARCHAR2(30) 
);

--Triggers con procedimientos almacenados
CREATE OR REPLACE PROCEDURE SP_CONFIRMACION(p_nombre VARCHAR2:='Jesus', p_tel VARCHAR2 default '94329749') IS 
BEGIN
    insert into LOG_CONTACTO values(p_nombre,p_tel);
END;
/    

CREATE OR REPLACE TRIGGER TR_INSERTA_CONTACTO BEFORE INSERT ON CONTACTOS FOR EACH ROW
    call SP_CONFIRMACION(:new.NOMBRE, :new.TELEFONO)
/

--AL REALIZAR UN REGISTRO SE GUARDA EN LOG
SELECT * FROM CONTACTOS;
INSERT INTO CONTACTOS VALUES(1, 'Boris','960847347');
INSERT INTO CONTACTOS VALUES(2, 'Robert','971849342');
SELECT * FROM LOG_CONTACTO;

-- TABLAS 'MUTANTES'
-- TABLA QUE ESTA SIENDO MODIFICADA POR UNA SENTENCIA DML
CREATE OR REPLACE TRIGGER tr_sobre_tmutante BEFORE UPDATE OF salary ON EMPLEADOS FOR EACH ROW
DECLARE 
    v_salario_min EMPLEADOS.salary%TYPE;
    v_salario_max EMPLEADOS.salary%type;
BEGIN
    SELECT MIN(salary), MAX(salary) INTO v_salario_min, v_salario_max
        FROM EMPLEADOS WHERE id=:NEW.id;
    IF NOT (:NEW.salary BETWEEN v_salario_min AND v_salario_max) THEN
        raise_application_error(-2001, 'Salario fuera de rango');
    END IF;
END;

update EMPLEADOS set salary=3000 WHERE id=20;


--TABLA DE EJEMPLO DE MUTANTES.
CREATE TABLE EMPLEADOS (
    id integer PRIMARY KEY,
    first_name varchar2(45)  NOT NULL,
    last_name varchar2(45)  NOT NULL,
    email varchar2(45)  NOT NULL,
    gender varchar2(45)  NOT NULL,
    salary DECIMAL(8,2)
    );
    
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('1','Reina','Cord','rcord0@hatena.ne.jp','Female','600');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('2','Regan','Lum','rlum1@ebay.co.uk','Agender','299');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('3','Denny','Leyland','dleyland2@lulu.com','Genderfluid','1700');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('4','Broddie','Corroyer','bcorroyer3@prlog.org','Male','1856');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('5','Atalanta','Realy','arealy4@hugedomains.com','Female','260');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('6','Itch','Roumier','iroumier5@hexun.com','Male','5600');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('7','Laina','Snoxall','lsnoxall6@odnoklassniki.ru','Female','850');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('8','Joellen','Barfford','jbarfford7@dropbox.com','Female','3890');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('9','Cilka','Hainey','chainey8@dyndns.org','Female','');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('10','Evered','Machans','emachans9@booking.com','Male','');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('11','Joseito','Minguet','jmingueta@virginia.edu','Genderfluid','2360');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('12','Elfrieda','Rickis','erickisb@skype.com','Female','3369');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('13','Ludovico','Lambal','llambalc@imgur.com','Male','790');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('14','Augy','Hinners','ahinnersd@facebook.com','Male','2300');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('15','Marrissa','Tubb','mtubbe@mapy.cz','Female','2400');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('16','Dominique','Bills','dbillsf@t-online.de','Male','2710');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('17','Burty','Spottswood','bspottswoodg@wsj.com','Male','878');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('18','Heloise','Al Hirsi','halhirsih@netlog.com','Female','910');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('19','Bibby','Heinrici','bheinricii@etsy.com','Female','');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('20','Tadeo','Dup','teastupj@netscape.com','Male','3420');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('21','Tad','EasT','teastupj@netscape.com','Male','6420');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('22','Oad','Astu','teastupj@netscape.com','Male','1520');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('23','Rad','Sup','teastupj@netscape.com','Male','');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('24','Tiro','Tnoa','teastupj@netscape.com','Male','2420');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('25','Tedo','Frup','teastupj@netscape.com','Male','');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('26','Augy','Hinners','ahinnersd@facebook.com','Male','2300');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('27','Marrissa','Tubb','mtubbe@mapy.cz','Female','2400');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('28','Dominique','Bills','dbillsf@t-online.de','Male','2710');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('29','Burty','Spottswood','bspottswoodg@wsj.com','Male','878');
INSERT INTO EMPLEADOS (id,first_name,last_name,email,gender,salary) VALUES ('30','Heloise','Al Hirsi','halhirsih@netlog.com','Female','910');

--SELECCIONAR DISPARADORES DEL USUARIO
SELECT * FROM USER_TRIGGERS;

--SELECCIONAR DISPARADORES que utilizan el mismo nombre_columna
SELECT * FROM USER_TRIGGER_COLS;

SELECT * FROM USER_OBJECTS 
WHERE OBJECT_TYPE = 'TRIGGER';

SELECT * FROM USER_PROCEDURES 
WHERE OBJECT_TYPE='TRIGGER';

SELECT * FROM ALL_PROCEDURES 
WHERE OBJECT_TYPE='TRIGGER' 
AND OWNER='SYSTEM';

SELECT * FROM DBA_PROCEDURES 
WHERE OBJECT_TYPE='TRIGGER' 
AND OWNER='SYSTEM';

DROP TRIGGER tr_sobre_tmutante;
