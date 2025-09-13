@echo off
echo Chicago Data Analysis - Setup and Execution
echo ===========================================

echo.
echo Step 1: Installing Python dependencies...
pip install -r requirements.txt

echo.
echo Step 2: Running Chicago Data Analysis...
python database_connection_helper.py

echo.
echo Analysis complete! Check the output above for results.
pause
