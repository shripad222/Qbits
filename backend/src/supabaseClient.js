import { createClient } from '@supabase/supabase-js';

const supabaseUrl = "https://gszkxmxrhfmhujujtwho.supabase.co";
const supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imdzemt4bXhyaGZtaHVqdWp0d2hvIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2MDQ2NjQzMSwiZXhwIjoyMDc2MDQyNDMxfQ.SHfGaVoRJ8aiqz3-92vw-4lqUst0QCmDA8POdR0VUBk";

export const supabase = createClient(supabaseUrl, supabaseKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
});
