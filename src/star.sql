--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_STAR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_STAR" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABWEI IS TABLE OF BINARY_DOUBLE;
    Weight TABWEI;
    TYPE TABSIZ IS TABLE OF BINARY_DOUBLE;
    SizeOf TABSIZ;
    TYPE TABLIG IS TABLE OF BINARY_DOUBLE;
    LightYears TABLIG;
    TYPE TABDIS IS TABLE OF VARCHAR2(255);
    Discovered TABDIS;
    TYPE TABCON IS TABLE OF VARCHAR2(255);
    Constelation TABCON;
    TYPE TABRIG IS TABLE OF VARCHAR2(255);
    RightAscension TABRIG;
    TYPE TABDEC IS TABLE OF VARCHAR2(255);
    Declination TABDEC;
    TYPE TABTYP IS TABLE OF VARCHAR2(3);
    StarType TABTYP;
    TYPE TABPS IS TABLE OF VARCHAR2(255);
    PlanetarySystem TABPS;
	qstar number(5);
BEGIN
	Name := TABNAM ('Sun');
    Weight := TABWEI (1);
    SizeOf := TABSIZ (1);
    LightYears := TABLIG (0.2);
    Discovered := TABDIS (NULL);
    Constelation := TABCON (NULL);
    RightAscension := TABRIG (NULL);
    Declination := TABDEC (NULL);
    StarType := TABTYP (NULL);
    PlanetarySystem := TABPS ('Solar System');
    qstar := Name.count;

	FOR i IN 1..qstar LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Star VALUES (Name(i), Weight(i), SizeOf(i), LightYears(i), Discovered(i), Constelation(i), RightAscension(i), Declination(i), StarType(i), PlanetarySystem(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All stars added.');

END ADD_STAR;

/
