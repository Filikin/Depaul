/*
	Author: Eamon Kelly, Enclude
	Purpose: Provide centralised access to the custom settings and make a copy available in test
	Copied from Advanced Apex Programming by Dan Appleman
*/
public with sharing class AppConfigSupport {
	private static AppConfig__c testconfig = null;
	
	public static AppConfig__c GetAppSettings()
	{
		if(Test.isRunningTest() && testconfig!=null) return testconfig;
		
		AppConfig__c theobject = AppConfig__c.getOrgDefaults();
		if(theobject==null || Test.isRunningTest()) 
		{
			theobject = new AppConfig__c();
			theobject.name = 'default';
			if(!Test.isRunningTest()) Database.Insert(theobject);
			else // set default test values (can be different from default values) 
			{
				theobject.Risk_Assessment_Template__c = 'RSK-$NAME$-$DATE$';
				theobject.Disable_Triggers__c = false;
				theobject.Needs_Assessment_Template__c = 'NAS-$NAME$-$DATE$';
				testconfig = theobject;
			}
		}
		return theobject;
	}

	public static String RiskNameTemplate
	{
		get
		{
			return GetAppSettings().Risk_Assessment_Template__c;
		}
	}
	
	public static String NeedsNameTemplate
	{
		get
		{
			return GetAppSettings().Needs_Assessment_Template__c;
		}
	}
	
	public static Boolean TriggersDisabled
	{
		get
		{
			return GetAppSettings().Disable_Triggers__c;
		}
	}
	
	public static Boolean DuplicateCheckDisabled
	{
		get
		{
			return GetAppSettings().Disable_Duplicate_Checks__c;
		}
	}
}