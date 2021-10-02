package parts.LaunchJSON
{
    import flash.filesystem.File;
    import contents.TextFile;
    import contents.alert.Alert;
    import popForm.Hints;
    import popForm.PopButtonData;
    import popForm.PopMenuEvent;

    public class LaunchFileCreator
    {
        private static var launchFile:LaunchJSONModel = new LaunchJSONModel();

        public function LaunchFileCreator()
        {
            
        }

        public static function createLaunchJSON(projectDirectory:File):void
        {
            var currentFlaFile:File ;

            FileManager.searchFor(projectDirectory,'*.fla',flaFounded);
            function flaFounded(flaList:Vector.<File>):void
            {
                var flaSelector:Array = [] ;
                for(var i:int = 0 ; i<flaList.length ; i++)
                {
                    flaSelector.push(new PopButtonData(flaList[i].name,2,null,true,false,true,'',flaList[i])) ;
                }
                
                if(flaList.length==0)
                {
                    Alert.show("No FLA file founded on the project directory.")
                    return ;
                }
                else if(flaSelector.length==1)
                {
                    thiFlaSelected((flaSelector[0] as PopButtonData).dynamicData as File);
                }
                else
                {
                    Hints.selector("Select the main Fla",'',flaSelector,onFlaSelected);
                }
            }

            function onFlaSelected(flaFile:PopMenuEvent):void
            {
                thiFlaSelected(flaFile.buttonData as File);
            }

            function thiFlaSelected(flaFile:File):void
            {
                launchFile.configurations[0].setFLAName(flaFile.name);
                currentFlaFile = flaFile ;
                findManifestFile();
            }
            
            function findManifestFile():void
            {
                FileManager.searchFor(projectDirectory,'*.xml',manifestFilesFounded);

                function manifestFilesFounded(manifestList:Vector.<File>):void
                {
                    var manifestListButtons:Array = [] ;
                    var bestMatchesList:Array = [] ;
                    for(var i:int = 0 ; i<manifestList.length ; i++)
                    {
                        var xmlContent:String = TextFile.load(manifestList[i]);
                        if(xmlContent.indexOf("application")!==-1 && xmlContent.indexOf(".swf")!=-1)
                        {
                            manifestListButtons.push(new PopButtonData(manifestList[i].name,2,null,true,false,true,'',manifestList[i]));
                            if(xmlContent.toLowerCase().indexOf(currentFlaFile.name.toLowerCase().split('.fla').join('.swf'))!=-1)
                            {
                                bestMatchesList.push(manifestListButtons[manifestListButtons.length-1]);
                            }
                        }
                    }
                    if(bestMatchesList.length>0)
                    {
                        selectManifestFile(bestMatchesList[0].dynamicData as File);
                    }
                    else
                    {
                        Hints.selector("Select your Manifest.xml file",'',manifestListButtons,onManifestSelected);
                    }
                }
                
                function onManifestSelected(e:PopButtonData):void
                {
                    selectManifestFile(e.dynamicData as File);
                }
            }

            function selectManifestFile(manifestFile:File):void
            {
                launchFile.configurations[0].setManifestXMLFile(manifestFile,projectDirectory);
                exportJSON();
            }


            function exportJSON():void
            {
                var jsonFile:String = JSON.stringify(launchFile,null,'\t');
                var launchFileDirecotry:File= projectDirectory.resolvePath('.vscode');
                if(!launchFileDirecotry.exists)
                {
                    launchFileDirecotry.createDirectory();
                }
                var launchFileTarget:File = launchFileDirecotry.resolvePath('launch.json');
                TextFile.save(launchFileTarget,jsonFile);
            }
        }
    }
}