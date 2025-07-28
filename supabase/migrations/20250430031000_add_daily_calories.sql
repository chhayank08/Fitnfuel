-- Remove daily_calories column from diet_plans table
ALTER TABLE diet_plans DROP COLUMN IF EXISTS daily_calories;