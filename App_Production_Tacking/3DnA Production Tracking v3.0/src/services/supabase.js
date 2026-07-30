import { createClient } from '@supabase/supabase-js';

// Sostituisci con le credenziali del nuovo progetto Supabase v3.0
const SUPABASE_URL = 'https://tcmqtwcbkowlmvvnrjbt.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRjbXF0d2Nia293bG12dm5yamJ0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI5NzQ3NzQsImV4cCI6MjA5ODU1MDc3NH0.-pyWIhUjkAYtaaybo1tt7vpeFYWvdDlu1RNNhInETyM';

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

export default supabase;
