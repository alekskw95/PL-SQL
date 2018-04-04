Zadanie 1
Napisać blok jawny w  języku pl/sql z kursorem jawnym, umożliwiajacy wyświetlenie dla poszczególnych wydziałów 
i poszczególnych liter alfabetu, liczby osób aktualnie zatrudnionych, których imię rozpoczyna się na daną literę
w postaci następującej:
Wydział Matematyka Litera A - 5


a) z petlą prostą
DECLARE
  z_NazwaWydzialu wydzialy.nazwa%TYPE;
  z_Litera CHAR(1);
  z_LiczbaOsob INT;
  z_Liczba INT;
  z_Licznik NUMBER:=1;
  CURSOR k_dane IS
   ( SELECT initcap(w.nazwa) nazwaWydzialu, substr(initcap(o.imie1),1,1) litera, count(z.id_os) liczbaOsob
     FROM wydzialy w join zatrudnienia z on w.id_w=z.id_w join osoby o on z.id_os=o.id_os
     WHERE z.do is null
     GROUP BY initcap(w.nazwa), substr(initcap(o.imie1),1,1)
   );
BEGIN
  OPEN k_dane;
    LOOP
      FETCH k_dane INTO z_NazwaWydzialu, z_Litera, z_LiczbaOsob;
      EXIT WHEN k_dane%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE(z_Licznik||' Wydzial '||z_NazwaWydzialu||' '||'Litera '||z_Litera||' - '||z_LiczbaOsob);
      z_Licznik:=z_Licznik+1;
    END LOOP;
  CLOSE k_dane;
END;
/





b) z pętlą WHILE


DECLARE
  z_NazwaWydzialu wydzialy.nazwa%TYPE;
  z_Litera CHAR(1);
  z_LiczbaOsob INT;
  z_Liczba INT;
  z_Licznik NUMBER:=1;
  CURSOR k_dane IS
   ( SELECT initcap(w.nazwa) nazwaWydzialu, substr(initcap(o.imie1),1,1) litera, count(z.id_os) liczbaOsob
     FROM wydzialy w join zatrudnienia z on w.id_w=z.id_w join osoby o on z.id_os=o.id_os
     WHERE z.do is null
     GROUP BY initcap(w.nazwa), substr(initcap(o.imie1),1,1)
   );
BEGIN
  OPEN k_dane;
      FETCH k_dane INTO z_NazwaWydzialu, z_Litera, z_LiczbaOsob;
      WHILE k_dane%FOUND LOOP
        DBMS_OUTPUT.PUT_LINE(z_Licznik||' Wydzial '||z_NazwaWydzialu||' '||'Litera '||z_Litera||' - '||z_LiczbaOsob);
        z_Licznik:=z_Licznik+1;
        FETCH k_dane INTO z_NazwaWydzialu, z_Litera, z_LiczbaOsob;
      END LOOP;
  CLOSE k_dane;
END;
/

c) z pętlą for kursora

DECLARE
  z_Licznik NUMBER:=1;
  CURSOR k_dane IS
   ( SELECT initcap(w.nazwa) z_NazwaWydzialu, substr(initcap(o.imie1),1,1) z_Litera, count(z.id_os) z_LiczbaOsob
     FROM wydzialy w join zatrudnienia z on w.id_w=z.id_w join osoby o on z.id_os=o.id_os
     WHERE z.do is null
     GROUP BY initcap(w.nazwa), substr(initcap(o.imie1),1,1)
   );
BEGIN
  FOR z_dane IN k_dane LOOP
    DBMS_OUTPUT.PUT_LINE(z_Licznik||' Wydzial '||z_dane.z_NazwaWydzialu||' '||'Litera '||z_dane.z_Litera||' - '||z_dane.z_LiczbaOsob);
    z_Licznik:=z_Licznik+1;
  END LOOP;
END;
/



Zadanie 2
Utworzyć tabelę osoby_short o polach nazwa, id_os, nazwisko, imie1, imie2, plec, od

Napisac blok w jezyku plsql z kursorem jawnym umozliwiajacym wprowadzenie danych do tabeli osoby_short 
tych osob, które zostały najpozniej zatrudnione na kazdym z wydziałów


1) sposób
CREATE TABLE osoby_short
(
nazwa VARCHAR2(15),
id_os NUMBER(4,0),
nazwisko VARCHAR2(15),
imie1 VARCHAR2(15),
imie2 VARCHAR2(15),
plec CHAR(1),
od DATE
);

2) sposób -> zalecany
CREATE TABLE osoby_short AS
(
  SELECT w.nazwa, o.id_os, o.nazwisko, o.imie1, o.imie2, o.plec, z.od
  FROM osoby o, zatrudnienia z, wydzialy w
  WHERE o.id_os > 100
);



DECLARE 
  CURSOR k_dane IS
  (
    SELECT initcap(w.nazwa) nazwaW, o.id_os idOsoby, initcap(o.nazwisko) NazwiskoShort, initcap(o.imie1) Imie1Short, initcap(o.imie2) Imie2Short, o.plec PlecShort, z.od OdShort
    FROM wydzialy w join zatrudnienia z on w.id_w=z.id_w join osoby o on z.id_os=o.id_os
    WHERE z.od = (SELECT MAX(z1.od)
                  FROM zatrudnienia z1 join wydzialy w1 on z1.id_w=w1.id_w 
                  WHERE w1.id_w=w.id_w
                  )
  );
BEGIN
  FOR z_dane IN k_dane LOOP
    INSERT INTO osoby_short VALUES(z_dane.nazwaW, z_dane.idOsoby, z_dane.NazwiskoShort, z_dane.Imie1Short, z_dane.Imie2Short, z_dane.PlecShort, z_dane.OdShort);
  END LOOP;
END;
/



 



 