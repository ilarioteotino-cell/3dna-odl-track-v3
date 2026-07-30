-- ============================================================
-- DATI MIGRATI DAL PROGETTO v2.0
-- Esegui DOPO setup_supabase_v3.sql
-- ============================================================

-- ======= REPARTI =======
INSERT INTO departments (id, name, order_position, is_active, created_at) VALUES
('f48101cb-4580-4a1e-913a-08fba834d168', 'Emissione JOB', 1, true, '2026-01-13T09:55:38.745087'),
('cfda80fb-58be-494f-bf77-28d52e145acb', 'Stampa', 2, true, '2026-01-13T09:55:38.745087'),
('c5873d7d-704f-4882-a645-5a56e7803d48', 'Spacchettamento', 3, true, '2026-01-13T09:55:38.745087'),
('c5e9580d-8566-4a0e-b2a5-8e03a3ac00ec', 'Aggiustaggio', 4, true, '2026-01-13T09:55:38.745087'),
('efe40c91-6068-498b-82e3-b0a97644031a', 'Collaudo', 5, true, '2026-01-13T09:55:38.745087'),
('a5955e80-4c19-413d-b7ec-39fd5f5f89b9', 'Laboratorio', 6, true, '2026-01-13T09:55:38.745087'),
('d342d8fe-eb49-4e68-83ce-fbeda4c04893', 'Da inviare a..', 7, true, '2026-01-13T09:55:38.745087'),
('a56ce0ff-cf13-4c8b-908e-236413f225ba', 'Ricevuto da..', 8, true, '2026-01-13T09:55:38.745087'),
('e1aafee3-36f3-41c6-a8da-94e864ed8fd4', 'Magazzino', 9, true, '2026-01-13T09:55:38.745087'),
('623cfad5-37fa-4321-b9bf-8acaad5ee73e', 'Montaggio/Incollaggio', 10, true, '2026-01-13T09:55:38.745087'),
('03e6bfbf-e24f-4544-b200-da5948f2e709', 'Controllo finale', 11, true, '2026-01-13T09:55:38.745087'),
('4f19f799-d584-475f-a5a3-5b6524d73678', 'Ecut', 12, true, '2026-01-13T09:55:38.745087'),
('51e13645-fd31-4c17-80d9-cde48b92f274', 'Trattamento termico', 13, true, '2026-01-13T09:55:38.745087'),
('b41396be-c231-4ca0-9413-157f92d1a7ae', 'Area scarti', 14, true, '2026-05-05T12:06:00.980449'),
('e9e3297d-9bf7-4257-a9b2-8a1982e32293', 'Area parti NC', 15, true, '2026-05-05T12:06:13.830799'),
('3104a3fb-0d0c-47ef-895f-5d0daff8f59e', 'Sabbiatura', 16, true, '2026-05-05T12:08:23.243878'),
('11fa4a06-2750-4a06-85ea-7971175e268b', 'Colorazione', 17, true, '2026-05-05T14:40:46.759279')
ON CONFLICT (id) DO NOTHING;

-- ======= UTENTI =======
-- NOTA: Le password qui sotto sono GIÀ hashate con bcrypt.
-- Password effettive:
--   admin  -> "admin123"
--   tutti gli operatori -> "123"
-- ATTENZIONE: Esegui lo script node sql/hasha_password.js per generare le hash corrette
-- e poi esegui le INSERT qui sotto con le hash generate.

-- Inserimento temporaneo con password in chiaro (DA SOSTITUIRE con hash bcrypt)
INSERT INTO profiles (id, username, password_hash, full_name, role, approved, created_at) VALUES
('c8f514a6-35dd-40b5-a945-fe4b54ec6d24', 'admin', 'admin123', 'Amministratore', 'admin', true, '2026-01-12T15:53:52.06003'),
('2264baf7-9f64-4dee-bb2c-52287c1442e5', 'marco.miglione', '123', 'Marco Miglione', 'operator', true, '2026-01-13T10:15:08.009348'),
('00c809e4-6824-4365-be5f-a2e30ae273ed', 'fabio.tango', '123', 'Fabio Tango', 'operator', true, '2026-01-13T10:15:59.489304'),
('1e8d85d7-f636-4f22-b222-1351d9aee238', 'diego.palladino', '123', 'Diego Palladino', 'operator', true, '2026-01-13T10:16:12.330752'),
('823174f0-da02-4791-a29e-197fd23af4b2', 'francesco.starace', '123', 'Francesco Starace', 'operator', true, '2026-01-13T10:16:20.883763'),
('26147e00-89be-4e7a-8996-52729e6f7cad', 'giovanni.quaranta', '123', 'Giovanni Quaranta', 'operator', true, '2026-01-13T10:16:29.461612'),
('922b6ad5-5f7e-4cbf-b793-8f0d4a3b16f4', 'claudio.delgesso', '123', 'Claudio Del Gesso', 'operator', true, '2026-01-13T10:16:38.424971'),
('c513ae0c-d21a-46e5-80f3-ebfc000ae564', 'alfonso.vitolo', '123', 'Alfonso Vitolo', 'operator', true, '2026-01-13T10:16:48.516254'),
('95e5c08a-dcd3-41e3-9cad-fdb7f6300145', 'luca.pennino', '123', 'Luca Pennino', 'operator', true, '2026-01-13T10:16:55.701267'),
('a75c7f3f-63f8-437c-bf9e-a25217a266c2', 'antonio.rinaldi', '123', 'Antonio Rinaldi', 'operator', true, '2026-01-13T10:17:02.572161'),
('9c45679f-d213-4d24-b13b-9f7b7373687a', 'ilario.teotino', '123', 'Ilario Teotino', 'admin', true, '2026-01-13T10:17:11.464036'),
('18ab8fdd-5ed6-4ee4-b65c-ae26c753c1a7', 'massimo.graziano', '123', 'Massimo Graziano', 'operator', true, '2026-01-14T08:55:33.052821'),
('abd9df97-9cb9-4e6f-ae68-31dea42fd4cb', 'mariano.abbate', '123', 'Mariano Abbate', 'operator', true, '2026-05-04T14:30:11.654599'),
('938edb4c-f53b-4ac8-af4a-476258d8d73c', 'errico.bifulco', '123', 'Errico Bifulco', 'operator', true, '2026-05-04T14:30:23.163243')
ON CONFLICT (id) DO NOTHING;

-- ======= IMPORTANTE =======
-- Dopo aver eseguito questo SQL, le password NON funzioneranno con bcrypt.
-- Per hashare tutte le password, esegui da terminale:
--   cd "3DnA Production Tracking v3.0"
--   node sql/hasha_password.js
-- Poi copia ed esegui le UPDATE generate dallo script.
