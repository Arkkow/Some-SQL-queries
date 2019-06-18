-- Podaj nazwiska pracowników, którzy nie kierują żadnym projektem. Nie używaj złączenia tabel.
SELECT nazwisko
FROM Pracownicy
WHERE id NOT IN (SELECT kierownik
                 FROM Projekty);


-- Podaj nazwiska pracowników, którzy nie są zatrudnieni w projekcie nr 10. Nie używaj złączenia tabel.
SELECT nazwisko
FROM Pracownicy
WHERE id NOT IN (SELECT idPrac
                 FROM Realizacje
                 WHERE idProj = 10);


-- Podaj nazwiska pracowników zatrudnionych w projekcie e-learning.
SELECT nazwisko
FROM Pracownicy
WHERE id IN (SELECT idPrac
             FROM Realizacje
             WHERE idProj = (SELECT id
                             FROM Projekty
                             WHERE nazwa = 'e-learning'));


-- Podaj nazwisko pracownika, który zarabia najwięcej. Wykorzystaj podzapytanie oraz ALL. Nie używaj TOP i MAX.
SELECT nazwisko,
       placa
FROM Pracownicy
WHERE placa >= ALL (SELECT placa
                    FROM Pracownicy);


-- Znajdź projekty, w których tygodniowa stawka (czyli stawka za 40 godz. pracy) w projekcie jest większa niż pensja kierownika tego projektu.
SELECT Projekty.id,
       nazwa,
       stawka,
       stawka * 40 as [tygodniowka],
       kierownik,
       nazwisko,
       placa
FROM Projekty
       join Pracownicy
            ON Projekty.kierownik = Pracownicy.id
WHERE stawka * 40 > placa

-- wersja ze skorelowanym
SELECT Projekty.id, nazwa
FROM Projekty
WHERE stawka * 40 >
      (SELECT placa
       FROM Pracownicy
       WHERE Pracownicy.id = Projekty.kierownik)


-- Sprawdź, czy w bazie znajdują się pracownicy o tym samym nazwisku (użyj podzapytania skorelowanego).
SELECT nazwisko,
       id
FROM Pracownicy P1
WHERE nazwisko IN (SELECT nazwisko
                   FROM Pracownicy P2
                   WHERE P1.id != P2.id);


-- Podaj nazwiska pracowników zatrudnionych w tym samym projekcie co ich szef. Najpierw połącz tabelę Pracownicy z tabelą Realizacje, a następnie wykorzystaj podzapytanie skorelowane.
SELECT DISTINCT P1.nazwisko
FROM Pracownicy P1
       INNER JOIN Realizacje R1
                  ON P1.id = R1.idPrac
WHERE R1.idProj IN (SELECT R2.idProj
                    FROM Realizacje R2
                    WHERE P1.szef = R2.idPrac);


-- Podaj nazwiska pracowników zatrudnionych w tym samym projekcie co ich szef. Tym razem wykorzystaj złączenia tabel.
SELECT DISTINCT P.nazwisko
FROM Pracownicy P
       INNER JOIN Realizacje R
                  ON R.idPrac = P.id
       INNER JOIN Projekty S
                  ON S.kierownik = P.szef
                    AND R.idProj = S.id;


-- Podaj nazwiska pracowników, którzy nie kierują żadnym projektem. Użyj EXISTS.
SELECT P.nazwisko
FROM Pracownicy P
WHERE NOT EXISTS(SELECT R.kierownik
                 FROM Projekty R
                 WHERE R.kierownik = P.id);


-- Znajdź pracownika, który pracuje w każdym projekcie (tzn. znajdź pracownika, dla którego nie istnieje projekt, w którym ten pracownik by nie pracował).
SELECT p.nazwisko
FROM pracownicy p
WHERE NOT exists(SELECT pr.id
                 FROM projekty pr
                 WHERE NOT exists(SELECT r.idprac
                                  FROM Realizacje r
                                  WHERE pr.id = r.idproj
                                    AND p.id = r.idprac));


-- Podaj nazwiska pracowników, którzy nie kierują żadnym projektem – 3 metody:


-- ver 1 - NOT EXISTS

SELECT nazwisko

FROM Pracownicy

WHERE NOT EXISTS(SELECT 1

                 FROM Projekty

                 WHERE Projekty.kierownik = Pracownicy.id)


-- ver 2 - NOT IN

SELECT nazwisko

FROM Pracownicy

WHERE id NOT IN (SELECT kierownik

                 FROM Projekty)


-- ver 3 - OUTER JOIN


SELECT nazwisko

FROM Pracownicy
       LEFT JOIN Projekty
                 ON Pracownicy.id = Projekty.kierownik

WHERE Projekty.id IS NULL
