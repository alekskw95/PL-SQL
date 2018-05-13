Zadanie 1 (obsluga wyjątków)
Utworzyć tabelkę tabela_bledow skladajaca sie z 2 pól: o nast nazwach i typach:
pole kod typu numerycznego i pole o nazwie komunikat typu tekstowego o max rozmiarze 200.
Napisac kod bloku anonimowego, w którym za pomoca kursora niejawnego wyświetlimy informacje o:
a) osobie, której identyfikator jest równy 50
b) wszystkich osobach, któych identyfikator jest mneijszy niz 50.
Zaprojektować obsługę wyjatków, za pomoca oders-a w ten sposób, że do tabeli tabela_bledow będzie 
wstawiany kod i komunikat o błędzie, który został obsłuzony za pomocą oders-a po uruchomieniu utworzonego bloku.

CREATE TABLE tabela_bledow(
kod NUMBER,
komunikat VARCHAR(200)
);

DECLARE
  z_IdOs osoby.id_os%TYPE;
  z_KodBledu tabela_bledow.kod%TYPE;
  z_Komunikat tabela_bledow.komunikat%TYPE;
BEGIN
  SELECT o.id_os
  INTO z_IdOs
  FROM osoby o
  --WHERE o.id_os = 50;  
  WHERE o.id_os < 50; --wykonac z < 50 dla pkt b)
  
  EXCEPTION 
    WHEN OTHERS THEN
       z_KodBledu:=SQLCODE;
       z_Komunikat:=SUBSTR(SQLERRM,1,200);
       INSERT INTO tabela_bledow(kod, komunikat) VALUES (z_KodBledu, z_Komunikat);
       
END;
/


Zadanie 2 (podprogramy)
Napisac procedurę dodaj_nowa_osoba która będzie wprowadzała osobę do tabeli osoby, 
przy czym uwzględnić fakt sprawdzenia wprowadzenia istniejącej już osoby.

CREATE OR REPLACE PROCEDURE DodajNowaOsoba(
  p_Id osoby.id_os%TYPE,
  p_Nazwisko osoby.nazwisko%TYPE,
  p_Imie osoby.imie1%TYPE,
  p_Imie2 osoby.imie2%TYPE,
  p_DUR osoby.d_ur%TYPE,
  p_Plec osoby.plec%TYPE)AS
  
  z_Sprawdzenie NUMBER;
BEGIN
  SELECT COUNT(o.id_os)
  INTO z_Sprawdzenie
  FROM osoby o
  WHERE o.id_os=p_id;


  IF z_Sprawdzenie = 0 THEN
    INSERT INTO osoby 
    VALUES (p_Id,p_Nazwisko,p_Imie,p_Imie2,p_DUR,p_Plec);
    COMMIT;
  ELSE
    RAISE_APPLICATION_ERROR(-20001, 'Osoba juz dodana');
  END IF;

END DodajNowaOsoba;
/
  
  
  
BEGIN
  DodajNowaOsoba(31,'Karp','Janusz','Mariusz',to_date('15/03/1971','dd/mm/yyyy'),'M');
END;
/


Zadanie 3
Utworzyć procedurę i funkcję dotyczącą obliczen liczby osób o zadanej płci. wywowłując je obie ma być wyświetlone:
Liczba kobiet  =18 a jak dla męzczyzn Liczba mężczyzn = 12.

CREATE OR REPLACE PROCEDURE SprawdzPlec(
  p_Plec osoby.plec%TYPE)AS
  
  z_Liczba NUMBER;
BEGIN
  SELECT COUNT(o.id_os)
  INTO z_Liczba
  FROM osoby o
  WHERE o.plec=p_Plec;


  IF p_Plec = 'K' THEN
    DBMS_OUTPUT.PUT_LINE('Liczba kobiet = '|| z_Liczba);
  ELSIF p_Plec = 'M' THEN
    DBMS_OUTPUT.PUT_LINE('Liczba męzczyzn = '|| z_Liczba);
  ELSE
    RAISE_APPLICATION_ERROR(-20001,'Zla plec');
  END IF;

END SprawdzPlec;
/
  

BEGIN
  SprawdzPlec('Z');
END;
/


--------------------------


CREATE OR REPLACE Function SprawdzPlecF(
  p_Plec osoby.plec%TYPE)
  RETURN NUMBER IS 
  z_Liczba NUMBER;
BEGIN
  SELECT COUNT(o.id_os)
  INTO z_Liczba
  FROM osoby o
  WHERE o.plec=p_Plec;

  IF p_Plec = 'K' THEN
    RETURN z_Liczba;
  ELSIF p_Plec = 'M' THEN
    RETURN z_Liczba;
  ELSE
    RAISE_APPLICATION_ERROR(-20001,'Zla plec');
  END IF;

END SprawdzPlecF;
/


DECLARE
  z_Plec osoby.plec%TYPE :='K';
BEGIN

  IF z_Plec = 'K' THEN
    DBMS_OUTPUT.PUT_LINE('Liczba kobiet = '|| SprawdzPlecF(z_Plec));
  ELSIF z_Plec = 'M' THEN
    DBMS_OUTPUT.PUT_LINE('Liczba męzczyzn = '|| SprawdzPlecF(z_Plec));
  ELSE
    RAISE_APPLICATION_ERROR(-20001,'Zla plec');
  END IF;
  
END;
/



Zadanie 4
Mamy zaprojektowac procedurę wyświetlania id_os kierownika i jego nazwiska połaczonego z 1 imieniem oraz liczby dni kierowania wydziałem,
przy czym mają być to dane osoby, która najdłużej kierowała wydziałem, przy czym nazwa wydziału jest znana.
CREATE OR REPLACE PROCEDURE ProceduraKierownikWydzialu(
  p_Nazwa wydzialy.nazwa%TYPE)AS
  
  z_Liczba NUMBER;
  z_OsobaDane VARCHAR(100);
  z_Id osoby.id_os%TYPE;
  
BEGIN

  SELECT o.id_os, initcap(o.nazwisko)||' '||initcap(o.imie1),nvl(k.do,sysdate)-k.od
  INTO z_Id, z_OsobaDane, z_Liczba
  FROM osoby o join kierownicy k on o.id_os=k.id_os join wydzialy w on k.id_w=w.id_w
  WHERE initcap(w.nazwa)=initcap(p_Nazwa) and o.id_os=(
                  SELECT k1.id_os
                  FROM kierownicy k1 join wydzialy w1 on k1.id_w = w1.id_w
                  WHERE initcap(w1.nazwa)=initcap(p_Nazwa) and nvl(k1.do,sysdate)-k1.od =(SELECT max(nvl(k2.do,sysdate)-k2.od)
                                                                                FROM kierownicy k2
                                                                                WHERE k2.id_w=w1.id_w)
  );
  
  
  DBMS_OUTPUT.put_line(z_Id||' '||z_OsobaDane||' '||z_Liczba);
  

END ProceduraKierownikWydzialu;
/
  

BEGIN
  ProceduraKierownikWydzialu('Matematyka');
END;
/








