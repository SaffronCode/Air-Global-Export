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

        private var externalLibraries:Vector.<File> ;

        public function Exporter()
        {
            super();

            projectList = Obj.get('project_list_mc',this);
            setTimeout(function(){
                projectList.setUp(onProjectSelected);
            },0);
        }

        public function setLibraries(libraries:Vector.<File>):void
        {
            externalLibraries = libraries ;
        }

        private function onProjectSelected():void
        {
            var projectFolder:File = projectList.getCurrentProjectFolder();
            var jsonConfig:File = projectFolder.resolvePath("asconfig.json");
            if(!jsonConfig.exists)
            {
                Hints.ask("","There is no jsonConfig file in your directory. Do you want to create it?",createConfigJSONFile,null,removeThisProjectFolder)
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
                    FileManager.searchFor(projectFolder,'*.as',asFilesFoundedFinal,asFilesFounded)
                }

                function asFilesFounded(asFiles:Vector.<File>):void
                {
                    if(asFiles.length==0)
                    {
                        createMainASFile();
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

                    function asFileSelected(e:PopMenuEvent):void
                    {
                        setTheMainASFile(e.buttonData as File);
                    }
                }

                function createMainASFile():void
                {
                    Hints.show("Main.as file created on your source project.");
                    var sampleMain:String = 'package \n{\n    import flash.display.MovieClip;\n\n    public class Main extends MovieClip\n    {\n        public function Main()\n        {\n            super();\n        }\n    }\n}'
                    var mainASFile:File ;
                    if(mainFlaFile!=null)
                    {
                        mainASFile = mainFlaFile.parent.resolvePath("Main.as") ;
                    }
                    else
                    {
                        mainASFile = projectFolder.resolvePath("Main.as");
                    }
                    TextFile.save(mainASFile,sampleMain);
                    setTheMainASFile(mainASFile);
                }

                function asFilesFoundedFinal(asFiles:Vector.<File>):void
                {
                    if(asFiles.length==1)
                    {
                        Hints.hide();
                        setTheMainASFile(asFiles[0]);
                    }
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

                    var externalLibraryIndex:int = -1 ;

                    //Detect Library types
                    nextItemSearch();

                    function nextItemSearch():void
                    {
                        externalLibraryIndex++;
                        if(externalLibraries!=null && externalLibraries.length>externalLibraryIndex)
                        {
                            checkLibraryForAS();
                        }
                        else
                        {
                            exprotJSON();
                        }
                    }

                    function checkLibraryForAS():void
                    {
                        Hints.pleaseWait(cancelSearchToDetectLibraries);
                        FileManager.searchFor(externalLibraries[externalLibraryIndex],'*.as',noAsItemFounded,asItemFounded);
                    }

                    function asItemFounded(files:Vector.<File>):void
                    {
                        jsonModel.compilerOptions.source_path.push(externalLibraries[externalLibraryIndex].nativePath);
                        FileManager.cancelSearch();
                        checkForSWC();
                    }

                    function noAsItemFounded(files:Vector.<File>):void
                    {
                        checkForSWC();
                    }

                    function checkForSWC():void
                    {
                        FileManager.searchFor(externalLibraries[externalLibraryIndex],'*.swc',noSWCItemFounded,swcItemFounded);
                    }

                    function swcItemFounded(files:Vector.<File>):void
                    {
                        trace(externalLibraries.length+" vs "+externalLibraryIndex);
                        jsonModel.compilerOptions.external_library_path.push(externalLibraries[externalLibraryIndex].nativePath);
                        FileManager.cancelSearch();
                        nextItemSearch();
                    }

                    function noSWCItemFounded(files:Vector.<File>):void
                    {
                        nextItemSearch();
                    }

                    function cancelSearchToDetectLibraries():void
                    {
                        FileManager.cancelSearch();
                    }
                }

                ////////////////////////////

                function exprotJSON():void
                {
                    Hints.hide();
                    var jsonString:String = JSON.stringify(jsonModel,null,'\t');
                    jsonString.replace("source_path","source-path").replace("external_library_path","external-library-path");
                    TextFile.save(jsonConfig,jsonString);
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}