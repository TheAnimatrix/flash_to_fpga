@echo off
setlocal EnableExtensions DisableDelayedExpansion

set "FILE_I=%~1"
set "SEARCH=%~2"
set "REPLAC=%~3"
set "FILE_O=%~4"
set "CASE=%~5"
set "FLAG=%~6"
if not defined FILE_I exit /B 1
if not defined SEARCH exit /B 1
if not defined FILE_O set "FILE_O=con"
if defined CASE set "CASE=#"
if defined FLAG set "FLAG=#"

for /F "delims=" %%L in ('
    findstr /N /R "^" "%FILE_I%" ^& break ^> "%FILE_O%"
') do (
    set "STRING=%%L"
    setlocal EnableDelayedExpansion
    set "STRING=!STRING:*:=!"
    call :REPL RETURN STRING SEARCH REPLAC "%CASE%" "%FLAG%"
    >> "%FILE_O%" echo(!RETURN!
    endlocal
)

endlocal
exit /B


:REPL  rtn_string  ref_string  ref_search  ref_replac  case  flag
setlocal EnableDelayedExpansion
set "STR=!%~2!"
set "SCH=!%~3!"
set "RPL=!%~4!"
if "%~5"=="" (set "OPT=/I") else (set "OPT=")
if not defined SCH endlocal & set "%~1=" & exit /B 1
set "SCH_CHR=!SCH:~,1!"
if not "%~6"=="" set "SCH_CHR="
if "!SCH_CHR!"=="=" set "SCH_CHR=" & rem = terminates search string
if "!SCH_CHR!"==""^" set "SCH_CHR=" & rem " could derange syntax
if "!SCH_CHR!"=="%%" set "SCH_CHR=" & rem % ends variable expansion
if "!SCH_CHR!"=="^!" set "SCH_CHR=" & rem ! ends variable expansion
call :LEN SCH_LEN SCH
call :LEN RPL_LEN RPL
set /A RED_LEN=SCH_LEN-1
set "RES="
:LOOP
call :LEN STR_LEN STR
if not defined STR goto :END
if defined SCH_CHR (
    set "WRK=!STR:*%SCH_CHR%=!"
    if %OPT% "!WRK!"=="!STR!" (
        set "RES=!RES!!STR!"
        set "STR="
    ) else (
        call :LEN WRK_LEN WRK
        set /A DFF_LEN=STR_LEN-WRK_LEN-1,INC_LEN=DFF_LEN+1,MOR_LEN=DFF_LEN+SCH_LEN
        for /F "tokens=1,2,3 delims=," %%M in ("!DFF_LEN!,!INC_LEN!,!MOR_LEN!") do (
            rem set "RES=!RES!!STR:~,%%M!"
            if defined WRK set "WRK=!WRK:~,%RED_LEN%!"
            if %OPT% "!STR:~%%M,1!!WRK!"=="!SCH!" (
                set "RES=!RES!!STR:~,%%M!!RPL!"
                set "STR=!STR:~%%O!"
            ) else (
                set "RES=!RES!!STR:~,%%N!"
                set "STR=!STR:~%%N!"
            )
        )
    )
) else (
    if %OPT% "!STR:~,%SCH_LEN%!"=="!SCH!" (
        set "RES=!RES!!RPL!"
        set "STR=!STR:~%SCH_LEN%!"
    ) else (
        set "RES=!RES!!STR:~,1!"
        set "STR=!STR:~1!"
    )
)
goto :LOOP
:END
if defined RES (
    for /F delims^=^ eol^= %%S in ("!RES!") do (
        endlocal
        set "%~1=%%S"
    )
) else endlocal & set "%~1="
exit /B


:LEN  rtn_length  ref_string
setlocal EnableDelayedExpansion
set "STR=!%~2!"
if not defined STR (set /A LEN=0) else (set /A LEN=1)
for %%L in (4096 2048 1024 512 256 128 64 32 16 8 4 2 1) do (
    if defined STR (
        set "INT=!STR:~%%L!"
        if not "!INT!"=="" set /A LEN+=%%L & set "STR=!INT!"
    )
)
endlocal & set "%~1=%LEN%"
exit /B