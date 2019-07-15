--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_LOCALIZATION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_LOCALIZATION" IS
	TYPE TABPLA IS TABLE OF VARCHAR2(255);
	Place TABPLA;
    TYPE TABCOU IS TABLE OF VARCHAR2(255);
    Country TABCOU;
    TYPE TABLOC IS TABLE OF VARCHAR2(255);
    Location TABLOC;
	qlocalization number(5);
BEGIN
	Place := TABPLA ('Washington DC.', 'Moscow', 'Tokyo', '7.67km/s orbit');
	Country := TABCOU ('USA', 'Russia', 'Japan', NULL);
    Location := TABLOC ('38d 52m 58.5sN,77d 00m 59.3sW', '55d 46m 59.7sN, 37d 37m 49.4sE', '35d 41m 55.0sN, 139d 45m 59.2sE', '36,9279d, 0,0003041');
    qlocalization := Place.count;

	FOR i IN 1..qlocalization LOOP
		DBMS_OUTPUT.put_line(Place(i));
		INSERT INTO Localization VALUES (Place(i), Country(i), Location(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All localizations added.');

END ADD_LOCALIZATION;

/
