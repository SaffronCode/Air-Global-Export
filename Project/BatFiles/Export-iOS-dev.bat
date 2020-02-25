call core.bat
TITLE %~n0

"%airpath%\bin\adt.bat" -package -target ipa-test-interpreter -keystore "%ios_dev_certificate%" -storetype pkcs12 -storepass "%ios_cert_pass%"  -provisioning-profile  "%ios_dev_provision%"  "%exportname%-dev%timestamp%.ipa" "%ios_dev_xml_name%.xml"  "%swfname%.swf" %contents% %ios_contents% %native_folder% > %logdir%/"%~n0".log