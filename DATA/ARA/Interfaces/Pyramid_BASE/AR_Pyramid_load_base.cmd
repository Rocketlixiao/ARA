@echo off
Setlocal EnableDelayedExpansion

set sourceURI=\\pitodv101.edev.elabs.eds.com\ara_share
set sourceURIFiles=HPES_Asset_Reconciliation_Data_Pyramid*.zip
set logFile=Pyramid_BASE.LOG
set msg=Everything went well
set sourceDir=Input
set sourceFile=HPES_Asset_Reconciliation_Data_Pyramid*
set sourceFileAP=HPES_Asset_Reconciliation_Data_PyramidAP_*
set sourceFileEA=HPES_Asset_Reconciliation_Data_PyramidEA_*
set sourceFileLA=HPES_Asset_Reconciliation_Data_PyramidLA_*
set sourceFileNA=HPES_Asset_Reconciliation_Data_PyramidNA_*
set destFile=Pyramid_BASE
set destFileAP=%destFile%_AP
set destFileEA=%destFile%_EA
set destFileLA=%destFile%_LA
set destFileNA=%destFile%_NA

copy /Y %sourceURI%\%sourceURIFiles% %sourceDir%

if errorlevel 1 (
  set datetime=!date! !time!
  set msg=ERROR: Could not copy files from '%sourceURI%'!
  echo !datetime!^> !msg! >> %logFile%
)

set dt=%date:~10,4%%date:~4,2%%date:~7,2%

set archiveDir=Archive
set extract="c:\Program Files\7-Zip\7z.exe" e -y -bd -o%sourceDir%

for /F "delims=|" %%i in ('DIR "%sourceDir%\%sourceFile%.zip" /B') do (
   call %extract% %sourceDir%\%%i
   move /Y %sourceDir%\%%i %archiveDir%\%%~ni_%dt%%%~xi
)

:: APJ part
copy %sourceDir%\%sourceFileAP%.csv %sourceDir%\%destFileAP%.csv
del /Q %sourceDir%\%sourceFileAP%.csv

..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_%destFileAP%.xml
if %errorlevel% EQU 0 (
 del /Q %sourcedir%\%destFileAP%.csv
)

:: EMEA part
copy %sourceDir%\%sourceFileEA%.csv %sourceDir%\%destFileEA%.csv
del /Q %sourceDir%\%sourceFileEA%.csv

..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_%destFileEA%.xml
if %errorlevel% EQU 0 (
  del /Q %sourcedir%\%destFileEA%.csv
)

:: LA part
copy %sourceDir%\%sourceFileLA%.csv %sourceDir%\%destFileLA%.csv
del /Q %sourceDir%\%sourceFileLA%.csv

..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_%destFileLA%.xml
if %errorlevel% EQU 0 (
 del /Q %sourcedir%\%destFileLA%.csv
)


:: NA part
copy %sourceDir%\%sourceFileNA%.csv %sourceDir%\%destFileNA%.csv
del /Q %sourceDir%\%sourceFileNA%.csv

..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_%destFileNA%.xml
if %errorlevel% EQU 0 (
  del /Q %sourcedir%\%destFileNA%.csv
)

:: Post BASE Load procedures
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Post_BASE_procs.xml