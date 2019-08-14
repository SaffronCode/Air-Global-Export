package parts
//parts.GlobalSetting
{
    import flash.display.MovieClip;
    import flash.filesystem.File;
    import contents.alert.Alert;
    import dataManager.GlobalStorage;
    import contents.TextFile;

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

        private var airCompilersList:FolderManager ;

        public function GlobalSetting()
        {
            super();

            airLocation = loadFileIfExists(id_air_location);
            certIOS = loadFileIfExists(id_cert_ios_location);
            certIOSDev = loadFileIfExists(id_cert_ios_dev_location);
            certAndroid = loadFileIfExists(id_cert_android_location);

            airCompilersList = Obj.get("compiler_list_mc",this);
            airCompilersList.setUp(isAirCompilderFolder)
        }

        private function isAirCompilderFolder(folder:File):File
        {
            var airVersion:String ;
            if(
                folder.exists 
                && 
                folder.isDirectory
            )
            {
                var airDescriptionFile:File = folder.resolvePath("air-sdk-description.xml");
                if(airDescriptionFile.exists)
                {
                    var airFileString:String = TextFile.load(airDescriptionFile);
                    var airDescriptorXMLList:XMLList = new XMLList(airFileString);
                    for(var i:int = 0 ; i<airDescriptorXMLList.length() ; i++)
                    {
                        if(XML(airDescriptorXMLList[i]).name())
                        {
                            airVersion = XML(airDescriptorXMLList[i]) ;
                            break;
                        }
                    }
                }

            }

            if(airVersion!=null)
                return folder; 
            else
                return null ;
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