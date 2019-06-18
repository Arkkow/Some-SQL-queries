-- Podaj średnią zarobków oraz liczbę pracowników pracujących w projekcie e-learning. Wykorzystaj funkcję agregującą.
SELECT AVG(placa), COUNT(*)
FROM Pracownicy
       JOIN Realizacje
            ON Pracownicy.id = Realizacje.idPrac
       JOIN Projekty
            ON Projekty.id = Realizacje.idProj
WHERE Projekty.nazwa = 'e-learning'


-- ver 2, lepsza gdyby powtarzali sie pracownicy
SELECT AVG(placa),
       COUNT(*)
FROM Pracownicy
WHERE id IN (SELECT IdPrac
             FROM Realizacje
                    JOIN Projekty
                         ON Projekty.id = Realizacje.idProj
             WHERE Projekty.nazwa = 'e-learning')


-- Podaj nazwisko pracownika, który zarabia najwięcej. Wykorzystaj podzapytanie i funkcję agregującą.
SELECT nazwisko,
       placa
FROM Pracownicy
WHERE placa = (SELECT MAX(placa)
               FROM Pracownicy);


-- Dla każdego stanowiska podaj nazwisko pracownika, który zarabia najwięcej na danym stanowisku. Wykorzystaj podzapytanie skorelowane i funkcją agregującą.
SELECT P1.stanowisko,
       P1.nazwisko,
       P1.placa
FROM Pracownicy P1
WHERE P1.placa IN (SELECT MAX(P2.placa)
                   FROM Pracownicy P2
                   WHERE P1.stanowisko = P2.stanowisko);


-- Sprawdź ilu różych pracowników było zaangażowanych w realizacje projektów.
SELECT COUNT(DISTINCT idPrac) AS 'ilu różnych pracowników'
FROM Realizacje;


-- Sprawdź ilu różnych szefów mają pracownicy.
SELECT COUNT(DISTINCT szef) AS 'liczba szefów'
FROM Pracownicy
WHERE szef IS NOT NULL;


-- Dla każdego szefa podaj minimalną i maksymalną płacę jego pracowników. Wykorzystaj funkcje agregujące i grupowanie.
SELECT szef,
       MIN(placa) 'minimum',
       MAX(placa) 'maximum'
FROM Pracownicy
WHERE szef IS NOT NULL
GROUP BY szef;


-- Dla każdego pracownika policz ilu ma podwładnych.
SELECT P1.nazwisko, COUNT(P2.id) 'ilu podwładnych'
FROM Pracownicy P1
       LEFT JOIN Pracownicy P2
                 ON P2.szef = P1.id
GROUP BY P1.nazwisko;


-- Dla pracowników, którzy nie są profesorami i brali udział w więcej niż jednym projekcie, podaj informacje o liczbie różnych projektów, których byli uczestnikami. Wykorzystaj klauzule GROUP BY i HAVING. Uwzględnij sytuację gdy pracownik miał przerwę w projekcie.
SELECT P.nazwisko,
       COUNT(R.idProj) AS 'liczba różnych projektów'
FROM Pracownicy P
       JOIN Realizacje R
            ON R.idPrac = P.id
WHERE P.stanowisko != 'profesor'
GROUP BY P.nazwisko
HAVING COUNT(R.idProj) > 1;


-- Przed wykonaniem zadania dodajmy na chwilę jednego pracownika:
SELECT P.nazwisko,
       COUNT(P.id) 'liczba'
FROM Pracownicy P
       JOIN Pracownicy P2
            ON P.nazwisko = P2.nazwisko AND P.id != P2.id
GROUP BY P.nazwisko
HAVING COUNT(P.id) > 1;


-- Wykorzystując operację UNION ALL, wyświetl informacje o projektach
SELECT nazwa,
       dataZakonczPlan         'DataZakonczenia',
       'projekt zakonczony' AS 'Status'
FROM Projekty
WHERE dataZakonczPlan < GETDATE()

UNION ALL

SELECT nazwa, dataZakonczPlan 'DataZakonczenia', 'projekt trwa' AS 'Status'
FROM Projekty
WHERE dataZakonczPlan >= GETDATE();

-- wersja 2
SELECT nazwa,
       dataZakonczPlan   'DataZakonczenia',
       'projekt trwa' AS 'Status'
FROM Projekty
WHERE dataZakonczFakt IS NULL

UNION ALL

SELECT nazwa,
       dataZakonczPlan         'DataZakonczenia',
       'projekt zakonczony' AS 'Status'
FROM Projekty
WHERE dataZakonczFakt < GETDATE()


-- Podaj nazwiska pracowników, którzy nie kierują żadnym projektem. Użyj EXCEPT.
SELECT nazwisko
FROM Pracownicy
WHERE id IN (SELECT id
             FROM Pracownicy
               EXCEPT

             SELECT kierownik
             FROM Projekty);


-- Wyświetl pracowników, których miesięczna pensja (płaca + dodatek funkcyjny) jest większa niż 2000.
SELECT nazwisko,
       placa,
       dod_funkc,
       pensja
FROM (SELECT *, placa + ISNULL(dod_funkc, 0) as pensja
      FROM pracownicy) as t
WHERE pensja > 2000;


-- Porównaj płacę każdego pracownika ze średnią płacą. Wykorzystaj podzapytanie w klauzuli SELECT.
SELECT nazwisko,
       (placa / (SELECT AVG(placa) FROM pracownicy)) * 100
         AS 'procent średniej'
FROM pracownicy