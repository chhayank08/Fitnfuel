/*
  # Initial Schema Setup for Fitness Fuel App

  1. New Tables
    - `profiles`: Stores user profile information
      - `id` (uuid, primary key, references auth.users)
      - `created_at` (timestamp with time zone)
      - `updated_at` (timestamp with time zone)
      - `full_name` (text, nullable)
      - `avatar_url` (text, nullable)
      - `weight` (numeric, nullable)
      - `height` (numeric, nullable)
      - `goal` (text, nullable)
    
    - `diet_plans`: Stores user diet plans
      - `id` (uuid, primary key)
      - `created_at` (timestamp with time zone)
      - `user_id` (uuid, references profiles.id)
      - `name` (text)
      - `description` (text, nullable)
      - `calories` (numeric, nullable)
      - `protein` (numeric, nullable)
      - `carbs` (numeric, nullable)
      - `fat` (numeric, nullable)
    
    - `exercise_plans`: Stores user exercise plans
      - `id` (uuid, primary key)
      - `created_at` (timestamp with time zone)
      - `user_id` (uuid, references profiles.id)
      - `name` (text)
      - `description` (text, nullable)
      - `duration` (numeric, nullable)
      - `difficulty` (text, nullable)
    
    - `progress_logs`: Stores user progress logs
      - `id` (uuid, primary key)
      - `created_at` (timestamp with time zone)
      - `user_id` (uuid, references profiles.id)
      - `weight` (numeric, nullable)
      - `notes` (text, nullable)
      - `mood` (text, nullable)
  
  2. Security
    - Enable RLS on all tables
    - Add policies for authenticated users to manage their own data
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  full_name TEXT,
  avatar_url TEXT,
  weight NUMERIC,
  height NUMERIC,
  goal TEXT
);

-- Create diet_plans table
CREATE TABLE IF NOT EXISTS diet_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  calories NUMERIC,
  protein NUMERIC,
  carbs NUMERIC,
  fat NUMERIC
);

-- Create exercise_plans table
CREATE TABLE IF NOT EXISTS exercise_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  duration NUMERIC,
  difficulty TEXT
);

-- Create progress_logs table
CREATE TABLE IF NOT EXISTS progress_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID REFERENCES profiles(id) ON DELETE CASCADE NOT NULL,
  weight NUMERIC,
  notes TEXT,
  mood TEXT
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE diet_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE exercise_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE progress_logs ENABLE ROW LEVEL SECURITY;

-- Create policies for profiles
CREATE POLICY "Users can view their own profile"
  ON profiles
  FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile"
  ON profiles
  FOR UPDATE
  USING (auth.uid() = id);

-- Create policies for diet_plans
CREATE POLICY "Users can view their own diet plans"
  ON diet_plans
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own diet plans"
  ON diet_plans
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own diet plans"
  ON diet_plans
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own diet plans"
  ON diet_plans
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for exercise_plans
CREATE POLICY "Users can view their own exercise plans"
  ON exercise_plans
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own exercise plans"
  ON exercise_plans
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own exercise plans"
  ON exercise_plans
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own exercise plans"
  ON exercise_plans
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create policies for progress_logs
CREATE POLICY "Users can view their own progress logs"
  ON progress_logs
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own progress logs"
  ON progress_logs
  FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own progress logs"
  ON progress_logs
  FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own progress logs"
  ON progress_logs
  FOR DELETE
  USING (auth.uid() = user_id);

-- Create function to handle profile creation on user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (new.id, new.raw_user_meta_data->>'full_name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();