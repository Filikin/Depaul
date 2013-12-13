trigger Maintenance on Maintenance__c (after update) 
{
// update Building Item status to OK when Maintenance status is "completed"
// EK 25 November 2013
	set <ID> buildingItemIDs = new set <ID>();
	for (Maintenance__c oneM : trigger.new)
	{
		if (oneM.Repair_Status__c == 'Completed')
		{
			buildingItemIDs.add (oneM.Facility_Item__c);
		}
	}
	if (buildingItemIDs.size() > 0)
	{
		List<Area_Item__c>items = [select ID, Maintenance_Status__c from Area_Item__c where ID in :buildingItemIDs];
		for (Area_Item__c oneItem: items)
		{
			oneItem.Maintenance_Status__c = 'OK';
		}
		if (items.size() > 0) update items;
	}
}