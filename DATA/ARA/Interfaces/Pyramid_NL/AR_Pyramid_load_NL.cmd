@echo off
Setlocal EnableDelayedExpansion

set sourceURI=\\205.239.18.191\ara_share
set sourceURIFiles=HPES_Asset_Reconciliation_Data_Weekly_Bookings_Pyramid*.zip
set sourceDir=Input
set amiDir=ARA\Interfaces\Pyramid_NL\Input
set logFile=Pyramid_NL.LOG
set msg=Everything went well

copy /Y %sourceURI%\%sourceURIFiles% %sourceDir%

if errorlevel 1 (
  set datetime=!date! !time!
  set msg=ERROR: Could not copy files from '%sourceURI%'!
  echo !datetime!^> !msg! >> %logFile%
)

set archiveDir=Archive
set extract="c:\Program Files\7-Zip\7z.exe" e -y -bd -o%sourceDir%
set dt=%date:~10,4%%date:~4,2%%date:~7,2%

for /F "delims=|" %%i in ('DIR "%sourceDir%\*.zip" /B') do (
   call %extract% %sourceDir%\%%i
   move /Y %sourceDir%\%%i %archiveDir%\%%~ni_%dt%%%~xi
)

..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Pyramid_NL_EMEA.xml
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Pyramid_NL_LA.xml
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Pyramid_NL_NA.xml
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Pyramid_NL_AP.xml

del /Q %sourceDir%\*.csv

:: Post NL Load procedures
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Post_NL_procs.xml