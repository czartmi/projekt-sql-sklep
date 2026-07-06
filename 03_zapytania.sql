SELECT p.produkt_id,
       p.nazwa        AS produkt,
       k.nazwa        AS kategoria,
       p.cena
FROM produkty p
INNER JOIN kategorie k ON p.kategoria_id = k.kategoria_id
ORDER BY k.nazwa, p.cena DESC;


SELECT nazwa, cena
FROM produkty
WHERE cena > (SELECT AVG(cena) FROM produkty)
ORDER BY cena DESC;


SELECT k.klient_id,
       k.imie,
       k.nazwisko,
       COUNT(z.zamowienie_id) AS liczba_zamowien
FROM klienci k
LEFT JOIN zamowienia z ON k.klient_id = z.klient_id
GROUP BY k.klient_id, k.imie, k.nazwisko
ORDER BY liczba_zamowien DESC;


SELECT z.zamowienie_id,
       z.data_zamowienia,
       z.status,
       SUM(pz.ilosc * pz.cena_jednostkowa) AS wartosc_zamowienia
FROM zamowienia z
JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
GROUP BY z.zamowienie_id, z.data_zamowienia, z.status
ORDER BY wartosc_zamowienia DESC;


SELECT k.imie,
       k.nazwisko,
       SUM(pz.ilosc * pz.cena_jednostkowa) AS suma_wydatkow
FROM klienci k
JOIN zamowienia z          ON k.klient_id = z.klient_id
JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
WHERE z.status = 'zrealizowane'
GROUP BY k.klient_id, k.imie, k.nazwisko
ORDER BY suma_wydatkow DESC
LIMIT 5;


SELECT DATE_TRUNC('month', z.data_zamowienia)::date AS miesiac,
       SUM(pz.ilosc * pz.cena_jednostkowa)          AS przychod
FROM zamowienia z
JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
WHERE z.status = 'zrealizowane'
GROUP BY miesiac
ORDER BY miesiac;


SELECT p.nazwa,
       SUM(pz.ilosc)                       AS sprzedane_sztuki,
       SUM(pz.ilosc * pz.cena_jednostkowa) AS przychod_z_produktu
FROM produkty p
JOIN pozycje_zamowienia pz ON p.produkt_id = pz.produkt_id
GROUP BY p.produkt_id, p.nazwa
ORDER BY sprzedane_sztuki DESC;


SELECT p.produkt_id, p.nazwa, p.stan_magazynowy
FROM produkty p
LEFT JOIN pozycje_zamowienia pz ON p.produkt_id = pz.produkt_id
WHERE pz.produkt_id IS NULL;


SELECT kat.nazwa                             AS kategoria,
       SUM(pz.ilosc * pz.cena_jednostkowa)   AS przychod
FROM kategorie kat
JOIN produkty p            ON kat.kategoria_id = p.kategoria_id
JOIN pozycje_zamowienia pz ON p.produkt_id = pz.produkt_id
GROUP BY kat.nazwa
ORDER BY przychod DESC;


SELECT kat.nazwa,
       COUNT(p.produkt_id) AS liczba_produktow
FROM kategorie kat
JOIN produkty p ON kat.kategoria_id = p.kategoria_id
GROUP BY kat.nazwa
HAVING COUNT(p.produkt_id) > 3
ORDER BY liczba_produktow DESC;


SELECT k.imie,
       k.nazwisko,
       SUM(pz.ilosc * pz.cena_jednostkowa) AS wydatki,
       CASE
           WHEN SUM(pz.ilosc * pz.cena_jednostkowa) >= 2000 THEN 'VIP'
           WHEN SUM(pz.ilosc * pz.cena_jednostkowa) >= 500  THEN 'Sredni'
           ELSE 'Maly'
       END AS segment
FROM klienci k
JOIN zamowienia z          ON k.klient_id = z.klient_id
JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
WHERE z.status = 'zrealizowane'
GROUP BY k.klient_id, k.imie, k.nazwisko
ORDER BY wydatki DESC;


SELECT kategoria,
       produkt,
       przychod,
       RANK() OVER (PARTITION BY kategoria ORDER BY przychod DESC) AS miejsce_w_kategorii
FROM (
    SELECT kat.nazwa                           AS kategoria,
           p.nazwa                             AS produkt,
           SUM(pz.ilosc * pz.cena_jednostkowa) AS przychod
    FROM kategorie kat
    JOIN produkty p            ON kat.kategoria_id = p.kategoria_id
    JOIN pozycje_zamowienia pz ON p.produkt_id = pz.produkt_id
    GROUP BY kat.nazwa, p.nazwa
) AS przychody_produktow
ORDER BY kategoria, miejsce_w_kategorii;


WITH wydatki_klientow AS (
    SELECT k.klient_id,
           k.imie,
           k.nazwisko,
           SUM(pz.ilosc * pz.cena_jednostkowa) AS wydatki
    FROM klienci k
    JOIN zamowienia z          ON k.klient_id = z.klient_id
    JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
    WHERE z.status = 'zrealizowane'
    GROUP BY k.klient_id, k.imie, k.nazwisko
)
SELECT imie, nazwisko, wydatki
FROM wydatki_klientow
WHERE wydatki > (SELECT AVG(wydatki) FROM wydatki_klientow)
ORDER BY wydatki DESC;


SELECT kat.nazwa                          AS kategoria,
       SUM(p.cena * p.stan_magazynowy)    AS wartosc_magazynu
FROM kategorie kat
JOIN produkty p ON kat.kategoria_id = p.kategoria_id
GROUP BY kat.nazwa
ORDER BY wartosc_magazynu DESC;


SELECT k.imie, k.nazwisko, k.email, k.data_rejestracji
FROM klienci k
LEFT JOIN zamowienia z ON k.klient_id = z.klient_id
WHERE z.zamowienie_id IS NULL;
