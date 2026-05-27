-- 第1步：创建通话记录表
CREATE TABLE IF NOT EXISTS call_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  lead_id UUID REFERENCES leads(id) ON DELETE CASCADE,
  result TEXT DEFAULT 'pending',
  note TEXT DEFAULT '',
  next_followup TIMESTAMPTZ,
  duration_seconds INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE call_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "allow all" ON call_logs;
CREATE POLICY "allow all" ON call_logs FOR ALL TO anon USING (true) WITH CHECK (true);

-- 第2步：给 leads 表加字段
ALTER TABLE leads ADD COLUMN IF NOT EXISTS last_contacted_at TIMESTAMPTZ;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS next_followup_at TIMESTAMPTZ;
ALTER TABLE leads ADD COLUMN IF NOT EXISTS call_count INT DEFAULT 0;
