-- ════════════════════════════════════════════════════════════════
--  St. Martin 2026 – Supabase Setup SQL
--  Dieses Skript im Supabase SQL-Editor ausführen (einmalig)
-- ════════════════════════════════════════════════════════════════

-- 1. Dienste (Admin legt sie an)
CREATE TABLE aufgaben (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titel        TEXT NOT NULL,
    beschreibung TEXT,
    max_helfer   INT NOT NULL DEFAULT 3,
    vergeben     BOOLEAN NOT NULL DEFAULT false,  -- true = bereits anderweitig vergeben, keine Anmeldung möglich
    sortierung   INT NOT NULL DEFAULT 0,
    created_at   TIMESTAMPTZ DEFAULT now()
);

-- 2. Helfer (Eltern tragen sich zu einem Dienst ein)
CREATE TABLE helfer (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aufgabe_id UUID NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
    name       TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Änderungsprotokoll
CREATE TABLE change_log (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tabelle       TEXT NOT NULL,
    zeile_id      UUID,
    aktion        TEXT NOT NULL CHECK (aktion IN ('eintrag', 'loeschung')),
    alter_wert    JSONB,
    neuer_wert    JSONB,
    geaendert_von TEXT,
    zeitstempel   TIMESTAMPTZ DEFAULT now()
);

-- ────────────────────────────────────────────────────────────────
--  Row Level Security – öffentlich lese- und schreibbar
--  (kein Login für Eltern; Schutz erfolgt über Admin-Passwort im Frontend)
-- ────────────────────────────────────────────────────────────────
ALTER TABLE aufgaben   ENABLE ROW LEVEL SECURITY;
ALTER TABLE helfer     ENABLE ROW LEVEL SECURITY;
ALTER TABLE change_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "public read aufgaben"    ON aufgaben    FOR SELECT USING (true);
CREATE POLICY "public read helfer"      ON helfer      FOR SELECT USING (true);
CREATE POLICY "public read change_log"  ON change_log  FOR SELECT USING (true);

CREATE POLICY "public insert aufgaben"    ON aufgaben    FOR INSERT WITH CHECK (true);
CREATE POLICY "public insert helfer"      ON helfer      FOR INSERT WITH CHECK (true);
CREATE POLICY "public insert change_log"  ON change_log  FOR INSERT WITH CHECK (true);

CREATE POLICY "public delete aufgaben"    ON aufgaben    FOR DELETE USING (true);
CREATE POLICY "public delete helfer"      ON helfer      FOR DELETE USING (true);

-- ────────────────────────────────────────────────────────────────
--  Vorbelegte Dienste
-- ────────────────────────────────────────────────────────────────
INSERT INTO aufgaben (titel, beschreibung, max_helfer, vergeben, sortierung) VALUES
    ('Ausschank',                          NULL,                       2, false, 10),
    ('Würstchen',                          NULL,                       2, true,  20),
    ('Verkauf Stangen, Martinsweck etc.',  NULL,                       3, false, 30),
    ('Brötchen',                           'Vorarbeit: Schneiden',     2, false, 40),
    ('Waffeln',                            NULL,                       2, false, 50),
    ('Aufbau',                             NULL,                       2, false, 60),
    ('Abbau',                              NULL,                       2, false, 70),
    ('Hintransport',                       NULL,                       1, false, 80),
    ('Rücktransport',                      NULL,                       1, false, 90);
