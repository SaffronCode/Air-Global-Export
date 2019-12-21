package parts.exporterFile
{
    import flash.net.NetworkInfo;
    import flash.net.NetworkInterface;
    import flash.net.InterfaceAddress;
    import contents.alert.Alert;
    import flash.filesystem.File;

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
        private var _airpath:File;
        public var android_cert_pass:String="NewPass123$";
        private var _android_certificate:File;
        private var _ios_certificate:File;
        public var exportname:String="RefahBank";
        public var android_xml_name:String="RefahBank-app-dist";
        public var swfname:String="RefahBank";
        public var contents:String="Data AppIconsForPublish";
        public var native_folder:String="native";
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
            if(target!=null)
                _android_certificate = new File(target.nativePath);
            else
                _android_certificate = null ;
        }
        
        public function setiOSP12(target:File):void
        {
            if(target!=null)
                _ios_certificate = new File(target.nativePath);
            else
                _ios_certificate = null ;
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