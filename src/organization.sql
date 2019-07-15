--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_ORGANIZATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_ORGANIZATION" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABLOC IS TABLE OF VARCHAR2(255);
    Localization TABLOC;
	qorganization number(5);
BEGIN
	Name := TABNAM ('NASA', 'Roskosmos', 'JAXA');
	Localization := TABLOC ('38d 52m 58.5sN,77d 00m 59.3sW', '55d 46m 59.7sN, 37d 37m 49.4sE', '35d 41m 55.0sN, 139d 45m 59.2sE');
    qorganization := Name.count;

	FOR i IN 1..qorganization LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Organization VALUES (Name(i), Localization(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All organizations added.');

END ADD_ORGANIZATION;

/
