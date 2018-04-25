Zadanie 1 (6 - kolokwium)
Zadeklarować zmienną z_Nazwisko o długości max 10 znaków, której w sekcji wykonawczej 
przypisac wartosc Nowak-Konopka i oblusyzc wyjatek za pomoca komuniaktu  zbyt dlugie nazwisko.
DECLARE
  z_Nazwisko VARCHAR2(10);
BEGIN
  z_Nazwisko:='Nowak-Konopka';
  EXCEPTION
    WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('Zbyt dlugie nazwisko'); -- aby wykonal sie blok do end-a
	  RAISE_APPLICATION_ERROR(-20999,'Zbyt dlugie nazwisko'); -- jak chcemy przerwac
END;
/
 -- jesli chcemy dojsc do end-a to uzywamy dbms a jak nie to raise application error

Zadanie 2 (+propagacja (tez na tescie))
Za pomoca kursora niejawnego wyświetlić dane tych osób, których id jest >= od pewnej liczby naturalnej,
zadeklarowanej w sekcji deklaracji. W bloku anonimowym z tym kursosrem obsłuzyć wszystkie wyjątki, 
które moga się w nim pojawić, za pomoca odpowiednich komentarzy. (jezeli petla to byloby dobrze)
(mozna tez z ROWTYPE)
DECLARE
  z_id osoby.id_os%TYPE:=100;
  z_nazwisko osoby.nazwisko%TYPE;
  z_imie1 osoby.imie1%TYPE;
BEGIN
  SELECT nazwisko, imie1
  INTO z_nazwisko, z_imie1
  FROM osoby
  WHERE id_os >= z_id;
  
  EXCEPTION
    WHEN TOO_MANY_ROWS THEN
      --DBMS_OUTPUT.PUT_LINE('Wiecej niz jeden wynik');
      RAISE_APPLICATION_ERROR(-20998,'Wiecej niz jeden wynik');
    WHEN NO_DATA_FOUND THEN
      --DBMS_OUTPUT.PUT_LINE('Nie znaleziono danych');
      RAISE_APPLICATION_ERROR(-20999,'Nie znaleziono danych');   
END;
/

Zadanie 3
Zanurzyć blok anonimowy z poprzedniego zadania w nadbloku (w innym bloku), z osbluga tych samych wyjatków.
Usuwac oblusge w podbloku.


DECLARE
  z_id osoby.id_os%TYPE:=6;
  z_nazwisko osoby.nazwisko%TYPE;
  z_imie1 osoby.imie1%TYPE;
BEGIN
  SELECT nazwisko, imie1
  INTO z_nazwisko, z_imie1
  FROM osoby
  WHERE id_os=1;
  DBMS_OUTPUT.PUT_LINE('Osoba ma id_os=1'); 
  
        BEGIN
          SELECT nazwisko, imie1
          INTO z_nazwisko, z_imie1
          FROM osoby
          WHERE id_os >= z_id;
          
          /*EXCEPTION
            /*WHEN TOO_MANY_ROWS THEN
              RAISE_APPLICATION_ERROR(-20998,'Wiecej niz jeden wynik.');*/
            /*WHEN NO_DATA_FOUND THEN
              RAISE_APPLICATION_ERROR(-20999,'Nie znaleziono danych.'); */
        END;
        
  EXCEPTION
   WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20998,'Wynikow jest wiecej.');
   WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20999,'Nie ma takich osob.');   
END;
/



 teraz dbms przykryje bledy
DECLARE
  z_id osoby.id_os%TYPE:=6;
  z_nazwisko osoby.nazwisko%TYPE;
  z_imie1 osoby.imie1%TYPE;
BEGIN
  SELECT nazwisko, imie1
  INTO z_nazwisko, z_imie1
  FROM osoby
  WHERE id_os=1;
  DBMS_OUTPUT.PUT_LINE('Osoba ma id_os=1'); 
  
        BEGIN
          SELECT nazwisko, imie1
          INTO z_nazwisko, z_imie1
          FROM osoby
          WHERE id_os >= z_id;
          
          EXCEPTION
            WHEN TOO_MANY_ROWS THEN
              DBMS_OUTPUT.PUT_LINE('Wiecej niz jeden wynik.');
            WHEN NO_DATA_FOUND THEN
              DBMS_OUTPUT.PUT_LINE('Nie znaleziono danych.'); 
        END;
        
  EXCEPTION
   WHEN TOO_MANY_ROWS THEN
       RAISE_APPLICATION_ERROR(-20998,'Wynikow jest wiecej.');
   WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20999,'Nie ma takich osob.');   
END;
/

Zadanie 4
Istnieje potrzeba ograniczenia płac na wszystkich wydziałach. Nalezy max aktualnie wypłacana pensję,
ograniczyc do 4000. Jesli aktualnie najwyzsza pensja przekracza te wartosc nalezy wyswietlic komunikat
informujacy o tym fakcie. (2 sposoby)
I)
DECLARE
  w_Ograniczenie EXCEPTION;
  z_pensja zatrudnienia.pensja%TYPE;
  z_Limit NUMBER:=4000;
BEGIN
  SELECT max(pensja)
  INTO z_pensja
  FROM zatrudnienia;
  DBMS_OUTPUT.PUT_LINE('Najwyzsza pensja na wszystkich wydzialach: '||z_pensja); 
 
  IF z_pensja > z_Limit THEN 
		RAISE w_Ograniczenie; 
  END IF;
  
  EXCEPTION 
      WHEN w_Ograniczenie THEN 
            DBMS_OUTPUT.PUT_LINE('Najwyzsza pensja przekracza '||z_Limit);      
END;
/

II)
DECLARE
  w_Ograniczenie EXCEPTION;
  z_pensja zatrudnienia.pensja%TYPE;
  z_Limit NUMBER:=4000;
BEGIN
  SELECT max(pensja)
  INTO z_pensja
  FROM zatrudnienia;
  DBMS_OUTPUT.PUT_LINE('Najwyzsza pensja na wszystkich wydzialach: '||z_pensja); 
 
  IF z_pensja > z_Limit THEN 
    RAISE_APPLICATION_ERROR(-20999,' ');
  END IF;
  
  EXCEPTION 
	  WHEN OTHERS THEN 
			DBMS_OUTPUT.PUT_LINE('Najwyzsza pensja przekracza '||z_Limit);        
END;
/

Zadanie 5
Do bazy kadry wprowadzono dwa rekordy. Do tabeli 
osoby  31 Karop Janusz 15/03/1971 M
Zatrudneinia 100 31 01/03/1970 27/01/1969 2 3000 1

Nalezy zaprojektowac obsluge wyjatkow ktore dla dowolnej osoby zaprojektowac osbluge wyjatkow
ktore obsluza nastepujace wyjatki:
a) Data urodzenia jest pozniejsza niz data zatrudneinia!
b) Data zatrudnienia jest pozniesza niz data zwolnienia!
c) Data urodzenia jest pozniesza niz data zatrudnienia i data zatrudnienia jest pozniejsza 
niz data zwoleninia!

insert into osoby values(31,'Karp','Janusz',null,to_date('15/03/1971','dd/mm/yyyy'),'M');
insert into zatrudnienia values(100,31,to_date('21/03/1970','dd/mm/yyyy'),to_date('21/01/1969','dd/mm/yyyy'),2,3000,1);


DECLARE
  w_OgraniczenieUR EXCEPTION;
  w_OgraniczenieZ EXCEPTION;
  w_OgraniczenieZW EXCEPTION;
  z_id osoby.id_os%TYPE:=31;
  z_dUR osoby.d_ur%TYPE;
  z_dataOd zatrudnienia.od%TYPE;
  z_dataDo zatrudnienia.do%TYPE;  
BEGIN
  SELECT o.d_ur, z.od, z.do
  INTO z_dUR, z_dataOd, z_dataDo
  FROM osoby o join zatrudnienia z on o.id_os=z.id_os
  WHERE o.id_os=z_id;
 
  IF z_dUR > z_dataOd and z_dataOd > z_datado THEN  RAISE w_OgraniczenieZW;
  END IF;
  IF z_dataOd > z_dataDo THEN RAISE w_OgraniczenieUR;
  END IF;
  IF z_dUR > z_dataOd THEN RAISE w_OgraniczenieZ;
  END IF;
  
  EXCEPTION 
      WHEN w_OgraniczenieUR THEN 
            DBMS_OUTPUT.PUT_LINE('Data urodzenia jest pozniejsza niz data zatrudnienia!');
      WHEN w_OgraniczenieZ THEN
            DBMS_OUTPUT.PUT_LINE('Data zatrudnienia jest pozniesza niz data zwolnienia!');
      WHEN w_OgraniczenieZW THEN
            DBMS_OUTPUT.PUT_LINE('Data urodzenia jest pozniesza niz data zatrudnienia i data zatrudnienia jest pozniejsza 
niz data zwoleninia!');
          
END;
/



Zadanie 6 do domu
Wykonac obsluge wyjatku za pomoca wyjatku OTHERS przy wykorzystaniu funkcji SQLCODE i SQLERRM. 
Przy czym obsluga ta powinna polegac na zapisie kodu bledu i tekstu o bledzie do tabeli dziennik_bledow,
skladajacej sie z dwoch pólL kod NUMBER i komunikat VARCHAR(200).
Blok w ktorym ma byc zrealizowana ta obsluga wyjatkow, zawiera kursor niejawny, ktory wybiera te osoby dla ktorych 
aktualny staz pracy wynosi od 1 - 100 pelnych przepracowanych lat.







