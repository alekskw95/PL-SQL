SET SERVEROUTPUT ON


begin
DBMS_OUTPUT.PUT_LINE('Hello');
end;


Zadanie 1
Za pomocą zmiennej rekordowej dokonać korekty błędnych danych wstawionych do tabeli osoby.
nazwisko - Paczkowska
imię - Maria
data urodzenia - 18/05/1992


DECLARE
  TYPE t_RekordOsoba IS RECORD(
  p_Id osoby.id_os%TYPE,
  p_Nazwisko osoby.nazwisko%TYPE,
  p_Imie1 osoby.imie1%TYPE,
  p_Imie2 osoby.imie2%TYPE,
  p_DataUr osoby.d_ur%TYPE,
  p_Plec osoby.plec%TYPE
  );
  rDane t_RekordOsoba;
BEGIN
  rDane.p_Id:=31;
  rDane.p_nazwisko:='Palczewska';
  rDane.p_Imie1:='Maria';
  rDane.p_Imie2:=NULL;
  rDane.p_DataUr:=TO_DATE('18/05/1992','dd/mm/yyyy');
  rDane.p_Plec:='K';
  UPDATE osoby SET ROW=rDane WHERE id_os=rDane.p_Id;
  COMMIT;
END;
/


Zadanie 2
Zadeklarować podtyp użytkownika, a następnie dwie zmienne tego podtypu, za pomocą których będzie można wyświetlić inicjały osoby, której id jest 
dane poprzez zainicjowanie odpowiedniej zmiennej w sekcji deklaracji.

Osoba Jan Lis ma inicjaly J.L.

DECLARE
  SUBTYPE inicjal IS CHAR(1);
  t_OsobaI inicjal;
  t_OsobaN inicjal; 
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_IdOs osoby.id_os%TYPE:=1;
BEGIN
  SELECT initcap(o.imie1), initcap(o.nazwisko), substr(initcap(o.imie1),1,1), substr(initcap(o.nazwisko),1,1)
  INTO z_Imie, z_Nazwisko, t_OsobaI, t_OsobaN
  FROM osoby o
  WHERE o.id_os=z_IdOs;
  DBMS_OUTPUT.PUT_LINE('Osoba '||z_Imie||' '||z_Nazwisko||' '||' ma inicjaly '||t_OsobaI||'.'||t_OsobaN||'.');
END;
/


Zadanie 3
Napisać kod bloku anonimowego w języku PL/SQL za pomocą, którego dla danej osoby z tabelki osoby, której id jest dane poprzez zainicjowanie 
odpowiedniej zmiennej w sekcji deklaracji, bedzie wyświetlony opowiedni komunikat dotyczący sumy długosci jej nazwiska i imienia.
Gdy ta dlugość jest nie wieksza niż 10 - osoba o małej sumie długosci nazwiska i imienia.
Zaś gdy od 11 do 20 - osoba o dużej sumie długosci nazwiska i imienia.
Powyżej 20 - osoba o bardzo dużej sumie długosci nazwiska i imienia

DECLARE
  z_IdOs osoby.id_os%TYPE:=1;
  z_Dlugosc NUMBER;
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
BEGIN
  SELECT initcap(o.imie1), initcap(o.nazwisko), length(o.imie1)+length(o.nazwisko)
  INTO z_Imie, z_Nazwisko, z_Dlugosc
  FROM osoby o
  WHERE o.id_os=z_IdOs;
  IF z_Dlugosc<10 THEN
    DBMS_OUTPUT.PUT_LINE('Osoba '||z_Imie||' '||z_Nazwisko||' o malej sumie dlugosci nazwiska i imienia. Dugość: '||z_Dlugosc);
  ELSIF z_Dlugosc>=11 and z_Dlugosc <=20 THEN
    DBMS_OUTPUT.PUT_LINE('Osoba '||z_Imie||' '||z_Nazwisko||' o duzej sumie dlugosci nazwiska i imienia. Dugość: '||z_Dlugosc);
  ELSE 
    DBMS_OUTPUT.PUT_LINE('Osoba '||z_Imie||' '||z_Nazwisko||' o bardzo duzej sumie dlugosci nazwiska i imienia. Dugość: '||z_Dlugosc);
    END IF;
END;
/



Zadanie 4
Napisać program z wykorzystaniem bloku anonimowego w języku PL/SQL, za pomoca którego bedzie podane 
dla wybranej osoby której id jest dane poprzez zainicjowanie odpowiedniej zmiennej w sekcji deklaracji komunikat:
Jan Lis jest osoba urodzoną w lipcu.
Zastosować instrukcję CASE sprawdzajaca.

DECLARE
  z_IdOs osoby.id_os%TYPE:=1;
  z_Miesiac CHAR(2);
  z_Miesiac_Slowo VARCHAR2(15);
  z_Imie osoby.imie1%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
BEGIN
  SELECT initcap(o.imie1), initcap(o.nazwisko), to_char(o.d_ur,'MM')
  INTO z_Imie, z_Nazwisko, z_Miesiac
  FROM osoby o
  WHERE o.id_os=z_IdOs;
  CASE z_Miesiac
    WHEN '01' THEN z_Miesiac_Slowo:='w styczniu';
    WHEN '02' THEN z_Miesiac_Slowo:='w lutym';
    WHEN '03' THEN z_Miesiac_Slowo:='w marcu';
    WHEN '04' THEN z_Miesiac_Slowo:='w kwietniu';
    WHEN '05' THEN z_Miesiac_Slowo:='w maju';
    WHEN '06' THEN z_Miesiac_Slowo:='w czerwcu';
    WHEN '07' THEN z_Miesiac_Slowo:='w lipcu';
    WHEN '08' THEN z_Miesiac_Slowo:='w sierpniu';
    WHEN '09' THEN z_Miesiac_Slowo:='w wrzesniu';
    WHEN '10' THEN z_Miesiac_Slowo:='w pazdzierniku';
    WHEN '11' THEN z_Miesiac_Slowo:='w listopadzie';
    WHEN '12' THEN z_Miesiac_Slowo:='w grudniu';
    END CASE;
    DBMS_OUTPUT.PUT_LINE(z_Imie||' '||z_Nazwisko||' jest osoba urodzona '||z_Miesiac_Slowo);
END;
/


Zadanie 5
Napisać kod bloku anonimowego w języku PL/SQL, za pomocą którego będzie podawał dla wybranej aktualnie zatrudnionej osoby, której 
id jest dane poprzez zainicjowanie odpowiedniej zmiennnej PL/SQL w sekcji deklaracji następujący komunikat dotyczacy
jej aktualnej pensji 
jeśli pensja <1000 grupa I zaszeregowania
jeśli jest od 1001-1400 grupa 2
jeśli 1401 - 1700 grupa 3 
1700-2000 grupa 4
2500-3000 grupa 5
....
powyzej 6000 grupa

osoba o id i pensji 2750 nalezy do grupy 5 wynagrodzej. Zatosowac case spradwzajacy. 


DECLARE
  z_IdOs osoby.id_os%TYPE:=3;
  z_Pensja zatrudnienia.pensja%TYPE;
  z_Grupa VARCHAR2(30);
BEGIN
  SELECT o.id_os, z.pensja
  INTO z_IdOs, z_Pensja
  FROM osoby o join zatrudnienia z on o.id_os=z.id_os
  WHERE o.id_os=z_IdOs and z.do is null;
  CASE 
    WHEN z_Pensja <1001 THEN z_Grupa:='I';
    WHEN z_Pensja BETWEEN 1001 AND 1400 THEN z_Grupa:='II';
    WHEN z_Pensja BETWEEN 1401 AND 1700 THEN z_Grupa:='III';
    WHEN z_Pensja BETWEEN 1701 AND 2000 THEN z_Grupa:='IV';
    WHEN z_Pensja BETWEEN 2001 AND 2500 THEN z_Grupa:='V';
    WHEN z_Pensja BETWEEN 2501 AND 3000 THEN z_Grupa:='VI';
    WHEN z_Pensja BETWEEN 3001 AND 3500 THEN z_Grupa:='VII';
    WHEN z_Pensja BETWEEN 4001 AND 4500 THEN z_Grupa:='VIII';
    WHEN z_Pensja BETWEEN 4501 AND 5000 THEN z_Grupa:='IX';
    WHEN z_Pensja BETWEEN 5001 AND 5500 THEN z_Grupa:='X';
    WHEN z_Pensja BETWEEN 5501 AND 6000 THEN z_Grupa:='XI';
    WHEN z_Pensja>6000 THEN z_Grupa:='XII';
    END CASE;
    DBMS_OUTPUT.PUT_LINE('Osoba o id='||z_IdOs||' i pensji '||z_Pensja||' nalezy do grupy '||z_Grupa||' wynagrodzen');
END;
/



obsluga wyjatku





