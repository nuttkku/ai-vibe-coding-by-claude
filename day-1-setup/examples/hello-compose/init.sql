CREATE TABLE IF NOT EXISTS greetings (
  id SERIAL PRIMARY KEY,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

INSERT INTO greetings (message) VALUES
  ('Hello Vibe Coding'),
  ('สวัสดี Claude');
