/*
	Author: Eamon Kelly, Enclude
	Purpose: Called when contact is inserted, rejects the contact if contact with same Client Pass Number or Client PPS Number or Client National Insurance Number
		or Lastname and Date of Birth - unless an override checkbox is on
	
*/
public without sharing class CheckForDuplicateClients implements TriggerDispatcher.ITriggerEntry
{
	public void MainEntry (String TriggerObject, Boolean isBefore, Boolean isDelete, Boolean isAfter, Boolean isInsert, Boolean isUpdate, Boolean isExecuting,
		List<SObject> newList, Map<Id, SObject> newMap, List<SObject> oldList, Map<Id, SObject> oldMap)
	{
		if (AppConfigSupport.TriggersDisabled) return;
		if (isBefore && isInsert)
		{
			CheckDuplicates (newList);
		}
	}
	
	void CheckDuplicates (List<Contact>newList)
	{
		// TODO find possible duplicates
		for (Contact oneContact: newList)
		{
			oneContact.addError ('Possible duplicate');
		}
	}
	
}