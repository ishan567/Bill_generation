-- Run this once in the existing Supabase project.
-- It is safe to run more than once.
alter table public.bills
  add column if not exists custom_items jsonb not null default '[]'::jsonb;
