echo off
cls
echo Please wait...
for /f "delims=" %%x in (exportparams) do (set %%x)

set logdir=ExportLogs
if not exist %logdir% mkdir %logdir%

set d=%DATE:~-2%%DATE:~4,2%%DATE:~7,2%
set t=%time:~0,5%
set t=%t::=%
set t=%t: =0%
set timestamp=%d%_%t%
set t=%t: =0%