-- Migration: Create finance_records table
-- Description: Creates table for deposit and withdrawal transactions
-- Version: 004

-- Create finance records table
create table public.finance_records (
  id text not null primary key,
  user_id uuid references public.profiles(id) not null,
  type text not null check (type in ('DEPOSIT', 'WITHDRAWAL')),
  time timestamp with time zone not null,
  amount double precision not null,
  status text not null,
  payment_gateway text not null,
  details text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  is_synced boolean default false
);

-- Create indexes for performance
create index idx_finance_records_user_id on public.finance_records(user_id);
create index idx_finance_records_time on public.finance_records(time desc);
create index idx_finance_records_type on public.finance_records(type);
create index idx_finance_records_is_synced on public.finance_records(is_synced);
