Zadanie 1
Zaprojektowac pakiet o nazwie pakiet_osobowy zawierajacy:
a) procedure wprowadzania nowej osoby do tabeli osoby, przy czym powinna ona zawierac obsluge wyjatku iz 
taka osoba istnieje w tabeli osoby
b) procedure usuwania osoby z tabelki osoby, przy czym powinna ona zawierac obluge wyjatkow iz taka osoba nie 
istnieje w tabeli osoby
c) wyjatek uzytkownika zwiazanego z nieznalezieniem danej osoby 
d) procedure wyswietlajaca liste alfabetyczna osob zatrudnionych na danym wydziale, przy czym ma ona byc 
drukowana wewnatrz procedury a procedura powinna zwracac liczbe wszystkich osob zatrudnionych 
na danym wydziale
e) funkcje obliczajaca liczbe osob kazdej plci aktualnie zatrudnioncyh na wskazanym wydziale (Matematyka)


CREATE OR REPLACE PACKAGE pakietOsobowy AS
  PROCEDURE DodajOsobe (p_osobaId IN osoby.id_os%TYPE,
                        p_Nazwisko IN osoby.nazwisko%TYPE,
                        p_Imie1 IN osoby.imie1%TYPE,
                        p_Imie2 IN osoby.imie2%TYPE,
                        p_Dur IN osoby.d_ur%TYPE,
                        p_Plec osoby.plec%TYPE);
  -- Usuwanie
  PROCEDURE UsunOsobe (p_osobaId IN osoby.id_os%TYPE);
  -- Wyjatek
  w_NieZnalezionoOsoby EXCEPTION;
  --Procedura lista osob
  PROCEDURE ListaOsobNaWydziale(p_WydzialNazwa IN wydzialy.nazwa%TYPE,
                                p_LiczbaOsob OUT NUMBER);
  --Funkcja obl liczbe osob
  FUNCTION LiczbaOsobPlec(p_WydzialNazwa IN wydzialy.nazwa%TYPE,
                          p_Plec IN osoby.plec%TYPE)RETURN NUMBER;

END pakietOsobowy;


//------------------------------------------------------------------

CREATE OR REPLACE PACKAGE BODY pakietOsobowy AS
  PROCEDURE DodajOsobe (p_osobaId IN osoby.id_os%TYPE,
                        p_Nazwisko IN osoby.nazwisko%TYPE,
                        p_Imie1 IN osoby.imie1%TYPE,
                        p_Imie2 IN osoby.imie2%TYPE,
                        p_Dur IN osoby.d_ur%TYPE,
                        p_Plec osoby.plec%TYPE)AS
                  z_Sprawdz NUMBER;
        BEGIN
            SELECT COUNT(o.id_os)
            INTO z_Sprawdz
            FROM osoby o
            WHERE o.id_os=p_osobaID;
            
            IF z_Sprawdz = 0 THEN
                INSERT INTO osoby(id_os,nazwisko,imie1,imie2,d_ur,plec) 
                VALUES (p_osobaId,p_Nazwisko,p_Imie1,p_Imie2,p_Dur,p_Plec);
                COMMIT;
            ELSE
                RAISE_APPLICATION_ERROR(-20004, 'Użytkownik istnieje, dodanie jest nie mozliwe');
            END IF;
            
        END DodajOsobe;
        
  -- Usuwanie
  PROCEDURE UsunOsobe (p_osobaId IN osoby.id_os%TYPE)AS
      BEGIN
            DELETE FROM osoby 
              WHERE id_os=p_osobaId;
            IF SQL%NOTFOUND THEN
              RAISE w_NieZnalezionoOsoby;
            END IF;
          EXCEPTION
              WHEN w_NieZnalezionoOsoby THEN 
                DBMS_OUTPUT.PUT_LINE('Osoba nie zostala znaleziona');
      END UsunOsobe;
      
  --Procedura lista osob
  PROCEDURE ListaOsobNaWydziale(p_WydzialNazwa IN wydzialy.nazwa%TYPE,
                                p_LiczbaOsob OUT NUMBER) AS
        CURSOR k_daneOS IS
          SELECT initcap(o.imie1) imieOsoby, initcap(o.nazwisko) nazwiskoOsoby
          FROM osoby o join zatrudnienia z on o.id_os=z.id_os join wydzialy w on w.id_w=z.id_w
          WHERE initcap(w.nazwa)=initcap(p_WydzialNazwa) and z.do is null
          ORDER BY 1ASC;
        z_Licznik NUMBER:=0;
    BEGIN
        FOR k_dane IN k_daneOs LOOP
          DBMS_OUTPUT.PUT_LINE(k_dane.imieOsoby||' '||k_dane.nazwiskoOsoby);
          z_Licznik:=z_Licznik+1;
        END LOOP;
        p_LiczbaOsob:=z_Licznik;
        DBMS_OUTPUT.PUT_LINE('Liczba osob: '||p_LiczbaOsob);   
                                
    END ListaOsobNaWydziale;                           
                                
                                
  --Funkcja obl liczbe osob
  FUNCTION LiczbaOsobPlec(p_WydzialNazwa IN wydzialy.nazwa%TYPE,
                          p_Plec IN osoby.plec%TYPE) RETURN NUMBER IS        
           z_Liczba NUMBER;
      BEGIN             
          SELECT COUNT(o.id_os)
          INTO z_Liczba
          FROM osoby o join zatrudnienia z on o.id_os=z.id_os join wydzialy w on z.id_w=w.id_w
          WHERE initcap(w.nazwa)=initcap(p_WydzialNazwa) and initcap(o.plec)=initcap(p_Plec) and z.do is null;
              
         RETURN z_Liczba;  
         
    END LiczbaOsobPlec;
    
END pakietOsobowy;






DECLARE
  z_Liczba NUMBER;
BEGIN
 --pakietOsobowy.DodajOsobe(31,'Palczewska','Maria',NULL,TO_DATE('18/05/1992','dd/mm/yyyy'),'K');
 --pakietOsobowy.UsunOsobe(31);
 --pakietOsobowy.UsunOsobe(32); //wyrzuci wyjatek
 
 --pakietOsobowy.ListaOsobNaWydziale('Matematyka',z_Liczba);
 
 
 DBMS_OUTPUT.PUT_LINE('Liczba osob plci: '||pakietOsobowy.LiczbaOsobPlec('Matematyka','K'));
 
END;
/

Zadanie 2
Zaprojektowac pakiet zatrudnianie_osoby zawierajacy:
a) procedure prywatna wyswietlajaca dane osoby za pomoca ktorej nazwisko osoby i imie jest laczone 
w calosc i pisane duzymi literami 
oraz dwie procedury za pomoca ktorych wyswietlana jest wewnatrz procedury nazwa stanowiska i lista osob
ktore sa na tym stanowisku aktualnie zatrudnione 
oraz procedura ma zwrocic liczbe osob zatrudnionych na tym stanowisku. 
Dokonac przeciazenia procedury stanowisko_osoby w  ten sposob ze raz parametrem wejsiowym jest 
id stanowiskaa , a drugi raz nazwa stanowiska.

CREATE OR REPLACE PACKAGE zatrudnienieOsoby AS
  PROCEDURE wyswietlOsobe (p_osobaId IN osoby.id_os%TYPE);
  
  PROCEDURE stanowiskoOsoby (p_nazwaS IN stanowiska.nazwa%TYPE,
                             p_Liczba OUT NUMBER);
  
  PROCEDURE stanowiskoOsoby (p_idS IN stanowiska.id_s%TYPE,
                             p_Liczba OUT NUMBER); 

END zatrudnienieOsoby;



//---------------------
CREATE OR REPLACE PACKAGE BODY zatrudnienieOsoby AS 
  PROCEDURE wyswietlOsobe (p_osobaId IN osoby.id_os%TYPE) AS 
      z_Sprawdz NUMBER;
      z_imie osoby.imie1%TYPE;
      z_nazwisko osoby.nazwisko%TYPE;
    BEGIN
      SELECT COUNT(id_os)
      INTO z_Sprawdz
      FROM osoby
      WHERE id_os=p_osobaId;
      
      /*SELECT upper(o.imie1), upper(o.nazwisko)
      INTO z_imie, z_nazwisko
      FROM osoby o
      WHERE o.id_os=p_osobaId;*/
          
      IF z_Sprawdz > 0 THEN
          --DBMS_OUTPUT.PUT_LINE(z_imie||' '||z_nazwisko);
          SELECT upper(o.imie1), upper(o.nazwisko)
          INTO z_imie, z_nazwisko
          FROM osoby o
          WHERE o.id_os=p_osobaId;
          DBMS_OUTPUT.PUT_LINE(z_imie||' '||z_nazwisko);
      ELSE
          DBMS_OUTPUT.PUT_LINE('Osoby o podanym id nie ma w bazie');
      END IF;
     
  END wyswietlOsobe;
  
  -- procedura stanowisko osoby i lista osob wedlug nazwy
  PROCEDURE stanowiskoOsoby (p_nazwaS IN stanowiska.nazwa%TYPE,
                             p_Liczba OUT NUMBER) AS
            CURSOR k_stanowisko IS
                SELECT initcap(s.nazwa) nazwaS, initcap(o.nazwisko) nOsoba, initcap(o.imie1) iOsoba
                FROM osoby o join zatrudnienia z on o.id_os=z.id_os join stanowiska s on s.id_s=z.id_s
                WHERE initcap(s.nazwa)=initcap(p_nazwaS); 
            z_Licznik NUMBER:=0;
    BEGIN
        FOR k_dane IN k_stanowisko LOOP
          z_Licznik:=z_Licznik+1;
          DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||k_dane.nOsoba||' '||k_dane.iOsoba);
        END LOOP;
        p_Liczba:=z_Licznik;
        DBMS_OUTPUT.PUT_LINE('Liczba osob na tym stanowisku ogolem wynosi: '||p_Liczba);
        
    END stanowiskoOsoby;
  -- procedura stanowisko osoby i lista osob wedlug id_s
  PROCEDURE stanowiskoOsoby (p_idS IN stanowiska.id_s%TYPE,
                             p_Liczba OUT NUMBER) AS
            CURSOR k_stanowisko IS
                SELECT initcap(s.nazwa) nazwaS, initcap(o.nazwisko) nOsoba, initcap(o.imie1) iOsoba
                FROM osoby o join zatrudnienia z on o.id_os=z.id_os join stanowiska s on s.id_s=z.id_s
                WHERE s.id_s=p_idS; 
            z_Licznik NUMBER:=0;
    BEGIN
        FOR k_dane IN k_stanowisko LOOP
          z_Licznik:=z_Licznik+1;
          DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||k_dane.nOsoba||' '||k_dane.iOsoba);
        END LOOP;
        p_Liczba:=z_Licznik;
        DBMS_OUTPUT.PUT_LINE('Liczba osob na tym stanowisku ogolem wynosi: '||p_Liczba);
        
    END stanowiskoOsoby;

END zatrudnienieOsoby;

//----------------------------------------
DECLARE
  z_Liczba NUMBER;
BEGIN
   --zatrudnienieOsoby.wyswietlOsobe(5);
   zatrudnienieOsoby.stanowiskoOsoby('Profesor',z_Liczba);
   zatrudnienieOsoby.stanowiskoOsoby(3,z_Liczba);
END;
/


