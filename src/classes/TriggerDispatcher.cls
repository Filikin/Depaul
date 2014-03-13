/*
	Author: Eamon Kelly, Enclude
	Purpose: All triggers should pass through here
*/
public class TriggerDispatcher 
{
	public static Boolean InTrigger = false;
	public interface ITriggerEntry 
	{
		void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
			List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap);
	}
	
	public static ITriggerEntry activeFunction = null;
	
	public static void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (TriggerObject == 'Risk_Assessment__c')
		{
			activeFunction = new UpdateNameUsingTemplate();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
		}
		else if (TriggerObject == 'Needs_Assessment__c')
		{
			activeFunction = new UpdateNameUsingTemplate();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
		}
		else if (TriggerObject == 'Contact')
		{
			activeFunction = new CheckForDuplicateClients();
			activeFunction.MainEntry (TriggerObject, isBefore, isDelete, isAfter, isInsert, isUpdate, isExecuting, newList, newMap, oldList, oldMap);
		}
	}

}