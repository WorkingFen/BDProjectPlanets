--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_OBSERVATORY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_OBSERVATORY" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABLOC IS TABLE OF VARCHAR2(255);
    Localization TABLOC;
    TYPE TABOBS IS TABLE OF VARCHAR2(255);
    ObservatoryType TABOBS;
    TYPE TABBEG IS TABLE OF VARCHAR2(255);
    BeginYear TABBEG;
    TYPE TABEND IS TABLE OF VARCHAR2(255);
    EndYear TABEND;
	qobservatory number(5);
BEGIN
	Name := TABNAM ('ISS');
	Localization := TABLOC ('36,9279d, 0,0003041');
    ObservatoryType := TABOBS ('Space observatory');
    BeginYear := TABBEG (1998);
    EndYear := TABEND (NULL);
    qobservatory := Name.count;

	FOR i IN 1..qobservatory LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Observatory VALUES (Name(i), Localization(i), ObservatoryType(i), BeginYear(i), EndYear(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All observatories added.');

END ADD_OBSERVATORY;

/
