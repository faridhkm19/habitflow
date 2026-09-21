-- ==========================================
-- HABITFLOW DATABASE SETUP SCRIPT
-- ==========================================

-- ------------------------------------------
-- 1. PROFILES TABLE
-- ------------------------------------------
create table if not exists profiles (
  id               uuid primary key references auth.users(id) on delete cascade,
  display_name     varchar,
  avatar_url       text,
  theme_preference varchar default 'light',
  notif_enabled    boolean default true,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now()
);

-- RLS for profiles
alter table profiles enable row level security;

create policy "User can view own profile"
  on profiles for select using (auth.uid() = id);

create policy "User can update own profile"
  on profiles for update using (auth.uid() = id);

-- Trigger to automatically create profile on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (new.id, split_part(new.email, '@', 1));
  return new;
end;
$$;

-- Drop trigger if exists to prevent errors on re-run
drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- Trigger for updated_at
create or replace function update_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

drop trigger if exists profiles_updated_at on profiles;
create trigger profiles_updated_at
  before update on profiles
  for each row execute function update_updated_at();

-- ------------------------------------------
-- 2. HABITS TABLE
-- ------------------------------------------
create table if not exists habits (
  id              uuid primary key default gen_random_uuid(),
  user_id         uuid not null references auth.users(id) on delete cascade,
  name            varchar(50) not null,
  icon_name       varchar not null,
  color_hex       varchar(7) not null,
  category        varchar not null check (category in ('health','learning','mindfulness','productivity','social','custom')),
  frequency_type  varchar not null check (frequency_type in ('daily','specific_days','x_per_week')),
  frequency_value jsonb not null default '{}',
  reminder_time   time,
  reminder_message varchar(100),
  is_archived     boolean not null default false,
  longest_streak  int not null default 0,
  created_at      timestamptz not null default now(),
  updated_at      timestamptz not null default now()
);

-- RLS for habits
alter table habits enable row level security;

create policy "User reads own habits"
  on habits for select using (auth.uid() = user_id);

create policy "User inserts own habits"
  on habits for insert with check (auth.uid() = user_id);

create policy "User updates own habits"
  on habits for update using (auth.uid() = user_id);

create policy "User deletes own habits"
  on habits for delete using (auth.uid() = user_id);

-- Trigger for updated_at
drop trigger if exists habits_updated_at on habits;
create trigger habits_updated_at
  before update on habits
  for each row execute function update_updated_at();

-- ------------------------------------------
-- 3. HABIT LOGS TABLE
-- ------------------------------------------
create table if not exists habit_logs (
  id              uuid primary key default gen_random_uuid(),
  habit_id        uuid not null references habits(id) on delete cascade,
  user_id         uuid not null references auth.users(id) on delete cascade,
  log_date        date not null,
  is_completed    boolean not null default true,
  mood            varchar check (mood in ('good','neutral','tired')),
  note            varchar(100),
  created_at      timestamptz not null default now(),
  unique(habit_id, log_date)
);

-- RLS for habit_logs
alter table habit_logs enable row level security;

create policy "User reads own habit logs"
  on habit_logs for select using (auth.uid() = user_id);

create policy "User inserts own habit logs"
  on habit_logs for insert with check (auth.uid() = user_id);

create policy "User updates own habit logs"
  on habit_logs for update using (auth.uid() = user_id);

create policy "User deletes own habit logs"
  on habit_logs for delete using (auth.uid() = user_id);

