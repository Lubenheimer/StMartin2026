-- ════════════════════════════════════════════════════════════════
--  St. Martin 2026 – Migration (idempotent, löscht keine Daten)
--  Verwenden, wenn Tabellen schon existieren ("relation already exists").
-- ════════════════════════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS aufgaben (
    id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    titel        TEXT NOT NULL,
    beschreibung TEXT,
    max_helfer   INT NOT NULL DEFAULT 3,
    created_at   TIMESTAMPTZ DEFAULT now()
);
ALTER TABLE aufgaben ADD COLUMN IF NOT EXISTS vergeben   BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE aufgaben ADD COLUMN IF NOT EXISTS sortierung INT NOT NULL DEFAULT 0;

CREATE TABLE IF NOT EXISTS helfer (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    aufgabe_id UUID NOT NULL REFERENCES aufgaben(id) ON DELETE CASCADE,
    name       TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now()
);

CREATE TABLE IF NOT EXISTS change_log (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tabelle       TEXT NOT NULL,
    zeile_id      UUID,
    aktion        TEXT NOT NULL CHECK (aktion IN ('eintrag', 'loeschung')),
    alter_wert    JSONB,
    neuer_wert    JSONB,
    geaendert_von TEXT,
    zeitstempel   TIMESTAMPTZ DEFAULT now()
);

ALTER TABLE aufgaben   ENABLE ROW LEVEL SECURITY;
ALTER TABLE helfer     ENABLE ROW LEVEL SECURITY;
ALTER TABLE change_log ENABLE ROW LEVEL SECURITY;

-- Alle bestehenden Policies dieser Tabellen entfernen und neu setzen
DO $$
DECLARE p RECORD;
BEGIN
    FOR p IN SELECT policyname, tablename FROM pg_policies
             WHERE schemaname = 'public' AND tablename IN ('aufgaben','helfer','change_log')
    LOOP
        EXECUTE format('DROP POLICY %I ON %I', p.policyname, p.tablename);
    END LOOP;
END $$;

CREATE POLICY "public read aufgaben"   ON aufgaben   FOR SELECT USING (true);
CREATE POLICY "public read helfer"     ON helfer     FOR SELECT USING (true);
CREATE POLICY "public read change_log" ON change_log FOR SELECT USING (true);

CREATE POLICY "public insert helfer"     ON helfer     FOR INSERT WITH CHECK (true);
CREATE POLICY "public insert change_log" ON change_log FOR INSERT WITH CHECK (true);

CREATE POLICY "admin insert aufgaben" ON aufgaben FOR INSERT TO authenticated WITH CHECK (true);
CREATE POLICY "admin delete aufgaben" ON aufgaben FOR DELETE TO authenticated USING (true);
CREATE POLICY "admin delete helfer"   ON helfer   FOR DELETE TO authenticated USING (true);

-- Dienste nur vorbelegen, wenn die Tabelle noch leer ist
INSERT INTO aufgaben (titel, beschreibung, max_helfer, vergeben, sortierung)
SELECT * FROM (VALUES
    ('Ausschank',                          NULL,                   2, false, 10),
    ('Würstchen',                          NULL,                   2, true,  20),
    ('Verkauf Stangen, Martinsweck etc.',  NULL,                   3, false, 30),
    ('Brötchen',                           'Vorarbeit: Schneiden', 2, false, 40),
    ('Waffeln',                            NULL,                   2, false, 50),
    ('Aufbau',                             NULL,                   2, false, 60),
    ('Abbau',                              NULL,                   2, false, 70),
    ('Hintransport',                       NULL,                   1, false, 80),
    ('Rücktransport',                      NULL,                   1, false, 90)
) AS v(titel, beschreibung, max_helfer, vergeben, sortierung)
WHERE NOT EXISTS (SELECT 1 FROM aufgaben);
