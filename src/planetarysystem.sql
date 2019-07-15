--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_PLANETARYSYSTEM
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_PLANETARYSYSTEM" IS
    TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABRIG IS TABLE OF VARCHAR2(255);
    RightAscension TABRIG;
    TYPE TABDEC IS TABLE OF VARCHAR2(255);
    Declination TABDEC;
    TYPE TABLIG IS TABLE OF BINARY_DOUBLE;
    LightYears TABLIG;
    qplanetarysystem NUMBER(5);
BEGIN
	Name := TABNAM ('Solar System');
    RightAscension := TABRIG (0);
    Declination := TABDEC (0);
    LightYears := TABLIG (0);
    qplanetarysystem := Name.count;

    FOR i IN 1..qplanetarysystem LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO PlanetarySystem VALUES (Name(i), RightAscension(i), Declination(i), LightYears(i), 0, 0);
	END LOOP;
	DBMS_OUTPUT.put_line('All planetarysystems added.');

END ADD_PLANETARYSYSTEM;

/
