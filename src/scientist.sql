--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_SCIENTIST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_SCIENTIST" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABSUR IS TABLE OF VARCHAR2(255);
    Surname TABSUR;
    TYPE TABORG IS TABLE OF VARCHAR2(255);
    Organization TABORG;
    TYPE TABOBS IS TABLE OF VARCHAR2(255);
    Observatory TABOBS;
	qscientist number(5);
BEGIN
	Name := TABNAM ('Ricky', 'Oleg', 'Drew', 'Norishige', 'Anton', 'Scott', 'Mikolaj');
	Surname := TABSUR ('Arnold', 'Artemyev', 'Feustel', 'Kanai', 'Shkaplerov', 'Tingle', 'Kopernik');
    Organization := TABORG ('NASA', 'Roskosmos', 'NASA', 'JAXA', 'Roskosmos', 'NASA', NULL);
    Observatory := TABOBS ('ISS', 'ISS', 'ISS', 'ISS', 'ISS', 'ISS' , NULL);
    qscientist := Name.count;

	FOR i IN 1..qscientist LOOP
		DBMS_OUTPUT.put_line(i||', '||Name(i)||', '||Surname(i)||', '||Organization(i)||', '||Observatory(i));
		INSERT INTO Scientist VALUES (NULL, Name(i), Surname(i), Organization(i), Observatory(i));
	END LOOP;
	DBMS_OUTPUT.put_line('All scientists added.');

END ADD_SCIENTIST;

/
