# 🎤 Obrona projektu — pytania i odpowiedzi

Ściąga do przygotowania się na rozmowę. Przeczytaj kilka razy i spróbuj
odpowiadać **własnymi słowami** — chodzi o zrozumienie, nie recytowanie.

---

## O projekcie ogólnie

**Opowiedz o tym projekcie.**
> To baza danych sklepu internetowego, którą zbudowałem samodzielnie do portfolio,
> żeby przećwiczyć SQL. Zaprojektowałem 5 tabel (klienci, produkty, kategorie,
> zamówienia i pozycje zamówień), wypełniłem je przykładowymi danymi i napisałem
> 15 zapytań analitycznych odpowiadających na pytania biznesowe — np. kto wydał
> najwięcej, które produkty się nie sprzedają, jaki jest przychód miesięczny.

**Skąd dane?**
> To dane syntetyczne, które sam wygenerowałem. Skupiłem się na projekcie schematu
> i logice zapytań, a dane miały tylko pokazać, że wszystko działa.

---

## Modelowanie / schemat

**Dlaczego rozdzieliłeś zamówienia i pozycje zamówień na dwie tabele?**
> Bo jedno zamówienie może zawierać wiele produktów. Gdyby wszystko było w jednej
> tabeli, dane by się powtarzały. `zamowienia` trzyma nagłówek (klient, data,
> status), a `pozycje_zamowienia` — poszczególne produkty w zamówieniu.

**Co to jest klucz obcy (FOREIGN KEY)?**
> Kolumna, która wskazuje na klucz główny innej tabeli i pilnuje spójności danych.
> Np. w `zamowienia` kolumna `klient_id` musi wskazywać na istniejącego klienta —
> baza nie pozwoli dodać zamówienia dla nieistniejącego klienta.

**Czym jest relacja wiele-do-wielu i gdzie ją masz?**
> Jeden produkt może być w wielu zamówieniach, a jedno zamówienie ma wiele
> produktów. Taką relację realizuję przez tabelę łączącą `pozycje_zamowienia`.

**Dlaczego zapisujesz `cena_jednostkowa` w pozycji, skoro cena jest w `produkty`?**
> Bo cena produktu może się z czasem zmienić, a zamówienie musi pamiętać cenę
> **z momentu zakupu**. Gdybym liczył ze aktualnej ceny produktu, historyczne
> zamówienia miałyby złe kwoty.

**Co to normalizacja / 3NF?**
> Zasada projektowania tabel tak, żeby nie powtarzać danych. Np. nazwę kategorii
> trzymam raz w tabeli `kategorie`, a produkty tylko się do niej odwołują przez id.

---

## Zapytania

**Różnica między INNER JOIN a LEFT JOIN?**
> INNER JOIN zwraca tylko wiersze, które mają dopasowanie w obu tabelach.
> LEFT JOIN zwraca wszystkie wiersze z lewej tabeli, a jak nie ma dopasowania —
> wstawia NULL. Dlatego przy liczeniu zamówień per klient użyłem LEFT JOIN, żeby
> pokazać też klientów z zerem zamówień.

**Różnica między WHERE a HAVING?**
> WHERE filtruje pojedyncze wiersze PRZED grupowaniem. HAVING filtruje wyniki już
> PO agregacji (GROUP BY). Np. „kategorie mające więcej niż 3 produkty" to HAVING,
> bo filtruję po policzeniu.

**Jak znalazłeś produkty, które nigdy się nie sprzedały?**
> LEFT JOIN produktów z pozycjami zamówień i warunek `WHERE pz.produkt_id IS NULL`.
> Brak dopasowania oznacza, że produkt nie pojawił się w żadnym zamówieniu.

**Co robi funkcja okna RANK() OVER (PARTITION BY ...)?**
> Nadaje ranking wierszom wewnątrz grupy, bez zwijania ich do jednego wiersza.
> U mnie: ranking produktów wg przychodu OSOBNO w każdej kategorii — czyli
> „który produkt jest nr 1 w swojej kategorii".

**Co to CTE (WITH ...)?**
> Nazwane, tymczasowe zapytanie, do którego można się odwołać niżej. Robi
> skomplikowany kod czytelniejszym. Użyłem go, żeby najpierw policzyć wydatki
> klientów, a potem porównać je do średniej.

**Do czego służy GROUP BY?**
> Grupuje wiersze o tej samej wartości i pozwala policzyć na nich agregaty
> (SUM, COUNT, AVG). Np. suma wydatków per klient.

**Po co CASE WHEN?**
> Logika warunkowa w zapytaniu — jak „jeśli/to". Użyłem do segmentacji klientów
> na VIP / średni / mały wg wydanej kwoty.

---

## Wydajność

**Po co indeksy?**
> Przyspieszają wyszukiwanie i JOIN-y na dużych tabelach. Działają jak spis treści
> w książce — baza nie musi przeglądać całej tabeli. Założyłem je na kolumnach
> kluczy obcych, po których najczęściej łączę tabele.

**Co to widok (VIEW)?**
> Zapisane zapytanie, którego używa się jak zwykłej tabeli. Dzięki temu
> skomplikowaną logikę piszę raz i potem tylko `SELECT * FROM widok`.

---

## Pytania „a gdyby"

**Jak dodałbyś obsługę rabatów?**
> Dodałbym kolumnę `rabat` w `pozycje_zamowienia` albo osobną tabelę promocji,
> i uwzględnił ją we wzorze na wartość: `ilosc * cena_jednostkowa * (1 - rabat)`.

**Co jakby baza miała miliony wierszy?**
> Kluczowe stają się indeksy na kolumnach używanych w JOIN i WHERE, a przy
> raportach — rozważyłbym widoki zmaterializowane albo wcześniejsze agregacje.
