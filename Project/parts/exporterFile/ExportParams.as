package parts.exporterFile
{
    import flash.net.NetworkInfo;
    import flash.net.NetworkInterface;
    import flash.net.InterfaceAddress;
    import flash.filesystem.File;
    import contents.TextFile;

    public class ExportParams
    {

        public function get airpath():String
        {
            if(_airpath==null)
                return '' ;
            else
                return _airpath.nativePath ;
        }
        public function get android_certificate():String
        {
            if(_android_certificate==null)
                return '' ;
            else
                return _android_certificate.nativePath ;
        }
        public function get ios_certificate():String
        {
            if(_ios_certificate==null)
                return '' ;
            else
                return _ios_certificate.nativePath ;
        }
        public function get ios_dev_certificate():String
        {
            if(_ios_dev_certificate==null)
                return '' ;
            else
                return _ios_dev_certificate.nativePath ;
        }
        public function get android_xml_name():String
        {
            if(_android_xml_name==null)
                return '' ;
            return fileName(_android_xml_name.name) ;
        }
        public function get ios_xml_name():String
        {
            if(_ios_xml_name==null)
                return '' ;
            else
                return fileName(_ios_xml_name.name) ;
        }
        public function get ios_dev_xml_name():String
        {
            if(_ios_dev_xml_name==null)
                return '' ;
            else
                return fileName(_ios_dev_xml_name.name) ;
        }
        public function get exportname():String
        {
            if(_exportname!=null)
            {
                return _exportname ;
            }
            return swfname ;
        }
        private var _airpath:File;
        private var _android_certificate:File;
        public var android_cert_pass:String="";
        private var _ios_certificate:File;
        public var ios_cert_pass:String="";
        private var _ios_dev_certificate:File;
        public var ios_cert_dev_pass:String="";
        private var _android_xml_name:File=null;//"RefahBank-app-dist";
        private var _ios_xml_name:File=null;//"RefahBank-app-dist";
        private var _ios_dev_xml_name:File=null;//"RefahBank-app-dist";
        public var swfname:String='';//"RefahBank";
        private var _exportname:String=null;//"RefahBank";
        public var native_folder:String='';//"native";
        public var ip_adress:String ;

        public var ios_dist_provision:String = '' ;
        public var ios_dev_provision:String = '';

        
        public var contents:String='';//"Data AppIconsForPublish";
        public function ExportParams()
        {
            var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
            var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();
            var interfaceObj:NetworkInterface;
            var address:InterfaceAddress;

            //Get available interfaces
            for (var i:int = 0; i < interfaces.length; i++)
            {
                interfaceObj = interfaces[i];

                for (var j:int = 0; j < interfaceObj.addresses.length; j++)
                {
                    address = interfaceObj.addresses[j];
                    if(address.prefixLength==24)
                    {
                        ip_adress =  address.address ;
                        break;
                    }
                }
            }
        }

        public function load(file:File):void
        {
            if(!file.exists)
                return ;
            var loadedParams:String = TextFile.load(file);
            if(loadedParams=='')
                return;

            /** airpath=D:\air\AIR33
                android_cert_pass=
                android_certificate=D:\Sepehr\ZekrShomarForPublish\Project\src\DigitalPT.p12
                android_xml_name=ZekrExport-app
                contents=AppIconsForPublish Data 
                exportname=Fazkorooni
                ios_cert_dev_pass=
                ios_cert_pass=
                ios_certificate=D:\Sepehr\ZekrShomarForPublish\Project\src\dist_ios.p12
                ios_dev_certificate=D:\Sepehr\ZekrShomarForPublish\Project\src\dev_ios.p12
                ios_dev_provision=D:\Sepehr\ZekrShomarForPublish\Project\src\Fazkorooni.mobileprovision
                ios_dev_xml_name=ZekrExport-app
                ios_dist_provision=D:\Sepehr\ZekrShomarForPublish\Project\src\FazkorooniDist.mobileprovision
                ios_xml_name=ZekrExport-app-dist
                ip_adress=192.168.1.100
                native_folder=-extdir .\native
                swfname=Zekr */
                var foundedItems:Array = loadedParams.match(/android_cert_pass\=[^\n]+/);
                if(foundedItems!=null)
                    android_cert_pass = String(foundedItems[0]).split('android_cert_pass=').join('');
                foundedItems = loadedParams.match(/ios_cert_dev_pass\=[^\n]+/);
                if(foundedItems!=null)
                    ios_cert_dev_pass = String(foundedItems[0]).split('ios_cert_dev_pass=').join('');
                foundedItems = loadedParams.match(/ios_cert_pass\=[^\n]+/);
                if(foundedItems!=null)
                    ios_cert_pass = String(foundedItems[0]).split('ios_cert_pass=').join('');
                
        }


        public function setAndroid_xml_name(target:File):void
        {
            if(target==null)
                _android_xml_name = null;
            else
            {
                _exportname = loadFileNamefromXML(target);
               _android_xml_name = new File(target.nativePath) ;
            }
        }
        public function setIos_xml_name(target:File):void
        {
            if(target==null)
                _ios_xml_name = null ;
            else
             {
                _exportname = loadFileNamefromXML(target);
                _ios_xml_name = new File(target.nativePath);
             }
        }
        public function setios_dev_xml_name(target:File):void
        {
            if(target==null)
                _ios_dev_xml_name = null ;
            else
            {
                _exportname = loadFileNamefromXML(target);
                _ios_dev_xml_name = new File(target.nativePath);
            }
        }

        
        public function setAirpath(target:File):void
        {
            if(target!=null)
                _airpath = new File(target.nativePath);
            else
                _airpath = null ;
        }
        
        public function setAndroidP12(target:File):void
        {
            if(target!=null)
            {
                _android_certificate = new File(target.nativePath);
                var passFile:File = _android_certificate.parent.resolvePath(fileName(_android_certificate.name)+".pass");
                if(passFile.exists)
                    android_cert_pass = TextFile.load(passFile);
            }
            else
                _android_certificate = null ;
        }

        private function fileName(nameAndExt:String):String
        {
            return nameAndExt.substring(0,nameAndExt.lastIndexOf('.'));
        }
        
        /**
         * Development
         * @param target 
         */
        public function setiOSP12(target:File):void
        {
            ios_cert_pass = '';
            if(target!=null)
            {
                _ios_certificate = new File(target.nativePath);
                var passFile:File = _ios_certificate.parent.resolvePath(fileName(_ios_certificate.name)+".pass")
                if(passFile.exists)
                    ios_cert_pass = TextFile.load(passFile);
            }
            else
                _ios_certificate = null ;
        }

        private function loadFileNamefromXML(XMLFile:File):String
        {
            var theName:String = null ;
            var loadedXMLFile:String = TextFile.load(XMLFile);
            var foundedFileNames:Array = loadedXMLFile.match(/<filename>.*<\/filename>/i);
            if(foundedFileNames!=null && foundedFileNames.length>0)
            {
                theName = String(foundedFileNames[0]).replace(/<[^>]+>/g,'');
                if(theName=='')
                {
                    theName = null ;
                }
            }
            return theName ;
        }
        
        public function setiOSDevP12(target:File):void
        {
            ios_cert_dev_pass = '';
            if(target!=null)
            {
                _ios_dev_certificate = new File(target.nativePath);
                var passFile:File = _ios_dev_certificate.parent.resolvePath(fileName(_ios_dev_certificate.name)+".pass")
                if(passFile.exists)
                    ios_cert_dev_pass = TextFile.load(passFile);
            }
            else
                _ios_dev_certificate = null ;
        }
        
        public function toString():String
        {
            var obj:Object = JSON.parse(JSON.stringify(this));
            var outPut:Array = [] ;
            for(var value:String in obj)
            {
                outPut.push(value+"="+obj[value]);
            }
            outPut.sort();
            return outPut.join('\n') ;
        }
    }
}