SET SERVEROUTPUT ON


begin
DBMS_OUTPUT.PUT_LINE('Hello');
end;


Zadanie 1
Zdefiniować typ rekordowy, przeznaczony do przechowywania następujących informacji o osobach: id, nazwisko, imiona, data urodzenia, plec. Przy czym, typ rekordowy zdefiniować:
a) w sposób jawny 
b) w sposob nie jawny. 
Następnie przy jego wykorzystaniu wyświetlić dane osoby z tabeli osoby, której id jest dane poprzez zainicjowanie odpowiedniej zmiennej PL/SQL-owej w sekcji deklaracji.

a)
DECLARE
  TYPE t_RekordOsoba IS RECORD(
  p_Id osoby.id_os%TYPE,
  p_Nazwisko osoby.nazwisko%TYPE,
  p_Imie osoby.imie1%TYPE,
  p_Imie2 osoby.imie2%TYPE,
  p_DataUr osoby.d_ur%TYPE,
  p_Plec osoby.plec%TYPE 
  );
  rDane t_RekordOsoba;
  z_Id osoby.id_os%TYPE:=1;
BEGIN
  Select o.id_os, initcap(o.nazwisko), initcap(o.imie1), initcap(o.imie2), o.d_ur, o.plec
  INTO rDane
  From Osoby o 
  Where o.id_os=z_Id;
  DBMS_OUTPUT.PUT_LINE(rDane.p_Id||' '||rDane.p_Nazwisko||' '||rDane.p_Imie||' '||rDane.p_Imie2||' '||rDane.p_DataUr||' '||rDane.p_Plec);
END;
/

b)
DECLARE
  rDane osoby%ROWTYPE;
  z_Id osoby.id_os%TYPE:=1;
BEGIN
  Select o.id_os, initcap(o.nazwisko), initcap(o.imie1), initcap(o.imie2), o.d_ur, o.plec
  INTO rDane
  From Osoby o 
  Where o.id_os=z_Id;
  DBMS_OUTPUT.PUT_LINE(rDane.id_os||' '||rDane.nazwisko||' '||rDane.imie1||' '||rDane.imie2||' '||rDane.plec||' '||rDane.d_ur);
END;
/



Zadanie 2
Zdefiniować dwa typy rekordowe t_Osoba1 i t_Osoba2 składające się z nastepujacych pól: p.id_os, p.nazwisko, p.imie1, p.d_ur. Następnie zadeklarować po dwie zmienne dla każdego z tyów:
r_osoba11
r_osoba12


r_osoba21
r_osoba22.

Do r_osoba11 przypisać następujące dane: 1 Kowalska, Maria, 05/05/1990.
Wykonać operację przypisania pozostałym zmiennym rekordowym, za pomocą różnych sposobów przypisawania wartości rekordom. 


DECLARE 
  TYPE t_osoba1 IS RECORD (
  p_id_os osoby.id_os%TYPE, 
  p_nazwisko osoby.nazwisko%TYPE,
  p_imie1 osoby.imie1%TYPE,
  p_d_ur osoby.d_ur%TYPE
  );
  TYPE t_osoba2 IS RECORD (
  p_id_os osoby.id_os%TYPE, 
  p_nazwisko osoby.nazwisko%TYPE,
  p_imie1 osoby.imie1%TYPE,
  p_d_ur osoby.d_ur%TYPE
  );

  r_osoba11 t_osoba1;
  r_osoba12 t_osoba1;
  r_osoba21 t_osoba2;
  r_osoba22 t_osoba2;
  
BEGIN 
  r_osoba11.p_id_os :=1;
  r_osoba11.p_nazwisko :='Kowalska';
  r_osoba11.p_imie1 := 'Maria';
  r_osoba11.p_d_ur :=to_date('05/05/1990','dd/mm/yyyy');
  
  --r_osoba12 :=r_osoba11; --Isposob
  
  r_osoba12.p_id_os :=r_osoba11.p_id_os;
  r_osoba12.p_nazwisko :=r_osoba11.p_nazwisko;
  r_osoba12.p_imie1 := r_osoba11.p_imie1;
  r_osoba12.p_d_ur :=r_osoba11.p_d_ur;
  
  
  --r_osoba22 := r_osoba11; --nie dziala
  --nie wolno przypisywać zmiennych z dwóch niekompatybilnych typów
  
  r_osoba21.p_id_os :=r_osoba11.p_id_os;
  r_osoba21.p_nazwisko :=r_osoba11.p_nazwisko;
  r_osoba21.p_imie1 := r_osoba11.p_imie1;
  r_osoba21.p_d_ur :=r_osoba11.p_d_ur;
  
  dbms_output.put_line(r_osoba12.p_id_os||' '||r_osoba12.p_nazwisko||' '||r_osoba12.p_imie1||' '||r_osoba12.p_d_ur);
  dbms_output.put_line(r_osoba21.p_id_os||' '||r_osoba21.p_nazwisko||' '||r_osoba21.p_imie1||' '||r_osoba21.p_d_ur);

END;
/


--MOJE
DECLARE
  TYPE t_Osoba1 IS RECORD(
  p_id osoby.id_os%TYPE,
  p_nazwisko osoby.nazwisko%TYPE,
  p_imie1 osoby.imie1%TYPE,
  p_dUr osoby.d_ur%TYPE
  );
  TYPE t_Osoba2 IS RECORD(
  p_id osoby.id_os%TYPE,
  p_nazwisko osoby.nazwisko%TYPE,
  p_imie1 osoby.imie1%TYPE,
  p_dUr osoby.d_ur%TYPE
  );
  r_Osoba11 t_Osoba1;
  r_Osoba12 t_Osoba1;
  
  r_Osoba21 t_Osoba2;
  r_Osoba22 t_Osoba2;
BEGIN
  r_Osoba11.p_id:=1;
  r_Osoba11.p_nazwisko:='Kowalska';
  r_Osoba11.p_imie1:='Maria';
  r_Osoba11.p_dUr:=TO_DATE('1990/05/05','yyyy/mm/dd');
  
  r_Osoba12.p_id:=r_Osoba11.p_id;
  r_Osoba12.p_nazwisko:=r_Osoba11.p_nazwisko;
  r_Osoba12.p_imie1:=r_Osoba11.p_imie1;
  r_Osoba12.p_dUr:=r_Osoba11.p_dUr;
  
  r_Osoba21.p_id :=r_Osoba11.p_id;
  r_Osoba21.p_nazwisko :=r_Osoba11.p_nazwisko;
  r_Osoba21.p_imie1 := r_Osoba11.p_imie1;
  r_Osoba21.p_dUr :=r_Osoba11.p_dUr;
  
  r_Osoba22.p_id :=r_Osoba12.p_id;
  r_Osoba22.p_nazwisko :=r_Osoba12.p_nazwisko;
  r_Osoba22.p_imie1 := r_Osoba12.p_imie1;
  r_Osoba22.p_dUr :=r_Osoba12.p_dUr;
  
  dbms_output.put_line('Osoba11: '||r_Osoba12.p_id||' '||r_Osoba12.p_nazwisko||' '||r_Osoba12.p_imie1||' '||r_Osoba12.p_dUr);
  dbms_output.put_line('Osoba12: '||r_Osoba12.p_id||' '||r_Osoba12.p_nazwisko||' '||r_Osoba12.p_imie1||' '||r_Osoba12.p_dUr);
  dbms_output.put_line('Osoba21: '||r_Osoba21.p_id||' '||r_Osoba21.p_nazwisko||' '||r_Osoba21.p_imie1||' '||r_Osoba21.p_dUr);
  dbms_output.put_line('Osoba22: '||r_Osoba22.p_id||' '||r_Osoba22.p_nazwisko||' '||r_Osoba22.p_imie1||' '||r_Osoba22.p_dUr);
END;
/



Zadanie 4
Za pomocą zmiennej rekordowej o typie dane wprowadzić do tabelki osoby za pomocą tej zmiennej następujące dane:
31 Pawłowska Marta 23/05/1982 K.
Operacje zatwierdzić w sposób jawny.
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
  rDane.p_nazwisko:='Pawlowska';
  rDane.p_Imie1:='Marta';
  rDane.p_Imie2:='';
  rDane.p_DataUr:=TO_DATE('28/05/1987','dd/mm/yyyy');
  rDane.p_Plec:='K';
  INSERT INTO osoby VALUES rDane;
  COMMIT;
END;
/
