﻿package parts.exporterFile
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
    import com.mteamapp.JSONParser;
    import flash.events.MouseEvent;

    public class Exporter extends MovieClip
    {
        private var projectList:ProjectsList;

        private var externalLibraries:Vector.<File> ;

        private var createExporterFilesMC:MovieClip ;

        private var batDirectory:File ;

        private var exportDirectory:File ;

        private var currentExportParams:ExportParams ;

        private var currentAirTarget:File ;

        private var currentAndroidp12:File,
                    currentiosp12:File;

        public function Exporter()
        {
            super();

            projectList = Obj.get('project_list_mc',this);
            setTimeout(function(){
                projectList.setUp(onProjectSelected);
            },0);

            batDirectory = File.applicationDirectory.resolvePath("BatFiles");

            createExporterFilesMC = Obj.get("create_exporter_files_mc",this);
            createExporterFilesMC.addEventListener(MouseEvent.CLICK,saveBatFiles);
            disableExporterButton();
        }

        private function saveBatFiles(e:MouseEvent):void
        {
            exportDirectory = null ;
            var projectFolder:File = projectList.getCurrentProjectFolder();
            Hints.pleaseWait();
            FileManager.searchFor(projectFolder,'*.swf',swfFileFounded);

            function swfFileFounded(swfFileList:Vector.<File>):void
            {
                if(swfFileList.length==0)
                {
                    Hints.show("You didn't export any SWF file yet.")
                }
                else if(swfFileList.length==1)
                {
                    Hints.hide();
                    trace("Export folder founded");
                    saveExportDirectory(swfFileList[0].parent);
                }
                else
                {
                    var directories:Array = [];
                    for(var i:int = 0 ; i<swfFileList.length ; i++)
                    {
                        var brotherFiles:Array = swfFileList[i].parent.getDirectoryListing();
                        for(var j:int = 0 ; j<brotherFiles.length ; j++)
                        {
                            var brotherFile:File = brotherFiles[j] as File ;
                            if(brotherFile.extension == 'xml')
                            {
                                var xmlFile:String = (TextFile.load(brotherFile));
                                if(xmlFile.indexOf(swfFileList[i].name)!=-1 && xmlFile.indexOf("application")!=-1)
                                {
                                    directories.push(new PopButtonData(swfFileList[i].name,3,i,true,false,false,'',swfFileList[i]));
                                    break;
                                }
                            }
                        }
                    }
                    if(directories.length==0)
                    {
                        swfFileFounded(new Vector.<File>())
                    }
                    else if(directories.length==1)
                    {
                        saveExportDirectory((directories[0].dynamicData as File).parent);
                    }
                    else
                    {
                        Hints.selector("Select the output SWF file.",'',directories,onExportDirectorySelected);
                    }
                    function onExportDirectorySelected(e:PopButtonData):void
                    {
                        var selectedSWF:File = e.dynamicData as File ;
                        if(selectedSWF!=null)
                        {
                            saveExportDirectory(selectedSWF.parent);
                        }
                    }
                }
            }

            function saveExportDirectory(exportLocation:File):void
            {
                if(!exportLocation.isDirectory)
                {
                    throw "You should select a directory!";
                }
                exportDirectory = exportLocation ;
                copyAllBathFilesToExportDirectory();
                Hints.hide();

                updateExportParams();
            }
        }

            private function copyAllBathFilesToExportDirectory():void
            {
                FileManager.copyFolder(batDirectory,exportDirectory,false,null,true);
            }

            private function updateExportParams():void
            {
                currentExportParams = new ExportParams();
                currentExportParams.setAirpath(currentAirTarget) ;
                findAndroidp12();

                function findAndroidp12():void
                {
                    FileManager.searchFor(projectList.getCurrentProjectFolder(),'*.p12',p12founded);
                    function p12founded(p12List:Vector.<File>):void
                    {
                        var ap12List:Array = [] ;
                        if(currentAndroidp12!=null)
                        {
                            ap12List.push(new PopButtonData("Default p12",1,null,true,false,true,'',currentAndroidp12));
                        }
                        for(var i:int = 0 ; i<p12List.length;i++)
                        {
                            ap12List.push(new PopButtonData(p12List[i].name,1,null,true,false,true,'',p12List[i]));
                        }
                        if(ap12List.length>1)
                        {
                            Hints.selector("Select Android certificate.p12",'',ap12List,onAndroidp12Selected);
                        }
                        else if(ap12List.length == 1)
                        {
                            currentExportParams.setAndroidP12((ap12List[0] as PopButtonData).dynamicData as File);
                            findiOSp12();
                        }
                        else
                        {
                            findiOSp12();
                        }

                        function onAndroidp12Selected(e:PopMenuEvent):void
                        {
                            var selectedFile:File = e.buttonData as File ;
                            if(selectedFile!=null)
                            {
                                currentExportParams.setAndroidP12(selectedFile);
                            }
                            findiOSp12();
                        }
                    }
                }

                


                function findiOSp12():void
                {
                    FileManager.searchFor(projectList.getCurrentProjectFolder(),'*.p12',p12founded);
                    function p12founded(p12List:Vector.<File>):void
                    {
                        var ap12List:Array = [] ;
                        if(currentiosp12!=null)
                        {
                            ap12List.push(new PopButtonData("Default p12",1,null,true,false,true,'',currentiosp12));
                        }
                        for(var i:int = 0 ; i<p12List.length;i++)
                        {
                            ap12List.push(new PopButtonData(p12List[i].name,1,null,true,false,true,'',p12List[i]));
                        }
                        if(ap12List.length>1)
                        {
                            Hints.selector("Select iOS certificate.p12",'',ap12List,onAndroidp12Selected);
                        }
                        else if(ap12List.length==1)
                        {
                            currentExportParams.setiOSP12((ap12List[0] as PopButtonData).dynamicData as File);
                            buildExportparamsFile();
                        }
                        else
                        {
                            buildExportparamsFile();
                        }

                        function onAndroidp12Selected(e:PopMenuEvent):void
                        {
                            var selectedFile:File = e.buttonData as File ;
                            if(selectedFile!=null)
                            {
                                currentExportParams.setiOSP12(selectedFile);
                            }
                            buildExportparamsFile();
                        }
                    }
                }

                function buildExportparamsFile():void
                {
                    //Update, create load params TODO
                    var paramFile:File = exportDirectory.resolvePath('exportparams');
                    TextFile.save(paramFile,currentExportParams.toString());
                }
            }

        private function disableExporterButton():void
        {
            createExporterFilesMC.alpha = 0.5;
            createExporterFilesMC.mouseChildren = false ;
            createExporterFilesMC.mouseEnabled = false ;
        }

        private function enableExporterButton():void
        {
            createExporterFilesMC.alpha = 1;
            createExporterFilesMC.mouseEnabled = true ;
            createExporterFilesMC.buttonMode = true ;
        }

        public function setAndroidp12(androidp12:File):void
        {
            currentAndroidp12 = androidp12 ;
        }

        public function setiOSp12(iosp12:File):void
        {
            currentiosp12 = iosp12 ;
        }

        public function setAirSDK(airTarget:File):void
        {
            if(airTarget!=null)
                currentAirTarget = new File(airTarget.nativePath) ;
            else
                currentAirTarget = null ;
        }

        public function setLibraries(libraries:Vector.<File>):void
        {
            externalLibraries = libraries ;
        }

        private function onProjectSelected():void
        {
            var projectFolder:File = projectList.getCurrentProjectFolder();
            if(projectFolder!=null && projectFolder.exists)
            {
                var jsonConfig:File = projectFolder.resolvePath("asconfig.json");
                if(!jsonConfig.exists)
                {
                    Hints.ask("","There is no jsonConfig file in your directory. Do you want to create it?",createConfigJSONFile,null,removeThisProjectFolder)
                }
                else
                {
                    createConfigJSONFile();
                }
                enableExporterButton();
            }
            else
            {
                disableExporterButton();
            }
        }

            private function createConfigJSONFile():void
            {
                var projectFolder:File = projectList.getCurrentProjectFolder();
                var mainFlaFile:File = null ;
                var jsonConfig:File = projectFolder.resolvePath("asconfig.json");

                var jsonModel:AsConfig = new AsConfig();
                if(jsonConfig.exists)
                {
                    Hints.pleaseWait();
                    var loadedJSONString:String = TextFile.load(jsonConfig);
                    loadedJSONString = loadedJSONString.replace("source-path","source_path").replace("external-library-path","external_library_path").replace(/,([\n\r\t\s\^]*\])/gi,"$1");
                    trace("loadedJSON : "+loadedJSONString);
                    try
                    {
                        JSONParser.parse(loadedJSONString,jsonModel);
                        continueToCompleteJSON();
                    }
                    catch(e:Error)
                    {
                        Hints.show("asconfig.json pars error!")
                    }
                }
                else
                {
                    Hints.pleaseWait();
                    FileManager.searchFor(projectFolder,'*.fla',onSearchDone);
                }


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
                    else if(fileList.length==1)
                    {
                        setFla(fileList[0])
                    }
                    else if(FileManager.searchPattern.indexOf('xfl')==-1)
                    {
                        FileManager.searchFor(projectFolder,'*.xfl',onSearchDone);
                    }
                    else
                    {
                        Hints.show("No Fla file detected on your project directory.")
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
                        if(mainFlaFile.extension.toLowerCase().indexOf('xfl')==-1)
                        {
                            mainASFile = mainFlaFile.parent.resolvePath("Main.as") ;
                        }
                        else
                        {
                            mainASFile = mainFlaFile.parent.parent.resolvePath("Main.as") ;
                        }
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
                    
                    jsonModel.type = "app";
                    jsonModel.config = "airmobile";
                    
                    
                    continueToCompleteJSON();
                }

                function continueToCompleteJSON():void
                {

                    var externalLibraryIndex:int = -1 ;

                    //Detect Library types
                    nextItemSearch();

                    function nextItemSearch():void
                    {
                        externalLibraryIndex++;
                        trace("externalLibraryIndex++= "+externalLibraryIndex);
                        if(externalLibraries!=null && externalLibraries.length>externalLibraryIndex)
                        {
                            trace("externalLibraries.length : "+externalLibraries.length+" vs externalLibraryIndex : "+externalLibraryIndex);
                            checkLibraryForAS();
                        }
                        else
                        {
                            FileManager.cancelSearch();
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
                        var externalLibPath:String = externalLibraries[externalLibraryIndex].nativePath ;
                        if(jsonModel.compilerOptions.source_path.indexOf(externalLibPath)==-1)
                            jsonModel.compilerOptions.source_path.push(externalLibPath);
                        FileManager.cancelSearch();
                        checkForSWC();
                    }

                    function noAsItemFounded(files:Vector.<File>):void
                    {
                        if(files.length==0)
                            checkForSWC();
                    }

                    function checkForSWC():void
                    {
                        FileManager.searchFor(externalLibraries[externalLibraryIndex],'*.swc',noSWCItemFounded,swcItemFounded);
                    }

                    function swcItemFounded(files:Vector.<File>):void
                    {
                        trace("swcItemFounded externalLibraryIndex : "+externalLibraryIndex);
                        var externalLibPath:String = externalLibraries[externalLibraryIndex].nativePath ;
                        if(jsonModel.compilerOptions.external_library_path.indexOf(externalLibPath)==-1)
                            jsonModel.compilerOptions.external_library_path.push(externalLibPath);
                            trace("So cancel the search");
                        FileManager.cancelSearch();
                        nextItemSearch();
                    }

                    function noSWCItemFounded(files:Vector.<File>):void
                    {
                        if(files.length==0)
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
                    jsonString = jsonString.replace("source_path","source-path").replace("external_library_path","external-library-path");
                    TextFile.save(jsonConfig,jsonString);
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}