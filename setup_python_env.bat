#!/bin/bash

# setup_python_env.sh
# Script to set up just the Python environment

echo "Setting up Python environment..."

# Use the absolute path to Python
PYTHON_PATH="C:/Users/andrechw/AppData/Local/Programs/Python/Python312/python.exe"
PIP_PATH="C:/Users/andrechw/AppData/Local/Programs/Python/Python312/Scripts/pip.exe"

# Install packages one by one
echo "Installing Python packages..."

$PIP_PATH install fastapi==0.103.1
$PIP_PATH install uvicorn[standard]==0.23.2
$PIP_PATH install pydantic>=2.3.0 
$PIP_PATH install python-dotenv==1.0.0
$PIP_PATH install httpx==0.24.1
$PIP_PATH install sqlalchemy==2.0.20
$PIP_PATH install aiosqlite==0.19.0
$PIP_PATH install jira==3.5.1
$PIP_PATH install python-jose[cryptography]==3.3.0
$PIP_PATH install passlib[bcrypt]==1.7.4
$PIP_PATH install schedule==1.2.0
$PIP_PATH install nltk==3.8.1
$PIP_PATH install dateparser==1.1.8
$PIP_PATH install requests==2.31.0
$PIP_PATH install apscheduler==3.10.1

echo "Python package installation complete!"
