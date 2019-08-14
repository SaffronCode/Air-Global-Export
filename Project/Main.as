package
{

    import flash.display.Sprite;
    import parts.GlobalSetting;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import dynamicFrame.FrameGenerator;
    import appManager.displayContentElemets.TitleText;

    public class Main extends Sprite
    {
        private var globalSettingMC:GlobalSetting ;

        private var settingBTN:MovieClip ;

        public function Main()
        {
            super();

            TextPutter.defaultResolution = 2 ;

            FrameGenerator.createFrame(stage);

            globalSettingMC = Obj.get("global_setting_mc",this);
            globalSettingMC.visible = globalSettingMC.needToSetUp() ;

            settingBTN = Obj.get("setting_btn",this);
            settingBTN.buttonMode = true;
            settingBTN.addEventListener(MouseEvent.CLICK,function(r){
                globalSettingMC.visible = !globalSettingMC.visible ;
            });

            generateExportGenerator();
        }

        private function generateExportGenerator():void
        {
            
        }
    }

}