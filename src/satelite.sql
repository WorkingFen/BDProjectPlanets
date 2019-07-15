--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_SATELITE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_SATELITE" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABWEI IS TABLE OF BINARY_DOUBLE;
    Weight TABWEI;
    TYPE TABSIZ IS TABLE OF BINARY_DOUBLE;
    SizeOf TABSIZ;
    TYPE TABDIS IS TABLE OF VARCHAR2(255);
    Discovered TABDIS;
    TYPE TABPLA IS TABLE OF VARCHAR2(255);
    Planet TABPLA;
	qsatelite number(5);
BEGIN
	Name := TABNAM ('Moon');
    Weight := TABWEI (0.0123);
    SizeOf := TABSIZ (0.2727);
    Discovered := TABDIS (NULL);
    Planet := TABPLA ('Earth');
    qsatelite := Name.count;

	FOR i IN 1..qsatelite LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Satelite VALUES (Name(i), Weight(i), SizeOf(i), Discovered(i), Planet(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All satelites added.');

END ADD_SATELITE;

/
