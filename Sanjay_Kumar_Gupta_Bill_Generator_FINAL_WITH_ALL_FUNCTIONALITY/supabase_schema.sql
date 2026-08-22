create table if not exists public.bills (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  bill_date text not null,
  party_name text not null,
  assessment_year text not null,
  income_tax numeric(14,2) not null default 0,
  appeal numeric(14,2) not null default 0,
  drafting numeric(14,2) not null default 0,
  miscellaneous numeric(14,2) not null default 0,
  total numeric(14,2) not null default 0,
  created_at timestamptz not null default now()
);

alter table public.bills enable row level security;

drop policy if exists "Users can view their own bills" on public.bills;
create policy "Users can view their own bills"
on public.bills for select to authenticated
using ((select auth.uid()) = user_id);

drop policy if exists "Users can create their own bills" on public.bills;
create policy "Users can create their own bills"
on public.bills for insert to authenticated
with check ((select auth.uid()) = user_id);

drop policy if exists "Users can delete their own bills" on public.bills;
create policy "Users can delete their own bills"
on public.bills for delete to authenticated
using ((select auth.uid()) = user_id);

grant select, insert, delete on public.bills to authenticated;

create index if not exists bills_user_created_idx
on public.bills(user_id, created_at desc);
