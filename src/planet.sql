--------------------------------------------------------
--  File created - œroda-czerwca-13-2018   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure ADD_PLANET
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "PZAWADKA"."ADD_PLANET" IS
	TYPE TABNAM IS TABLE OF VARCHAR2(255);
	Name TABNAM;
    TYPE TABWEI IS TABLE OF BINARY_DOUBLE;
    Weight TABWEI;
    TYPE TABSIZ IS TABLE OF BINARY_DOUBLE;
    SizeOf TABSIZ;
    TYPE TABLIG IS TABLE OF BINARY_DOUBLE;
    LightYears TABLIG;
    TYPE TABHAB IS TABLE OF NUMBER(1,0);
    Habitable TABHAB;
    TYPE TABPS IS TABLE OF VARCHAR2(255);
    PlanetarySystem TABPS;
    TYPE TABDIS IS TABLE OF VARCHAR2(255);
    Discovered TABDIS;
    TYPE TABRIG IS TABLE OF VARCHAR2(255);
    RightAscension TABRIG;
    TYPE TABDEC IS TABLE OF VARCHAR2(255);
    Declination TABDEC;
    TYPE TABTYP IS TABLE OF VARCHAR2(255);
    PlanetType TABTYP;
    TYPE TABTEX IS TABLE OF CLOB;
    Text TABTEX;
    TYPE TABLET IS TABLE OF VARCHAR2(1);
    Letter TABLET;
    TYPE TABSTA IS TABLE OF VARCHAR2(1);
    StarLetter TABSTA;
    
    qplanet number(5);
    randPlanetarySystem VARCHAR2(255);
    randLightYears BINARY_DOUBLE;
    randHour INT;
    randMinute INT;
    randSecond INT;
    randRightAscension VARCHAR2(255);
    randDegree INT;
    randMinuteDegree INT;
    randDeclination VARCHAR2(255);
    randStar INT;
    randStarName VARCHAR2(255);
    randStarWeight BINARY_DOUBLE;
    randStarSizeOf BINARY_DOUBLE;
    qletters number(2);
    randHabitable NUMBER(2);
    randName VARCHAR2(255);
    randWeight BINARY_DOUBLE;
    randSizeOf BINARY_DOUBLE;
    anythingFound INT;
BEGIN
	Name := TABNAM ('Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Neptune', 'Uranus', 'Kepler', 'Gliese', 'HD', 'Cancri', 'Corot', 'MOA');
    Weight := TABWEI (0.055, 0.815, 1, 0.107, 317.83, 95.16, 14.54, 17.15);
    SizeOf := TABSIZ (0.383, 0.9499, 1, 0.532, 10.973, 9.140, 3.981, 3.865);
    LightYears := TABLIG (0.02, 0.01, 0, 0.012, 0.05, 0.07, 0.09, 0.1);
    Habitable := TABHAB (0, 0, 1, 1, 0, 0, 0, 0);
    PlanetarySystem := TABPS ('Solar System');
    Discovered := TABDIS (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    RightAscension := TABRIG (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    Declination := TABDEC (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    PlanetType := TABTYP (NULL);
    Text := TABTEX (NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
    Letter := TABLET ('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z');
    StarLetter := TABSTA ('A', 'B', 'C');
    qplanet := Name.count;

	FOR i IN 1..8 LOOP
		DBMS_OUTPUT.put_line(Name(i));
		INSERT INTO Planet VALUES (Name(i), Weight(i), SizeOf(i), LightYears(i), Habitable(i), PlanetarySystem(1), Discovered(i), RightAscension(i), Declination(i), PlanetType(1), Text(i));
	END LOOP;
    FOR i IN 9..qplanet LOOP
        FOR k IN 1..70 LOOP
            randPlanetarySystem := Name(i) || '-' || k;
            randLightYears := dbms_random.value(1,120);
            randHour := dbms_random.value(0,23);
            randMinute := dbms_random.value(0,59);
            randSecond := dbms_random.value(0,59);
            randRightAscension := randHour || 'h ' || randMinute || 'm ' || randSecond || 's';
            randDegree := dbms_random.value(-180, 180);
            randMinuteDegree := dbms_random.value(0,100);
            randDeclination := randDegree || 'd ' || randMinuteDegree || 'm';
            SELECT count(*) INTO anythingFound FROM PlanetarySystem WHERE Name = randPlanetarySystem;
            IF anythingFound = 0 THEN
                INSERT INTO PlanetarySystem VALUES (randPlanetarySystem, randRightAscension, randDeclination, randLightYears, 0, 0);
            END IF;
            randStar := dbms_random.value(1,3);
            FOR l IN 1..randStar LOOP
                randStarName := randPlanetarySystem || StarLetter(l);
                randStarWeight := dbms_random.value(1,2000)/100;
                randStarSizeOf := dbms_random.value(1,90)/10;
                SELECT count(*) INTO anythingFound FROM Star WHERE Name = randStarName;
                IF anythingFound = 0 THEN 
                    INSERT INTO Star VALUES (randStarName, randStarWeight, randStarSizeOf, randLightYears, NULL, NULL, randRightAscension, randDeclination, NULL, randPlanetarySystem); 
                END IF;
            END LOOP;
            qletters := dbms_random.value(1,26);
            FOR j IN 1..qletters LOOP
                --DBMS_OUTPUT.put_line(Name(i));
                IF randLightYears > 70 THEN randHabitable := dbms_random.value(0,1); ELSE randHabitable := 0; END IF;
                randName := randPlanetarySystem || Letter(j);
                randWeight := dbms_random.value(4,4000)/100;
                randSizeOf := dbms_random.value(200,14000)/1000;
                INSERT INTO Planet VALUES (randName, randWeight, randSizeOf, randLightYears, randHabitable, randPlanetarySystem, NULL, randRightAscension, randDeclination, NULL, NULL);
            END LOOP;
        END LOOP;
	END LOOP;
	DBMS_OUTPUT.put_line('All planets added.');

END ADD_PLANET;

/
