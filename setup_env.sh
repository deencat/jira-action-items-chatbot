#!/bin/bash

# This script sets up the environment for development

# Add Node.js to path
export PATH=$PATH:/c/Program\ Files/nodejs/

# Activate the Python virtual environment
source server/venv_proper/Scripts/activate

# Echo the environment info
echo "Environment setup complete!"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "Python version: $(python --version)"

# Keep the terminal open
exec $SHELL
