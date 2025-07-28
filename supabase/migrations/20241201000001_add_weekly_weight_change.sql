-- Add weekly_weight_change column to profiles table
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS weekly_weight_change DECIMAL(3,1) DEFAULT 0;

-- Add comment to describe the column
COMMENT ON COLUMN profiles.weekly_weight_change IS 'Weekly weight change target in kg (positive for gain, negative for loss)';