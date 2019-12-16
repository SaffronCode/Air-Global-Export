package parts
//parts.FolderLinkItem
{
    import contents.displayPages.LinkItem;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;
    import flash.events.Event;

    public class FolderLinkItem extends LinkItem
    {
        public function FolderLinkItem()
        {
            super(true,true);

            var delButton:MovieClip = Obj.get("delete_mc",this);
            delButton.buttonMode = true ;
            delButton.addEventListener(MouseEvent.CLICK,deleteInsteadOfSelect,false,10000);
        }

        private function deleteInsteadOfSelect(e:MouseEvent):void
        {
            e.stopImmediatePropagation();
            this.dispatchEvent(new Event(Event.CANCEL,true));
        }
    }
}