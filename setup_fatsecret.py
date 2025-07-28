#!/usr/bin/env python3
"""
FatSecret API Setup Script

This script helps you set up the FatSecret API credentials for the diet service.

Steps to get FatSecret API credentials:
1. Go to https://platform.fatsecret.com/
2. Sign up for a developer account
3. Create a new application
4. Get your Client ID and Client Secret
5. Run this script to configure your credentials

Note: FatSecret API has different tiers:
- Basic (Free): Limited requests, basic recipe search
- Premium: More requests, detailed nutrition data, images
"""

import os
import sys

def setup_fatsecret_credentials():
    print("=== FatSecret API Setup ===")
    print()
    print("To use the FatSecret API, you need to:")
    print("1. Visit https://platform.fatsecret.com/")
    print("2. Sign up for a developer account")
    print("3. Create a new application")
    print("4. Get your Client ID and Client Secret")
    print()
    
    # Get credentials from user
    client_id = input("Enter your FatSecret Client ID: ").strip()
    client_secret = input("Enter your FatSecret Client Secret: ").strip()
    
    if not client_id or not client_secret:
        print("Error: Both Client ID and Client Secret are required!")
        return False
    
    # Update the service file
    service_file = "fatsecret_diet_service.py"
    
    try:
        with open(service_file, 'r') as f:
            content = f.read()
        
        # Replace placeholder credentials
        content = content.replace(
            'FATSECRET_CLIENT_ID = "your_client_id"',
            f'FATSECRET_CLIENT_ID = "{client_id}"'
        )
        content = content.replace(
            'FATSECRET_CLIENT_SECRET = "your_client_secret"',
            f'FATSECRET_CLIENT_SECRET = "{client_secret}"'
        )
        
        with open(service_file, 'w') as f:
            f.write(content)
        
        print(f"\n✅ Credentials updated in {service_file}")
        print("\nYou can now run the FatSecret diet service:")
        print(f"python3 {service_file}")
        
        return True
        
    except FileNotFoundError:
        print(f"Error: {service_file} not found!")
        return False
    except Exception as e:
        print(f"Error updating credentials: {e}")
        return False

def create_env_file():
    """Create .env file with FatSecret credentials"""
    print("\n=== Creating .env file ===")
    
    client_id = input("Enter your FatSecret Client ID: ").strip()
    client_secret = input("Enter your FatSecret Client Secret: ").strip()
    
    if not client_id or not client_secret:
        print("Error: Both credentials are required!")
        return False
    
    # Read existing .env file
    env_content = ""
    if os.path.exists('.env'):
        with open('.env', 'r') as f:
            env_content = f.read()
    
    # Add FatSecret credentials
    if 'FATSECRET_CLIENT_ID' not in env_content:
        env_content += f"\nFATSECRET_CLIENT_ID={client_id}"
    if 'FATSECRET_CLIENT_SECRET' not in env_content:
        env_content += f"\nFATSECRET_CLIENT_SECRET={client_secret}"
    
    with open('.env', 'w') as f:
        f.write(env_content)
    
    print("✅ .env file updated with FatSecret credentials")
    return True

def test_api_connection():
    """Test the FatSecret API connection"""
    print("\n=== Testing API Connection ===")
    
    try:
        # Import and test the API
        from fatsecret_diet_service import FatSecretAPI, FATSECRET_CLIENT_ID, FATSECRET_CLIENT_SECRET
        
        if FATSECRET_CLIENT_ID == "your_client_id":
            print("❌ Credentials not set up yet. Run setup first.")
            return False
        
        api = FatSecretAPI(FATSECRET_CLIENT_ID, FATSECRET_CLIENT_SECRET)
        
        # Test search
        print("Testing recipe search...")
        recipes = api.search_recipes("chicken", max_results=5)
        
        if recipes:
            print(f"✅ API connection successful! Found {len(recipes)} recipes.")
            print("Sample recipes:")
            for i, recipe in enumerate(recipes[:3]):
                print(f"  {i+1}. {recipe.get('recipe_name', 'Unknown')}")
        else:
            print("⚠️  API connected but no recipes found. This might be normal.")
        
        return True
        
    except Exception as e:
        print(f"❌ API test failed: {e}")
        return False

def main():
    print("FatSecret API Setup for FitFuel Diet Service")
    print("=" * 50)
    
    while True:
        print("\nOptions:")
        print("1. Set up FatSecret API credentials")
        print("2. Create/update .env file")
        print("3. Test API connection")
        print("4. Exit")
        
        choice = input("\nEnter your choice (1-4): ").strip()
        
        if choice == '1':
            setup_fatsecret_credentials()
        elif choice == '2':
            create_env_file()
        elif choice == '3':
            test_api_connection()
        elif choice == '4':
            print("Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

if __name__ == "__main__":
    main()