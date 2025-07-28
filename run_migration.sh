#!/bin/bash

# Run Supabase migration to add weekly_weight_change column
echo "Running Supabase migration..."

# Check if supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "Supabase CLI not found. Please install it first:"
    echo "npm install -g supabase"
    exit 1
fi

# Run the migration
supabase db push

echo "Migration completed successfully!"
echo "The weekly_weight_change column has been added to the profiles table."