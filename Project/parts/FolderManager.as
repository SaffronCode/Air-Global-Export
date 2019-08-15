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
    import dataManager.GlobalStorage;
    import appManager.event.AppEvent;
    import appManager.event.AppEventContent;
    import contents.displayPages.LinkItem;

    public class FolderManager extends MovieClip
    {
        private var titleMC:TextParag ;

        private var list:DynamicLinks ;

        private var directories:Array ;


        private var listY0:Number,
                    listH0:Number ;

        /**It will return the file if it was corrected */
        private var fileControllerFunction:Function ;

        private const   id_folderManager:String = "id_folderManager",
                        id_selectedFile:String="id_selectedFile" ;

        public function FolderManager()
        {
            super();

            //directories = [] ;
            loadDirectories();


            //TODO load from GlobalStorage

            titleMC = Obj.findThisClass(TextParag,this);
            list = Obj.findThisClass(DynamicLinks,this);
            list.fadeScroll = true;
            list.myDeltaY = 5 ;
            listY0 = list.y ;
            listH0 = list.height ;
            list.addEventListener(AppEventContent.PAGE_CHANGES,changeSelectedFolder);
            list.addEventListener(MouseEvent.CLICK,preventListClick);

            this.addEventListener(MouseEvent.CLICK,openFolderBrowser);

            updateInterface();
        }

            private function preventListClick(e:MouseEvent):void
            {
                trace("Stop!!");
                e.stopImmediatePropagation();
            }

        /**
         * Load directories from GlobalStorage
         */
        private function loadDirectories():void
        {
            var cash:Array = GlobalStorage.load(id_folderManager+this.name);
            if(cash==null)
            {
                directories = [];
            }
            else
            {
                directories = cash ;
            }
        }

        /**
         * Save Directories
         */
        private function saveDirectories():void
        {
            GlobalStorage.save(id_folderManager+this.name,directories);
        }

        public function setUp(fileController:Function):void
        {
            fileControllerFunction = fileController ;
            
            for(var i:int = 0 ; i<directories.length ; i++)
            {
                if(fileController(new File(directories[i])) == null)
                {
                    directories.removeAt(i);
                    i--;
                }
            }

            updateInterface();
        }

        private function openFolderBrowser(e:MouseEvent):void
        {
            FileManager.browseForDirectory(addThisDirectory,"Select SaffronCode directory");
        }

        private function addThisDirectory(directory:File):void
        {
            var files:Vector.<File> = new Vector.<File>(); ;
            if(fileControllerFunction==null || fileControllerFunction(directory)!=null)
            {
                files.push(directory);
            }
            for(var i:int = 0 ; i<files.length ; i++)
            {
                var doundedIndex:int ;
                if((doundedIndex=directories.indexOf(files[i].nativePath))==-1)
                {
                    directories.unshift(directory.nativePath);
                }
                else
                {
                    directories.unshift(directories.removeAt(doundedIndex));
                }
            }
            if(files.length>0)
                updateInterface();

            saveDirectories();
        }

        private function updateInterface():void
        {
            if(directories.length>0)
            {
                titleMC.setUp(new File(directories[0]).nativePath,false,false,false,false,false,true);
            }
            else
                showWarning();
            if(directories.length>1)
            {
                //list.y = titleMC.y + titleMC.height ;
                //list.height = listH0 - (list.y-listY0);
                var directoryList:PageData = new PageData().createPageFor(null,'',null,this.name);
                for(var i:int = 0 ; i<directories.length ; i++)
                {
                    directoryList.links1.push(new LinkData().createLinkFor(i,null,-1,new File(directories[i]).name))
                }
                list.setUp(directoryList);
            }
        }

            private function showWarning():void
            {
                titleMC.setUp('-',false);
            }

        private function changeSelectedFolder(event:AppEventContent):void
        {
            trace("Hi");
            event.stopImmediatePropagation();
            var selectedDirectory:uint = uint(event.linkData.id);
            directories.unshift(directories.removeAt(selectedDirectory));
            updateInterface();
        }

        public function getSelectedFile():File
        {
            if(directories.length==0)
            {
                return null ;
            }
            else
            {
                return fileControllerFunction(new File(directories[0]));
            }
        }
    }
}