/*
    DDL - CREAZIONE TABELLE
*/

DROP TABLE t1;
DROP TABLE t1Bad;
DROP TABLE t_log_event;
DROP SEQUENCE log_seq;

-- t1 tutte le colonne in varchar2
CREATE TABLE t1 (
    codFisc VARCHAR2(100),
    nome VARCHAR2(100),
    cogn VARCHAR2(100),
    mail VARCHAR2(100),
    dataN VARCHAR2(100),
    tel VARCHAR2(100)
);

-- t1Bad 
CREATE TABLE t1Bad AS (
    SELECT * FROM t1
);

ALTER table t1Bad 
add summary varchar(500);


-- Tabella Log degli Eventi
CREATE TABLE t_log_event (
    event_id NUMBER,
    event_description VARCHAR2(100),
    event_time TIMESTAMP,
    event_type VARCHAR2(10)
);

-- sequenza per log
CREATE SEQUENCE log_seq
start with 1
increment by 1
nocache
nocycle;