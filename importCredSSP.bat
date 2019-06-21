:: importCredSSP.bat
:: Author:	Alex Paarfus <apaarfus@wtcox.com>
:: Date:	2019-06-21
::
:: Win7 Registry path for RDP Connections to Windows 10 1803+ hosts
::
:: The MIT License
:: 
:: Copyright (c) 2019 Alex Paarfus
:: 
:: Permission is hereby granted, free of charge, 
:: to any person obtaining a copy of this software and 
:: associated documentation files (the "Software"), to 
:: deal in the Software without restriction, including 
:: without limitation the rights to use, copy, modify, 
:: merge, publish, distribute, sublicense, and/or sell 
:: copies of the Software, and to permit persons to whom 
:: the Software is furnished to do so, 
:: subject to the following conditions:
:: 
:: The above copyright notice and this permission notice 
:: shall be included in all copies or substantial portions of the Software.
:: 
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
:: EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
:: OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
:: IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR 
:: ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
:: TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
:: SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

:: Environment Options
@echo off
setlocal enableextensions

:: Check for admin rights
cd .
net sessions >nul 2>&1
if not %errorlevel% equ 0 (
	echo Error: ADMIN REQUIRED
	goto :eof
)

:: Check for "delete" option
if not "%~1."=="." if /i "%~1."=="delete" (
	call :delpatch
	goto :eof
)

:: If keys already exist, skip
cd .
reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" >null 2>&1
if %errorlevel% equ 0 (
	reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters" 2>&1 | findstr /i "0x2" >nul 2>&1
	if %errorlevel% equ 0 (
		echo Registry Key already set to correct value
		goto :eof
	)
)

:: Import Registry Key Values
pushd %~dp0
cd .
reg import credSSP.reg >nul
if not %errorlevel% equ 0 (
	echo Error: Unable to import CredSSP
	goto :eof
)
echo Path Applied
goto :eof

:: Functions
:: Remove Patch
:delPatch
	cd .
	reg query "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP" >null 2>&1
	if not %errorlevel% equ 0 (
		echo Error: CANNOT LOCATE KEY
		goto :eof
	)
	cd .
	reg delete "HKLM\Software\Micrsofot\Windows\CurrentVersion\Policies\System\CredSSP" /f >nul
	if not %errorlevel% equ 0 (
		echo Error: CANNOT DELETE KEY
		goto :eof
	)
	echo Patch Removed
goto :eof
