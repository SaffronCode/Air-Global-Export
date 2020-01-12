call core.bat
TITLE %~n0

"%airpath%\bin\adt.bat" -package -target apk-captive-runtime  -storetype pkcs12 -storepass "%android_cert_pass%" -keystore "%android_certificate%" "%exportname%%timestamp%.apk" "%android_xml_name%.xml" "%swfname%.swf" %contents% %native_folder% > %logdir%/"%~n0"-log.log