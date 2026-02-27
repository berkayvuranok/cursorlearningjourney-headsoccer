-- Head Soccer: profiles, matches, rank view
-- Run in Supabase SQL Editor or via supabase db push

-- Profiles: display name, skin, device_id for anonymous play
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  device_id TEXT UNIQUE NOT NULL,
  display_name TEXT NOT NULL DEFAULT 'Player',
  skin TEXT NOT NULL DEFAULT 'classicGreen',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Matches: each game result (online or local)
CREATE TABLE IF NOT EXISTS public.matches (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  player1_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  player2_id UUID REFERENCES public.profiles(id) ON DELETE SET NULL,
  player1_device_id TEXT,
  player2_device_id TEXT,
  score1 INT NOT NULL DEFAULT 0,
  score2 INT NOT NULL DEFAULT 0,
  winner_device_id TEXT,
  is_online BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Indexes for leaderboard and profile stats
CREATE INDEX IF NOT EXISTS idx_matches_player1 ON public.matches(player1_id);
CREATE INDEX IF NOT EXISTS idx_matches_player2 ON public.matches(player2_id);
CREATE INDEX IF NOT EXISTS idx_matches_created_at ON public.matches(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_profiles_device_id ON public.profiles(device_id);

-- RLS: allow anonymous read/write for anon key (restrict in production if needed)
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for profiles" ON public.profiles
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all for matches" ON public.matches
  FOR ALL USING (true) WITH CHECK (true);

-- View: leaderboard by device_id (wins, losses, points)
CREATE OR REPLACE VIEW public.leaderboard AS
SELECT
  p.id,
  p.device_id,
  p.display_name,
  p.skin,
  COALESCE(w.wins, 0) AS wins,
  COALESCE(l.losses, 0) AS losses,
  (COALESCE(w.wins, 0) * 30 - COALESCE(l.losses, 0) * 10) AS points
FROM public.profiles p
LEFT JOIN (
  SELECT winner_device_id AS device_id, COUNT(*) AS wins
  FROM public.matches
  WHERE winner_device_id IS NOT NULL
  GROUP BY winner_device_id
) w ON p.device_id = w.device_id
LEFT JOIN (
  SELECT
    CASE
      WHEN winner_device_id = player1_device_id THEN player2_device_id
      ELSE player1_device_id
    END AS device_id,
    COUNT(*) AS losses
  FROM public.matches
  WHERE winner_device_id IS NOT NULL
  GROUP BY 1
) l ON p.device_id = l.device_id
ORDER BY points DESC NULLS LAST;

-- Trigger: update profiles.updated_at
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
