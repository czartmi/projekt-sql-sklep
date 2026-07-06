DROP TABLE IF EXISTS pozycje_zamowienia CASCADE;
DROP TABLE IF EXISTS zamowienia        CASCADE;
DROP TABLE IF EXISTS produkty          CASCADE;
DROP TABLE IF EXISTS kategorie         CASCADE;
DROP TABLE IF EXISTS klienci           CASCADE;


CREATE TABLE kategorie (
    kategoria_id  SERIAL PRIMARY KEY,
    nazwa         VARCHAR(50) NOT NULL UNIQUE
);


CREATE TABLE klienci (
    klient_id         SERIAL PRIMARY KEY,
    imie              VARCHAR(50)  NOT NULL,
    nazwisko          VARCHAR(50)  NOT NULL,
    email             VARCHAR(120) NOT NULL UNIQUE,
    miasto            VARCHAR(50),
    data_rejestracji  DATE NOT NULL DEFAULT CURRENT_DATE
);


CREATE TABLE produkty (
    produkt_id        SERIAL PRIMARY KEY,
    nazwa             VARCHAR(100)   NOT NULL,
    kategoria_id      INT            NOT NULL,
    cena              DECIMAL(10,2)  NOT NULL CHECK (cena >= 0),
    stan_magazynowy   INT            NOT NULL DEFAULT 0 CHECK (stan_magazynowy >= 0),
    CONSTRAINT fk_produkt_kategoria
        FOREIGN KEY (kategoria_id) REFERENCES kategorie(kategoria_id)
);


CREATE TABLE zamowienia (
    zamowienie_id     SERIAL PRIMARY KEY,
    klient_id         INT   NOT NULL,
    data_zamowienia   DATE  NOT NULL DEFAULT CURRENT_DATE,
    status            VARCHAR(20) NOT NULL DEFAULT 'nowe'
                      CHECK (status IN ('nowe','wyslane','zrealizowane','anulowane')),
    CONSTRAINT fk_zamowienie_klient
        FOREIGN KEY (klient_id) REFERENCES klienci(klient_id)
);


CREATE TABLE pozycje_zamowienia (
    pozycja_id        SERIAL PRIMARY KEY,
    zamowienie_id     INT NOT NULL,
    produkt_id        INT NOT NULL,
    ilosc             INT NOT NULL CHECK (ilosc > 0),
    cena_jednostkowa  DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_pozycja_zamowienie
        FOREIGN KEY (zamowienie_id) REFERENCES zamowienia(zamowienie_id) ON DELETE CASCADE,
    CONSTRAINT fk_pozycja_produkt
        FOREIGN KEY (produkt_id) REFERENCES produkty(produkt_id)
);
