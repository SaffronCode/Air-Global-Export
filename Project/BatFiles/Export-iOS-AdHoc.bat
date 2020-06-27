call core.bat
TITLE %~n0

"%airpath%\bin\adt.bat" -package -target ipa-ad-hoc -keystore "%ios_dev_certificate%" -storetype pkcs12 -storepass "%ios_cert_pass%"  -provisioning-profile  "%ios_adhoc_provision%"  "%exportname%-adHoc%timestamp%.ipa" "%ios_xml_name%.xml"  "%swfname%.swf" %contents% %ios_contents% %native_folder% > %logdir%/"%~n0".log