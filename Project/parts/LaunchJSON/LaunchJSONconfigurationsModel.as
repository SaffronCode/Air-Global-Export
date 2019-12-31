package parts.LaunchJSON
{
	import flash.filesystem.File;

	public class LaunchJSONconfigurationsModel
	{
		/**"name":"Debug (desktop2)"*/
		public var name:String = "Debug (desktop2)" ;
		/**"preLaunchTask":"Adobe Animate: compile debug - RefahBank.fla"*/
		private const preLaunchSaticPart:String = "Adobe Animate: compile debug - ";
		public var preLaunchTask:String = preLaunchSaticPart+"RefahBank.fla";
		/**"program":"Project\src\RefahBank-app-dist.xml"*/
		public var program:String = "Project\\src\\RefahBank-app-dist.xml" ;
		/**"request":"launch"*/
		public var request:String ="launch" ;
		/**"type":"swf"*/
		public var type:String = "swf";

		
		public function LaunchJSONconfigurationsModel()
		{
		}

		public function setFLAName(FlaName:String):void
		{
			preLaunchTask = preLaunchSaticPart+FlaName;
		}

		public function setManifestXMLFile(ManifestFile:File,rootDirectory:File):void
		{
			program = FileManager.getRelatedTarget(rootDirectory,ManifestFile)
		}
	}
}