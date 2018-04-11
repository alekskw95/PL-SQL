Zadanie 1
Napisac blok anonimoway pl/sql umożliwiajacy wyswietlenie dla poszczegolnych wydzialow komunikatu.
Kierownikiem wydzialu Matematyki jest Krawczyk Adam.

DECLARE
  z_Licznik NUMBER:=1;
  CURSOR k_dane IS
    SELECT initcap(w.nazwa) z_NazwaWydzialu, initcap(o.nazwisko) z_Nazwisko, initcap(o.imie1) z_Imie
     FROM osoby o join kierownicy k on k.id_os=o.id_os join wydzialy w on w.id_w=k.id_w
     WHERE k.do is null;   
BEGIN
  FOR z_dane IN k_dane LOOP
      CASE z_dane.z_NazwaWydzialu
        WHEN 'Matematyka' THEN z_dane.z_NazwaWydzialu:='Matematyki';
        WHEN 'Prawo' THEN z_dane.z_NazwaWydzialu:='Prawa';
        WHEN 'Ekonomia' THEN z_dane.z_NazwaWydzialu:='Ekonomii';
        WHEN 'Filologia' THEN z_dane.z_NazwaWydzialu:='Filologii';
        WHEN 'Fizyka' THEN z_dane.z_NazwaWydzialu:='Fizyki';
        WHEN 'Biologia' THEN z_dane.z_NazwaWydzialu:='Biologii';
      END CASE;
  DBMS_OUTPUT.PUT_LINE(z_Licznik||' Kierownikiem wydzialu '||z_dane.z_NazwaWydzialu||' jest '||z_dane.z_Nazwisko||' '||z_dane.z_Imie);
    z_Licznik:=z_Licznik+1;
  END LOOP;
END;
/


Zadanie 2
Napisac kod bloku za pomocą którego będzie wyświetlana na poszczególnych wydziałach lista osób aktualnie zatrudnionych,
przy czym każda osoba będzie poprzedona kolejna liczbą porządkową.

Lista osób zatrudnionych na wydziale Matematyka:
1. Duda Barbara
2. Krawczyk Adam

DECLARE
  z_Licznik NUMBER:=1;
  z_Nazwa wydzialy.nazwa%TYPE;
  CURSOR k_dane IS
    SELECT initcap(o.nazwisko) z_Nazwisko, initcap(o.imie1) z_Imie
     FROM osoby o join zatrudnienia z on z.id_os=o.id_os join wydzialy w on w.id_w=z.id_w
     WHERE z.do is null and initcap(w.nazwa)=initcap(z_Nazwa)
     order by 1 asc;   
  CURSOR k_daneWydzial IS
    SELECT initcap(w.nazwa) z_NazwaWydzialu
     FROM wydzialy w
     order by 1 asc; 
BEGIN
  FOR z_dane IN k_daneWydzial LOOP
    DBMS_OUTPUT.PUT_LINE('Lista osób zatrudnionych na wydziale '||z_dane.z_NazwaWydzialu);
    z_Nazwa:=z_dane.z_NazwaWydzialu;
      FOR z_daneOs IN k_dane LOOP
        DBMS_OUTPUT.PUT_LINE(z_Licznik||' '||z_daneOs.z_Nazwisko||' '||z_daneOs.z_Imie);
        z_Licznik:=z_Licznik+1;
      END LOOP;
      z_Licznik:=1;
      DBMS_OUTPUT.PUT_LINE(' ');
  END LOOP; 
END;
/


Zadanie 3
Napisać kod bloku anonimowego pl/sql, za pomocą którego będzie wyświetlony rok, miesiąc oraz lista osób zatrudniona
w tym okresie. Ma być wyświetlony rok zatrudnienia (podajemy rok), nastepnie miesiąc zatrudnienia
(podajemy cyfrę miesiąca) a nastepnie lista osób zatrudnionych w tym okresie, poprzedzona liczba porządkową z kropką.

Rok zatrudnienia - 2005
	Miesiąc zatrudnia - 6
	1. Duda Barbara
	2. Krawczyk Adam

	Miesiac zatrudnienia - 10
	1. Duda Barbara
	2. Krawczyk Adam
	
Rok zatrudnienia - 2004
	Miesiąc zatrudnia - 6
		1. Duda Barbara
		2. Krawczyk Adam

	Miesiac zatrudnienia - 10
	1. Duda Barbara
	2. Krawczyk Adam


DECLARE
  z_Licznik NUMBER:=1;
  z_RokZ CHAR(4);
  z_MZ CHAR(2);
  CURSOR k_dane IS
    SELECT initcap(o.nazwisko) z_Nazwisko, initcap(o.imie1) z_Imie
     FROM osoby o join zatrudnienia z on z.id_os=o.id_os 
     WHERE to_char(z.od, 'yyyy')= z_RokZ and to_char(z.od, 'mm')=z_MZ
     order by 1 asc;   
     
  CURSOR k_daneR IS
    SELECT distinct to_char(z.od, 'yyyy') z_Rok
     FROM zatrudnienia z
     order by 1 DESC;
     
  CURSOR k_daneM IS
    SELECT distinct to_char(z.od, 'mm') z_Miesiac
     FROM zatrudnienia z
     WHERE to_char(z.od, 'yyyy')=z_RokZ
     order by 1 ASC;
BEGIN
  FOR z_dane IN k_daneR LOOP
    DBMS_OUTPUT.PUT_LINE('Rok zatrudnienia - '||z_dane.z_Rok);
    z_RokZ:=z_dane.z_Rok;
      FOR z_daneM IN k_daneM LOOP
        DBMS_OUTPUT.PUT_LINE('Miesiac zatrudnienia - '||z_daneM.z_Miesiac);
        z_MZ:=z_daneM.z_Miesiac;
                FOR z_daneOs IN k_dane LOOP
                DBMS_OUTPUT.PUT_LINE(z_Licznik||'. '||z_daneOs.z_Nazwisko||' '||z_daneOs.z_Imie);
                z_Licznik:=z_Licznik+1;
                END LOOP;
                z_Licznik:=1;
      END LOOP;
      DBMS_OUTPUT.PUT_LINE(' ');
      DBMS_OUTPUT.PUT_LINE(' ');
  END LOOP; 
END;
/



