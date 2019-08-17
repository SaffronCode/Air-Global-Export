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
    import contents.TextFile;

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
                var mainFlaFile:File = null ;
                var jsonConfig:File = projectFolder.resolvePath("asconfig.json");

                var jsonModel:AsConfig = new AsConfig();
                Hints.pleaseWait();

                FileManager.searchFor(projectFolder,'*.fla',onSearchDone);

                function onSearchDone(fileList:Vector.<File>):void
                {
                    Hints.hide();
                    if(fileList.length>1)
                    {
                        var relatedFileList:Array = [] ;
                        for(var i:int = 0 ; i<fileList.length ; i++)
                        {
                            relatedFileList.push(new PopButtonData(FileManager.getRelatedTarget(projectFolder,fileList[i]),2,i,true,false,true,'',fileList[i]));
                        }
                        Hints.selector('','Select your Fla file from the list',relatedFileList,onFileSelected);
                    }
                    else
                    {
                        setFla(fileList[0])
                    }
                }

                function onFileSelected(e:PopMenuEvent):void
                {
                    setFla(e.buttonData as File);
                }

                function setFla(flaFile:File=null):void
                {
                    mainFlaFile = flaFile ;
                    if(flaFile!=null)
                        jsonModel.animateOptions.file = FileManager.getRelatedTarget(projectFolder,flaFile);
                    searchForMainClass();
                }



            ////////////////////////////////////////////////////

                function searchForMainClass():void
                {
                    Hints.pleaseWait();
                    FileManager.searchFor(projectFolder,'*.as',asFilesFounded,asFilesFounded)
                }

                function asFilesFounded(asFiles:Vector.<File>):void
                {
                    if(asFiles.length==0)
                    {
                        Hints.show("Main.as file created on your source project.");
                        var sampleMain:String = 'package \n{\n    import flash.display.MovieClip;\n\n    public class Main extends MovieClip\n    {\n        public function Main()\n        {\n            super();\n        }\n    }\n}'
                        if(mainFlaFile!=null)
                        {
                            TextFile.save(mainFlaFile.parent.resolvePath("Main.as"),sampleMain);
                        }
                        else
                        {
                            TextFile.save(projectFolder.resolvePath("Main.as"),sampleMain);
                        }
                    }
                    else
                    {
                        var asFileList:Array = [] ;
                        for(var i:int = 0 ; i<FileManager.foundedQue.length ; i++)
                        {
                            asFileList.push(new PopButtonData(FileManager.getRelatedTarget(projectFolder,FileManager.foundedQue[i]),2,null,true,false,true,'',FileManager.foundedQue[i]));
                        }
                        Hints.selector("","Select the main AS file of your project",asFileList,asFileSelected);
                    }
                }

                function asFileSelected(e:PopMenuEvent):void
                {
                    setTheMainASFile(e.buttonData as File);
                }

                function setTheMainASFile(asFile:File):void
                {
                    if(asFile!=null)
                        jsonModel.files.push(FileManager.getRelatedTarget(projectFolder,asFile));
                    continueToCompleteJSON();
                }

                function continueToCompleteJSON():void
                {
                    jsonModel.type = "app";
                    jsonModel.config = "airmobile";

                    //TODO
                    throw "Save external libraries and as libraries"
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}