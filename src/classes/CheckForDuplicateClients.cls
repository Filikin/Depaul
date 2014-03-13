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
		if (isBefore)
		{
			if (isInsert) CheckDuplicates (newList, new set<ID>()); // pass an empty set is an insert (these contacts don't have IDs)
			else if (isUpdate) CheckDuplicates (newList, newMap.keySet()); 
		}
	}
	
	// if this is an update, the contacts been changed are already in the database - don't retrieve them when checking for matches 
	void CheckDuplicates (List<Contact>newList, set <ID> updatingIDs)
	{
		// find possible duplicates
		// get a set of all Pass Number, PPS numbers, Nation Insurance Numbers and date of birth.
		// return all the clients that match each of these, with an extra check for last name
		map <String, Contact> passNumbers = new map <String, Contact>();
		map <String, Contact> PPSNumbers = new map <String, Contact>();
		map <String, Contact> NINumbers = new map <String, Contact>();
		map <Date, Contact> dateOfBirths = new map <Date, Contact>();
		for (Contact oneContact: newList)
		{
			if (oneContact.PASS_Number__c != null) passNumbers.put (oneContact.PASS_Number__c, oneContact);
			if (oneContact.PPS_Number__c != null) PPSNumbers.put (oneContact.PPS_Number__c, oneContact);
			if (oneContact.National_Insurance_Number__c != null) NINumbers.put (oneContact.National_Insurance_Number__c, oneContact);
			if (oneContact.Birthdate != null) dateOfBirths.put (oneContact.Birthdate, oneContact);			
		}
		
		if (passNumbers.size() > 0)
		{
			List<Contact> matchingContacts;
			matchingContacts = [select ID, DPI_Service__c, PASS_Number__c from Contact where PASS_Number__c in :passNumbers.keySet() and (ID not in :updatingIDs)];
			if (matchingContacts.size() > 0)
			{
				for (Contact oneMatch: matchingContacts)
				{
					Contact matched = passNumbers.get (oneMatch.PASS_Number__c);
					if (matched != null && matched.Ignore_Duplicate_Check__c == false) matched.addError ('A client with this pass number is already in service ' + oneMatch.DPI_Service__c);
				}
			}
		}

		if (PPSNumbers.size() > 0)
		{
			List<Contact> matchingContacts;
			matchingContacts = [select ID, DPI_Service__c, PPS_Number__c from Contact where PPS_Number__c in :PPSNumbers.keySet() and (ID not in :updatingIDs)];
			if (matchingContacts.size() > 0)
			{
				for (Contact oneMatch: matchingContacts)
				{
					Contact matched = PPSNumbers.get (oneMatch.PPS_Number__c);
					if (matched != null && matched.Ignore_Duplicate_Check__c == false) matched.addError ('A client with this PPS number is already in service ' + oneMatch.DPI_Service__c);
				}
			}
		}
		
		if (NINumbers.size() > 0)
		{
			List<Contact> matchingContacts;
			matchingContacts = [select ID, DPI_Service__c, National_Insurance_Number__c from Contact where National_Insurance_Number__c in :NINumbers.keySet() and (ID not in :updatingIDs)];
			if (matchingContacts.size() > 0)
			{
				for (Contact oneMatch: matchingContacts)
				{
					Contact matched = NINumbers.get (oneMatch.National_Insurance_Number__c);
					if (matched != null && matched.Ignore_Duplicate_Check__c == false) matched.addError ('A client with this National Insurance number is already in service ' + oneMatch.DPI_Service__c);
				}
			}
		}
		
		// this bit isn't perfect - if two contacts are added at the same time with the same date of birth but different last names, a duplicate may be missed
		if (dateOfBirths.size() > 0)
		{
			List<Contact> matchingContacts;
			matchingContacts = [select ID, LastName, DPI_Service__c, Birthdate from Contact where Birthdate in :dateOfBirths.keySet() and (ID not in :updatingIDs)];
			if (matchingContacts.size() > 0)
			{
				for (Contact oneMatch: matchingContacts)
				{
					Contact matched = dateOfBirths.get (oneMatch.Birthdate);
					if (matched != null && matched.Ignore_Duplicate_Check__c == false && matched.LastName == oneMatch.LastName) matched.addError ('A client with this date of birth and last name is already in service ' + oneMatch.DPI_Service__c);
				}
			}
		}
	}
	
}