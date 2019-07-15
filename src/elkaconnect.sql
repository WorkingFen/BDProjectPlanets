------------------------------Resetowanie tabel--------------------------------
-------------------------------------------------------------------------------
DROP TABLE Satelite CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE Planet CASCADE CONSTRAINTS;
DROP TRIGGER PlanetType_Trg;
DROP TRIGGER PlanetForSystem_Trg;
-------------------------------------------------------------------------------
DROP TABLE Star CASCADE CONSTRAINTS;
DROP TRIGGER StarType_Trg;
DROP TRIGGER StarForSystem_Trg;
-------------------------------------------------------------------------------
DROP TABLE PlanetarySystem CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE BlackHole CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE Constelation CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE Scientist CASCADE CONSTRAINTS;
DROP SEQUENCE ScientistSeq;
-------------------------------------------------------------------------------
DROP TABLE Organization CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE Observatory CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE Localization CASCADE CONSTRAINTS;
-------------------------------------------------------------------------------
DROP TABLE NearbyPlanet CASCADE CONSTRAINTS;
DROP TRIGGER NearbyPlanet_Trg;
-------------------------------------------------------------------------------
DROP TABLE HabitablePlanet CASCADE CONSTRAINTS;
DROP TRIGGER HabitablePlanet_Trg;

------------------------------Ustawianie sesji---------------------------------
-------------------------------------------------------------------------------
SET serveroutput ON format WRAPPED;
SET DEFINE OFF;
ALTER SESSION SET nls_date_format = 'DD/MM/YYYY';

------------------------------Dodawanie tabel----------------------------------
-------------------------------------------------------------------------------
CREATE TABLE Planet(
    Name varchar(255) PRIMARY KEY,
    Weight BINARY_DOUBLE,   --W skali Ziemi, czyli Ziemia = 1; Masa
    SizeOf BINARY_DOUBLE,   --W skali Ziemi, czyli Ziemia = 1; Promien
    LightYears BINARY_DOUBLE NOT NULL,
    Habitable NUMBER(1),    --1 jako tak, 0 jako nie
    PlanetarySystem varchar(255),
    Discovered varchar(255),
    RightAscension varchar(255),
    Declination varchar(255),
    PlanetType varchar(255),    --Ustawia sie automatycznie
    Text CLOB
);
-------------------------------------------------------------------------------
CREATE TABLE Star(
    Name varchar(255) PRIMARY KEY,
    Weight binary_double,   --W skali Slonca, czyli Slonce = 1; Masa
    SizeOf binary_double,   --W skali Slonca, czyli Slonce = 1; Promien
    LightYears binary_double NOT NULL,
    Discovered varchar(255),
    Constelation varchar(255),
    RightAscension varchar(255),
    Declination varchar(255),
    StarType varchar(3),    --Ustawia sie automatycznie
    PlanetarySystem varchar(255)
);
-------------------------------------------------------------------------------
CREATE TABLE Constelation(
    Name varchar(255) PRIMARY KEY,
    RightAscension varchar(255) NOT NULL,
    Declination varchar(255) NOT NULL
);
-------------------------------------------------------------------------------
CREATE TABLE Observatory(
    Name varchar(255) PRIMARY KEY,
    Localization varchar(255) NOT NULL,
    ObservatoryType varchar(255) NOT NULL,
    BeginYear varchar(255),
    EndYear varchar(255)
);
-------------------------------------------------------------------------------
CREATE TABLE BlackHole(
    Name varchar(255) PRIMARY KEY,
    Weight binary_double,
    SizeOf binary_double,
    LightYears binary_double NOT NULL,
    Discovered varchar(255) NOT NULL
);
-------------------------------------------------------------------------------
CREATE TABLE Scientist(
    ID int NOT NULL, 
    Name varchar2(255) NOT NULL,
    Surname varchar2(255),
    Organization varchar2(255),
    Observatory varchar2(255),
    CONSTRAINT Scientist_PK PRIMARY KEY(ID) USING INDEX
);
CREATE SEQUENCE ScientistSeq START WITH 1 INCREMENT BY 1 NOMAXVALUE;
CREATE INDEX Scientist_Idx ON Scientist(Name);

CREATE OR REPLACE TRIGGER Scientist_ID_Trg
BEFORE INSERT ON Scientist
FOR EACH ROW
BEGIN
  SELECT ScientistSeq.nextval INTO :new.ID FROM dual;
END;
/
-------------------------------------------------------------------------------
CREATE TABLE Organization(
    Name varchar(255) PRIMARY KEY,
    Localization varchar(255) NOT NULL
);
-------------------------------------------------------------------------------
CREATE TABLE Localization(
    Place varchar(255) NOT NULL,
    Country varchar(255),
    Location varchar(255) PRIMARY KEY
);
-------------------------------------------------------------------------------
CREATE TABLE PlanetarySystem(
    Name varchar(255) PRIMARY KEY,
    RightAscension varchar(255),
    Declination varchar(255),
    LightYears binary_double NOT NULL,
    NoStars int NOT NULL,
    NoPlanets int NOT NULL
);
-------------------------------------------------------------------------------
CREATE TABLE Satelite(
    Name varchar(255) PRIMARY KEY,
    Weight binary_double,
    SizeOf binary_double,
    Discovered varchar(255),
    Planet varchar(255) NOT NULL
);

--------------------------Dodawanie kluczy obcych------------------------------
-------------------------------------------------------------------------------
ALTER TABLE Planet
ADD FOREIGN KEY (PlanetarySystem) REFERENCES PlanetarySystem(Name);
ALTER TABLE Planet
ADD FOREIGN KEY (Discovered) REFERENCES Observatory(Name);
-------------------------------------------------------------------------------
ALTER TABLE Satelite
ADD FOREIGN KEY (Planet) REFERENCES Planet(Name);
ALTER TABLE Satelite
ADD FOREIGN KEY (Discovered) REFERENCES Observatory(Name);
-------------------------------------------------------------------------------
ALTER TABLE Star
ADD FOREIGN KEY (Discovered) REFERENCES Observatory(Name);
ALTER TABLE Star
ADD FOREIGN KEY (Constelation) REFERENCES Constelation(Name);
ALTER TABLE Star
ADD FOREIGN KEY (PlanetarySystem) REFERENCES PlanetarySystem(Name);
-------------------------------------------------------------------------------
ALTER TABLE Observatory
ADD FOREIGN KEY (Localization) REFERENCES Localization(Location);
-------------------------------------------------------------------------------
ALTER TABLE BlackHole
ADD FOREIGN KEY (Discovered) REFERENCES Observatory(Name);
-------------------------------------------------------------------------------
ALTER TABLE Scientist
ADD FOREIGN KEY (Organization) REFERENCES Organization(Name);
ALTER TABLE Scientist
ADD FOREIGN KEY (Observatory) REFERENCES Observatory(Name);
-------------------------------------------------------------------------------
ALTER TABLE Organization
ADD FOREIGN KEY (Localization) REFERENCES Localization(Location);

-------------------------Dodawanie triggerow-----------------------------------
-------------------------------------------------------------------------------
CREATE TABLE NearbyPlanet (
    name varchar(255) NOT NULL,
    LightYears BINARY_DOUBLE NOT NULL
);
ALTER TABLE NearbyPlanet
ADD FOREIGN KEY (name) REFERENCES Planet(Name);

CREATE OR REPLACE TRIGGER NearbyPlanet_Trg
  FOR INSERT OR UPDATE OR DELETE ON Planet
  COMPOUND TRIGGER
  AFTER EACH ROW IS
  BEGIN
    CASE
      WHEN INSERTING THEN
        BEGIN
            IF :new.LightYears < 18 THEN
                INSERT INTO NearbyPlanet (name, LightYears) VALUES (:new.name, :new.LightYears);
            END IF;
        END;
      WHEN UPDATING THEN
        BEGIN
            IF :old.LightYears >= 18 AND :new.LightYears < 18 THEN
                INSERT INTO NearbyPlanet (name, LightYears) VALUES (:new.name, :new.LightYears);
            ELSIF :old.LightYears < 18 AND :new.LightYears < 18 THEN
                BEGIN
                    DELETE FROM NearbyPlanet WHERE Name=:old.Name;
                    INSERT INTO NearbyPlanet (name, LightYears) VALUES (:new.name, :new.LightYears); 
                END;
            ELSIF :old.LightYears < 18 AND :new.LightYears >= 18 THEN
                DELETE FROM NearbyPlanet WHERE Name=:old.Name;
            END IF;
        END;
      WHEN DELETING THEN
        DELETE FROM NearbyPlanet WHERE Name=:old.Name;
    END CASE;
  END AFTER EACH ROW;
END;
/
-------------------------------------------------------------------------------
CREATE TABLE HabitablePlanet (
    name varchar(255) NOT NULL,
    LightYears BINARY_DOUBLE NOT NULL
);
ALTER TABLE HabitablePlanet
ADD FOREIGN KEY (name) REFERENCES Planet(Name);

CREATE OR REPLACE TRIGGER HabitablePlanet_Trg
  FOR INSERT OR UPDATE OR DELETE ON Planet
  COMPOUND TRIGGER
  AFTER EACH ROW IS
  BEGIN
    CASE
      WHEN INSERTING THEN
        BEGIN
            IF :new.Habitable = 1 THEN
                INSERT INTO HabitablePlanet (name, LightYears) VALUES (:new.name, :new.LightYears);
            END IF;
        END;
      WHEN UPDATING THEN
        BEGIN
            IF :old.Habitable = 0 AND :new.Habitable = 1 THEN
                INSERT INTO HabitablePlanet (name, LightYears) VALUES (:new.name, :new.LightYears);
            ELSIF :old.Habitable = :new.Habitable THEN
                BEGIN
                    DELETE FROM HabitablePlanet WHERE Name=:old.Name;
                    INSERT INTO HabitablePlanet (name, LightYears) VALUES (:new.name, :new.LightYears);
                END;
            ELSIF :old.Habitable = 1 AND :new.Habitable = 0 THEN
                DELETE FROM HabitablePlanet WHERE Name=:old.Name;
            END IF;
        END;
      WHEN DELETING THEN
        DELETE FROM HabitablePlanet WHERE Name=:old.Name;
    END CASE;
  END AFTER EACH ROW;
END;
/
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER PlanetType_Trg
BEFORE INSERT ON Planet
FOR EACH ROW
BEGIN
    IF ((:new.Weight/(:new.SizeOf*:new.SizeOf*:new.SizeOf*4/3*3.14)) >= 0.15 AND (:new.Weight/(:new.SizeOf*:new.SizeOf*:new.SizeOf*4/3*3.14)) <= 0.4) THEN
        :new.PlanetType := 'Rock Planet'; 
    ELSIF (:new.Weight/(:new.SizeOf*:new.SizeOf*:new.SizeOf*4/3*3.14)) < 0.15 THEN
        :new.PlanetType := 'Gas Giant';
    ELSE
        :new.PlanetType := 'Unknown Type';
    END IF;
END;
/
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER StarType_Trg
BEFORE INSERT ON Star
FOR EACH ROW
BEGIN
    IF :new.SizeOf >= 6.6 THEN
        :new.StarType := 'c'; 
    ELSIF :new.SizeOf < 6.6 AND :new.SizeOf >= 1.4 THEN
        :new.StarType := 'g';
    ELSIF :new.SizeOf < 1.4 AND :new.SizeOf >= 0.96 THEN
        :new.StarType := 'sg';
    ELSIF :new.SizeOf < 0.96 AND :new.SizeOf >= 0.5 THEN
        :new.StarType := 'w';
    ELSIF :new.SizeOf < 0.5 AND :new.SizeOf >= 0.21 THEN
        :new.StarType := 'd';
    ELSIF :new.SizeOf < 0.21 THEN
        :new.StarType := 'sd';
    END IF;
    IF :new.Weight >= 16 THEN
        :new.StarType := (:new.StarType||'O');
    ELSIF :new.Weight < 16 AND :new.Weight >= 2.1 THEN
        :new.StarType := (:new.StarType||'B');
    ELSIF :new.Weight < 2.1 AND :new.Weight >= 1.4 THEN
        :new.StarType := (:new.StarType||'A');
    ELSIF :new.Weight < 1.4 AND :new.Weight >= 1.04 THEN
        :new.StarType := (:new.StarType||'F');
    ELSIF :new.Weight < 1.04 AND :new.Weight >= 0.8 THEN
        :new.StarType := (:new.StarType||'G');
    ELSIF :new.Weight < 0.8 AND :new.Weight >= 0.45 THEN
        :new.StarType := (:new.StarType||'K');
    ELSIF :new.Weight < 0.45 AND :new.Weight >= 0.08 THEN
        :new.StarType := (:new.StarType||'M');
    ELSIF :new.Weight < 0.08 AND :new.Weight >= 0.06 THEN
        :new.StarType := (:new.StarType||'L');
    ELSIF :new.Weight < 0.06 AND :new.Weight >= 0.03 THEN
        :new.StarType := (:new.StarType||'T');
    ELSIF :new.Weight < 0.03 THEN
        :new.StarType := (:new.StarType||'Y');
    END IF;
END;
/
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER PlanetForSystem_Trg
  FOR INSERT OR UPDATE OR DELETE ON Planet
  COMPOUND TRIGGER
  BEFORE EACH ROW IS
  BEGIN
    CASE
      WHEN INSERTING THEN
        UPDATE PlanetarySystem SET NoPlanets=NoPlanets+1 WHERE PlanetarySystem.Name=:new.PlanetarySystem;
      WHEN UPDATING THEN
        BEGIN
            UPDATE PlanetarySystem SET NoPlanets=NoPlanets-1 WHERE PlanetarySystem.Name=:old.PlanetarySystem;
            UPDATE PlanetarySystem SET NoPlanets=NoPlanets+1 WHERE PlanetarySystem.Name=:new.PlanetarySystem;
        END;
      WHEN DELETING THEN
        UPDATE PlanetarySystem SET NoPlanets=NoPlanets-1 WHERE PlanetarySystem.Name=:old.PlanetarySystem;
    END CASE;
  END BEFORE EACH ROW;
END;
/
--Sprawdzanie dzialania triggera
--EXEC ADD_PLANET;
--DELETE FROM Planet WHERE Planet.Name = 'Uranus';
--UPDATE Planet SET PlanetarySystem='Solar System' WHERE Planet.Name='Uranus';
-------------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER StarForSystem_Trg
  FOR INSERT OR UPDATE OR DELETE ON Star
  COMPOUND TRIGGER
  BEFORE EACH ROW IS
  BEGIN
    CASE
      WHEN INSERTING THEN
        UPDATE PlanetarySystem SET NoStars=NoStars+1 WHERE PlanetarySystem.Name=:new.PlanetarySystem;
      WHEN UPDATING THEN
        BEGIN
            UPDATE PlanetarySystem SET NoStars=NoStars-1 WHERE PlanetarySystem.Name=:old.PlanetarySystem;
            UPDATE PlanetarySystem SET NoStars=NoStars+1 WHERE PlanetarySystem.Name=:new.PlanetarySystem;
        END;
      WHEN DELETING THEN
        UPDATE PlanetarySystem SET NoStars=NoStars-1 WHERE PlanetarySystem.Name=:old.PlanetarySystem;
    END CASE;
  END BEFORE EACH ROW;
END;
/
--EXEC ADD_STAR;
--DELETE FROM Star WHERE Star.Name = 'Sun';
--UPDATE Star SET PlanetarySystem='Solar System' WHERE Star.Name='Sun';

--Trigger wymuszajacy wpisanie danych jesli ich nie ma?
--create or replace trigger Planet_Trg_

-------------------------Dodawanie wartosci do tabel---------------------------
-------------------------------------------------------------------------------
EXEC ADD_LOCALIZATION;
--INSERT INTO Localization VALUES(Place, Country, Location);

EXEC ADD_OBSERVATORY;
--INSERT INTO Observatory VALUES(Name, Localization, ObservatoryType, BeginYear, EndYear);

EXEC ADD_ORGANIZATION;
--INSERT INTO Organization VALUES(Name, Localization);

EXEC ADD_SCIENTIST;
--INSERT INTO Scientist VALUES(ID, Name, Surname, Organization, Observatory);

EXEC ADD_CONSTELATION;
--INSERT INTO Constelation VALUES(Name, RightAscension, Declination);

EXEC ADD_BLACKHOLE;
--INSERT INTO BlackHole VALUES(Name, Weight, SizeOf, LightYears, Discovered);

EXEC ADD_PLANETARYSYSTEM;
--INSERT INTO PlanetarySystem VALUES(Name, RightAscension, Declination, LightYears, NoStars, NoPlanets);

EXEC ADD_STAR;
--INSERT INTO Star VALUES(Name, Weight, SizeOf, LightYears, Discovered, Constelation, RightAscension, Declination, StarType, PlanetarySystem);

EXEC ADD_PLANET;
--INSERT INTO Planet VALUES(Name, Weight, SizeOf, LightYears, Habitable, PlanetarySystem, Discovered, RightAscension, Declination, PlanetType, Text);

EXEC ADD_SATELITE;
--INSERT INTO Satelite VALUES(Name, Weight, SizeOf, Discovered, Planet);

--DELETE FROM Planet;

-------------------------Dodawanie indeksow do tabel---------------------------
-------------------------------------------------------------------------------
EXECUTE DBMS_STATS.GATHER_TABLE_STATS ('pzawadka','Planet');

DROP INDEX PlanetIndex1;
CREATE INDEX PlanetIndex1 ON Planet(Weight);
DROP INDEX PlanetIndex2;
CREATE INDEX PlanetIndex2 ON Planet(Weight, SizeOf, PlanetarySystem);
DROP INDEX PlanetIndex3;
CREATE INDEX PlanetIndex3 ON Planet(Weight, LightYears);
DROP INDEX PlanetIndex4;
CREATE INDEX PlanetIndex4 ON Planet(Name);

ALTER INDEX PlanetIndex1 VISIBLE;
ALTER INDEX PlanetIndex2 VISIBLE;
ALTER INDEX PlanetIndex3 VISIBLE;
ALTER INDEX PlanetIndex4 VISIBLE;

-- index fast full scan po indeksie PlanetIndex1 
explain plan for
select Weight from Planet where Weight > 40 order by 1;
select * from table (dbms_xplan.display);
select count(*)/5738 from Planet where Weight > 40 order by 1;

-- table access full
explain plan for
select Name from Planet where (Weight between 23 and 25) AND (SizeOf between 9 and 11) AND (PlanetarySystem = 'Kepler-1');
select * from table (dbms_xplan.display);
select count(*)/5738 from Planet where (Weight between 23 and 25) AND (SizeOf between 9 and 11) AND (PlanetarySystem = 'Kepler-1');

-- table access full
explain plan for
select * from Planet where (Name between 'A' and 'D');
select * from table (dbms_xplan.display);
select count(*)/5738 from Planet where Name between 'A' and 'D';

-- index fast full scan po indeksie PlanetIndex3 
explain plan for
select Weight from Planet order by 1;
select * from table (dbms_xplan.display);
select count(*)/5738 from Planet order by 1;

-------------------------Dodawanie hintow do tabel-----------------------------
-------------------------------------------------------------------------------
DROP INDEX planetidx1;
CREATE INDEX planetidx1 ON Planet(Name);
DROP INDEX planetidx2;
CREATE INDEX planetidx2 ON Planet(SizeOf);
DROP INDEX planetidx3;
CREATE INDEX planetidx3 ON Planet(LightYear);
DROP INDEX planetidx4;
CREATE INDEX planetidx4 ON Planet(PlanetType);
DROP INDEX planetidx5;
CREATE INDEX planetidx5 ON Planet(Name, LightYear);

EXECUTE dbms_stats.gather_table_stats ('pzawadka','Planet');
EXECUTE dbms_stats.gather_table_stats ('pzawadka','HabitablePlanet');

--hash join
ALTER INDEX planetidx1 VISIBLE;
ALTER INDEX planetidx2 VISIBLE;
ALTER INDEX planetidx3 VISIBLE;
ALTER INDEX planetidx4 VISIBLE;
ALTER INDEX planetidx5 VISIBLE;

EXPLAIN PLAN FOR
select B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);

--hash join with index 1 po zablokowaniu indeksow 5 i 3
ALTER INDEX planetidx1 VISIBLE;
ALTER INDEX planetidx2 VISIBLE;
ALTER INDEX planetidx3 INVISIBLE;
ALTER INDEX planetidx4 VISIBLE;
ALTER INDEX planetidx5 INVISIBLE;

EXPLAIN PLAN FOR
select B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);

--hash join po PLANET po hincie ordered
ALTER INDEX planetidx1 INVISIBLE;
ALTER INDEX planetidx2 INVISIBLE;
ALTER INDEX planetidx3 INVISIBLE;
ALTER INDEX planetidx4 INVISIBLE;
ALTER INDEX planetidx5 INVISIBLE;

EXPLAIN PLAN FOR
select /*+ ordered */ B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);

EXPLAIN PLAN FOR
select /*+ ordered */ B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);

EXPLAIN PLAN FOR
select /*+ use_merge(A,B) */ B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);

EXPLAIN PLAN FOR
select /*+ LEADING(A B) USE_NL(A) INDEX(A,B planetidx1) USE_MERGE(B) FULL(A,B) */ B.Name, B.LightYears, A.Name, A.LightYears
from Planet A, HabitablePlanet B
where B.LightYears = A.LightYears
and B.Name = A.Name;
select *
from table (dbms_xplan.display);