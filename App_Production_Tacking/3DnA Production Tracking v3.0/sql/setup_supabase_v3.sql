-- ============================================================
-- 3DnA Production Tracking v3.0 - Setup Database Supabase
-- Esegui questo script nel SQL Editor del nuovo progetto Supabase
-- ============================================================

-- ======= 1. TABELLA PROFILES (utenti) =======
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  username text UNIQUE NOT NULL,
  password_hash text NOT NULL,
  full_name text NOT NULL,
  role text NOT NULL DEFAULT 'operator' CHECK (role IN ('operator', 'admin')),
  approved boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

-- ======= 2. TABELLA DEPARTMENTS (reparti) =======
CREATE TABLE IF NOT EXISTS departments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  order_position integer NOT NULL,
  is_active boolean DEFAULT true,
  created_at timestamptz DEFAULT now()
);

-- ======= 3. TABELLA ORDERS =======
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text,
  job_number text,
  staccato_number text,
  starting_department_id uuid REFERENCES departments(id),
  current_department_id uuid REFERENCES departments(id),
  created_by uuid REFERENCES profiles(id),
  scarti integer DEFAULT 0,
  note text,
  status text DEFAULT 'active' CHECK (status IN ('active', 'completed', 'closed')),
  close_date date,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- ======= 4. TABELLA ORDER_HISTORY (con nuove colonne v3.0) =======
CREATE TABLE IF NOT EXISTS order_history (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id),
  order_number text,
  job_number text,
  staccato_number text,
  from_department_id uuid REFERENCES departments(id),
  to_department_id uuid REFERENCES departments(id),
  moved_by_user_id uuid REFERENCES profiles(id),
  operation_type text NOT NULL CHECK (operation_type IN ('avanzamento', 'retrocessione')),
  scarti integer DEFAULT 0,
  note text,
  moved_at timestamptz DEFAULT now(),
  -- Nuove colonne v2.0 (denormalizzate)
  moved_by_name text,
  from_department_name text,
  to_department_name text,
  -- NUOVE COLONNE v3.0
  close_date date,
  bem_materiale text,
  bem_supporto text,
  nc_number text,
  nc_motivation text
);

-- ======= 5. NUOVA TABELLA: BEM_JOB =======
CREATE TABLE IF NOT EXISTS bem_job (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  job_number text NOT NULL,
  order_id uuid REFERENCES orders(id),
  bem_code text NOT NULL,
  type text DEFAULT 'materiale' CHECK (type IN ('materiale', 'supporto')),
  created_at timestamptz DEFAULT now(),
  operator_id uuid REFERENCES profiles(id)
);

CREATE INDEX IF NOT EXISTS idx_bem_job_job_number ON bem_job(job_number);
CREATE INDEX IF NOT EXISTS idx_bem_job_bem_code ON bem_job(bem_code);

-- ======= 6. NUOVA TABELLA: BEM_FORNO =======
CREATE TABLE IF NOT EXISTS bem_forno (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  bem_code text NOT NULL,
  entry_date timestamptz,
  exit_date timestamptz,
  operator_id uuid REFERENCES profiles(id),
  created_at timestamptz DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_bem_forno_bem_code ON bem_forno(bem_code);

-- ======= 7. VISTA: ORDER_HISTORY_CSV_VIEW =======
CREATE OR REPLACE VIEW order_history_csv_view AS
SELECT
  to_char(oh.moved_at AT TIME ZONE 'Europe/Rome', 'YYYY-MM-DD HH24:MI:SS') AS Data_operazione,
  oh.job_number AS Job,
  oh.order_number AS OdL,
  oh.staccato_number AS Staccato,
  p.full_name AS Operatore,
  oh.operation_type AS Tipo_operazione,
  dep_from.name AS Dal_reparto,
  dep_to.name AS Al_reparto,
  oh.note AS Note_operazione,
  oh.scarti AS Qta_scarti,
  oh.nc_number AS NC,
  oh.nc_motivation AS Causa_NC,
  oh.bem_materiale AS Bem_Materiale,
  oh.bem_supporto AS Bem_Supporto,
  o.close_date AS Data_chiusura_ordine
FROM order_history oh
LEFT JOIN departments dep_from ON oh.from_department_id = dep_from.id
LEFT JOIN departments dep_to ON oh.to_department_id = dep_to.id
LEFT JOIN profiles p ON oh.moved_by_user_id = p.id
LEFT JOIN orders o ON oh.order_id = o.id
ORDER BY oh.moved_at DESC;

-- ======= 8. VISTA: BEM_JOB_VIEW (per visualizzare BEM con dettagli) =======
CREATE OR REPLACE VIEW bem_job_view AS
SELECT
  bj.job_number,
  bj.bem_code,
  bj.type,
  to_char(bj.created_at AT TIME ZONE 'Europe/Rome', 'YYYY-MM-DD HH24:MI:SS') AS created_at,
  p.full_name AS operator_name,
  o.order_number,
  o.staccato_number
FROM bem_job bj
LEFT JOIN profiles p ON bj.operator_id = p.id
LEFT JOIN orders o ON bj.order_id = o.id
ORDER BY bj.created_at DESC;

-- ======= 9. VISTA: BEM_FORNO_VIEW =======
CREATE OR REPLACE VIEW bem_forno_view AS
SELECT
  bf.bem_code,
  to_char(bf.entry_date AT TIME ZONE 'Europe/Rome', 'YYYY-MM-DD HH24:MI:SS') AS entry_date,
  to_char(bf.exit_date AT TIME ZONE 'Europe/Rome', 'YYYY-MM-DD HH24:MI:SS') AS exit_date,
  p.full_name AS operator_name,
  CASE
    WHEN bf.entry_date IS NOT NULL AND bf.exit_date IS NULL THEN 'in_forno'
    WHEN bf.exit_date IS NOT NULL THEN 'uscito'
    ELSE 'registrato'
  END AS status
FROM bem_forno bf
LEFT JOIN profiles p ON bf.operator_id = p.id
ORDER BY bf.created_at DESC;

-- ======= 10. ROW LEVEL SECURITY =======
-- Abilita RLS su tutte le tabelle
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE bem_job ENABLE ROW LEVEL SECURITY;
ALTER TABLE bem_forno ENABLE ROW LEVEL SECURITY;

-- Policy: tutti possono leggere profiles (per lookup)
CREATE POLICY "Profili leggibili da tutti" ON profiles
  FOR SELECT USING (true);

-- Policy: solo admin può modificare profiles
CREATE POLICY "Solo admin modifica profili" ON profiles
  FOR ALL USING (
    auth.uid() IN (SELECT id FROM profiles WHERE role = 'admin')
  );

-- Policy: utenti autenticati possono leggere/scrivere orders
CREATE POLICY "Ordini accessibili a tutti" ON orders
  FOR ALL USING (true);

-- Policy: utenti autenticati possono leggere/scrivere departments
CREATE POLICY "Reparti accessibili a tutti" ON departments
  FOR ALL USING (true);

-- Policy: utenti autenticati possono leggere/scrivere order_history
CREATE POLICY "Storico accessibile a tutti" ON order_history
  FOR ALL USING (true);

-- Policy: utenti autenticati possono leggere/scrivere bem_job
CREATE POLICY "BEM Job accessibile a tutti" ON bem_job
  FOR ALL USING (true);

-- Policy: utenti autenticati possono leggere/scrivere bem_forno
CREATE POLICY "BEM Forno accessibile a tutti" ON bem_forno
  FOR ALL USING (true);

-- ======= 11. UTENTE ADMIN INIZIALE =======
-- Password: admin123 (dovrai hasharla con bcrypt o cambiarla dopo)
INSERT INTO profiles (username, password_hash, full_name, role, approved)
VALUES ('admin', 'admin123', 'Amministratore', 'admin', true)
ON CONFLICT (username) DO NOTHING;
