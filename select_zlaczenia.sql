-- a) Dla każdego pracownika zestaw jego płacę z płacą minimalną na każdym stanowisku. Poniżej znajduje się przykładowy wynik dla pierwszych 12 wierszy:
SELECT nazwisko,
       placa,
       nazwa,
       placa_min
FROM Pracownicy,
     Stanowiska
ORDER BY nazwisko;

-- b) Pozostaw w zestawieniu tylko stanowiska profesor i sekretarka. Poniżej znajduje się pierwsze 10 wyników:
SELECT nazwisko,
       placa,
       nazwa,
       placa_min
FROM Pracownicy,
     Stanowiska
WHERE nazwa like 'profesor'
   or nazwa like 'sekretarka'
ORDER BY nazwisko;


-- Dla każdego pracownika podaj jego nazwisko, płacę, nazwę stanowiska oraz widełki płacowe na jego stanowisku.
SELECT Pracownicy.nazwisko,
       Pracownicy.placa,
       Pracownicy.stanowisko,
       Stanowiska.placa_min,
       Stanowiska.placa_max
FROM Pracownicy
            INNER JOIN Stanowiska
                       ON Pracownicy.stanowisko = Stanowiska.nazwa


-- Dla każdego pracownika podaj nazwy projektów w których pracuje; posortuj alfabetycznie po nazwisku.
SELECT Pracownicy.nazwisko,
       Projekty.nazwa
FROM Realizacje
            INNER JOIN Projekty
                       ON Projekty.id = Realizacje.idProj
            INNER JOIN Pracownicy
                       ON Pracownicy.id = Realizacje.idPrac
ORDER BY nazwisko ASC


-- Znajdź doktorantów, których płaca nie mieści się w widełkach płacowych dla doktoranta.
SELECT Pracownicy.nazwisko,
       Pracownicy.placa,
       Pracownicy.stanowisko,
       Stanowiska.placa_min,
       Stanowiska.placa_max
FROM Pracownicy
            INNER JOIN Stanowiska
                       ON (Pracownicy.placa > placa_max OR Pracownicy.placa < placa_min)
WHERE Stanowiska.nazwa = 'doktorant'
  AND Pracownicy.stanowisko = 'doktorant'


-- Dla każdego pracownika podaj jego nazwisko oraz nazwisko jego szefa.
SELECT P1.nazwisko,
       P2.nazwisko
FROM Pracownicy P1
            JOIN Pracownicy P2
                 ON P1.szef = P2.id


-- Sprawdź, czy w bazie znajdują się pracownicy o tym samym nazwisku.
SELECT TOP 1 P1.id,
             P1.nazwisko,
             P2.id,
             P2.nazwisko
FROM Pracownicy P1
            JOIN Pracownicy P2
                 ON P1.nazwisko = P2.nazwisko AND P1.id != P2.id


-- Zmodyfikuj rozwiązanie Zadania:
--
-- ,,Dla każdego pracownika podaj jego nazwisko oraz nazwisko jego szefa.''
--
-- tak aby na liście pracowników uwzględnić również Wachowiaka (który nie ma nad sobą szefa).
SELECT P1.nazwisko,
       P2.nazwisko
FROM Pracownicy P1
            LEFT OUTER JOIN Pracownicy P2
                            ON P1.szef = P2.id


-- Podaj nazwiska pracowników, którzy nie kierują żadnym projektem.
SELECT P1.nazwisko
FROM Pracownicy P1
            LEFT OUTER JOIN Projekty P2
                            ON P1.id = P2.kierownik
WHERE P2.id IS NULL;


-- Podaj nazwiska pracowników, którzy nie są zatrudnieni w projekcie nr 10.
SELECT P1.nazwisko
FROM Pracownicy P1
            LEFT OUTER JOIN Realizacje P2
                            ON P2.idProj = 10 AND P2.idPrac = P1.id
WHERE P2.idProj IS NULL;


-- Zweryfikuj, czy każdy pracownik kierujący projektem jest również pracownikiem tego projektu (wpisanym do tabeli Realizacje). Zapytanie ma zwracać pracowników nie spełniających tego warunku.
SELECT Pracownicy.nazwisko,
       Projekty.id       as 'kieruje projektem',
       Realizacje.idPrac as 'pracuje w projekcie'
FROM Pracownicy
            JOIN Projekty ON Projekty.kierownik = Pracownicy.id
            LEFT JOIN Realizacje ON Projekty.id = Realizacje.idProj
WHERE Realizacje.idPrac IS NULL;


-- Znajdź najlepiej zarabiającego pracownika. Użyj złączenia zewnętrznego. Nie używaj TOP i MAX.
SELECT P1.nazwisko,
       P1.placa
FROM Pracownicy P1
            LEFT OUTER JOIN Pracownicy P2
                            ON P2.placa > P1.placa
WHERE P2.placa IS NULL 