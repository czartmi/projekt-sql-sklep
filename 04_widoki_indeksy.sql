CREATE INDEX idx_produkty_kategoria       ON produkty(kategoria_id);
CREATE INDEX idx_zamowienia_klient        ON zamowienia(klient_id);
CREATE INDEX idx_zamowienia_status        ON zamowienia(status);
CREATE INDEX idx_pozycje_zamowienie       ON pozycje_zamowienia(zamowienie_id);
CREATE INDEX idx_pozycje_produkt          ON pozycje_zamowienia(produkt_id);


CREATE OR REPLACE VIEW widok_wartosc_zamowien AS
SELECT z.zamowienie_id,
       z.data_zamowienia,
       z.status,
       k.imie,
       k.nazwisko,
       SUM(pz.ilosc * pz.cena_jednostkowa) AS wartosc_zamowienia
FROM zamowienia z
JOIN klienci k             ON z.klient_id = k.klient_id
JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
GROUP BY z.zamowienie_id, z.data_zamowienia, z.status, k.imie, k.nazwisko;


CREATE OR REPLACE VIEW widok_podsumowanie_klientow AS
SELECT k.klient_id,
       k.imie,
       k.nazwisko,
       k.miasto,
       COUNT(DISTINCT z.zamowienie_id)                          AS liczba_zamowien,
       COALESCE(SUM(pz.ilosc * pz.cena_jednostkowa), 0)         AS suma_wydatkow
FROM klienci k
LEFT JOIN zamowienia z          ON k.klient_id = z.klient_id
                               AND z.status = 'zrealizowane'
LEFT JOIN pozycje_zamowienia pz ON z.zamowienie_id = pz.zamowienie_id
GROUP BY k.klient_id, k.imie, k.nazwisko, k.miasto;
