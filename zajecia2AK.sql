Zadanie 1
Dla poszczególnych wydziałów, wyświetlić średnią z aktualnie zarobionych pensji, przy czym nie wyświetlać wydziału (ów), na którym średnia ta jest największa.


create view WydzialPensja AS
select w.nazwa as Wydzial, ROUND(AVG(z.pensja)) as Pensja
from ZATRUDNIENIA z join WYDZIALY w on z.id_w=w.id_w
where z.do is null
group by w.nazwa
order by nazwa ASC;

select * from WydzialPensja;

select INITCAP(wydzial), pensja 
from WydzialPensja
where pensja < (select MAX(pensja)
from WydzialPensja);

II opcja:
with sredniawydzialu as(
select w.nazwa, avg(pensja) as srednia
from wydzialy w join zatrudnienia z on w.id_w=z.id_w
where z.do is null
group by w.nazwa)

select INITCAP(wydzial), pensja 
from sredniawydzialu
where srednia <> (select MAX(srednia)
from sredniawydzialu);

III opcja:
SELECT nazwa, srednia
FROM sredniawydzialu
ORDER BY 2 DESC
MINUS
SELECT nazwa, srednia
FROM sredniawydzialu
WHERE srednia=(SELECT MAX(srednia) FROM sredniawydzialu);


Zadanie 2
Dla poszczególnych wydziałów, wyświetlić średnią z aktualnie zarobionych pensji, przy czym nie wyświetlać wydziałów, na których są dwie największe średnie.

select INITCAP(wydzial) as Wydzial, pensja 
from WydzialPensja
where pensja < (select MAX(pensja) 
                from WydzialPensja
                where pensja < (select MAX(pensja)
                                from WydzialPensja))
ORDER BY 2 ASC;


II sposob:

WITH srednia_pensja2 AS
(SELECT nazwa, srednia
FROM srednia_wydzialu
MINUS
SELECT nazwa, srednia
FROM srednia_wydzialu
WHERE srednia=(SELECT MAX(srednia) FROM srednia_wydzialu))
select nazwa, srednia
from srednia_pesnja2
MINUS 
select nazwa, srednia
from srednia_pesnja2
where srednia >(select max(srednia) from srednia_pesdnja2)

III sposob -> Ania Rokicka


Zadanie 3
Jak poprzednie ale wyrzucic 3. Do domu.


Zadanie 4 do domu
Wyswietlic osoby wraz z dlugoscia ich imienia bez osoby o najdluzszym imieniu. O dwoch najdluzszych i o 3 najdluzszych.


Zadanie 5 PL/SQL

Napisać kod bloku anonimowego w jezyku PL/SQL za pomocą którego z tabeli osoby, bedzie można wyświetlić dane osoby o danym nazwisku i imieniu. np. Lis, Jan, któe zostaną podane poprzez zainicjowanie odpowiednich zmiennych PL/SQL-owych w sekcji deklaracji bloku. 

DECLARE
  z_Imie VARCHAR2(30):='Jan';
  z_Nazwisko VARCHAR2(30):='Lis';
  z_plec CHAR(1);
  z_DataUr DATE;
  z_idOs  NUMBER;
BEGIN
  SELECT o.nazwisko, o.imie1, o.plec, o.d_ur, o.id_os
  INTO z_Imie, z_Nazwisko, z_plec, z_DataUr, z_idOs
  FROM osoby o
  WHERE initcap(o.imie1)=z_Imie and initcap(o.nazwisko)=z_Nazwisko;
  DBMS_OUTPUT.PUT_LINE(INITCAP(z_Imie)||' '||z_Nazwisko||' '||z_plec||' '||z_DataUr||' '||z_idOs);
END;
/



