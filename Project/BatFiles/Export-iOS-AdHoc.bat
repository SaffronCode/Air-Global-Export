call core.bat
TITLE %~n0

"%airpath%\bin\adt.bat" -package -target ipa-ad-hoc -storetype pkcs12 -storepass %ios_cert_pass% -keystore "%android_certificate%" "%exportname%-remote-debug.apk" "%android_xml_name%.xml" "%swfname%.swf" %contents% %native_folder% > %logdir%/"%~n0"-log.log