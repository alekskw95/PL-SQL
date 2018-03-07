SET SERVEROUTPUT ON


begin
DBMS_OUTPUT.PUT_LINE('Hello');
end;


Zadanie 1

Napisać kod bloku anonimowego PL/SQL, za pomocą którego bedzie można wyśwteitlić dane o osobie, 
która aktualnie pobiera największą pensję, przy czym płeć tej osoby jest podana poprzez zainicjowanie w sekcji deklaracji 
odpowiedniej zmiennej PL/SQL. Wykorzystać w deklaracji zmiennych PL/SQL deklaracje zakotwiczone.


DECLARE
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_plec osoby.plec%TYPE:='K';
  z_Zmienna zatrudnienia.pensja%TYPE;
BEGIN
  SELECT o.nazwisko, o.imie1, o.plec, z.pensja
  INTO z_Imie, z_Nazwisko, z_plec, z_Zmienna
  FROM osoby o join zatrudnienia z on o.id_os=z.id_os
  WHERE z.do is null and o.plec=z_plec and z.pensja=(SELECT MAX(z1.pensja)
                                   FROM zatrudnienia z1 join osoby o1 on z1.id_os=o1.id_os
                                   WHERE z1.do is null and z_plec=o1.plec);
  DBMS_OUTPUT.PUT_LINE(INITCAP(z_Imie)||' '||INITCAP(z_Nazwisko)||' '||z_plec||' '||z_Zmienna);
END;
/



Zadanie 2
Napisać kod bloku anonimowego PL/SQL, za pomocą którego będzie można wyświetlić dane najmłodszego kierownika w następujący sposób:
Kowalski Jan jest najmłodszym kierownikiem zatrudnionym na wydziale Matematyka.


DECLARE
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_WydzialNazwa wydzialy.nazwa%TYPE;
BEGIN
  SELECT initcap(o.imie1), initcap(o.nazwisko), w.nazwa
  INTO z_Imie, z_Nazwisko, z_WydzialNazwa
  FROM osoby o join kierownicy k on o.id_os=k.id_os join wydzialy w on w.id_w=k.id_w
  WHERE k.do is null and o.d_ur=(SELECT MAX(o1.d_ur)
                                 FROM osoby o1 join kierownicy k1 on k1.id_os=o1.id_os 
                                 WHERE k1.do is null); 
  DBMS_OUTPUT.PUT_LINE(z_Imie||' '||z_Nazwisko||' jest najmodszym kierownikiem zatrudnionym na wydziale '||initcap(z_WydzialNazwa)||'.');
END;
/



Zadanie 3
Napisać kod bloku anonimowego PL/SQL, za pomocą którego bedzie można wyświetlić nazwę wydziału na którym 
aktualnie jest zatrudnionych najwięcej osób urodzonych w 4 kwratale.

create view WydzialLiczba AS
select initcap(w.nazwa) as Wydzial, count(z.od) as Liczba
from ZATRUDNIENIA z join WYDZIALY w on z.id_w=w.id_w join OSOBY o on o.id_os=z.id_os
where z.do is null and to_char(o.d_ur,'q')='4'
group by initcap(w.nazwa);

select * from WydzialLiczba;

DECLARE
  z_WydzialNazwa wydzialy.nazwa%TYPE;
BEGIN
  SELECT w.Wydzial
  INTO z_WydzialNazwa
  FROM WydzialLiczba w
  WHERE w.Liczba=(SELECT MAX(w1.Liczba)
                                  FROM WydzialLiczba w1);  
  DBMS_OUTPUT.PUT_LINE('Wydzial zatrudniajacy najwiecej osob: '||z_WydzialNazwa);
END;
/
















