# Data Quality Notes / Notizen zur Datenqualität
## Week 1 / Woche 1

### Scope / Umfang

**English:** These initial checks cover the complete database before cohort filtering.

**Deutsch:** Diese ersten Prüfungen beziehen sich auf die gesamte Datenbank vor der Kohortenfilterung.

### Source table sizes / Zeilenzahlen der Ausgangstabellen

| Table / Tabelle | Rows / Zeilen |
|---|---:|
| users | 1,020,926 |
| sessions | 5,408,063 |
| flights | 1,901,038 |
| hotels | 1,918,617 |

### Session period / Session-Zeitraum

| Check / Prüfung | Result / Ergebnis |
|---|---|
| First session / Erste Session | 2021-04-01 00:42:00 |
| Last session / Letzte Session | 2023-07-28 23:57:55 |
| Missing session_start / Fehlender Session-Beginn | 0 |

### Keys and relationships / Schlüssel und Beziehungen

**English:**
- All four documented primary keys are unique and non-null.
- Every session references an existing user.
- There are 2,245,175 distinct non-null trip IDs in sessions.
- Of these, 90,670 trip IDs occur in two sessions each.
- Each of these repeated trips has exactly one cancellation session.
- No trip ID occurs in more than two sessions.
- Joining booking details to sessions can repeat the same booking details. Trip-level aggregations must prevent double counting.

**Deutsch:**
- Alle vier dokumentierten Primärschlüssel sind eindeutig und enthalten keine fehlenden Werte.
- Jede Session verweist auf einen vorhandenen Nutzer.
- In den Sessions gibt es 2.245.175 unterschiedliche, nicht leere Reise-IDs.
- Davon kommen 90.670 Reise-IDs jeweils in zwei Sessions vor.
- Jede dieser mehrfach referenzierten Reisen hat genau eine Stornierungs-Session.
- Keine Reise-ID kommt in mehr als zwei Sessions vor.
- Beim Verbinden von Buchungsdetails mit Sessions können dieselben Buchungsdetails mehrfach erscheinen. Aggregationen auf Reiseebene müssen Doppelzählungen verhindern.

### Missing booking details / Fehlende Buchungsdetails

| Booking type / Buchungsart | Sessions marked as booked / Als gebucht markierte Sessions | Missing details / Fehlende Details | Share / Anteil |
|---|---:|---:|---:|
| Flight / Flug | 1,991,708 | 1,326 | 0.067% |
| Hotel | 2,009,287 | 46,367 | 2.31% |

**English:**
- These counts refer to sessions, not distinct trips or users.
- All affected sessions have a trip ID, but no matching record exists in the corresponding booking table.
- The cause is unknown.
- These sessions are retained for now.
- Missing booking details must not be interpreted as zero prices, zero nights or no booking.

**Deutsch:**
- Diese Zahlen beziehen sich auf Sessions, nicht auf unterschiedliche Reisen oder Nutzer.
- Alle betroffenen Sessions haben eine Reise-ID, aber keinen passenden Eintrag in der jeweiligen Buchungstabelle.
- Die Ursache ist unbekannt.
- Diese Sessions bleiben vorerst erhalten.
- Fehlende Buchungsdetails dürfen nicht als Preise von null, null Übernachtungen oder fehlende Buchung interpretiert werden.

### Follow-up checks / Weitere Prüfungen

**English:**
- Repeat missing-booking-detail checks within the selected group.
- Inspect booking flags in cancellation sessions and their associated sessions.
- Define how cancelled trips are handled in booking and spending metrics.
- Distinguish booking values from actual spending; payment and refund information has not been established.

**Deutsch:**
- Fehlende Buchungsdetails innerhalb der ausgewählten Gruppe erneut prüfen.
- Buchungsindikatoren in Stornierungs-Sessions und den zugehörigen Sessions untersuchen.
- Festlegen, wie stornierte Reisen in Buchungs- und Ausgabenkennzahlen behandelt werden.
- Buchungswerte von tatsächlichen Ausgaben unterscheiden; Zahlungs- und Erstattungsinformationen sind bisher nicht geklärt.

### Analysis group / Analysegruppe

**English:**
- Include sessions starting after 2023-01-04 00:00:00.
- Include users with more than seven sessions in this period.
- The latest available session starts on 2023-07-28 at 23:57:55.
- The selected group contains 5,998 users and 49,211 sessions.
- Sessions per selected user range from 8 to 12.
- Selection is based on sessions before further cleaning.

**Deutsch:**
- Sessions mit Beginn nach dem 04.01.2023 um 00:00:00 einschließen.
- Nutzer mit mehr als sieben Sessions in diesem Zeitraum einschließen.
- Die letzte verfügbare Session beginnt am 28.07.2023 um 23:57:55.
- Die Analysegruppe umfasst 5.998 Nutzer und 49.211 Sessions.
- Jeder ausgewählte Nutzer hat zwischen 8 und 12 Sessions.
- Die Auswahl basiert auf den Sessions vor weiteren Bereinigungen.

### Missing booking details in the analysis group
### Fehlende Buchungsdetails in der Analysegruppe

**English:**
- Flight: 50 of 14,320 sessions marked as booked lack matching details (about 0.35%).
- Hotel: 193 of 14,919 sessions marked as booked lack matching details (about 1.29%).
- Counts refer to sessions, not distinct trips or users.
- Sessions are retained for now; missing details remain missing values.

**Deutsch:**
- Flug: Bei 50 von 14.320 als gebucht markierten Sessions fehlen passende Details (ca. 0,35 %).
- Hotel: Bei 193 von 14.919 als gebucht markierten Sessions fehlen passende Details (ca. 1,29 %).
- Die Zahlen beziehen sich auf Sessions, nicht auf unterschiedliche Reisen oder Nutzer.
- Die Sessions bleiben vorerst erhalten; fehlende Details bleiben fehlende Werte.

### CSV export validation / Prüfung der CSV-Exporte

| Table / Tabelle | Exported rows / Exportierte Zeilen |
|---|---:|
| users | 5,998 |
| sessions | 49,211 |
| flights | 13,717 |
| hotels | 14,313 |

**English:**
- All exported row counts match the SQL results.
- Primary keys contain no missing or duplicate values.
- Flight and hotel records were selected using distinct trip IDs.
- Records linked to cancelled trips are retained for further analysis.
- Original CSV exports are stored locally in data/raw and excluded from Git.

**Deutsch:**
- Alle exportierten Zeilenzahlen stimmen mit den SQL-Ergebnissen überein.
- Die Primärschlüssel enthalten keine fehlenden oder doppelten Werte.
- Flug- und Hoteldatensätze wurden über eindeutige Reise-IDs ausgewählt.
- Datensätze zu stornierten Reisen bleiben für weitere Analysen erhalten.
- Die ursprünglichen CSV-Exporte liegen lokal unter data/raw und sind von Git ausgeschlossen.

### User data validation / Prüfung der Nutzerdaten

**English:**
- No missing values were detected in the imported user columns.
- birthdate and sign_up_date were converted to datetime without parsing failures.
- No birthdates or sign-up dates occur after the reference date, 2023-07-28.
- No sign-up date precedes the user's birthdate.
- gender contains F, M and O; O means Other.
- married and has_children contain only Boolean values.
- Text checks found no blank values, surrounding whitespace or variants
  differing only in capitalization and surrounding whitespace.
- Age at the reference date ranges from 16 to 88, with a median of 41.
- Birth year 2006 accounts for 233 users (3.88%) across 170 birthdates.
  Its elevated frequency remains unexplained; these users are retained.
- Home-airport coordinates are complete, within valid ranges and consistent
  per airport. Actual locations have not been externally verified.
- No selected user has a session on a calendar date before sign-up
  within the analysis period.

**Deutsch:**
- In den eingelesenen Nutzerspalten wurden keine fehlenden Werte erkannt.
- birthdate und sign_up_date wurden ohne Parsing-Fehler umgewandelt.
- Keine Geburts- oder Anmeldedaten liegen nach dem Stichtag 28.07.2023.
- Keine Anmeldung liegt vor dem Geburtsdatum.
- gender enthält F, M und O; O bedeutet Other / Andere.
- married und has_children enthalten ausschließlich boolesche Werte.
- Die Textprüfung fand keine leeren Werte, äußeren Leerzeichen oder Varianten,
  die sich nur durch Groß-/Kleinschreibung und äußere Leerzeichen unterscheiden.
- Das Alter am Stichtag reicht von 16 bis 88 Jahren; der Median beträgt 41.
- Der Jahrgang 2006 umfasst 233 Nutzer (3,88 %) mit 170 Geburtsdaten.
  Seine erhöhte Häufigkeit bleibt ungeklärt; die Nutzer bleiben erhalten.
- Heimatflughafen-Koordinaten sind vollständig, formal gültig und je Flughafen
  konsistent. Die tatsächlichen Standorte wurden nicht extern geprüft.
- Kein ausgewählter Nutzer hat im Analysezeitraum eine Session
  an einem Kalendertag vor seiner Anmeldung.