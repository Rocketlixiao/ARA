..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\MARK_FOR_REPORT_WEEKLY_NL.xml
if %errorlevel% EQU 0 (
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_NL_EMEA.xml
  sleep(10)
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_NL_AMS.xml
  sleep(10)
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_NL_APJ.xml
  
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\UNMARK_FOR_REPORT.xml
)
del /Q Output\*.xlsx