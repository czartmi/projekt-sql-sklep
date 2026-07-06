# 🛒 Analiza sprzedaży sklepu internetowego (SQL / PostgreSQL)

Projekt zaliczeniowy zrealizowany w ramach przedmiotu **Bazy danych** na studiach.
Modeluje działanie sklepu internetowego: klientów, produkty, kategorie i zamówienia.
Zawiera zaprojektowany od zera schemat relacyjny, dane testowe oraz zestaw
**15 zapytań analitycznych** odpowiadających na realne pytania biznesowe
(najlepsi klienci, przychód miesięczny, produkty bez sprzedaży itd.).

> Cel projektu: pokazać praktyczną znajomość SQL — od projektowania schematu,
> przez relacje i klucze obce, po zapytania analityczne z agregacjami, JOIN-ami,
> podzapytaniami, widokami i funkcjami okna.

> ℹ️ **Dane** wykorzystane w projekcie są danymi syntetycznymi (wygenerowanymi
> na potrzeby zaliczenia), aby zaprezentować działanie zapytań.

---

## 🧰 Użyte technologie
- **PostgreSQL** (standardowy SQL; działa też w innych silnikach po drobnych zmianach)
- Narzędzie do klikania/uruchamiania: **pgAdmin** lub **DBeaver**

---

## 🗂️ Struktura repozytorium
| Plik | Zawartość |
|------|-----------|
| `01_schema.sql` | Tworzenie tabel, kluczy głównych i obcych, ograniczeń (DDL) |
| `02_dane.sql` | Dane testowe: 5 kategorii, 12 klientów, 18 produktów, 20 zamówień |
| `03_zapytania.sql` | 15 zapytań analitycznych z komentarzami |
| `04_widoki_indeksy.sql` | Widoki i indeksy (elementy średniozaawansowane) |

---

## 🧩 Model danych (ERD)

Pięć tabel w trzeciej postaci normalnej (3NF). Relacje `1:N` oraz `N:M`
(zamówienia ↔ produkty przez tabelę łączącą `pozycje_zamowienia`).

```
  kategorie                klienci
      │ 1                     │ 1
      │                       │
      │ N                     │ N
  produkty               zamowienia
      │ 1                     │ 1
      │                       │
      │ N                     │ N
      └──── pozycje_zamowienia ────┘
                (tabela łącząca N:M)
```

- **kategorie** (kategoria_id 🔑) — słownik kategorii
- **klienci** (klient_id 🔑) — dane klientów
- **produkty** (produkt_id 🔑, kategoria_id 🔗) — produkty przypisane do kategorii
- **zamowienia** (zamowienie_id 🔑, klient_id 🔗) — nagłówek zamówienia
- **pozycje_zamowienia** (pozycja_id 🔑, zamowienie_id 🔗, produkt_id 🔗) — pozycje zamówienia

---

## ▶️ Jak uruchomić

### Opcja A — bez instalacji (najszybciej)
1. Wejdź na internetowy edytor Postgresa, np. **db-fiddle.com** (wybierz PostgreSQL)
   lub **onecompiler.com/postgresql**.
2. Wklej po kolei zawartość plików `01` → `02` → `03`.
3. Gotowe — widzisz wyniki od razu w przeglądarce.

### Opcja B — lokalnie (PostgreSQL + pgAdmin/DBeaver)
```bash
# w terminalu (po zainstalowaniu PostgreSQL):
psql -U postgres -c "CREATE DATABASE sklep;"
psql -U postgres -d sklep -f 01_schema.sql
psql -U postgres -d sklep -f 02_dane.sql
psql -U postgres -d sklep -f 04_widoki_indeksy.sql
psql -U postgres -d sklep -f 03_zapytania.sql
```

---

## 📊 Co pokazują zapytania (`03_zapytania.sql`)

| # | Pytanie biznesowe | Użyta technika SQL |
|---|-------------------|--------------------|
| 1 | Jakie mamy produkty i w jakich kategoriach? | `INNER JOIN` |
| 2 | Które produkty są droższe od średniej? | podzapytanie w `WHERE` |
| 3 | Ile zamówień ma każdy klient? | `LEFT JOIN` + `GROUP BY` + `COUNT` |
| 4 | Ile wart było każde zamówienie? | `JOIN` + `SUM` |
| 5 | Kto wydał najwięcej? (TOP 5) | wiele `JOIN` + `ORDER BY` + `LIMIT` |
| 6 | Jak wyglądał przychód miesięczny? | `DATE_TRUNC` + grupowanie po dacie |
| 7 | Które produkty sprzedają się najlepiej? | `SUM(ilosc)` + `GROUP BY` |
| 8 | Które produkty nigdy się nie sprzedały? | `LEFT JOIN` + `IS NULL` (anti-join) |
| 9 | Która kategoria zarabia najwięcej? | `JOIN` przez 3 tabele |
| 10 | Które kategorie mają szeroki asortyment? | `HAVING` |
| 11 | Segmentacja klientów (VIP/średni/mały) | `CASE WHEN` |
| 12 | Nr 1 produkt w każdej kategorii | **funkcja okna** `RANK() OVER (PARTITION BY ...)` |
| 13 | Klienci wydający powyżej średniej | **CTE** (`WITH`) + podzapytanie |
| 14 | Ile kapitału mamy w magazynie? | agregacja `cena * stan` |
| 15 | Którzy klienci nic nie kupili? | `LEFT JOIN` + `IS NULL` |

---

## 🎓 Umiejętności zaprezentowane w projekcie
- Projektowanie schematu relacyjnego, normalizacja (3NF)
- Klucze główne i obce, ograniczenia integralności (`NOT NULL`, `UNIQUE`, `CHECK`)
- `INNER JOIN`, `LEFT JOIN`, łączenie wielu tabel
- Agregacje: `COUNT`, `SUM`, `AVG` + `GROUP BY` + `HAVING`
- Podzapytania i CTE (`WITH`)
- Funkcje okna (`RANK() OVER (PARTITION BY ...)`)
- Logika warunkowa (`CASE WHEN`)
- Widoki (`VIEW`) i indeksy (`INDEX`)
