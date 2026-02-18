#!/bin/bash
# Quick local test of Google Drive sync

set -e

echo "Testing Google Drive sync locally..."
echo ""

# Check if credentials file exists
if [ ! -f "credentials.json" ]; then
    echo "❌ Error: credentials.json not found"
    echo ""
    echo "To test locally:"
    echo "1. Download your service account JSON from Google Cloud Console"
    echo "2. Save it as 'credentials.json' in this directory"
    echo "3. Run this script again"
    exit 1
fi

# Check if GDRIVE_ROOT_FOLDER_ID is set
if [ -z "$GDRIVE_ROOT_FOLDER_ID" ]; then
    echo "❌ Error: GDRIVE_ROOT_FOLDER_ID environment variable not set"
    echo ""
    echo "Export it with:"
    echo "  export GDRIVE_ROOT_FOLDER_ID='your_folder_id_here'"
    exit 1
fi

echo "✓ Found credentials.json"
echo "✓ GDRIVE_ROOT_FOLDER_ID=$GDRIVE_ROOT_FOLDER_ID"
echo ""

# Run the sync script
echo "Running sync..."
GOOGLE_DRIVE_CREDENTIALS=$(cat credentials.json) python scripts/gdrive_sync.py > data/gdrive_files.json 2>&1

if [ $? -eq 0 ]; then
    echo "✓ Sync successful!"
    echo ""
    echo "Files synced:"
    cat data/gdrive_files.json | python -m json.tool
else
    echo "❌ Sync failed. Check the error messages above."
    exit 1
fi
