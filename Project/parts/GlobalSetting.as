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
        private var airCompilersList:FolderManager ;

        private var externalLibrariesList:FolderManager ;
        private var androidP12:FolderManager ;
        private var iOSP12:FolderManager ;

        public function GlobalSetting()
        {
            super();

            airCompilersList = Obj.get("compiler_list_mc",this);
            airCompilersList.setUp(isAirCompilderFolder,"Select Air SDK directory");
            
            androidP12 = Obj.get("andridp12_mc",this);
            androidP12.setUp(isp12,'Select Android certificate.p12',false,"*.p12");
            
            iOSP12 = Obj.get("iosp12_mc",this);
            iOSP12.setUp(isp12,'Select iOS certificate.p12',false,"*.p12");

            externalLibrariesList = Obj.get("external_libraries_mc",this);
            externalLibrariesList.setUp(libraryFolderControll,"Select external libraries",true);
        }

        public function getAndroidp12():File
        {
            return androidP12.getSelectedFile();
        }

        public function getiOSp12():File
        {
            return iOSP12.getSelectedFile();
        }

        private function isp12(aFile:File):File
        {
            return aFile!=null && aFile.exists && aFile.extension.toLowerCase()=='p12'?aFile:null ;
        }


        public function getLibraries():Vector.<File>
        {
            return externalLibrariesList.getAllFiles();
        }

        public function getSelectedAdobeAir():File
        {
            return airCompilersList.getSelectedFile();
        }

        private function libraryFolderControll(aFolder:File):File
        {
            return aFolder!=null && aFolder.exists && aFolder.isDirectory?aFolder:null ;
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
            return airCompilersList.getSelectedFile()==null ;
        }
    }
}