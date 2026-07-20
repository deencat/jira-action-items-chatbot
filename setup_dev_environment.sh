#!/bin/bash

# setup_dev_environment.sh
# Script to set up the complete development environment for jira-action-items-chatbot

echo "Setting up development environment for jira-action-items-chatbot..."

# Step 1: Ensure Python virtual environment is properly set up
echo "Step 1: Setting up Python virtual environment..."
if [ ! -d "server/venv_proper" ]; then
    echo "Creating Python virtual environment..."
    "C:/Users/andrechw/AppData/Local/Programs/Python/Python312/python.exe" -m venv server/venv_proper --clear
fi

# Step 2: Activate virtual environment and install Python dependencies
echo "Step 2: Installing Python dependencies..."
source server/venv_proper/Scripts/activate
pip install -r server/requirements.txt

# Step 3: Install Node.js dependencies for main project and extension
echo "Step 3: Installing Node.js dependencies..."
npm install
cd extension && npm install && cd ..

# Step 4: Verify environment
echo "Step 4: Verifying environment..."
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
echo "Python version: $(python --version)"

# Step 5: Create necessary directories if they don't exist
echo "Step 5: Creating necessary directories..."
mkdir -p memory

echo ""
echo "===== Environment Setup Complete ====="
echo "You can now run the following commands:"
echo "  - 'npm run dev' to start the extension development server"
echo "  - 'cd server && uvicorn app.main:app --reload' to start the API server"
echo ""
echo "Your environment is ready for development!"

# Keep the virtual environment active
exec $SHELL
