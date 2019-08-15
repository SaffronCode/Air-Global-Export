package parts.exporterFile
//parts.exporterFile.Exporter
{
    import flash.display.MovieClip;
    import flash.filesystem.File;
    import popForm.Hints;
    import flash.utils.setTimeout;
    import parts.jsonConfig.AsConfig;
    import contents.alert.Alert;

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
                    if(fileList.length>1)
                    {
                        Hints.selector('','Select your Fla file from the list',)
                    }
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}