package parts.exporterFile
{
    import flash.net.NetworkInfo;
    import flash.net.NetworkInterface;
    import flash.net.InterfaceAddress;
    import contents.alert.Alert;
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
        private var _airpath:File;
        private var _android_certificate:File;
        public var android_cert_pass:String="$";
        private var _ios_certificate:File;
        public var ios_cert_pass:String="";
        private var _ios_dev_certificate:File;
        public var ios_cert_dev_pass:String="";
        
        public var exportname:String='';//"RefahBank";
        public var android_xml_name:String='';//"RefahBank-app-dist";
        public var swfname:String='';//"RefahBank";
        public var contents:String='';//"Data AppIconsForPublish";
        public var native_folder:String='';//"native";
        public var ip_adress:String ;
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

        
        public function setAirpath(target:File):void
        {
            if(target!=null)
                _airpath = new File(target.nativePath);
            else
                _airpath = null ;
        }
        
        public function setAndroidP12(target:File):void
        {
            android_cert_pass = '';
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