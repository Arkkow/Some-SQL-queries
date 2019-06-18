-- Wyświetl kolumny id, nazwa i stawka z tabeli Projekty.
SELECT id,
       nazwa,
       stawka
FROM projekty;



-- Wyświetl wszystkie kolumny z tabeli Pracownicy.
SELECT *
FROM pracownicy;



--Przy pomocy aliasów wyświetl z tabeli Stanowiska dwie kolumny o następujących nazwach: "nazwa stanowiska" oraz "płaca minimalna na stanowisku".
SELECT nazwa 'nazwa stanowiska',
       placa_min 'płaca minimalna na stanowisku'
FROM stanowiska;

-- Wersja 2
SELECT  nazwa [nazwa stanowiska],
       placa_min [płaca minimalna na stanowisku]
FROM Stanowiska;



-- Wyświetl nazwy stanowisk oraz liczbę znaków w tych nazwach.
SELECT nazwa,
       LEN(nazwa) AS [liczba znaków]
FROM stanowiska;



-- Dla każdego pracownika podaj jego roczny przychód z pensji.
SELECT nazwisko,
       placa*12  AS 'roczny przychód z pensji'
FROM pracownicy;



-- Dla każdego pracownika podaj ile miesięcy upłynęło między datą jego zatrudnienia a 01-01-2019 (użyj funkcji DATEDIFF).
SELECT nazwisko,
       DATEDIFF(month,zatrudniony, '01-01-2019') AS 'mies. zatrudniony'
FROM pracownicy



-- Dla każdego pracownika podaj jego nazwisko i pełne roczne wynagrodzenie, tzn. (płaca + dodatki) * 12.
SELECT nazwisko,
       (placa+ISNULL(dod_funkc, 0))*12 AS 'roczne wynagrodzenie'
FROM pracownicy



-- Dla każdego projektu podaj jego nazwę i czas trwania (w miesiącach; wykorzystaj DATEDIFF; jeżeli projekt nadal trwa, to należy porównać z dzisiejszą datą uzyskaną przy pomocy GETDATE).
SELECT nazwa,
       DATEDIFF(month,datarozp,ISNULL(datazakonczfakt, GETDATE())) AS 'czas trwania'
FROM projekty



-- Zmodyfikuj poniższe zapytanie:
-- SELECT 2/4;
-- tak aby uzyskać poniższy wynik (zapytanie ma wyświetlić dokładnie dwie cyfry po kropce):
-- 0.50
-- W zapytaniu możesz zmienić np. 2 na 2.0, itp. Użyj funkcji CAST lub CONVERT.
SELECT CAST (2.0/4.0 AS numeric(3,2));



-- Wyświetl id wszystkich kierowników projektów, bez powtórzeń.
SELECT DISTINCT kierownik
FROM projekty;



-- Wyświetl nazwy i płace minimalne poszczególnych stanowisk; informacje są posortowane najpierw malejąco według płacy minimalnej, a następnie w odwrotnym porządku alfabetycznym (zwróć uwagę gdzie znajduje się stanowisko techniczny oraz sekretarka).
SELECT nazwa,
       placa_min
FROM Stanowiska
ORDER BY placa_min DESC,
         nazwa DESC;



-- Znajdź najnowszy projekt.
SELECT  TOP 1  nazwa,
              dataRozp,
              kierownik
FROM Projekty
ORDER BY dataRozp DESC;



-- Podaj informację o pracownikach zatrudnionych na stanowisku adiunkt lub doktorant i zarabiających powyżej 1500 zł.
SELECT nazwisko,
       placa,
       stanowisko
FROM Pracownicy
WHERE placa > 1500 AND (stanowisko LIKE 'adiunkt' OR stanowisko LIKE 'doktorant');



-- Znajdź projekty zawierające web w nazwie.
SELECT nazwa
FROM Projekty
WHERE nazwa LIKE '%web%';



-- Podaj nazwiska pracowników, którzy nie mają szefa.
SELECT nazwisko
FROM Pracownicy
WHERE szef IS NULL;



-- Wyświetl pracowników, których miesięczna pensja (płaca + dodatek funkcyjny) jest większa niż 2000.
SELECT nazwisko,
       placa,
       dod_funkc,
       placa + ISNULL(dod_funkc, 0) AS 'pensja'
FROM Pracownicy
WHERE (placa + dod_funkc > 2000) OR (placa > 2000);



-- Dla każdego stanowiska wypisz typ, tzn. profesor, adiunkt i doktorant to stanowiska badawcze, a pozostałe to stanowiska administracyjne.
SELECT NAZWA,
       CASE WHEN ((NAZWA = 'PROSEFOR') OR (NAZWA = 'ADIUNKT') OR (NAZWA = 'DOKTORANT'))
         THEN 'BADACZE'
         ELSE 'ADMINISTACYJNE'
       END AS 'TYP STANOWISKA?'
FROM STANOWISKA;
