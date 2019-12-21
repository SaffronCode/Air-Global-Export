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
    import flash.events.Event;
    import popForm.Hints;

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

        private var isMultifile:Boolean = false ;

        private var title:String ;

        private var filePattern:String = null ;

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
            list.addEventListener(Event.CANCEL,removeItem);
            list.addEventListener(MouseEvent.CLICK,preventListClick);

            this.addEventListener(MouseEvent.CLICK,openFolderBrowser);

            updateInterface();
        }

        private function removeItem(e:Event):void
        {
            var selectedItem:LinkItem = e.target as LinkItem;
            Hints.ask('',"Do you whant to remove "+selectedItem.myLinkData.name+" from the list?",removeThisItem);
            function removeThisItem():void
            {
                var index:int = int(selectedItem.myLinkData.id);
                directories.removeAt(index);//(selectedItem.myLinkData.dynamicData as )unshift(directories.removeAt(doundedIndex));

                saveDirectories();
                updateInterface();
            }
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

        public function setUp(fileController:Function,fileBrowserTitle:String,multiFile:Boolean=false,extensionPatternToChooseFile:String=null):void
        {
            fileControllerFunction = fileController ;
            isMultifile = multiFile ;
            titleMC.visible = !multiFile ;
            this.filePattern = extensionPatternToChooseFile ;
            title = fileBrowserTitle ;

            list.y = listY0 - int(multiFile)*titleMC.height ;
            
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
            if(filePattern!=null)
            {
                FileManager.browse(addThisDirectory,[filePattern],title)
            }
            else
            {
                FileManager.browseForDirectory(addThisDirectory,title);
            }
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
            if(directories.length>0)
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
            else
            {
                list.setUp(new PageData());
            }
        }

            private function showWarning():void
            {
                titleMC.setUp('-',false);
            }

        private function changeSelectedFolder(event:AppEventContent):void
        {
            if(isMultifile)
                return;
            trace("Hi");
            event.stopImmediatePropagation();
            var selectedDirectory:uint = uint(event.linkData.id);
            directories.unshift(directories.removeAt(selectedDirectory));
            updateInterface();
        }

        public function getAllFiles():Vector.<File>
        {
            var filesList:Vector.<File> = new Vector.<File>();
            for(var i:int = 0 ; i<directories.length ; i++)
            {
                filesList.push(new File(directories[i]));
            }
            return filesList ;
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