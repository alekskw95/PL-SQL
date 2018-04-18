Zadanie 1
Napisac bloku anonimowego PL/SQL, w którym
a) zostanie pobrany, a nastepnie wydrukowany ROWID przykładowego rekordu danych wstawinego do tabeli osoby
31 Tomcazyk Monika 21/01/1987 K
b) powyższy ROWID zostanie wykorzystany do aktualizacji powyższej daty do daty 12/01/1987, przy czym z aktualizowanego rekordu zostaną pobrane, a nastepnie wydrukowane id_os, nazwisko, imie1 osoby, której d_ur została zaktualizowana
c) powyższy ROWID zostanie wykorzystany do usuniecia rekordu, przy czym zostanie pobrane i wydrukowane id_os i d_ur usuwanej osoby.

DECLARE
  z_NowyRowid ROWID;
  z_Id osoby.id_os%TYPE;
  z_Nazwisko osoby.nazwisko%TYPE;
  z_Imie1 osoby.imie1%TYPE;
  z_Plec osoby.plec%TYPE;
  z_Dataur osoby.d_ur%TYPE;
BEGIN
  INSERT INTO osoby(id_os,nazwisko,imie1,imie2,d_ur,plec)
  VALUES(31,'Tomczyk','Monika',' ',to_date('21/01/1987','dd/mm/yyyy'),'K')
  RETURNING rowid INTO z_NowyRowid;
  DBMS_OUTPUT.PUT_LINE('Identyfikator rowid nowego wiersza to:'||z_NowyRowid);
  
  UPDATE osoby
  SET d_ur=to_date('12/01/1987','dd/mm/yyyy')
  WHERE rowid=z_NowyRowid
  RETURNING id_os,nazwisko,imie1,d_ur,plec INTO z_Id, z_Nazwisko, z_Imie1, z_Dataur, z_Plec;
  DBMS_OUTPUT.PUT_LINE('Dane osoby: '||z_Id||' '||z_Nazwisko||' '||z_Imie1||' '||z_Dataur||' '||z_Plec);
  
  DELETE FROM osoby
  WHERE rowid=z_NowyRowid;
  DBMS_OUTPUT.PUT_LINE('Identyfikator i data ur usunietej osoby wynosi: '||z_Id||' '||z_Dataur);

END;
/



Zadanie 2
Napisac kod bloku anonimowego PL/SQL z kursorem jawnym z blokadą, którego zadaniem jest podniesienie aktualnej pensji, wsztyskicm aktualnie zatrudnionym kobietom o 10%. Operacje w sposób jawny zatwierdzić.
DECLARE
  z_zmiana NUMBER:=1.1;
  
  CURSOR k_podwyzka IS
    SELECT o.id_os, z.pensja
    FROM zatrudnienia z join osoby o on z.id_os=o.id_os
    WHERE o.plec='K' and z.do is null
    FOR UPDATE OF pensja;
BEGIN
  FOR z_Dane IN k_podwyzka LOOP
    UPDATE zatrudnienia
    SET pensja=pensja*z_zmiana
    WHERE CURRENT OF k_podwyzka;
  END LOOP;
  
  COMMIT;
END;
/

Zadanie 3
Napisac kod bloku anonimowego PL/SQL z kursorem jawnym z blokadą, którego zadaniem jest podniesienie aktualnej pensji, wsztyskicm aktualnie zatrudnionym osobom przy czym w puli na podniesienie pensji mamy 10 000zł. Operacje w sposób jawny zatwierdzić.
Wydruk z nowymi i starymi pensjami.

DECLARE
  z_kwota NUMBER:=10000;
  z_SumaOsob NUMBER;
  z_kwotaOs NUMBER;
  z_pensjaPrzed zatrudnienia.pensja%TYPE;
  z_pensjaPo zatrudnienia.pensja%TYPE;
  
  CURSOR k_PrzedPodwyzka IS
    SELECT o.id_os z_IDOS, z.pensja z_PensjaPrzed
    FROM zatrudnienia z join osoby o on z.id_os=o.id_os
    WHERE z.do is null
    FOR UPDATE OF pensja;

BEGIN
  SELECT count(o.id_os)
  INTO z_SumaOsob
  FROM osoby o join zatrudnienia z on o.id_os=z.id_os
  WHERE z.do is null;
  
  z_kwotaOs:=z_kwota/z_SumaOsob;
  
  
  DBMS_OUTPUT.PUT_LINE('ID'||' '||'Pensja przed'||' '||'Pensja po');
  FOR z_DanePrzed IN k_PrzedPodwyzka LOOP
    z_pensjaPrzed:=z_DanePrzed.z_PensjaPrzed;
    z_pensjaPo:=z_pensjaPrzed+z_kwotaOs;
    UPDATE zatrudnienia
    SET pensja=z_pensjaPo
    WHERE CURRENT OF k_PrzedPodwyzka;
    DBMS_OUTPUT.PUT_LINE(z_DanePrzed.z_IDOS||' '||z_pensjaPrzed||' '||z_pensjaPo);
  END LOOP;
  
  COMMIT;
END;
/


Zadanie 4
Napisac kod bloku anonimowego PL/SQL z kursorem jawnym z blokadą, którego zadaniem jest podniesienie aktualnej pensji, dokonac podwyzski wszytskim osobom aktualnie pracujacym na danym wydziale, wydzial zadeklarowany poprzez zmienna. Kazda z osob ma dosac taka kwote podwyzki jaka wynika z okresu jej pracy na dnaym wydziawle, czyli z liczby lat przepracownych na dnaym wydziale (za kazdy przepracowany rok osoba dostaje podwyzke wysokosci1/2% swojej aktualnej pensji ).

DECLARE
  z_IdWydzial wydzialy.id_w%TYPE:=1;
  z_lata NUMBER;
  z_zmiana NUMBER:=0.005;
  z_pensjaPrzed NUMBER;
  z_pensjaPo NUMBER;
  
  
  CURSOR k_PrzedPodwyzka IS
    SELECT o.id_os IDOS, z.pensja staraPensja,pensja*(1+TRUNC(MONTHS_BETWEEN(SYSDATE,z.od)/12)*z_zmiana) nowaPensja
    FROM zatrudnienia z join osoby o on z.id_os=o.id_os join wydzialy w on w.id_w=z.id_w
    WHERE z.do is null and w.id_w=z_IdWydzial
    FOR UPDATE OF pensja;

BEGIN
  DBMS_OUTPUT.PUT_LINE('ID'||' '||'Przed'||' '||'Po');
  FOR i IN k_PrzedPodwyzka LOOP
    z_pensjaPrzed:=i.staraPensja;
    UPDATE zatrudnienia
    SET pensja=pensja+i.nowaPensja
    WHERE CURRENT OF k_PrzedPodwyzka;
    DBMS_OUTPUT.PUT_LINE(i.IDOS||' poprzednia pensja: '||z_pensjaPrzed||' nowa pensja: '||i.nowaPensja);
  END LOOP;
  
  COMMIT;
END;
/