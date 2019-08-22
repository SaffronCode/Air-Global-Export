package
{

    import flash.display.Sprite;
    import parts.GlobalSetting;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import dynamicFrame.FrameGenerator;
    import appManager.displayContentElemets.TitleText;
    import parts.exporterFile.Exporter;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.events.Event;
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.filesystem.File;
    import flash.events.ProgressEvent;
    import flash.desktop.NativeApplication;
    import flash.events.IOErrorEvent;
    import flash.text.TextField;
    import flash.utils.setTimeout;

    public class Main extends Sprite
    {
        private var globalSettingMC:GlobalSetting ;
        private var exporterPartMC:Exporter ;

        private var settingBTN:MovieClip ;

        public function Main()
        {
            super();

            TextPutter.defaultResolution = 2 ;
            UnicodeStatic.deactiveConvertor = true ;

            FrameGenerator.createFrame(stage);

            globalSettingMC = Obj.get("global_setting_mc",this);
            globalSettingMC.visible = globalSettingMC.needToSetUp() ;

            exporterPartMC = Obj.findThisClass(Exporter,this);
            exporterPartMC.visible = !globalSettingMC.visible ;
            exporterPartMC.setLibraries(globalSettingMC.getLibraries());

            settingBTN = Obj.get("setting_btn",this);
            settingBTN.buttonMode = true;
            settingBTN.addEventListener(MouseEvent.CLICK,function(r){
                globalSettingMC.visible = !globalSettingMC.visible ;
                exporterPartMC.visible = !globalSettingMC.visible ;
                settingButtonFrame();
                exporterPartMC.setLibraries(globalSettingMC.getLibraries());
            });

            generateExportGenerator();
            settingButtonFrame();

            var newVersionMC:MovieClip = Obj.get("new_version_mc",this);
			var hintTF:TextField = Obj.get("hint_mc",newVersionMC);
			newVersionMC.addEventListener(MouseEvent.CLICK,openUpdator);


            var fileURL:String = "https://github.com/SaffronCode/Air-Global-Export/raw/master/Project/AdobeAirExporter.air" ;
			
			function openUpdator(e:MouseEvent):void
			{
				newVersionMC.removeEventListener(MouseEvent.CLICK,openUpdator);
				var loader:URLLoader = new URLLoader(new URLRequest(fileURL));
				loader.dataFormat = URLLoaderDataFormat.BINARY ;
				
				loader.addEventListener(Event.COMPLETE,loaded);
				loader.addEventListener(ProgressEvent.PROGRESS,progress)
				
				hintTF.text = "Please wait ..." ;
				
				function progress(e:ProgressEvent):void
				{
					hintTF.text = "Please wait ...(%"+Math.round((e.bytesLoaded/e.bytesTotal)*100)+")" ;
				}
				
				function loaded(e:Event):void
				{
					var fileTarget:File = File.createTempDirectory().resolvePath('SaffronAppGenerator.air') ;
					FileManager.seveFile(fileTarget,loader.data);
					
					fileTarget.openWithDefaultApplication();
					
					hintTF.text = "The installer should be open now...";
					
					setTimeout(function(e){
						NativeApplication.nativeApplication.exit();
					},2000);
					
					newVersionMC.addEventListener(MouseEvent.CLICK,function(e)
					{
						//navigateToURL(new URLRequest(fileTarget.url));
						navigateToURL(new URLRequest(fileURL));
					});
				}
				
			}
			
			newVersionMC.visible = false ;
			var urlLoader:URLLoader = new URLLoader(new URLRequest("https://raw.githubusercontent.com/SaffronCode/Air-Global-Export/master/Project/AdobeAirExporter-app.xml?"+new Date().time));
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT ;
			urlLoader.addEventListener(Event.COMPLETE,function(e){
				var versionPart:Array = String(urlLoader.data).match(/<versionNumber>.*<\/versionNumber>/gi);
				if(versionPart.length>0)
				{
					versionPart[0] = String(versionPart[0]).split('<versionNumber>').join('').split('</versionNumber>').join('');
					trace("version loaded : "+versionPart[0]+' > '+(DevicePrefrence.appVersion==versionPart[0]));
					trace("DevicePrefrence.appVersion : "+DevicePrefrence.appVersion);
					if(!(DevicePrefrence.appVersion==versionPart[0]))
					{
						newVersionMC.visible = true ;
						newVersionMC.alpha = 0 ;
						AnimData.fadeIn(newVersionMC);
					}
				}
			});
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e){});
        }

        private function settingButtonFrame():void
        {
            settingBTN.gotoAndStop(globalSettingMC.visible?2:1);
        }

        private function generateExportGenerator():void
        {
            
        }
    }

}