trigger Residency on Residency__c (after insert) 
{
	List <Residency__c> newResidencies = [select ID, Name, Arrival_Date__c, Service_User__r.Name from Residency__c where id in :trigger.newMap.keySet()];
	for (Residency__c oneResident: newResidencies)
	{
		oneResident.Name = oneResident.Service_User__r.Name + ' ' + oneResident.Arrival_Date__c.format();
	}
	update newResidencies;
}