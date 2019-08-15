package parts.exporterFile
//parts.exporterFile.Exporter
{
    import flash.display.MovieClip;
    import flash.filesystem.File;
    import popForm.Hints;
    import flash.utils.setTimeout;
    import parts.jsonConfig.AsConfig;
    import contents.alert.Alert;
    import popForm.PopButtonData;
    import popForm.PopMenuEvent;

    public class Exporter extends MovieClip
    {
        private var projectList:ProjectsList;

        public function Exporter()
        {
            super();

            projectList = Obj.get('project_list_mc',this);
            setTimeout(function(){
                projectList.setUp(onProjectSelected);
            },0);
        }

        private function onProjectSelected():void
        {
            var projectFolder:File = projectList.getCurrentProjectFolder();
            var jsonConfig:File = projectFolder.resolvePath("asconfig.json");
            if(!jsonConfig.exists)
            {
                Hints.ask("","There is no jsonConfig file in your directory. Do you whant to create it?",createConfigJSONFile,null,removeThisProjectFolder)
            }
        }

            private function createConfigJSONFile():void
            {
                var projectFolder:File = projectList.getCurrentProjectFolder();
                var jsonConfig:File = projectFolder.resolvePath("asconfig.json");

                var jsonModel:AsConfig = new AsConfig();
                Hints.pleaseWait();

                FileManager.searchFor(projectFolder,'*.fla',onSearchDone);

                function onSearchDone(fileList:Vector.<File>):void
                {
                    Hints.hide();
                    if(fileList.length>0)
                    {
                        var relatedFileList:Array = [] ;
                        for(var i:int = 0 ; i<fileList.length ; i++)
                        {
                            relatedFileList.push(new PopButtonData(FileManager.getRelatedTarget(projectFolder,fileList[i]),1,i));
                        }
                        Hints.selector('','Select your Fla file from the list',relatedFileList,onFileSelected);
                    }
                }

                function onFileSelected(e:PopMenuEvent):void
                {
                    Alert.show("fla : "+e.buttonTitle);
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}