--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_CONSTELATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_CONSTELATION" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABRIG IS TABLE OF VARCHAR2(255);
    RightAscension TABRIG;
    TYPE TABDEC IS TABLE OF VARCHAR2(255);
    Declination TABDEC;
	qconstelation number(5);
BEGIN
	Name := TABNAM ();
	RightAscension := TABRIG ();
    Declination := TABDEC ();
    qconstelation := Name.count;

	FOR i IN 1..qconstelation LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Constelation VALUES (Name(i), RightAscension(i), Declination(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All constelations added.');

END ADD_CONSTELATION;

/
