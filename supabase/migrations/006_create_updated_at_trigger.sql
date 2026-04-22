-- Migration: Create updated_at trigger function
-- Description: Creates a trigger function to automatically update updated_at timestamp
-- Version: 006

-- Create function to handle updated_at timestamp
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc'::text, now());
  return new;
end;
$$ language plpgsql;

-- Create trigger for profiles table
create trigger handle_updated_at
  before update on public.profiles
  for each row
  execute procedure public.handle_updated_at();

-- Create trigger for closed_positions table
create trigger handle_updated_at
  before update on public.closed_positions
  for each row
  execute procedure public.handle_updated_at();

-- Create trigger for open_positions table
create trigger handle_updated_at
  before update on public.open_positions
  for each row
  execute procedure public.handle_updated_at();

-- Create trigger for finance_records table
create trigger handle_updated_at
  before update on public.finance_records
  for each row
  execute procedure public.handle_updated_at();
