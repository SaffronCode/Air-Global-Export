@echo off
cls
echo.
title Air Exporte batch script - Saffron

rem fist initializes
set android_certificate=%certfolder%\MTeam Certification File.p12
set ios_dev_certificate=%certfolder%\MTeam IOS Certificate_dev.p12
set ios_dist_certificate=%certfolder%\MTeam IOS Certificate.p12

 
set passwordfile=%certfolder%\passwords
if exist "%passwordfile%" (
	set /p password=<"%passwordfile%"
)
set certificate_pass=%password%
if not exist exportparams (
	if ["%aircompiler%"]==[""] (
		goto environment_vars
	) else (
		set /p edit_env_var=Do you need to update your environment variables for air compiler directory and etc? press 1 to proceed.%=%
		if [%edit_env_var%]==1 (
			goto environment_vars
		) else (
			goto setswfname
		)
	)
)

echo Export properties founded
set goto_edit_exporter=2
set /p goto_edit_exporter=Do you need to reset your Exoprter file? press 1 to reset.%=%
if not %goto_edit_exporter%==1 (goto load_param_and_continue)
echo.
set edit_env_var=2
set /p edit_env_var=Do you need to update your environment variables? press 1 to proceed.%=%
if %edit_env_var%==1 (
		goto environment_vars
	) else (
		goto setswfname
	)
rem test part

:environment_vars
rem set the air compiler
	echo The current air compiler directory is "%aircompiler%" if you whant to change it, please enter it below.
	echo.
	set new_aircompiler=.
	set /p new_aircompiler=aircompiler: %=%
	echo Please wait... %new_aircompiler%
	if not [%new_aircompiler%]==[.] ( if not [%new_aircompiler%]==[ (setx aircompiler "%new_aircompiler%") ) else (echo Compiler directory not change)
	rem cls
echo.
rem set the global_native_folder
	echo Do you have Global directory for all of your .ane files? please enter the directory below.
	if not ["%global_native_folder%"]==[""] (echo    *** Your current .ane directory is "%global_native_folder%" ***)
	echo.
	set new_global_native_folder=.
	set /p new_global_native_folder=My global natives direcoty: %=%
	echo Please wait...
	if not [%new_global_native_folder%]==[.] ( if not [%new_global_native_folder%]==. (setx global_native_folder "%new_global_native_folder%") ) else (echo Global native direcoty didn't change)
	
echo.
rem set the certfolder
	echo Do you have Global directory for all of your p12 files? please enter the directory below.
	if not ["%certfolder%"]==[""] (echo    *** Your current "certificate" directory is "%certfolder%" ***)
	echo.
	set new_certfolder=.
	set /p new_certfolder=My certificates direcoty (The direcotry that contains all of your p12 files) you can skip it blank: %=%
	echo Please wait...
	if not [%new_certfolder%]==[.] ( if not [%new_certfolder%]==. (setx certfolder "%new_certfolder%") ) else (echo Global p12 direcoty didn't change)
	
rem get the name of the application. I have to save them all in "exportparas" file
	rem cls
	:setswfname
	cls
	set swfname=.
	set /p swfname=Enter the SWF file name without extenstion:%=%
	if [%swfname%]==[.] (echo * You have to enter you swf file name 
		goto setswfname
	)
	
	echo.
	echo   *** Default export name is %swfname%
	set exportname=%swfname%
	set /p exportname=Enter export file name:%=%
	echo.
	set /p provision_dev=Enter the apple "development" mobileprovision file name without extensnion:%=%
	echo.
	set /p provision_dist=Enter the apple "production(distribution)" mobileprovision file name without extensnion:%=%
	echo.
	set /p provision_adhoc=Enter the apple "adhoc" mobileprovision file name without extensnion:%=%
	echo.
	set local_native_folder=.
	if not [%global_native_folder%]==[.] echo    *** Your global native folder is %global_native_folder%
	set /p local_native_folder=Do you have local native folder? enter its name or pass this questin blank:%=%
	echo.
	if [%local_native_folder%]==[.] (
		set native_folder=-extdir "%global_native_folder%"
	) else (
		set native_folder=-extdir "%local_native_folder%"
	)
	
	rem local parameters
	set global_manifest=%swfname%-app
	set dist_xml_name=%global_manifest%
	set dev_xml_name=%global_manifest%
	set android_xml_name=%global_manifest%
	
	rem local parameters
	echo    *** Default manifest file is %global_manifest%
	set /p dist_xml_name=Enter the name of the apple "distribution" or "dist" manifest xml file:%=%
	echo.
	echo    *** Default manifest file is %global_manifest%
	set /p dev_xml_name=Enter the name of the apple "development" or "dev" manifest xml file:%=%
	echo.
	echo    *** Default manifest file is %global_manifest%
	set /p android_xml_name=Enter the name of the "android" development manifest xml file:%=%
	echo.

	rem local parameters
	set contents=Data AppIconsForPublish
	echo If you need to change iOS and Android icons, add "AppIconsForPublish-and" for android icons and "AppIconsForPublish-and" for iOS icons.
	set /p contents=These directories should embed with your application: "%contents%". Enter your own directory if you need to change them:%=%
	if not exist AppIconsForPublish (echo YOU FORGOT TO ADD "AppIconsForPublish" FOLDER TO YOUR EXPORT FOLDER! it uses for Saffron apps)
	if not exist Data (echo YOU FORGOT TO ADD "Data" FOLDER TO YOUR EXPORT FOLDER! it uses for Saffron apps)
	echo.
	
	set ios_contents=Default.png Default@2x.png Default-568h@2x.png Default-568h-Portrait@2x.png Default-Landscape.png Default-Landscape@2x~ipad.png Default-Landscape~ipad.png Default-Portrait.png Default-Portrait@2x~ipad.png Default-Portrait~ipad.png
	if not exist Default.png (echo YOU FORGOT TO ADD "%ios_contents%" FILES TO YOUR EXPORT FOLDER! used for ios exports)
	echo.
	
	
	rem local parameters
	set local_ios_dev_certificate=%ios_dev_certificate%
	echo -%local_ios_dev_certificate%
	set /p local_ios_dev_certificate=Do you need to change your iOS "development" certificate file? enter the new target or pass this question blank%=%
	set ios_dev_certificate=%local_ios_dev_certificate%
	echo.
	
	rem local parameters
	set local_ios_dist_certificate=%ios_dist_certificate%
	echo -%local_ios_dist_certificate%
	set /p local_ios_dist_certificate=Do you need to change your iOS "distribution" certificate file? enter the new target or pass this question blank%=%
	set ios_dist_certificate=%local_ios_dist_certificate%
	echo.
	
	rem local parameters
	set local_android_certificate=%android_certificate%
	echo -%local_android_certificate%
	set /p local_android_certificate=Do you need to change your "Android" certificate file? enter the new target or pass this question blank%=%
	set android_certificate=%local_android_certificate%
	echo.
	
	:setpasswrod
	
	if not [%certificate_pass%] == [] echo The certificates password is loaded from certificates directory.
	set /p test_pass=Do you need to change the Certificate files passwords? Enter your new password:%=%
	
	if ["%test_pass%"]==[""] if ["%certificate_pass%"]==[""] (echo You should enter your passwrod! 
	goto :setpasswrod)
	
	if not [%test_pass%]==[] set certificate_pass=%test_pass%

	
	
rem save parameters

del exportparams
echo swfname=%swfname%> exportparams
echo exportname=%exportname%>> exportparams
echo provision_dev=%provision_dev%>> exportparams
echo provision_dist=%provision_dist%>> exportparams
echo provision_adhoc=%provision_adhoc%>> exportparams
if not ["%local_native_folder%"]==[ if not ["%native_folder%"]==["%local_native_folder%"] (echo native_folder=%native_folder%>> exportparams)
echo dist_xml_name=%dist_xml_name%>> exportparams
echo dev_xml_name=%dev_xml_name%>> exportparams
echo android_xml_name=%android_xml_name%>> exportparams
echo contents=%contents%>> exportparams
echo ios_contents=%ios_contents%>> exportparams
if not ["%local_ios_dev_certificate%"]==["%ios_dev_certificate%"] (echo ios_dev_certificate=%ios_dev_certificate%>> exportparams)
if not ["%ios_dist_certificate%"]==["%local_ios_dist_certificate%"] (echo ios_dist_certificate=%ios_dist_certificate%>> exportparams)
if not ["%android_certificate%"]==["%local_android_certificate%"] (echo android_certificate=%android_certificate%>> exportparams)
if not ["%certificate_pass%"]==["%password%"] (echo certificate_pass=%certificate_pass%>> exportparams)
	
	
:load_param_and_continue
rem load and save a file line by line to other place
for /f "delims=" %%x in (exportparams) do (set %%x)

set ios_pass=%certificate_pass%
set android_pass=%certificate_pass%

if not ["%provision_dist%"]==[ (
	if ["%provision_dist%"]==["%provision_dist:.mobileprovision=%"] (
		set ios_dist_mobprevision=%provision_dist%.mobileprovision
	) else (
		set ios_dist_mobprevision=%provision_dist%
	)
) else (set provision_dist=.)

if not ["%provision_dev%"]==[ (
	if ["%provision_dev%"]==["%provision_dev:.mobileprovision=%"] (
		set ios_dev_mobprevision=%provision_dev%.mobileprovision
	) else (
		set ios_dev_mobprevision=%provision_dev%
	)
) else (set provision_dev=.)
	
if not ["%provision_adhoc%"]==[ (
	if ["%provision_adhoc%"]==["%provision_adhoc:.mobileprovision=%"] (
		set ios_adHoc_mobprevision=%provision_adhoc%.mobileprovision
	) else (
		set ios_adHoc_mobprevision=%provision_adhoc%
	)
) else (set provision_adhoc=.)
















cls 
echo.

rem set pc ip
	ipconfig | findstr /R /C:"IPv4 Address" > iptemp
	set /p ip_complete=<iptemp
	del iptemp
	set pcip=%ip_complete:~39%
	echo Your System ip is %pcip%

	echo.
set ios_targ_dev=ipa-ad-hoc
set ios_targ_dist=ipa-app-store
set ios_targ_dev_remote=ipa-debug -connect %pcip%
rem -useLegacyAOT yes   -useLegacyAOT no
rem ipa-ad-hoc    ipa-app-store   ipa-debug -connect 192.168.0.15
rem    ipa-ad-hoc � an iOS package for ad hoc distribution.

rem    ipa-app-store � an iOS package for Apple App store distribution.

rem    ipa-debug � an iOS package with extra debugging information. (The SWF files in the application must also be compiled with debugging support.)

rem    ipa-test � an iOS package compiled without optimization or debugging information.

rem    ipa-debug-interpreter � functionally equivalent to a debug package, but compiles more quickly. However, the ActionScript bytecode is interpreted and not translated to machine code. As a result, code execution is slower in an interpreter package.

rem    ipa-debug-interpreter-simulator � functionally equivalent to ipa-debug-interpreter, but packaged for the iOS simulator. Macintosh-only. If you use this option, you must also include the -platformsdk option, specifying the path to the iOS Simulator SDK.

rem    ipa-test-interpreter � functionally equivalent to a test package, but compiles more quickly. However, the ActionScript bytecode is interpreted and not translated to machine code. As a result, code execution is slower in an interpreter package.

rem    ipa-test-interpreter-simulator � functionally equivalent to ipa-test-interpreter, but packaged for the iOS simulator. Macintosh-only. If you use this option, you must also include the -platformsdk option, specifying the path to the iOS Simulator SDK.



set /p os_type=Select your OS: 1-Android  2-iOS  3-Widnows%=%

if %os_type% == 1 goto android_export
if %os_type% == 2 goto ios_export
if %os_type% == 3 goto window_export

:android_export
	if exist AppIconsForPublish-and copy "AppIconsForPublish-and" "AppIconsForPublish"
	set /p export_type=1-with embeded air  2-whitout air  3-remote debug%=%
	
	rem :apk-debug -connect 192.168.0.15         apk-captive-runtime
	rem :apk � an Android package. A package produced with this target can only be installed on an Android device, not an emulator.
	rem :apk?captive?runtime � an Android package that includes both the application and a captive version of the AIR runtime. A package produced with this target can only be installed on an Android device, not an emulator.
	rem :apk-debug � an Android package with extra debugging information. (The SWF files in the application must also be compiled with debugging support.)
	rem :apk-emulator � an Android package for use on an emulator without debugging support. (Use the apk-debug target to permit debugging on both emulators and devices.)
	rem :apk-profile � an Android package that supports application performance and memory profiling.


	if %export_type% == 1 goto androidexport
	if %export_type% == 2 goto androidexport_whitout_air
	if %export_type% == 3 goto androiddebug
	
	
	:androidexport
		@echo on
		rem android export V
		"%aircompiler%\bin\adt.bat" -package -target apk-captive-runtime  -storetype pkcs12 -storepass %android_pass% -keystore "%android_certificate%" "%exportname%.apk" "%android_xml_name%.xml" "%swfname%.swf" %contents% %native_folder%
		exit

	:androidexport_whitout_air
		@echo on
		rem android export V
		"%aircompiler%\bin\adt.bat" -package -target apk  -storetype pkcs12 -storepass %android_pass% -keystore "%android_certificate%" "%exportname%_no_air.apk" "%android_xml_name%.xml" "%swfname%.swf" %contents% %native_folder%
		exit
		
	:androiddebug
		@echo on
		rem android export V
		"%aircompiler%\bin\adt.bat" -package -target apk-debug -connect %pcip% -storetype pkcs12 -storepass %android_pass% -keystore "%android_certificate%" "%exportname%-remote_debug.apk" "%android_xml_name%.xml" "%swfname%.swf" %contents% %native_folder%
		exit

:ios_export
	if exist AppIconsForPublish-ios copy "AppIconsForPublish-ios" "AppIconsForPublish"
	set /p export_type=1-Dev  2-Dist  3-remote debug 4-adHoc%=%

	if %export_type% == 1 goto iosdev
	if %export_type% == 2 goto iosdist
	if %export_type% == 3 goto iosdev_debug
	if %export_type% == 4 goto iosadhoc
	
	

	:iosdev
		@echo on
		rem IOS  Dev export V
		"%aircompiler%\bin\adt.bat" -package -target %ios_targ_dev%  -keystore "%ios_dev_certificate%" -storetype pkcs12 -storepass %ios_pass%  -provisioning-profile  "%ios_dev_mobprevision%"  "%exportname%-dev.ipa" "%dev_xml_name%.xml"  "%swfname%.swf"  %contents% %ios_contents% %native_folder%
	
	:iosadhoc
		@echo on
		rem IOS  Dev export V
		"%aircompiler%\bin\adt.bat" -package -target %ios_targ_dev%  -keystore "%ios_dev_certificate%" -storetype pkcs12 -storepass %ios_pass%  -provisioning-profile  "%ios_adHoc_mobprevision%"  "%exportname%-adhoc.ipa" "%dev_xml_name%.xml"  "%swfname%.swf"  %contents% %ios_contents% %native_folder%
		

	:iosdist
		@echo on
		rem IOS Dist export V
		"%aircompiler%\bin\adt.bat" -package -target %ios_targ_dist%  -keystore "%ios_dist_certificate%" -storetype pkcs12 -storepass %ios_pass%  -provisioning-profile  "%ios_dist_mobprevision%"  "%exportname%-dist.ipa" "%dist_xml_name%.xml"  "%swfname%.swf"  %contents% %ios_contents% %native_folder%
		

	:iosdev_debug
		@echo on
		rem IOS  Dev export V
		"%aircompiler%\bin\adt.bat" -package -target %ios_targ_dev_remote%  -keystore "%ios_dev_certificate%" -storetype pkcs12 -storepass %ios_pass%  -provisioning-profile  "%ios_dev_mobprevision%"  "%exportname%-dev-remote.ipa" "%dev_xml_name%.xml"  "%swfname%.swf"  %contents% %ios_contents% %native_folder%





:window_export

	:preview
	@echo on
	rem set dAA3=1024x768:1024x768
	rem debugger V
	"%aircompiler%\bin\adl.exe" -profile mobileDevice -screensize "%global_manifest%"
	pause
	exit



