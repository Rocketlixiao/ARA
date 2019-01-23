..\..\..\BIN\TOOLS\ARTaskHandler\AR_TaskHandler.exe conf_Pyramid.xml

if %errorlevel% EQU 0 (
	del Input\Pyramid_base.csv
)