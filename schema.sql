-- PostgreSQL schema for the Alcohol Detection project
-- Run this once in your database's SQL editor (Neon / Vercel Postgres / Supabase).

-- People who should receive alerts
CREATE TABLE IF NOT EXISTS contacts (
  id          SERIAL PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  phone       VARCHAR(16)  NOT NULL UNIQUE,
  created_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- One row per alcohol alert (or test) raised by the website
CREATE TABLE IF NOT EXISTS alerts (
  id           BIGSERIAL PRIMARY KEY,
  vehicle      VARCHAR(100),
  raw_reading  VARCHAR(200),          -- exact text received from the ESP32
  message      TEXT,                  -- SMS text that was sent
  is_test      BOOLEAN NOT NULL DEFAULT FALSE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- One row per phone number per alert: was the SMS sent or did it fail
CREATE TABLE IF NOT EXISTS sms_logs (
  id          BIGSERIAL PRIMARY KEY,
  alert_id    BIGINT NOT NULL REFERENCES alerts(id) ON DELETE CASCADE,
  phone       VARCHAR(16) NOT NULL,
  status      VARCHAR(10) NOT NULL CHECK (status IN ('sent', 'failed')),
  error       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_alerts_created  ON alerts (created_at DESC);
CREATE INDEX IF NOT EXISTS idx_sms_logs_alert  ON sms_logs (alert_id);

-- Handy summary view: one line per alert with SMS counts
CREATE OR REPLACE VIEW alert_summary AS
SELECT a.id, a.vehicle, a.raw_reading, a.is_test, a.created_at,
       COUNT(s.id) FILTER (WHERE s.status = 'sent')   AS sms_sent,
       COUNT(s.id) FILTER (WHERE s.status = 'failed') AS sms_failed
FROM alerts a
LEFT JOIN sms_logs s ON s.alert_id = a.id
GROUP BY a.id;

-- ---------- Useful queries ----------
-- Latest 20 real alerts:
--   SELECT * FROM alert_summary WHERE is_test = FALSE ORDER BY created_at DESC LIMIT 20;
-- Alerts per vehicle:
--   SELECT vehicle, COUNT(*) FROM alerts WHERE is_test = FALSE GROUP BY vehicle;
-- Failed SMS:
--   SELECT * FROM sms_logs WHERE status = 'failed' ORDER BY created_at DESC;
-- Add a contact:
--   INSERT INTO contacts (name, phone) VALUES ('Father', '9876543210');
