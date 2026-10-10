# St. Martin 2026 – Setup

1. **Supabase**: Im SQL Editor den Inhalt von `setup.sql` ausführen (legt Tabellen, Policies und die 9 Dienste an).
2. **Zugangsdaten**: In `index.html` oben im `<script>`-Block eintragen:
   ```js
   const SUPABASE_URL   = '…';   // Project URL
   const SUPABASE_KEY   = '…';   // anon / publishable key
   const ADMIN_PASSWORD = 'StMartin2026!';   // bitte ändern
   ```
3. **Veröffentlichen**: GitHub → Settings → Pages → Deploy from branch `main` / `(root)`.

## Dienste anpassen
- Im Admin-Modus (Button unten rechts) können Dienste angelegt/gelöscht und Helfer entfernt werden.
- Ein Dienst gilt als „bereits vergeben“, wenn in Tabelle `aufgaben` die Spalte `vergeben = true` ist
  (Supabase → Table Editor). Dann ist die Anmeldung gesperrt.
- Reihenfolge steuert die Spalte `sortierung`.

## Hinweise
- Eigenes Supabase-Projekt verwenden, nicht die Zugangsdaten von Erntedank/Waldwoche.
- Free-Tier-Projekte pausieren nach 7 Tagen Inaktivität („Restore project“).
