# Quarto-Website im Corporate Design der Universität Tübingen

## Nutzung

```bash
quarto preview   # lokale Vorschau
quarto render    # fertige Seite im Ordner _site
```

Benötigt wird Quarto ab Version 1.6 (getestet mit 1.8).

## Aufbau

| Datei | Zweck |
|---|---|
| `_brand.yml` | Marke nach brand.yml: Logo, Farben, Schriften |
| `_quarto.yml` | Website-Konfiguration (Navigation, Footer, Titel) |
| `custom.scss` | Feinschliff: Kopfleiste, Hero-Bereich, Karten, Footer |
| `images/` | Wort-Bild-Marke, Bildmarke, Favicon |
| `index.qmd`, `corporate-design.qmd`, `kontakt.qmd` | Beispielseiten |

Quarto wendet `_brand.yml` im Projektordner automatisch an.

## Anpassen

- Titel, Fußzeile und Navigation stehen in `_quarto.yml`. Die Platzhalter (Projekttitel, Name Fakultät, Telefonnummer) bitte ersetzen.
- Neue Seiten als `.qmd` anlegen und in `navbar` eintragen.

## Hinweise zum Corporate Design

- Das CD darf nur von Beschäftigten verwendet werden, die im Namen der Universität kommunizieren.
- Die rote Wort-Bild-Marke steht nur auf weißem Untergrund und wird nicht verändert. Deshalb gibt es keinen Dunkelmodus und keinen Umschalter.
- Trajan (Headlines) und FF Zwo sind lizenzpflichtig (design@cd.uni-tuebingen.de). Die Website nutzt Cinzel als Ersatz. Mit Lizenzdateien: Beispiel in `_brand.yml` einkommentieren.
- Schriften kommen von Bunny Fonts statt Google Fonts (EU-Anbieter, DSGVO).
- Der Farbton `sand` ist aus den Layouts im Leitfaden abgeleitet und kein offizieller Wert.
- Öffentliche Webauftritte der Universität laufen laut Leitfaden im zentralen TYPO3 und müssen dem Styleguide entsprechen. Klären Sie vor einer Veröffentlichung mit design@cd.uni-tuebingen.de und dem ZDV, ob diese Seite so erscheinen darf.
