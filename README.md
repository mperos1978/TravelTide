# TravelTide — Customer Segmentation

## Project goal / Projektziel

**English:** This four-week project explores customer behavior to support a personalized rewards program for TravelTide. The analysis will develop customer segments and recommend suitable rewards.

**Deutsch:** Dieses vierwöchige Projekt untersucht das Kundenverhalten, um ein personalisiertes Rewards-Programm für TravelTide zu unterstützen. Ziel sind nachvollziehbare Kundengruppen und passende Reward-Empfehlungen.

## Planned approach / Geplantes Vorgehen

**English:** Start with exploratory data analysis and visual exploration. Develop rule-based customer segments, then use clustering as a comparison or complement. Present the findings in a Streamlit app.

**Deutsch:** Zunächst erfolgen eine explorative Datenanalyse und visuelle Untersuchung. Danach entwickeln wir regelbasierte Kundengruppen und verwenden Clustering als Vergleich oder Ergänzung. Die Ergebnisse sollen in einer Streamlit-App präsentiert werden.

## Data / Daten

The source database contains four tables:
Die Ausgangsdatenbank enthält vier Tabellen:

| Table / Tabelle | One row represents / Eine Zeile entspricht |
|---|---|
| users | A user profile / Einem Nutzerprofil |
| sessions | A browsing session / Einer Browsing-Session |
| flights | Flight booking details for a trip / Flugbuchungsdetails einer Reise |
| hotels | Hotel booking details for a trip / Hotelbuchungsdetails einer Reise |

## Analysis group / Analysegruppe

**English:**
- Sessions starting after 2023-01-04 00:00:00.
- Users with more than seven sessions in this period.
- No upper date filter; the latest available session starts on 2023-07-28 at 23:57:55.
- Selection is based on sessions before further cleaning.

**Deutsch:**
- Sessions mit Beginn nach dem 04.01.2023 um 00:00:00.
- Nutzer mit mehr als sieben Sessions in diesem Zeitraum.
- Keine obere Datumsgrenze; die letzte verfügbare Session beginnt am 28.07.2023 um 23:57:55.
- Die Auswahl basiert auf Sessions vor weiteren Bereinigungen.

| Export | Rows / Zeilen |
|---|---:|
| users.csv | 5,998 |
| sessions.csv | 49,211 |
| flights.csv | 13,717 |
| hotels.csv | 14,313 |

## Project structure / Projektstruktur

- sql/: source checks, group selection and export queries.
  Datenprüfungen, Auswahl der Analysegruppe und Exportabfragen.
- notebooks/: data loading, validation and analysis.
  Datenladen, Validierung und Analyse.
- docs/: data quality findings and analytical decisions.
  Erkenntnisse zur Datenqualität und Analyseentscheidungen.
- data/raw/: unchanged local CSV exports.
  Unveränderte lokale CSV-Exporte.
- data/processed/: prepared datasets created during analysis.
  Im Verlauf der Analyse aufbereitete Datensätze.
- requirements.txt: Python packages and installed versions.
  Python-Pakete und installierte Versionen.

## Current status / Aktueller Stand

**English:** Source row counts, primary keys and selected table relationships have been checked. The analysis group has been selected and all four CSV exports validated. Detailed EDA, cleaning and segmentation are still pending.

**Deutsch:** Zeilenzahlen, Primärschlüssel und ausgewählte Tabellenbeziehungen wurden geprüft. Die Analysegruppe wurde ausgewählt und alle vier CSV-Exporte wurden validiert. Detaillierte EDA, Bereinigung und Segmentierung stehen noch aus.

See / Siehe: [Data quality notes / Notizen zur Datenqualität](docs/data_quality_notes.md)

## Local setup / Lokale Einrichtung

**English:** Development uses Python 3.14.6. From the repository root, create an environment and install dependencies:

**Deutsch:** Für die Entwicklung verwenden wir Python 3.14.6. Im Hauptordner des Repositorys eine Umgebung erstellen und Abhängigkeiten installieren:

    py -m venv .venv
    .\.venv\Scripts\python.exe -m pip install -r requirements.txt

**English:** Run the export queries in sql/03_data_exports.sql and save the four CSV files in data/raw/. Open notebooks/01_eda.ipynb in VS Code and select the .venv kernel.

**Deutsch:** Die Exportabfragen in sql/03_data_exports.sql ausführen und die vier CSV-Dateien unter data/raw/ speichern. notebooks/01_eda.ipynb in VS Code öffnen und den .venv-Kernel auswählen.

## Data availability and limitations / Datenverfügbarkeit und Grenzen

**English:** CSV exports and credentials are excluded from Git. Running the notebook requires local exports and access to the source database. Missing booking details and cancellation handling are documented in the data quality notes. Reward preferences inferred from behavior are hypotheses, not confirmed customer preferences.

**Deutsch:** CSV-Exporte und Zugangsdaten sind von Git ausgeschlossen. Für die Ausführung des Notebooks werden lokale Exporte und Zugriff auf die Ausgangsdatenbank benötigt. Fehlende Buchungsdetails und der Umgang mit Stornierungen werden in den Notizen zur Datenqualität dokumentiert. Aus Verhalten abgeleitete Reward-Präferenzen sind Hypothesen, keine bestätigten Kundenpräferenzen.
