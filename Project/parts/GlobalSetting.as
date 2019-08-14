package parts
//parts.GlobalSetting
{
    import flash.display.MovieClip;
    import flash.filesystem.File;
    import contents.alert.Alert;
    import dataManager.GlobalStorage;

    public class GlobalSetting extends MovieClip
    {
        private const   id_air_location:String = "id_air_location" ,
                        id_cert_ios_location:String = "id_cert_ios_location",
                        id_cert_ios_dev_location:String = "id_cert_ios_dev_location",
                        id_cert_android_location:String = "id_cert_android_location";

        private var airLocation:File,
                    certIOS:File,
                    certIOSDev:File,
                    certAndroid :File ;

        private var airButton:MovieClip ;

        public function GlobalSetting()
        {
            super();

            airLocation = loadFileIfExists(id_air_location);
            certIOS = loadFileIfExists(id_cert_ios_location);
            certIOSDev = loadFileIfExists(id_cert_ios_dev_location);
            certAndroid = loadFileIfExists(id_cert_android_location);

            airButton = Obj.get("air_mc",this);
            //airButton.buttonMode = true ;
        }

        private function loadFileIfExists(id:String):File
        {
            var targ:String = GlobalStorage.load(id);
            if(targ!=null)
            {
                var fil:File = new File(targ);
                if(fil.exists)
                {
                    return fil ;
                }
            }
            return null ;
        }

        public function needToSetUp():Boolean
        {
            return airLocation==null ;
        }
    }
}