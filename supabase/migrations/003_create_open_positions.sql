-- Migration: Create open_positions table
-- Description: Creates table for currently active/open trade positions
-- Version: 003

-- Create open positions table
create table public.open_positions (
  id text not null primary key,
  user_id uuid references public.profiles(id) not null,
  symbol text not null,
  open_time timestamp with time zone not null,
  volume double precision not null,
  side text not null check (side in ('BUY', 'SELL')),
  open_price double precision not null,
  current_price double precision,
  stop_loss double precision,
  take_profit double precision,
  swap double precision default 0.0,
  commission double precision default 0.0,
  profit double precision not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null,
  is_synced boolean default false
);

-- Create indexes for performance
create index idx_open_positions_user_id on public.open_positions(user_id);
create index idx_open_positions_open_time on public.open_positions(open_time desc);
create index idx_open_positions_symbol on public.open_positions(symbol);
create index idx_open_positions_is_synced on public.open_positions(is_synced);
