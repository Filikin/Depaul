/*
Author: Eamon Kelly, Enclude
Purpose: 1) Change the name of the residency to the name of the service user + arrival date - changed this to 	Date_of_Referral__c on 12 March 2014
	2) when a residency is created, search for all frequencies that match the building the residency is in and add them to the residency
	
Called from: after insert
Tested in: TestCreateChecks
*/
trigger Residency on Residency__c (after insert) 
{
	List <Residency__c> newResidencies = [select ID, Name, Date_of_Referral__c, Service_User__r.Name, Building__c from Residency__c where id in :trigger.newMap.keySet()];
	map <ID, String> mapResidencyToBuilding = new map <ID, String>();
	set <String> buildings = new set <String>();
	for (Residency__c oneResident: newResidencies)
	{
		if (oneResident.Date_of_Referral__c == null)
		{
			trigger.newMap.get(oneResident.id).	Date_of_Referral__c.addError ('Referral date needs to be set for ' + oneResident.Name);
		}
		else oneResident.Name = oneResident.Service_User__r.Name + ' ' + oneResident.Date_of_Referral__c.format();
		
		if (oneResident.Building__c != null)
		{
			mapResidencyToBuilding.put (oneResident.ID, oneResident.Building__c);
			buildings.add (oneResident.Building__c);
		}
	}
	update newResidencies;
	
	// Find the standard frequencies and add them to the residencies
	List <Frequency__c> stdFreqs = [select ID, Default_for__c from Frequency__c where Default_for__c in :buildings];
	if (stdFreqs.size() > 0)
	{
		List <Wellbeing_Check_Frequency__c> checksToAdd = new List <Wellbeing_Check_Frequency__c>();
		for (ID oneResidentID: mapResidencyToBuilding.keySet())
		{
			String building = mapResidencyToBuilding.get (oneResidentID);
			for (Frequency__c oneStdFreq: stdFreqs)
			{
				if (oneStdFreq.Default_for__c == building)
				{
					Wellbeing_Check_Frequency__c oneStdCheck = new Wellbeing_Check_Frequency__c (Residency__c=oneResidentID, Frequency__c=oneStdFreq.Id);
					checksToAdd.add (oneStdCheck);
				}
			}
		}
		if (checksToAdd.size()>0) insert checksToAdd;
	}
}