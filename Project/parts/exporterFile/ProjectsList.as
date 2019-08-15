package parts.exporterFile
//parts.exporterFile.ProjectsList
{
    import flash.display.MovieClip;
    import appManager.displayContentElemets.TitleText;
    import contents.displayPages.DynamicLinks;
    import otherPlatforms.dragAndDrow.DragAndDrop;
    import flash.filesystem.File;
    import dataManager.GlobalStorage;
    import contents.PageData;
    import contents.LinkData;
    import contents.alert.Alert;
    import appManager.event.AppEventContent;
    import appManager.event.AppEvent;

    public class ProjectsList extends MovieClip
    {

        private var currentProjectTitle:TitleText ;

        private var allProjectsList:DynamicLinks ;

        private var directories:Array ;

        private const id_saved_projects:String = "id_saved_projects" ;

        public function ProjectsList()
        {
            super();

            loadDirectories();

            currentProjectTitle = Obj.get("current_project_txt",this);
            allProjectsList = Obj.get("list_mc",this);
            allProjectsList.fadeScroll = true ;
            allProjectsList.addEventListener(AppEventContent.PAGE_CHANGES,switchProject);

            DragAndDrop.activateDragAndDrop(this,aDirecotryDropped,null,true);

            updateInterface();
        }

               /**
                 * Load directories from GlobalStorage
                 */
                private function loadDirectories():void
                {
                    var cash:Array = GlobalStorage.load(id_saved_projects);
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
                    GlobalStorage.save(id_saved_projects,directories);
                }

            private function aDirecotryDropped(directory:Vector.<File>):void
            {
                var folderIndex:int ;
                Alert.show("directory[0].nativePath : " +directory[0].nativePath);
                if((folderIndex = directories.indexOf(directory[0].nativePath))==-1)
                {
                    directories.push(directory[0].nativePath);
                }
                else
                {
                    directories.unshift(directories.removeAt(folderIndex));
                }
                saveDirectories();
                updateInterface();
            }


            private function updateInterface():void
            {
                var pageData:PageData = new PageData().createPageFor(null,'',null,'projects_list_page');
                if(directories.length>0)
                {
                    currentProjectTitle.setUp(new File(directories[0]).name);
                    for(var i:int = 1 ; i<directories.length ; i++)
                    {
                        pageData.links1.push(new LinkData().createLinkFor(i,null,-1,new File(directories[i]).name));
                    }
                    allProjectsList.setUp(pageData);
                }
            }

        private function switchProject(event:AppEventContent):void
        {
            var projectIndex:int = int(event.linkData.id);
            directories.unshift(directories.removeAt(projectIndex));
            updateInterface();
            saveDirectories();
        }
    }
}