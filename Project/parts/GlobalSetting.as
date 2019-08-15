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

        public function GlobalSetting()
        {
            super();

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
            return airCompilersList.getSelectedFile()==null ;
        }
    }
}