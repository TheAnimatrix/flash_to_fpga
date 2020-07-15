@echo off
set BITFILE=
set MCS_TARGET_DIRECTORY=
set HELP=FALSE
set MCS_FILE_NAME=out.mcs

echo.

:parseArgs
call:getArgFlag "-h" "HELP" "%~1" && shift && goto :parseArgs
call:getArgWithValue "--bit-file" "BITFILE" "%~1" "%~2" && shift && shift && goto :parseArgs
call:getArgWithValue "--prom-dest" "MCS_TARGET_DIRECTORY" "%~1" "%~2" && shift && shift && goto :parseArgs
call:getArgWithValue "--prom-name" "MCS_FILE_NAME" "%~1" "%~2" && shift && shift && goto :parseArgs


if %HELP% == TRUE (
    goto :help
)

if "%BITFILE%" == "" (
    echo --bit-file can't be null
    goto :help
)
if "%BITFILE%" == "." (
    echo --bit-file must be an absolute path
    goto :help
)
if "%MCS_TARGET_DIRECTORY%" == "" (
    echo no target directory given for prom, using .\generated directory
    set MCS_TARGET_DIRECTORY=%cd%\generated
)

if %MCS_TARGET_DIRECTORY%==. (
    echo %cd%
    set MCS_TARGET_DIRECTORY=%cd%
)
if NOT EXIST %BITFILE% (
    echo --bit-file, file provided doesn't exist
    echo.
    goto :help
) 
if NOT EXIST %MCS_TARGET_DIRECTORY% (
    echo --promdest, target directory provided doesn't exist
    echo.
    goto :help
) 

::all checks over code runs here
echo generating prom arguement file
call .\dependencies\repl-str.bat %cd%\dependencies\generate_prom.cmd "[mcs_name]" ""%MCS_FILE_NAME%"" %cd%\generated\generated_prom.cmd
call .\dependencies\repl-str.bat %cd%\generated\generated_prom.cmd "[mcs_target_directory]" ""%MCS_TARGET_DIRECTORY%"" %cd%\generated\generated_prom.cmd
call .\dependencies\repl-str.bat %cd%\generated\generated_prom.cmd "[flash_bit_file]" ""%BITFILE%"" %cd%\generated\generated_prom.cmd
echo.
echo prom args file generated to %cd%\generated\generated_prom.cmd
call impact -batch %cd%\generated\generated_prom.cmd
echo. programming flash using generated file
call .\dependencies\repl-str.bat %cd%\dependencies\flash_rom.cmd "[mcs_target_directory]" ""%MCS_TARGET_DIRECTORY%\%MCS_FILE_NAME%"" %cd%\generated\g_flash_rom.cmd
call impact -batch %cd%\generated\g_flash_rom.cmd

goto:eof


:getArgWithValue
if "%~3"=="%~1" (
  if "%~4"=="" (
    REM unset the variable if value is not provided
    set "%~2="
    exit /B 1
  )
  set "%~2=%~4"
  exit /B 0
)
exit /B 1
goto:eof

:getArgFlag
if "%~3"=="%~1" (
  set "%~2=TRUE"
  exit /B 0
)
exit /B 1
goto:eof

set k=
:help
echo.
echo FLASH TO FPGA USAGE
echo arguement list:
echo --bit-file, [Required] provide your complete bit file absolute path [x:\folder\example.bit]
echo --prom-dest, [Optional] directory where you want your generated rom to be stored in (. for current directory, default)
echo --prom-name, [Optional] name of generated rom file, default is out.mcs
exit /B 1
goto:eof
