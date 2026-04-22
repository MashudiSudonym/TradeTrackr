-- Migration: Create profiles table
-- Description: Creates user profiles table linked to Supabase Auth
-- Version: 001

-- Enable UUID extension if not already enabled
create extension if not exists "uuid-ossp";

-- Create profiles table
create table public.profiles (
  id uuid references auth.users not null primary key,
  email text,
  display_name text,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null,
  updated_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Create index on email for lookups
create index idx_profiles_email on public.profiles(email);
