package parts
//parts.FolderManager
{
    import flash.display.MovieClip;
    import contents.alert.Alert;
    import appManager.displayContentElemets.TitleText;
    import contents.displayPages.DynamicLinks;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import contents.PageData;
    import contents.LinkData;
    import appManager.displayContentElemets.TextParag;

    public class FolderManager extends MovieClip
    {
        private var titleMC:TextParag ;

        private var list:DynamicLinks ;

        private var directories:Array ;

        private var selectedDirectory:uint = 0 ;

        private var listY0:Number,
                    listH0:Number ;

        public function FolderManager()
        {
            super();

            directories = [] ;

            //TODO load from GlobalStorage

            titleMC = Obj.findThisClass(TextParag,this);
            list = Obj.findThisClass(DynamicLinks,this);
            list.myDeltaY = 5 ;
            listY0 = list.y ;
            listH0 = list.height ;

            //this.buttonMode = true ;
            this.addEventListener(MouseEvent.CLICK,openFolderBrowser);
        }

        private function openFolderBrowser(e:MouseEvent):void
        {
            FileManager.browseForDirectory(addThisDirectory,"Select SaffronCode directory");
        }

        private function addThisDirectory(directory:File):void
        {
            directories.push(directory);
            updateInterface();
        }

        private function updateInterface():void
        {
            titleMC.setUp((directories[selectedDirectory] as File).nativePath,false,false,false,false,false,false);
            list.y = titleMC.y + titleMC.height ;
            list.height = listH0 - (list.y-listY0)
            if(directories.length>1)
            {
                var directoryList:PageData = new PageData();
                for(var i:int = 0 ; i<directories.length ; i++)
                {
                    directoryList.links1.push(new LinkData().createLinkFor('',null,-1,(directories[i] as File).name))
                }
                list.setUp(directoryList);
            }
        }
    }
}