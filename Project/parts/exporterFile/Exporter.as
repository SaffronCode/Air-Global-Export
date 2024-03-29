﻿package parts.exporterFile
//parts.exporterFile.Exporter
{
    import flash.display.MovieClip;
    import flash.filesystem.File;
    import popForm.Hints;
    import flash.utils.setTimeout;
    import parts.jsonConfig.AsConfig;
    import popForm.PopButtonData;
    import popForm.PopMenuEvent;
    import contents.TextFile;
    import com.mteamapp.JSONParser;
    import flash.events.MouseEvent;
    import parts.LaunchJSON.LaunchFileCreator;
    import popForm.PopMenuContent;
    import popForm.PopField;
    import popForm.PopFieldDate;
    import popForm.PopMenuFields;

    public class Exporter extends MovieClip
    {
        private var projectList:ProjectsList;

        private var externalLibraries:Vector.<File> ;

        private var createExporterFilesMC:MovieClip ;

        private var batDirectory:File ;

        private var exportDirectory:File ;

        private var mainSWF:File ;

        private var currentExportParams:ExportParams ;

        private var currentAirTarget:File ;

        private var currentAndroidp12:File,
                    currentiosp12:File;

        private var createLaunchFileForDebugger:MovieClip ;

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

            createLaunchFileForDebugger = Obj.get("debugger_mc",this);
            createLaunchFileForDebugger.buttonMode = true ;
            createLaunchFileForDebugger.addEventListener(MouseEvent.CLICK,saveLaunchFile);
        }

        private function saveLaunchFile(e:MouseEvent):void
        {
            LaunchFileCreator.createLaunchJSON(projectList.getCurrentProjectFolder());
        }

        private function saveBatFiles(e:MouseEvent):void
        {
            exportDirectory = null ;
            var projectFolder:File = projectList.getCurrentProjectFolder();
            Hints.pleaseWait();
            trace("**** projectFolder : "+projectFolder.nativePath)
            FileManager.searchFor(projectFolder,'*.swf',swfFileFounded);

            function swfFileFounded(swfFileList:Vector.<File>):void
            {
                if(swfFileList.length==0)
                {
                    Hints.show("You didn't export any SWF file yet.")
                }
                else/* if(swfFileList.length==1)
                {
                    Hints.hide();
                    trace("Export folder founded");
                    saveExportSWFonBinDirectory(swfFileList[0]);
                }
                else*/
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
                        Hints.show("Your XML file is not refers to correct SWF file");
                    }
                    else if(directories.length==1)
                    {
                        saveExportSWFonBinDirectory((directories[0].dynamicData as File));
                    }
                    else
                    {
                        Hints.selector("Select the output SWF file.",'',directories,onExportDirectorySelected);
                    }
                    function onExportDirectorySelected(e:PopMenuEvent):void
                    {
                        var selectedSWF:File = e.buttonData as File ;
                        if(selectedSWF!=null)
                        {
                            saveExportSWFonBinDirectory(selectedSWF);
                        }
                    }
                }
            }

            function saveExportSWFonBinDirectory(swfFileLocation:File):void
            {
                exportDirectory = swfFileLocation.parent ;
                mainSWF = new File(swfFileLocation.nativePath);
                copyAllBathFilesToExportDirectory();
                Hints.hide();

                updateExportParams();
            }
        }

            private function copyAllBathFilesToExportDirectory():void
            {
                FileManager.copyFolder(batDirectory,exportDirectory,false,DevicePrefrence.isMac()?['bat']:['sh'],true);
            }

            private function updateExportParams():void
            {
                currentExportParams = new ExportParams();
                currentExportParams.load(exportDirectory.resolvePath('exportparams'));
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
                            ap12List.push(new PopButtonData("Default p12",2,null,true,false,true,'',currentAndroidp12));
                        }
                        for(var i:int = 0 ; i<p12List.length;i++)
                        {
                            ap12List.push(new PopButtonData(p12List[i].name,2,null,true,false,true,'',p12List[i]));
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

                        function findiOSp12():void
                        {
                            ap12List = [] ;
                            if(currentiosp12!=null)
                            {
                                ap12List.push(new PopButtonData("Default p12",2,null,true,false,true,'',currentiosp12));
                            }
                            for(var i:int = 0 ; i<p12List.length;i++)
                            {
                                ap12List.push(new PopButtonData(p12List[i].name,2,null,true,false,true,'',p12List[i]));
                            }
                            if(ap12List.length>1)
                            {
                                Hints.selector("Select iOS Development certificate.p12",'',ap12List,oniOSp12Selected);
                            }
                            else if(ap12List.length==1)
                            {
                                currentExportParams.setiOSDevP12((ap12List[0] as PopButtonData).dynamicData as File);
                                findDistributionP12();
                            }
                            else
                            {
                                findDistributionP12();
                            }

                            function oniOSp12Selected(e:PopMenuEvent):void
                            {
                                var selectedFile:File = e.buttonData as File ;
                                if(selectedFile!=null)
                                {
                                    currentExportParams.setiOSDevP12(selectedFile);
                                }
                                findDistributionP12();
                            }

                            function findDistributionP12():void
                            {
                                if(ap12List.length>1)
                                {
                                    Hints.selector("Select iOS Distribution certificate.p12",'',ap12List,oniOSDistp12Selected);
                                }
                                else if(ap12List.length==1)
                                {
                                    currentExportParams.setiOSP12((ap12List[0] as PopButtonData).dynamicData as File);
                                    findMobileProvisions();
                                }
                                else
                                {
                                    findMobileProvisions();
                                }
                            }

                            function oniOSDistp12Selected(e:PopMenuEvent):void
                            {
                                var selectedFile:File = e.buttonData as File ;
                                if(selectedFile!=null)
                                {
                                    currentExportParams.setiOSP12(selectedFile);
                                }
                                findMobileProvisions();
                            } 
                        }
                    }
                }


                


                

                function findMobileProvisions():void
                {
                    FileManager.searchFor(projectList.getCurrentProjectFolder(),'*.mobileprovision',provisionsFounded);

                    function provisionsFounded(provfiles:Vector.<File>):void
                    {
                        if(provfiles.length==0)
                        {
                            trace("No provision file founded");
                            findSWFandManifest();
                        }
                        else
                        {
                            var distProvisionButtons:Array = [] ;
                            var devProvisionButtons:Array = [] ;
                            var hocProvisionButtons:Array = [] ;
                            for(var i:int = 0 ; i<provfiles.length ; i++)
                            {
                                var loadedProvision:String = TextFile.load(provfiles[i],50);
                                if(loadedProvision.indexOf('AdHoc')!=-1)
                                {
                                    hocProvisionButtons.push(new PopButtonData(provfiles[i].name,2,null,true,false,true,'',provfiles[i]));
                                }
                                else if(loadedProvision.indexOf('<key>beta-reports-active</key>')!=-1 || loadedProvision.indexOf('<string>production</string>')!=-1)
                                {
                                    distProvisionButtons.push(new PopButtonData(provfiles[i].name,2,null,true,false,true,'',provfiles[i]));
                                }
                                else
                                {
                                    devProvisionButtons.push(new PopButtonData(provfiles[i].name,2,null,true,false,true,'',provfiles[i]));
                                }
                            }
                            
                            selectDistProv();

                            function selectDistProv():void
                            {
                                if(distProvisionButtons.length==0)
                                {
                                    selectDevPorv();
                                }
                                else if(distProvisionButtons.length==1)
                                {
                                    currentExportParams.ios_dist_provision = (distProvisionButtons[0].dynamicData as File).nativePath ;
                                    selectDevPorv();
                                }
                                else
                                {
                                    Hints.selector("Select the Distribution provision file",'',distProvisionButtons,distSelected);
                                    function distSelected(e:PopMenuEvent):void
                                    {
                                        currentExportParams.ios_dist_provision = (e.buttonData as File).nativePath ;
                                        selectDevPorv();
                                    }
                                }
                            }

                            function selectDevPorv():void
                            {
                                if(devProvisionButtons.length==0)
                                {
                                    selectAdHocPorv();
                                }
                                else if(devProvisionButtons.length==1)
                                {
                                    currentExportParams.ios_dev_provision = (devProvisionButtons[0].dynamicData as File).nativePath ;
                                    selectAdHocPorv();
                                }
                                else
                                {
                                    Hints.selector("Select the Development provision file",'',devProvisionButtons,devSelected);
                                    function devSelected(e:PopMenuEvent):void
                                    {
                                        currentExportParams.ios_dev_provision = (e.buttonData as File).nativePath ;
                                        selectAdHocPorv();
                                    }
                                }
                            }

                            function selectAdHocPorv():void
                            {
                                if(hocProvisionButtons.length==0)
                                {
                                    findSWFandManifest();
                                }
                                else if(hocProvisionButtons.length==1)
                                {
                                    currentExportParams.ios_adhoc_provision = (hocProvisionButtons[0].dynamicData as File).nativePath ;
                                    findSWFandManifest();
                                }
                                else
                                {
                                    Hints.selector("Select the AdHoc provision file",'',hocProvisionButtons,adHocSelected);
                                    function adHocSelected(e:PopMenuEvent):void
                                    {
                                        currentExportParams.ios_adhoc_provision = (e.buttonData as File).nativePath ;
                                        findSWFandManifest();
                                    }
                                }
                            }
                        }
                    }
                }
                

                function findSWFandManifest():void
                {
                    currentExportParams.swfname = mainSWF.name.substring(0,mainSWF.name.lastIndexOf('.'));
                    
                    FileManager.searchFor(mainSWF.parent,'*.xml',controlFoundedXMLs);

                    function controlFoundedXMLs(xmlFiles:Vector.<File>):void
                    {
                        var manifestFiles:Vector.<File> = new Vector.<File>();
                        var manifestButtons:Array = [] ;
                        var manifestFordev:Array = [] ;
                        var manifestFordist:Array = [] ;
                        manifestButtons.push(new PopButtonData('-',2));
                        for(var i:int = 0 ; i<xmlFiles.length;i++)
                        {
                            var loadesManifest:String = TextFile.load(xmlFiles[i]);
                            if(loadesManifest.indexOf(mainSWF.name)!=-1 && loadesManifest.indexOf('application')!=-1)
                            {
                                manifestFiles.push(xmlFiles[i]);
                                manifestButtons.push(new PopButtonData(xmlFiles[i].name,2,i,true,false,true,'',xmlFiles[i]));
                                manifestFordev.push(new PopButtonData(xmlFiles[i].name+(loadesManifest.indexOf("<string>development</string>")!=-1?"(Recomended)":''),2,i,true,false,true,'',xmlFiles[i]));
                                manifestFordist.push(new PopButtonData(xmlFiles[i].name+(loadesManifest.indexOf("<string>production</string>")!=-1?"(Recomended)":''),2,i,true,false,true,'',xmlFiles[i]));
                            }
                        }
                        if(manifestFiles.length==0)
                        {
                            Hints.show("You forgot to add mainfest-app.xml file to the project. use SaffronCode Adobe Air Assistant application to create one");
                            //end()
                        }
                        else if(manifestFiles.length==1)
                        {
                            currentExportParams.setAndroid_xml_name(manifestFiles[0]);
                            currentExportParams.setios_dev_xml_name(manifestFiles[0]);
                            currentExportParams.setIos_xml_name(manifestFiles[0]);

                            buildExportparamsFile();
                        }
                        else
                        {
                            Hints.selector("Select Android manifest file",'',manifestButtons,androidManifestSelected);
                            function androidManifestSelected(e:PopMenuEvent):void
                            {
                                currentExportParams.setAndroid_xml_name(e.buttonData as File);
                                Hints.selector("Select iOS development manifest file",'',manifestFordev,iosDevManifestSelected);
                            }
                            function iosDevManifestSelected(e:PopMenuEvent):void
                            {
                                currentExportParams.setios_dev_xml_name(e.buttonData as File);
                                Hints.selector("Select iOS production manifest file",'',manifestFordist,iosManifestSelected);
                            }
                            function iosManifestSelected(e:PopMenuEvent):void
                            {
                                currentExportParams.setIos_xml_name(e.buttonData as File);
                                findNativeFolder();
                            }
                        }
                    }
                }

                function findNativeFolder():void
                {
                    FileManager.searchFor(exportDirectory,'*.ane',nativeFolderFounded);
                    function nativeFolderFounded(nativeFiles:Vector.<File>):void
                    {
                        currentExportParams.native_folder = '' ;
                        var nativeFoldersNames:Array =[];
                        var nativeFolders:Array = [];
                        for(var i:int = 0 ; i<nativeFiles.length ; i++)
                        {
                            if(nativeFoldersNames.indexOf(nativeFiles[i].parent.nativePath)==-1)
                            {
                                nativeFolders.push(new PopButtonData(nativeFiles[i].parent.nativePath,2,i,true,false,true,'',nativeFiles[i].parent));
                                nativeFoldersNames.push(nativeFiles[i].parent.nativePath);
                            }
                        }

                        if(nativeFolders.length==0)
                        {
                            findPlistFileForiOS();
                        }
                        else if(nativeFolders.length==1)
                        {
                            setNativeAdress((nativeFolders[0] as PopButtonData).dynamicData as File) ;
                            findPlistFileForiOS();
                        }
                        else
                        {
                            Hints.selector("Select the Native directory",'',nativeFolders,onNativeFolderSelected);
                            function onNativeFolderSelected(e:PopMenuEvent):void
                            {
                                var selectedDirectory:File = e.buttonData as File ;
                                if(selectedDirectory!=null)
                                {
                                    setNativeAdress(selectedDirectory) ;
                                }
                                findPlistFileForiOS();
                            }
                        }

                        function setNativeAdress(nativeFile:File):void
                        {
                            var relativeTarget:String = FileManager.getRelatedTarget(exportDirectory,nativeFile);
                            currentExportParams.native_folder = "-extdir "+relativeTarget ;
                        }
                    }
                }



                function findPlistFileForiOS():void
                {
                    FileManager.searchFor(exportDirectory,'*.plist',plistFilsFounded,null,false);// GoogleService-Info(14).plist)

                    function plistFilsFounded(plistFiles:Vector.<File>):void
                    {
                        if(plistFiles.length>0)
                        {
                            currentExportParams.setPlistFileForiOS(plistFiles[0]);
                        }
                        else
                        {
                            currentExportParams.setPlistFileForiOS(null);
                        }
                        findEmbededFiles();
                    }
                }

                function findEmbededFiles():void
                {
                    var appIconsFolder:File = exportDirectory.resolvePath("AppIconsForPublish");
                    var saffronData:File = exportDirectory.resolvePath('Data');
                    var embededFiles:String = '';
                    if(appIconsFolder.exists)
                        embededFiles+=appIconsFolder.name+' ';
                    if(saffronData.exists && saffronData.resolvePath('data.xml').exists)
                        embededFiles+=saffronData.name+' ';


                    currentExportParams.contents = embededFiles ;

                    Hints.ask("Embed files",(embededFiles!=''?"Embeded files are ("+embededFiles+") ":'')+" Do you want to add "+(embededFiles!=''?"more ":"")+" files?",addMoreFiles,null,buildExportparamsFile);

                    function addMoreFiles()
                    {
                        var files:Array = exportDirectory.getDirectoryListing();
                        var filesToSelect:Array = [];
                        var forbidenList:Array= ['.bat','.fla'];
                        for(var i:int = 0 ; i<files.length ; i++)
                        {
                            var aFile:File = files[i] as File;
                            if(forbidenList.indexOf(aFile.extension.toLowerCase())==-1)
                            {
                                filesToSelect.push(new PopButtonData(FileManager.getRelatedTarget(exportDirectory,aFile),2,i,true,false,true,'',aFile));
                            }
                        }
                        //Hints.checkList(filesToSelect,onListSelected);

                        function onListSelected(selectedFiles:Array):void
                        {
                            for(var i:int = 0 ; i<selectedFiles.length ; i++)
                            {
                                var selectedFile:File = (selectedFiles[i] as PopButtonData).dynamicData as File ;
                                if(
                                    (saffronData==null || selectedFile.nativePath!=saffronData.nativePath)
                                    &&
                                    (appIconsFolder==null || selectedFile.nativePath!=appIconsFolder.nativePath)
                                )
                                {
                                    embededFiles += aFile.nativePath+' ';
                                }
                            }
                            currentExportParams.contents = embededFiles ;
                            buildExportparamsFile();
                        }
                    }
                    
                }

                function buildExportparamsFile():void
                {
                    //Update, create load params TODO
                    var popFields:PopMenuFields = new PopMenuFields();
                    var ios_dist_field:String = 'iOS distribution p12 password:'
                    if(currentExportParams.ios_certificate!=null)
                        popFields.addField(ios_dist_field,currentExportParams.ios_cert_pass,null,true);
                    var ios_dev_field:String = 'iOS development p12 password:'
                    if(currentExportParams.ios_dev_certificate!=null)
                        popFields.addField(ios_dev_field,currentExportParams.ios_cert_dev_pass,null,true);
                    var android_field:String = 'Android p12 password:'
                    if(currentExportParams.android_certificate!=null)
                        popFields.addField(android_field,currentExportParams.android_cert_pass,null,true);
                    

                    var popContent:PopMenuContent = new PopMenuContent('',popFields,['Save']);
                    if(popFields.length()>0)
                        PopMenu1.popUp("Enter p12 files passwords.",null,popContent,0,onDone);
                    else
                        createFile();

                    function onDone(e:PopMenuEvent):void
                    {
                        currentExportParams.android_cert_pass = e.field[android_field];
                        currentExportParams.ios_cert_dev_pass = e.field[ios_dev_field];
                        currentExportParams.ios_cert_pass = e.field[ios_dist_field];
                        createFile();
                    }

                    function createFile():void
                    {
                        var paramFile:File = exportDirectory.resolvePath('exportparams');
                        TextFile.save(paramFile,currentExportParams.toString());
                    }
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
                    else if(asFiles.length==0)
                    {
                        var asFile:File = mainFlaFile.parent.resolvePath("Main.as");
                        TextFile.save(asFile,"package\n{\n\timport flash.display.MovieClip;\n\tpublic class Main extends MovieClip\n\t{\n\t\tpublic function Main()\n\t\t{\n\t\t\tsuper();\n\t\t}\n\t}\n}")
                        setTheMainASFile(asFile);
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

                    //create setting if not exists

                    var settingFile:File = projectFolder.resolvePath(".vscode");
                    if(!settingFile.exists)
                    {
                        settingFile.createDirectory();
                    }
                    settingFile = settingFile.resolvePath("settings.json");
                    if(!settingFile.exists)
                    {
                        var settinFileString:String = '{\n\t"as3mxml.sdk.framework": "'+currentAirTarget.nativePath.split('\\').join('\\\\')+'"\n}';
                        TextFile.save(settingFile,settinFileString);
                    }
                }
            }



            private function removeThisProjectFolder():void
            {
                projectList.removeCurrentProject();
            }
    }
}