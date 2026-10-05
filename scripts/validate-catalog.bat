@echo off
python -m owl_catalog_tools ^
  --catalog-dir catalog ^
  --output build\catalog-release.json ^
  --version local ^
  --locale en ^
  --commit-sha local

if errorlevel 1 exit /b 1

echo.
echo Catalog validation OK
