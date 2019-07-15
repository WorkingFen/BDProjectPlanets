--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_BLACKHOLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_BLACKHOLE" IS
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
	qblackhole number(5);
BEGIN
	Name := TABNAM ();
    Weight := TABWEI ();
    SizeOf := TABSIZ ();
    LightYears := TABLIG ();
    Discovered := TABDIS ();
    qblackhole := Name.count;

	FOR i IN 1..qblackhole LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO BlackHole VALUES (Name(i), Weight(i), SizeOf(i), LightYears(i), Discovered(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All blackholes added.');

END ADD_BLACKHOLE;

/
