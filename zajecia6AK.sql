Zadanie 1
Napisać kod bloku anonimowego w jezyku PL/SQL takiego, który dla kazdej osoby z tabeli osoby wyswietli nastepujacy komunikat:
1. Duda Barbara ma inicjały D.B.
2. Krawczyk Adam ma inicjaly K.A.

a) wykorzystac petle prosta
b) wykorzystac petle while

wykorzystac kursor nie jawny


a) pętla prosta 
DECLARE
  SUBTYPE inicjal IS CHAR(1);
  t_OsobaI inicjal;
  t_OsobaN inicjal;
  z_Licznik BINARY_INTEGER:=1;
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_LiczbaOsob INT;
BEGIN
  SELECT count(id_os)
  INTO z_LiczbaOsob
  FROM osoby;
  LOOP
    SELECT initcap(o.imie1), initcap(o.nazwisko), substr(initcap(o.imie1),1,1), substr(initcap(o.nazwisko),1,1)
    INTO z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN
    FROM osoby o
    where o.id_os=z_Licznik;
    DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||z_Imie||' '||z_Nazwisko||' ma inicjaly '||t_OsobaI||'. '||t_OsobaN||'.');
    z_Licznik:=z_Licznik+1;
	EXIT WHEN z_LiczbaOsob < z_Licznik;
  
  END LOOP;
END;
/

b) pętla WHILE
DECLARE
  SUBTYPE inicjal IS CHAR(1);
  t_OsobaI inicjal;
  t_OsobaN inicjal;
  z_Licznik BINARY_INTEGER:=1;
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_LiczbaOsob INT;
BEGIN
  SELECT count(id_os)
  INTO z_LiczbaOsob
  FROM osoby;
  WHILE z_Licznik <= z_LiczbaOsob LOOP
    SELECT initcap(o.imie1), initcap(o.nazwisko), substr(initcap(o.imie1),1,1), substr(initcap(o.nazwisko),1,1)
    INTO z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN
    FROM osoby o
    where o.id_os=z_Licznik;
    DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||z_Imie||' '||z_Nazwisko||' ma inicjaly '||t_OsobaI||'. '||t_OsobaN||'.');
    z_Licznik:=z_Licznik+1;
  END LOOP;
END;
/


c) pętla prosta z kursorem jawnym
DECLARE
  SUBTYPE inicjal IS CHAR(1);
  t_OsobaI inicjal;
  t_OsobaN inicjal;
  z_Licznik BINARY_INTEGER:=1;
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_LiczbaOsob INT;
  CURSOR k_dane IS
    SELECT initcap(o.imie1), initcap(o.nazwisko), substr(initcap(o.imie1),1,1), substr(initcap(o.nazwisko),1,1)
    FROM osoby o;
BEGIN
  SELECT count(id_os)
  INTO z_LiczbaOsob
  FROM osoby; 
  
  OPEN k_dane;
    LOOP
      FETCH k_dane INTO z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN;
      DBMS_OUTPUT.PUT_LINE(z_Licznik||' '||z_Imie||' '||z_Nazwisko||' ma inicjaly '||t_OsobaI||'. '||t_OsobaN||'.');
      z_Licznik:=z_Licznik+1;
	  IF z_Licznik > z_LiczbaOsob THEN EXIT;
	  END IF;
    END LOOP;
  CLOSE k_dane;
END;
/

d) petla for z kursorem jawnym

DECLARE
  CURSOR k_dane IS
    SELECT o.id_os z_Id, initcap(o.imie1) z_imie, initcap(o.nazwisko) z_nazwisko, substr(initcap(o.imie1),1,1) z_litera1, substr(initcap(o.nazwisko),1,1) z_litera2
    FROM osoby o;
BEGIN
  FOR z_dane IN k_dane LOOP
    DBMS_OUTPUT.PUT_LINE(z_dane.z_Id||'. '||z_dane.z_imie||' '||z_dane.z_nazwisko||' ma inicjaly '||z_dane.z_litera1||'. '||z_dane.z_litera2||'.');
  END LOOP;
END;
/


e) pętla while z kursorem jawnym
DECLARE
  SUBTYPE inicjal IS CHAR(1);
  t_OsobaI inicjal;
  t_OsobaN inicjal;
  z_Licznik BINARY_INTEGER:=1;
  z_Licznik2 binary_integer :=0;
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_LiczbaOsob INT;
  CURSOR k_dane IS
    SELECT o.id_os, initcap(o.imie1) imie, initcap(o.nazwisko) nazwisko, substr(initcap(o.imie1),1,1) litera1, substr(initcap(o.nazwisko),1,1) litera2
    FROM osoby o;
BEGIN
  SELECT count(id_os)
  INTO z_LiczbaOsob
  FROM osoby; 
  OPEN k_dane;
      FETCH k_dane INTO z_Licznik2, z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN;
      WHILE k_dane%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||z_Imie||' '||z_Nazwisko||'ma inicjaly '||t_OsobaI||'. '||t_OsobaN||'.');
        z_Licznik:=z_Licznik+1;
        FETCH k_dane INTO z_Licznik2, z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN;
      END LOOP;
  CLOSE k_dane;
END;
/












