# Digitaler Anhang: Bachelorarbeit – **Aushandlung von Identität und Stereotypen in der Rezeption des ersten Schwarzen AEW World Champions**

Dieses Repository enthält die unterstützenden Materialien und Werkzeuge zur Analyse im Rahmen der Bachelorarbeit **„Aushandlung von Identität und Stereotypen in der Rezeption des ersten Schwarzen AEW World Champions. Eine Kritische Diskursanalyse der Fan-Kommentare zu Swerve Strickland“**.

## Struktur des Repositories

Das Repository ist wie folgt organisiert:

```
Bachelorarbeit-Daten/
├── Codierschema/
│   └── Codierschema.pdf
├── Datensatz/
│   └── filtered_youtube_comments.csv
├── Python-Scripts/
│   ├── download_with_api.py
│   ├── duplicate_review.py
│   ├── merge_comments.py
│   └── youtube_comment_downloader.py
├── Tampermonkey-Scripts/
│   ├── YouTube-Expand All Video Comments-4.7.8.user.js
│   └── Youtube-expand description and long comments; show all the replies-1.2.15.user.js
└── README.md
```

### Inhalte

- **Codierschema/**:  
  - `Codierschema.pdf`: Das in der Arbeit verwendete Codierschema mit detaillierten Beschreibungen der Kategorien und deren Anwendung.

- **Datensatz/**:  
  - `filtered_youtube_comments.csv`: Der bereinigte und analysierte Datensatz, bestehend aus YouTube-Kommentaren, die in der Analyse verwendet wurden.

- **Python-Scripts/**:  
  - `download_with_api.py`: Skript zur Extraktion von Kommentaren mithilfe der YouTube Data API.  
  - `duplicate_review.py`: Skript zur Erkennung und Bereinigung von Duplikaten im Datensatz.  
  - `merge_comments.py`: Kombiniert Daten aus mehreren Quellen zu einer finalen kommentierten Datei.  
  - `youtube_comment_downloader.py`: Alternative Methode zur Kommentar-Extraktion ohne API, die weniger Metadaten liefert, aber vollständige Kommentare sammelt.

- **Tampermonkey-Scripts/**:  
  - `YouTube-Expand All Video Comments-4.7.8.user.js`: Skript zum automatisierten Öffnen aller Kommentare und Antwortthreads in der YouTube-Kommentarsektion.  
  - `Youtube-expand description and long comments; show all the replies-1.2.15.user.js`: Skript zur Anzeige langer Kommentare, Antworten und der Video-Beschreibung in voller Länge.

---

## Nutzungshinweise

### Python-Skripte
Die Python-Skripte setzen die Installation der folgenden Bibliotheken voraus:
- `pandas`
- `google-api-python-client`

Führe die Skripte in der Reihenfolge aus, wie sie in der Dokumentation angegeben sind, um die Ergebnisse zu reproduzieren.

### Tampermonkey-Skripte
1. Installieren Sie die [Tampermonkey-Erweiterung](https://www.tampermonkey.net/) für Ihren Browser.
2. Laden Sie die Skripte in das Tampermonkey-Dashboard hoch und aktivieren sie.
3. Nutzen Sie YouTube, um alle Kommentare, Threads und lange Beschreibungen anzuzeigen.

---

## Repository-Link

[https://github.com/elji99/Bachelorarbeit-Daten](https://github.com/elji99/Bachelorarbeit-Daten)
