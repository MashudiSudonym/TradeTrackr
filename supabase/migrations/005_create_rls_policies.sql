-- Migration: Enable Row Level Security and create policies
-- Description: Enables RLS and creates policies for data isolation
-- Version: 005

-- Enable RLS on all tables
alter table public.profiles enable row level security;
alter table public.closed_positions enable row level security;
alter table public.open_positions enable row level security;
alter table public.finance_records enable row level security;

-- ============================================
-- Profiles Policies
-- ============================================

-- Users can view their own profile
create policy "Users can view own profile"
  on public.profiles
  for select
  using (auth.uid() = id);

-- Users can insert their own profile (triggered by auth trigger)
create policy "Users can insert own profile"
  on public.profiles
  for insert
  with check (auth.uid() = id);

-- Users can update their own profile
create policy "Users can update own profile"
  on public.profiles
  for update
  using (auth.uid() = id);

-- ============================================
-- Closed Positions Policies
-- ============================================

-- Users can view their own closed positions
create policy "Users can view own closed positions"
  on public.closed_positions
  for select
  using (auth.uid() = user_id);

-- Users can insert their own closed positions
create policy "Users can insert own closed positions"
  on public.closed_positions
  for insert
  with check (auth.uid() = user_id);

-- Users can update their own closed positions
create policy "Users can update own closed positions"
  on public.closed_positions
  for update
  using (auth.uid() = user_id);

-- Users can delete their own closed positions
create policy "Users can delete own closed positions"
  on public.closed_positions
  for delete
  using (auth.uid() = user_id);

-- ============================================
-- Open Positions Policies
-- ============================================

-- Users can view their own open positions
create policy "Users can view own open positions"
  on public.open_positions
  for select
  using (auth.uid() = user_id);

-- Users can insert their own open positions
create policy "Users can insert own open positions"
  on public.open_positions
  for insert
  with check (auth.uid() = user_id);

-- Users can update their own open positions
create policy "Users can update own open positions"
  on public.open_positions
  for update
  using (auth.uid() = user_id);

-- Users can delete their own open positions
create policy "Users can delete own open positions"
  on public.open_positions
  for delete
  using (auth.uid() = user_id);

-- ============================================
-- Finance Records Policies
-- ============================================

-- Users can view their own finance records
create policy "Users can view own finance records"
  on public.finance_records
  for select
  using (auth.uid() = user_id);

-- Users can insert their own finance records
create policy "Users can insert own finance records"
  on public.finance_records
  for insert
  with check (auth.uid() = user_id);

-- Users can update their own finance records
create policy "Users can update own finance records"
  on public.finance_records
  for update
  using (auth.uid() = user_id);

-- Users can delete their own finance records
create policy "Users can delete own finance records"
  on public.finance_records
  for delete
  using (auth.uid() = user_id);
