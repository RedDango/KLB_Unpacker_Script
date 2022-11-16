:: Turn off echo
@echo off

:: Load config file
ECHO Loading config file...
IF EXIST %~dp0\UNPACK.INI GOTO :LOADINI

:: No config file found, error out
ECHO No config file found, please create UNPACK.INI
GOTO :EOF

:: Load config file
:LOADINI
ECHO Parsing config file...
FOR /F "tokens=1,2 delims==" %%A IN (%~dp0\UNPACK.INI) DO SET %%A=%%B

:: Check for required variables
:: Variables: AssetStudioCLIPath, SearchPath, OutputPath, binout_file, excel_file, assetindex_file, englishtextmap_file, lua_file, xor_key
ECHO Checking for required variables...
IF NOT DEFINED AssetStudioCLIPath GOTO :VAR_ERROR
IF NOT DEFINED SearchPath GOTO :VAR_ERROR
IF NOT DEFINED OutputPath GOTO :VAR_ERROR
IF NOT DEFINED binout_file GOTO :VAR_ERROR
IF NOT DEFINED excel_file GOTO :VAR_ERROR
IF NOT DEFINED assetindex_file GOTO :VAR_ERROR
IF NOT DEFINED englishtextmap_file GOTO :VAR_ERROR
IF NOT DEFINED lua_file GOTO :VAR_ERROR
IF NOT DEFINED xor_key GOTO :VAR_ERROR

:: Jump to main if all variables are set
GOTO :MAIN

:VAR_ERROR
ECHO Required variables not found, please check UNPACK.INI
GOTO :EOF

:MAIN
:: Debug print variables
ECHO Debug print variables...
ECHO -----------------------------------------
ECHO AssetStudioCLIPath: %AssetStudioCLIPath%
ECHO SearchPath: %SearchPath%
ECHO OutputPath: %OutputPath%

ECHO binout_file: %binout_file%
ECHO excel_file: %excel_file%
ECHO assetindex_file: %assetindex_file%
ECHO englishtextmap_file: %englishtextmap_file%
ECHO lua_file: %lua_file%

ECHO xor_key: %xor_key%
ECHO -----------------------------------------

:: Create output directory
ECHO Creating output directory...
MKDIR %~dp0\output

:: Look for files to unpack
ECHO Looking for files to unpack...
:: Find binout_file and unpack
FOR /F "tokens=*" %%A IN ('DIR /B /S "%SearchPath%"\%binout_file%') DO (
    ECHO Unpacking %%A...
    %AssetStudioCLIPath% "%%A" %OutputPath%\%binout_file%\ --game GI --xor_key %xor_key%
)

:: Find excel_file and unpack
FOR /F "tokens=*" %%A IN ('DIR /B /S "%SearchPath%"\%excel_file%') DO (
    ECHO Unpacking %%A...
    REM ECHO %AssetStudioCLIPath% %%A %~dp0\output\binout --game GI --xor_key %xor_key%
    %AssetStudioCLIPath% "%%A" %OutputPath%\%excel_file%\ --game GI --xor_key %xor_key%
)

:: Find assetindex_file and unpack
FOR /F "tokens=*" %%A IN ('DIR /B /S "%SearchPath%"\%assetindex_file%') DO (
    ECHO Unpacking %%A...
    %AssetStudioCLIPath% "%%A" %OutputPath%\%assetindex_file%\ --game GI 
)

:: Find englishtextmap_file and unpack
FOR /F "tokens=*" %%A IN ('DIR /B /S "%SearchPath%"\%englishtextmap_file%') DO (
    ECHO Unpacking %%A...
    %AssetStudioCLIPath% "%%A" %OutputPath%\%englishtextmap_file%\ --game GI 
)

:: Find lua_file and unpack
FOR /F "tokens=*" %%A IN ('DIR /B /S "%SearchPath%"\%lua_file%') DO (
    ECHO Unpacking %%A...
    %AssetStudioCLIPath% "%%A" %OutputPath%\%lua_file%\ --game GI 
)



