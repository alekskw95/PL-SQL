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
with srednia_wydzialu as (
select w.nazwa as nazwa, avg(pensja) as srednia  from wydzialy w 
join zatrudnienia z on w.ID_W=z.ID_W
where z.do is null
group by w.nazwa)
select initcap(sw.nazwa) as nazwa, round(sw.srednia,2) as srednia from srednia_wydzialu sw
where srednia <> (select max(srednia) from srednia_wydzialu)
order by sw.nazwa; 

III opcja:
SELECT wydzial, pensja
FROM wydzialpensja
MINUS
SELECT wydzial, pensja
FROM wydzialpensja
WHERE pensja=(SELECT MAX(pensja) FROM wydzialpensja);

IV opcja:
with srednia_wydzialu as (
select w.nazwa as nazwa, avg(pensja) as srednia  from wydzialy w 
join zatrudnienia z on w.ID_W=z.ID_W
where z.do is null
group by w.nazwa)
select initcap(sw.nazwa) as nazwa, round(sw.srednia,2) as srednia from srednia_wydzialu sw
minus
select initcap(sw.nazwa) as nazwa, round(sw.srednia,2) as srednia from srednia_wydzialu sw
where srednia = (select max(srednia) from srednia_wydzialu)
order by srednia desc;

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
(SELECT wydzial, pensja
FROM wydzialpensja
MINUS
SELECT wydzial, pensja
FROM wydzialpensja
WHERE pensja=(SELECT MAX(pensja) FROM wydzialpensja))
select wydzial, pensja
from srednia_pensja2
MINUS 
select wydzial, pensja
from srednia_pensja2
where pensja >(select max(pensja) from srednia_pensja2);

III sposob -> Ania Rokicka


Zadanie 3
select INITCAP(wydzial) as Wydzial, pensja 
from WydzialPensja
where pensja < (select MAX(pensja) 
                from WydzialPensja
                where pensja < (select MAX(pensja)
                                from WydzialPensja
                                where pensja < (select MAX(pensja)
                                from WydzialPensja)
                                )
                )
ORDER BY 2 ASC;




Zadanie 4 do domu
Wyswietlic osoby wraz z dlugoscia ich imienia bez osoby o najdluzszym imieniu. O dwoch najdluzszych i o 3 najdluzszych.

create view DlugoscImie AS
select initcap(imie1) as imie, LENGTH(imie1) as dlugosc
from Osoby
group by initcap(imie1), LENGTH(imie1) 
order by 1 ASC;

select * from DLUGOSCIMIE;

Bez osoby o najdłuższym imieniu:
select imie, dlugosc 
from DlugoscImie
where dlugosc < (select MAX(dlugosc)
from DlugoscImie);

Bez dwóch osób o najdłuższym imieniu:
select imie, dlugosc 
from DlugoscImie
where dlugosc < (select MAX(dlugosc)
                from DlugoscImie
                where dlugosc < (select MAX(dlugosc)
                                 from DlugoscImie
                                 )
               );

			   
			   
Bez trzech osób o najdluższym imieniu:			   
select imie, dlugosc 
from DlugoscImie
where dlugosc < (select MAX(dlugosc)
                from DlugoscImie
                where dlugosc < (select MAX(dlugosc)
                                 from DlugoscImie
                                 where dlugosc < (select MAX(dlugosc)
                                                  from DlugoscImie)    
                                )
               );
			   
			   
			   
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



