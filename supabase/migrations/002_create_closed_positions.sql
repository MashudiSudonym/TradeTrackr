-- Migration: Create closed_positions table
-- Description: Creates table for closed/completed trade positions
-- Version: 002

-- Create closed positions table
create table public.closed_positions (
  id text not null primary key,
  user_id uuid references public.profiles(id) not null,
  symbol text not null,
  open_time timestamp with time zone not null,
  close_time timestamp with time zone not null,
  volume double precision not null,
  side text not null check (side in ('BUY', 'SELL')),
  open_price double precision not null,
  close_price double precision not null,
  stop_loss double precision,
  take_profit double precision,
  swap double precision default 0.0,
  commission double precision default 0.0,
  profit double precision not null,
  reason text not null check (reason in ('TP', 'SL', 'USER', 'MANUAL')),
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  is_synced boolean default false
);

-- Create indexes for performance
create index idx_closed_positions_user_id on public.closed_positions(user_id);
create index idx_closed_positions_open_time on public.closed_positions(open_time desc);
create index idx_closed_positions_symbol on public.closed_positions(symbol);
create index idx_closed_positions_is_synced on public.closed_positions(is_synced);
