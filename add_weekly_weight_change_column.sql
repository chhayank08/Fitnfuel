-- Manual SQL script to add weekly_weight_change column
-- Run this in your Supabase SQL Editor if the migration doesn't work

-- Add the column if it doesn't exist
DO $$ 
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM information_schema.columns 
        WHERE table_name = 'profiles' 
        AND column_name = 'weekly_weight_change'
    ) THEN
        ALTER TABLE profiles 
        ADD COLUMN weekly_weight_change DECIMAL(3,1) DEFAULT 0;
        
        -- Add comment
        COMMENT ON COLUMN profiles.weekly_weight_change IS 'Weekly weight change target in kg (positive for gain, negative for loss)';
        
        RAISE NOTICE 'Column weekly_weight_change added successfully';
    ELSE
        RAISE NOTICE 'Column weekly_weight_change already exists';
    END IF;
END $$;

-- Verify the column was added
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'profiles' 
AND column_name = 'weekly_weight_change';