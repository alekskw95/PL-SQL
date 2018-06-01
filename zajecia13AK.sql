Wyzwalacze (Triggery)
Zadanie 1 
Zaprojektowac wyzwalacz DML na poziomie wiersza, ktory bedzie umozliwial wprowadzanie kolejnej wartosci sekwencji 
do pola klucza glownego w tabeli osoby.
create sequence id_os_seq increment by 1 start with  31;

create or replace trigger WygenerujNrOsoby
  before insert or update on osoby
  for each row
BEGIN
  select id_os_seq.nextval
  into :new.id_os
  from dual;
end WygenerujNrOsoby;
/

INSERT INTO osoby(id_os,nazwisko,imie1,imie2,d_ur,plec)
VALUES(1,'Tomczyk','Monika',' ',to_date('21/01/1987','dd/mm/yyyy'),'K');


Zadanie 2
Utworzyc wyzwalacz DML do zapisu wszystkich obserwacji wszystkich wykonywanych dzialan na tabeli zatrudnienia. W tym celu nalezy utworzyc
tabele zapis. Wyzwalacz powinien posiadac obsluge dowolnego bledu przy zcym obsluga powinna wyswietlac standardowy komentarz opisujacy blad.


create table Zapis(
  id_zapisz number primary key,
  akcja varchar2(12),
  id_klucz number(2), --id_os
  data_zapisz date,
  nazwa_uzyt varchar2(25)
  ); 

Create or replace trigger RejestrujZmiany
  BEFORE insert or update on zatrudnienia
  for each row
DECLARE
  Z_Zmiana CHAR(3);
BEGIN 
  if INSERTING then
    insert into zapis(id_zapisz,akcja,id_klucz,data_zapisz,nazwa_uzyt) 
    values(id_os_seq.nextval, 'Insert', :new.id_os, sysdate, user);
  elsif UPDATING then
    insert into zapis(id_zapisz,akcja,id_klucz,data_zapisz,nazwa_uzyt)
    values(id_os_seq.nextval, 'Update', :new.id_os, sysdate, user);   --tu obojetnie :new czy :old
  else
    insert into zapis(id_zapisz,akcja,id_klucz,data_zapisz,nazwa_uzyt)
    values(id_os_seq.nextval, 'Delete', :old.id_os, sysdate, user);
  end if;
END;
/



INSERT INTO zatrudnienia values(52,31,to_date('1/10/2000','dd/mm/yyyy'),null,1,3330,2);

update zatrudnienia
set id_w=3
where id_z=52;


Zadanie 3
Zaprojektowqac wyzwalacz DML, ktory bedzie w sposob ciagly aktualizowal tabele zatrud_liczba, ktora zawiera informacje
o aktualnie pracujacej liczbie osob na poszczegolnych wydzialach. 


create table zatrud_liczba(
  nazwa varchar2(15),
  liczba_os number);
  
  
  
create or replace trigger LiczOsobyWydzial
  AFTER insert or update on zatrudnienia
declare
  cursor k_Dane is
    select initcap(w.nazwa) nazwaW, count(z.id_os) LiczbaZ
    from zatrudnienia z join wydzialy w on z.id_w=w.id_w
    where z.do is null
    group by initcap(w.nazwa);
begin
  
  delete from zatrud_liczba;
  
  for i in k_Dane loop
      insert into zatrud_liczba values(i.nazwaW, i.liczbaZ);
  end loop;

end;
/


INSERT INTO zatrudnienia values(39,31,to_date('30/05/2018','dd/mm/yyyy'),null,1,3330,2);
  
Zadanie 4 
Mamy zaprojektowac wyzwalqacz DML na poziomie wiersza, ktory bedzie uniemozliwial (o nazwie tr_DwiePrace) wprowadzenie zatrudnienia osoby,
ktora juz pracuje na innych wydzialach.

create or replace trigger tr_DwiePrace
  before insert or update on zatrudnienia
  for each row
declare
  z_Ilosc number;
begin
  
  select count(z.id_os) LiczbaZ
  into z_Ilosc
  from zatrudnienia z join wydzialy w on z.id_w=w.id_w
  where z.do is null and id_os=:new.id_os;
  
  if z_Ilosc > 1 THEN
    RAISE_APPLICATION_ERROR(-20133, 'Osoba zatrudniona na innych wydzialach');
  end if;

end;
/



INSERT INTO zatrudnienia values(42,31,to_date('30/05/2018','dd/mm/yyyy'),null,1,3330,2);


INSERT INTO zatrudnienia values(42,31,to_date('30/05/2018','dd/mm/yyyy'),null,1,3330,2);


update zatrudnienia
set id_os=4
where id_z=12;  <- powinno wywalic mutacje, czyli trzeba zrobic pakiet zeby nie bylo mutacji



create or replace package PakietDwiePrace AS
  z_osoba zatrudnienia.id_os%type;
end PakietDwiePrace;
/


create or replace trigger tr_DwiePraceB
  Before insert or update on zatrudnienia
  for each row
begin
    PakietDwiePrace.z_osoba:=:new.id_os;
end tr_DwiePraceB;
/


create or replace trigger tr_DwiePrace
  after insert or update on zatrudnienia
declare
  z_id_osoba zatrudnienia.id_os%TYPE;
  z_liczbaWydz number;
  w_DwiePrace EXCEPTION;
begin
  select count(id_os) LiczbaZ
  into z_liczbaWydz
  from zatrudnienia
  where do is null and id_os=PakietDwiePrace.z_osoba;
  
  if z_liczbaWydz > 1 THEN
    RAISE w_DwiePrace;
  end if;

  exception
    when w_DwiePrace then
      RAISE_APPLICATION_ERROR(-20009, 'Osoba o id_os: '||PakietDwiePrace.z_osoba||' jest juz zatrudniona.');
end tr_DwiePrace;
/

















