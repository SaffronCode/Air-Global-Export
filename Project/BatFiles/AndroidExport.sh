#!/bin/sh
source exportparams
"${airpath}/bin/adt" -package -target apk-captive-runtime  -storetype pkcs12 -storepass "${android_cert_pass}" -keystore "${android_certificate}" "${exportname}$(date +%s).apk" "${android_xml_name}.xml" "${swfname}.swf" $contents $native_folder