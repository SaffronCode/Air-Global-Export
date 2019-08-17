package
{

    import flash.display.Sprite;
    import parts.GlobalSetting;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import dynamicFrame.FrameGenerator;
    import appManager.displayContentElemets.TitleText;
    import parts.exporterFile.Exporter;

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

            settingBTN = Obj.get("setting_btn",this);
            settingBTN.buttonMode = true;
            settingBTN.addEventListener(MouseEvent.CLICK,function(r){
                globalSettingMC.visible = !globalSettingMC.visible ;
                exporterPartMC.visible = !globalSettingMC.visible ;
                settingButtonFrame();
            });

            generateExportGenerator();
            settingButtonFrame();
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