package parts.LaunchJSON
{
	public class LaunchJSONModel
	{
		/**"configurations":"[object Object]"*/
		public var configurations:Vector.<LaunchJSONconfigurationsModel> = new Vector.<LaunchJSONconfigurationsModel>()
		/**"version":"0.2.0"*/
		public var version:String = "0.2.0" ;

		
		public function LaunchJSONModel()
		{
			configurations.push(new LaunchJSONconfigurationsModel())
		}
	}
}