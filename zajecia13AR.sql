Zadanie 1 


create sequence id_os_seq increment by 1 start with 31;


CREATE OR REPLACE TRIGGER WygenerujNrOsoby
BEFORE INSERT OR UPDATE ON osoby
FOR EACH ROW
BEGIN

SELECT id_os_seq.nextval
INTO :new.id_os
FROM dual;
END WygenerujNrPracownika;

insert into osoby values (1, 'Marczak', 'Adam', null, to_date('01/02/1969', 'dd/mm/yyyy'), 'M');

Zadanie 2 
Utworzyc wyzwalacz dml do zapisu wszystkich obserwacji wszystkich wykonywanych działań na tabeli zatrudnienia
w tym celu nalezy utworzyc tabele zapis

create table zapis 
(id_zapis NUMBER PRIMARY KEY, --sztuczny klucz z sekwencji
akcja VARCHAR2(12), -- nazwa operacji dml na zatrudnieniach
id_klucz NUMBER(2), -- na ktorej osobie jest wykonywana operacja id_os z zatrudnienia
data_zapis DATE,--dzisiejsza data
nazwa_uzyt VARCHAR2(25)--nazwa uzytkownika 
);

Wyzwalacz zapisuje do tej tabeli 
obsluga dowolnego bledu przy czym obsluga powinna wyswietlac standardowy komentarz opisujacy blad



create table zapis 
(id_zapis NUMBER PRIMARY KEY, --sztuczny klucz z sekwencji
akcja VARCHAR2(12), -- nazwa operacji dml na zatrudnieniach
id_klucz NUMBER(2), -- na ktorej osobie jest wykonywana operacja id_os z zatrudnienia
data_zapis DATE,--dzisiejsza data
nazwa_uzyt VARCHAR2(25)--nazwa uzytkownika 
);


create sequence zapis_seq increment by 1 start with 1;

CREATE OR REPLACE TRIGGER WstawDoZapis
BEFORE INSERT OR UPDATE OR DELETE ON zatrudnienia
FOR EACH ROW
BEGIN
IF INSERTING THEN 
insert into zapis values (zapis_seq.nextval, 'INSERT', :new.id_os, sysdate,user);
ELSIF UPDATING THEN 
insert into zapis values (zapis_seq.nextval, 'UPDATE', :new.id_os, sysdate,user);
ELSE 
insert into zapis values (zapis_seq.nextval, 'DELETE', :old.id_os, sysdate,user);
END IF;


END WstawDoZapis;


update zatrudnienia set pensja=2000 where id_os=1;

insert into zatrudnienia values (51, 31, to_date('01/10/2000', 'dd/mm/yyyy'), null, 1, 3330, 2 ); 

delete zatrudnienia where id_z=51;


Zadanie 3
Zaprojektowac wyzwalacz dml ktory bedzie w sposob ciagly aktualizowac tabele 
create table zatrudn_liczba 
(nazwa varchar2(15),
liczba_os number
);

ktora zawiera informacje o aktualnie  pracujacej liczbie osob na poszczególnych wydziałach



create table zatrudn_liczba as(
select w.nazwa , count(z.id_os) liczba_os
from zatrudnienia z join wydzialy w on z.id_w=w.id_w
where z.do is null
group by w.nazwa);

select * from ZATRUDN_LICZBA;


insert into zatrudnienia values (38, 31, sysdate, null, 1, 3330, 2);


CREATE OR REPLACE TRIGGER AktualizujZatrudnLiczba
AFTER INSERT OR UPDATE OR DELETE ON zatrudnienia
DECLARE 
z_wydzial wydzialy.id_w%TYPE;
z_liczba_os zatrudn_liczba.liczba_os%TYPE;


cursor z_licz_wydz is
select w.nazwa , count(z.id_os) liczba_os
from zatrudnienia z join wydzialy w on z.id_w=w.id_w
where z.do is null
group by w.nazwa;

BEGIN

for i in z_licz_wydz loop

update zatrudn_liczba 
set liczba_os=i.liczba_os
where nazwa=i.nazwa;

end loop;


END AktualizujZatrudnLiczba;


Zadanie 4
Zaprojektowac wyzwalacz dml na poziomie wiersza ktory bedzie unimozliwial o nazwie tr_Dwie_Prace 
ktora bedzie juz zatrudniona

--mutacja
CREATE OR REPLACE TRIGGER tr_Dwie_Prace
BEFORE INSERT OR UPDATE ON zatrudnienia
FOR EACH ROW
DECLARE 
z_check_zatrud number; 
BEGIN

select count(id_os)
into z_check_zatrud
from zatrudnienia
where do is null
and id_os=:new.id_os;

if z_check_zatrud >1 then 
RAISE_APPLICATION_ERROR(-20002,'Osoba jest już zatrudniona');
end if;

END tr_Dwie_Prace;


CREATE OR REPLACE TRIGGER tr_Dwie_PraceA
AFTER INSERT OR UPDATE ON zatrudnienia
DECLARE 
z_id_osoba zatrudnienia.id_os%TYPE;
z_liczba_wydz number;
w_DwiePrace exception;
begin 

select count(id_os)
into z_liczba_wydz
from zatrudnienia
where do is null
and id_os=PAKIETDWIEPRACE.z_osoba;

if z_liczba_wydz >1 then 
raise w_dwiePrace;
end if;

exception

when w_dwiePrace then 
RAISE_APPLICATION_ERROR(-20002,'Osoba jest już zatrudniona');
END tr_Dwie_PraceA;



insert into zatrudnienia values (39, 31, sysdate, null, 1, 3330, 2);


update zatrudnienia set id_os=4 where id_z=12;



create or replace package PakietDwiePrace AS
z_osoba zatrudnienia.id_os%TYPE;
end PakietDwiePrace;
/


create or replace trigger tr_DwiePraceB
BEFORE INSERT OR UPDATE ON zatrudnienia
FOR EACH ROW

BEGIN
PakietDwiePrace.z_osoba:=:new.id_os;
END tr_DwiePraceB;