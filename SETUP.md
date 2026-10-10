# St. Martin 2026 – Setup

1. **Supabase**: Im SQL Editor den Inhalt von `setup.sql` ausführen (legt Tabellen, Policies und die 9 Dienste an).
2. **Zugangsdaten**: In `index.html` oben im `<script>`-Block eintragen:
   ```js
   const SUPABASE_URL   = '…';   // Project URL
   const SUPABASE_KEY   = '…';   // anon / publishable key
   ```
   (Bestehende Tabellen: stattdessen `migrate.sql` ausführen.)
3. **Admin-Konto** (Passwort liegt in Supabase, nicht im Repo): Authentication → Users → Add user
   (E-Mail + Passwort, „Auto Confirm User" anhaken). Danach unter Authentication → Sign In / Providers
   „Allow new users to sign up" **ausschalten**.
4. **Veröffentlichen**: GitHub → Settings → Pages → Deploy from branch `main` / `(root)`.

## Dienste anpassen
- Im Admin-Modus (Button unten rechts) können Dienste angelegt/gelöscht und Helfer entfernt werden.
- Ein Dienst gilt als „bereits vergeben“, wenn in Tabelle `aufgaben` die Spalte `vergeben = true` ist
  (Supabase → Table Editor). Dann ist die Anmeldung gesperrt.
- Reihenfolge steuert die Spalte `sortierung`.

## Hinweise
- Eigenes Supabase-Projekt verwenden, nicht die Zugangsdaten von Erntedank/Waldwoche.
- Free-Tier-Projekte pausieren nach 7 Tagen Inaktivität („Restore project“).
