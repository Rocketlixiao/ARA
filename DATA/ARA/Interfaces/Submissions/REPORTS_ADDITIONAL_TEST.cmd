..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\RESUBMISSION.xml
..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\MARK_FOR_REPORT_ADDITIONAL.xml
if %errorlevel% EQU 0 (
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_ADD_EMEA.xml
  sleep(10)
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_ADD_AMS.xml
  sleep(10)
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\TEST_REPORT_ADD_APJ.xml
  
  ..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe Configs\UNMARK_FOR_REPORT.xml
)
del /Q Output\*.xlsx