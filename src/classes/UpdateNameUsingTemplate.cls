/*
	Author: Eamon Kelly, Enclude
	Purpose: Called when an object is inserted, change the name based on a template
*/
public with sharing class UpdateNameUsingTemplate implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (AppConfigSupport.TriggersDisabled) return;
		if (isBefore && isInsert)
		{
			ChangeName (TriggerObject, newList);
		}
	}
	
	public void ChangeName (String TriggerObject, list<SObject> newList)
	{
		String nameTemplate;
		String objDate;
		if (TriggerObject == 'Risk_Assessment__c') 
		{
			nameTemplate = AppConfigSupport.RiskNameTemplate;
		}
		else if (TriggerObject == 'Needs_Assessment__c') 
		{
			nameTemplate = AppConfigSupport.NeedsNameTemplate;
		}
		else return;
		
		Date nameDate = system.today();
		for (SObject oneObj: newList)
		{
			String clientName = (String)oneObj.get('Service_User__c');
//			String clientInitials = oneAtt.Young_Person__c != null ? oneAtt.Young_Person__r.Initials__c : '';
			oneObj.put ('Name', nameTemplate.replace('$NAME$', clientName).replace('$DATE$', nameDate.format()));
		}
		
	}
}