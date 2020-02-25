call core.bat
TITLE %~n0

"%airpath%\bin\adt.bat" -package -target ipa-app-store -keystore "%ios_certificate%" -storetype pkcs12 -storepass "%ios_cert_pass%"  -provisioning-profile  "%ios_dist_provision%"  "%exportname%-dist%timestamp%.ipa" "%ios_xml_name%.xml"  "%swfname%.swf" %contents% %ios_contents% %native_folder% > %logdir%/"%~n0".log